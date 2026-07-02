import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ebook.dart';
import '../repositories/ebook_repository.dart';

class SearchEbooks {
  const SearchEbooks(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, List<Ebook>>> call(String query) {
    return _repository.searchEbooks(query);
  }
}
