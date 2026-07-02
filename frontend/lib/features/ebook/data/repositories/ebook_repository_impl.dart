import 'package:dartz/dartz.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/ebook.dart';
import '../../domain/repositories/ebook_repository.dart';
import '../datasources/ebook_remote_datasource.dart';
import '../mappers/ebook_mapper.dart';

class EbookRepositoryImpl implements EbookRepository {
  EbookRepositoryImpl({
    required EbookRemoteDataSource remoteDataSource,
    required ErrorMapper errorMapper,
  }) : _remoteDataSource = remoteDataSource,
       _errorMapper = errorMapper;

  final EbookRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;
  final Map<String, int> _lastPages = <String, int>{};

  @override
  Future<Either<Failure, List<Ebook>>> getEbooks() async {
    return _guard(() async {
      final models = await _remoteDataSource.getEbooks();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Ebook>> getEbook(String id) async {
    return _guard(
      () async => (await _remoteDataSource.getEbook(id)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, List<Ebook>>> searchEbooks(String query) async {
    return _guard(() async {
      final models = await _remoteDataSource.searchEbooks(query);
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Ebook>> uploadEbook({
    required String title,
    required String author,
    required String filePath,
    required String filename,
    required int fileSize,
    void Function(double progress)? onProgress,
  }) async {
    return _guard(() async {
      final model = await _remoteDataSource.uploadEbook(
        title: title,
        author: author,
        filePath: filePath,
        filename: filename,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl(String id) async {
    return _guard(() async => _remoteDataSource.getDownloadUrl(id));
  }

  @override
  Future<Either<Failure, void>> deleteEbook(String id) async {
    return _guard(() async {
      await _remoteDataSource.deleteEbook(id);
    });
  }

  @override
  Future<void> rememberLastPage(String ebookId, int page) async {
    _lastPages[ebookId] = page;
  }

  @override
  int lastPageFor(String ebookId) => _lastPages[ebookId] ?? 1;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (error) {
      return Left(_errorMapper.map(error));
    }
  }
}
