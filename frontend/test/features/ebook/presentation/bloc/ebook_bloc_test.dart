import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/ebook/domain/entities/ebook.dart';
import 'package:frontend/features/ebook/domain/repositories/ebook_repository.dart';
import 'package:frontend/features/ebook/domain/usecases/delete_ebook.dart';
import 'package:frontend/features/ebook/domain/usecases/get_ebooks.dart';
import 'package:frontend/features/ebook/domain/usecases/search_ebooks.dart';
import 'package:frontend/features/ebook/domain/usecases/upload_ebook.dart';
import 'package:frontend/features/ebook/presentation/bloc/ebook_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockEbookRepository extends Mock implements EbookRepository {}

void main() {
  late MockEbookRepository repository;
  late Ebook ebook;

  EbookBloc buildBloc() {
    return EbookBloc(getEbooks: GetEbooks(repository), searchEbooks: SearchEbooks(repository), uploadEbook: UploadEbook(repository), deleteEbook: DeleteEbook(repository), repository: repository);
  }

  setUp(() {
    repository = MockEbookRepository();
    ebook = Ebook(
      id: '1',
      title: 'Flutter Clean Architecture',
      author: 'Riya Sharma',
      fileType: 'PDF',
      fileSize: 1200000,
      filename: 'flutter-clean-architecture.pdf',
      uploadedAt: DateTime(2026, 6, 28),
    );
  });

  blocTest<EbookBloc, EbookState>(
    'loads ebooks',
    setUp: () {
      when(() => repository.getEbooks()).thenAnswer((_) async => Right([ebook]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const EbookLibraryRequested()),
    expect: () => [
      isA<EbookState>().having((state) => state.status, 'status', EbookStatus.loading),
      isA<EbookState>().having((state) => state.status, 'status', EbookStatus.success).having((state) => state.ebooks.length, 'ebooks', 1),
    ],
  );

  blocTest<EbookBloc, EbookState>(
    'shows empty library state when the API returns no ebooks',
    setUp: () {
      when(() => repository.getEbooks()).thenAnswer((_) async => Right(<Ebook>[]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const EbookLibraryRequested()),
    expect: () => [
      isA<EbookState>().having((state) => state.status, 'status', EbookStatus.loading),
      isA<EbookState>().having((state) => state.status, 'status', EbookStatus.empty).having((state) => state.ebooks, 'ebooks', isEmpty).having((state) => state.filteredEbooks, 'filtered', isEmpty),
    ],
  );

  blocTest<EbookBloc, EbookState>(
    'searches ebooks',
    setUp: () {
      when(() => repository.searchEbooks('flutter')).thenAnswer((_) async => Right([ebook]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const EbookSearchChanged('flutter')),
    wait: const Duration(milliseconds: 450),
    expect: () => [
      isA<EbookState>().having((state) => state.searchQuery, 'query', 'flutter'),
      isA<EbookState>().having((state) => state.filteredEbooks, 'results', [ebook]),
    ],
  );

  blocTest<EbookBloc, EbookState>(
    'uploads ebook',
    setUp: () {
      when(
        () => repository.uploadEbook(
          title: any(named: 'title'),
          author: any(named: 'author'),
          filePath: any(named: 'filePath'),
          filename: any(named: 'filename'),
          fileSize: any(named: 'fileSize'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => Right(ebook));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const EbookUploadRequested(title: 'Flutter Clean Architecture', author: 'Riya Sharma', filePath: '/tmp/book.pdf', filename: 'book.pdf', fileSize: 1200000)),
    expect: () => [
      isA<EbookState>().having((state) => state.mutationStatus, 'mutation', EbookMutationStatus.uploading),
      isA<EbookState>().having((state) => state.mutationStatus, 'mutation', EbookMutationStatus.success).having((state) => state.ebooks.length, 'ebooks', 1),
    ],
  );

  blocTest<EbookBloc, EbookState>(
    'deletes ebook',
    setUp: () {
      when(() => repository.deleteEbook('1')).thenAnswer((_) async => const Right<Never, void>(null));
    },
    seed: () => EbookState(status: EbookStatus.success, ebooks: [ebook], filteredEbooks: [ebook]),
    build: buildBloc,
    act: (bloc) => bloc.add(EbookDeleteRequested(ebook)),
    expect: () => [
      isA<EbookState>().having((state) => state.mutationStatus, 'mutation', EbookMutationStatus.deleting),
      isA<EbookState>().having((state) => state.status, 'status', EbookStatus.empty).having((state) => state.ebooks, 'ebooks', isEmpty),
    ],
  );
}
