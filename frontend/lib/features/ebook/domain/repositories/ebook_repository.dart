import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ebook.dart';

abstract class EbookRepository {
  Future<Either<Failure, List<Ebook>>> getEbooks();
  Future<Either<Failure, Ebook>> getEbook(String id);
  Future<Either<Failure, List<Ebook>>> searchEbooks(String query);
  Future<Either<Failure, Ebook>> uploadEbook({
    required String title,
    required String author,
    required String filePath,
    required String filename,
    required int fileSize,
    void Function(double progress)? onProgress,
  });
  Future<Either<Failure, String>> getDownloadUrl(String id);
  Future<Either<Failure, void>> deleteEbook(String id);
  Future<void> rememberLastPage(String ebookId, int page);
  int lastPageFor(String ebookId);
}
