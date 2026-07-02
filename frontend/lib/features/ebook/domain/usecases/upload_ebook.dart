import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ebook.dart';
import '../repositories/ebook_repository.dart';

class UploadEbook {
  const UploadEbook(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, Ebook>> call(UploadEbookParams params) {
    return _repository.uploadEbook(
      title: params.title,
      author: params.author,
      filePath: params.filePath,
      filename: params.filename,
      fileSize: params.fileSize,
      onProgress: params.onProgress,
    );
  }
}

class UploadEbookParams {
  const UploadEbookParams({
    required this.title,
    required this.author,
    required this.filePath,
    required this.filename,
    required this.fileSize,
    this.onProgress,
  });

  final String title;
  final String author;
  final String filePath;
  final String filename;
  final int fileSize;
  final void Function(double progress)? onProgress;
}
