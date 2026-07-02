import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ebook.dart';
import '../repositories/ebook_repository.dart';

class GetEbooks {
  const GetEbooks(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, List<Ebook>>> call() => _repository.getEbooks();
}
