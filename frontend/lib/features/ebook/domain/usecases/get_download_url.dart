import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/ebook_repository.dart';

class GetDownloadUrl {
  const GetDownloadUrl(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, String>> call(String id) {
    return _repository.getDownloadUrl(id);
  }
}
