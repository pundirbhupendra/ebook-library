import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/ebook_repository.dart';

class DeleteEbook {
  const DeleteEbook(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.deleteEbook(id);
}
