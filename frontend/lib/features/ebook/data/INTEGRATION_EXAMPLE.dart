import 'package:dartz/dartz.dart';
import 'package:frontend/features/ebook/data/models/ebook_model.dart';
import 'package:frontend/features/ebook/domain/entities/ebook.dart';
import 'package:frontend/features/ebook/domain/repositories/ebook_repository.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import 'mappers/ebook_mapper.dart';

/// Complete Real-World Integration Example
///
/// Shows how all layers work together:
/// 1. Remote datasource fetches models
/// 2. Models are mapped to entities
/// 3. Repository wraps in Either<Failure, T>
/// 4. Use cases call repository
/// 5. Bloc dispatches use case

// ============================================================================
// LAYER 1: Remote Datasource (API Communication)
// ============================================================================

abstract class EbookRemoteDataSourceExample {
  /// Returns raw EbookModel instances (DTO layer)
  Future<List<EbookModel>> getEbooks();
  Future<EbookModel> getEbook(String id);
  Future<List<EbookModel>> searchEbooks(String query);
}

// ============================================================================
// LAYER 2: Repository (Error Handling + Mapping)
// ============================================================================

class EbookRepositoryExample implements EbookRepository {
  const EbookRepositoryExample({
    required EbookRemoteDataSourceExample remoteDataSource,
    required ErrorMapper errorMapper,
  }) : _remoteDataSource = remoteDataSource,
       _errorMapper = errorMapper;

  final EbookRemoteDataSourceExample _remoteDataSource;
  final ErrorMapper _errorMapper;

  /// Get all ebooks - Returns Either<Failure, List<Ebook>>
  @override
  Future<Either<Failure, List<Ebook>>> getEbooks() async {
    return _guard(() async {
      // Step 1: Fetch models from datasource
      final models = await _remoteDataSource.getEbooks();

      // Step 2: Map models to entities using extension
      return models.toEntities();
    });
  }

  /// Get single ebook - Returns Either<Failure, Ebook>
  @override
  Future<Either<Failure, Ebook>> getEbook(String id) async {
    return _guard(() async {
      // Step 1: Fetch model from datasource
      final model = await _remoteDataSource.getEbook(id);

      // Step 2: Map to entity using extension
      return model.toEntity();
    });
  }

  /// Search ebooks - Returns Either<Failure, List<Ebook>>
  @override
  Future<Either<Failure, List<Ebook>>> searchEbooks(String query) async {
    return _guard(() async {
      // Step 1: Fetch models from datasource
      final models = await _remoteDataSource.searchEbooks(query);

      // Step 2: Map to entities using extension
      return models.toEntities();
    });
  }

  /// Generic guard for error handling
  /// Catches any exception and maps it to Failure
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (error) {
      // Map any error (DioException, etc.) to Failure
      return Left(_errorMapper.map(error));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEbook(String id) {
    // TODO: implement deleteEbook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl(String id) {
    // TODO: implement getDownloadUrl
    throw UnimplementedError();
  }

  @override
  int lastPageFor(String ebookId) {
    // TODO: implement lastPageFor
    throw UnimplementedError();
  }

  @override
  Future<void> rememberLastPage(String ebookId, int page) {
    // TODO: implement rememberLastPage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Ebook>> uploadEbook({
    required String title,
    required String author,
    required String filePath,
    required String filename,
    required int fileSize,
    void Function(double progress)? onProgress,
  }) {
    // TODO: implement uploadEbook
    throw UnimplementedError();
  }
}

// ============================================================================
// LAYER 3: Use Cases (Business Logic)
// ============================================================================

class GetEbooksUseCase {
  const GetEbooksUseCase(this._repository);

  final EbookRepository _repository;

  /// Call returns Either<Failure, List<Ebook>>
  Future<Either<Failure, List<Ebook>>> call() async {
    return await _repository.getEbooks();
  }
}

class SearchEbooksUseCase {
  const SearchEbooksUseCase(this._repository);

  final EbookRepository _repository;

  Future<Either<Failure, List<Ebook>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Search query cannot be empty'));
    }

    return await _repository.searchEbooks(query);
  }
}

// ============================================================================
// LAYER 4: BLoC (State Management)
// ============================================================================

// Event
class EbookLibraryRequested {
  const EbookLibraryRequested();
}

// State
class EbookState {
  const EbookState({
    this.ebooks = const [],
    this.isLoading = false,
    this.failure,
    this.hasMore = true,
  });

  final List<Ebook> ebooks;
  final bool isLoading;
  final Failure? failure;
  final bool hasMore;
}

// BLoC Handler Example
Future<void> _handleEbookLibraryRequested(
  EbookLibraryRequested event,
  GetEbooksUseCase getEbooksUseCase,
) async {
  // Step 1: Call use case which returns Either
  final result = await getEbooksUseCase.call();

  // Step 2: Handle Both success and failure
  result.fold(
    // Failure handler
    (failure) {
      print('Error: ${failure.message}');
      // Emit failure state
    },
    // Success handler
    (ebooks) {
      print('Loaded ${ebooks.length} ebooks');
      // Emit success state with ebooks
    },
  );
}

// ============================================================================
// LAYER 5: Widget (Presentation)
// ============================================================================

// Widget example showing how data flows through all layers
Future<void> _widgetIntegrationExample() async {
  // This is what happens when user opens the app:

  // 1. Widget dispatches event to BLoC
  // ebookBloc.add(EbookLibraryRequested());

  // 2. BLoC calls use case
  // final result = await getEbooksUseCase.call();

  // 3. Use case calls repository
  // await _repository.getEbooks();

  // 4. Repository calls datasource wrapped in _guard()
  // final models = await _remoteDataSource.getEbooks();

  // 5. Models are mapped to entities
  // return models.toEntities(); // Extension: List<EbookModel> -> List<Ebook>

  // 6. Result wrapped in Either<Failure, List<Ebook>>
  // return Right(entities);

  // 7. BLoC listens to Either result
  // result.fold(
  //   (failure) => emit(FailureState(failure)),
  //   (ebooks) => emit(SuccessState(ebooks)),
  // );

  // 8. Widget rebuilds with new state
}

// ============================================================================
// COMPLETE DATA FLOW EXAMPLE
// ============================================================================

/// This is what happens when user opens the Library screen:
///
/// USER ACTION: Opens app → Library screen loaded
///
/// 1. WIDGET LAYER (lib/features/ebook/presentation/pages/library_page.dart)
///    ↓
///    context.read<EbookBloc>().add(EbookLibraryRequested());
///
/// 2. BLoC LAYER (lib/features/ebook/presentation/bloc/ebook_bloc.dart)
///    ↓
///    Future.delayed(() async {
///      final result = await getEbooksUseCase();
///      result.fold(
///        (failure) => emit(EbookState(failure: failure)),
///        (ebooks) => emit(EbookState(ebooks: ebooks)),
///      );
///    });
///
/// 3. USE CASE LAYER (lib/features/ebook/domain/usecases/get_ebooks.dart)
///    ↓
///    return await _repository.getEbooks();
///
/// 4. REPOSITORY LAYER (lib/features/ebook/data/repositories/)
///    ↓
///    return _guard(() async {
///      final models = await _remoteDataSource.getEbooks();
///      return models.toEntities();  // ← Mapper extension
///    });
///
/// 5. DATA SOURCE LAYER (lib/features/ebook/data/datasources/)
///    ↓
///    final response = await dio.get('/api/ebooks');
///    return (response.data as List)
///      .map((json) => EbookModel.fromJson(json))
///      .toList();
///
/// 6. JSON PARSING (EbookModel.fromJson)
///    ↓
///    JSON:
///    {
///      "id": 1,
///      "title": "Flutter Clean Architecture",
///      "author": "Riya Sharma",
///      "file_type": "application/pdf",
///      "file_size": 12345,
///      "filename": "flutter-clean-architecture.pdf",
///      "uploaded_at": "2026-07-02T10:30:00Z",
///      "download_url": "/rails/active_storage/blobs/redirect/eyJ..."
///    }
///    ↓
///    EbookModel created with normalized fields
///
/// 7. ENTITY MAPPING (model.toEntity())
///    ↓
///    Returns: Ebook(
///      id: "1",
///      title: "Flutter Clean Architecture",
///      author: "Riya Sharma",
///      fileType: "PDF",
///      fileSize: 12345,
///      filename: "flutter-clean-architecture.pdf",
///      uploadedAt: DateTime(...),
///      downloadUrl: "http://localhost:3000/rails/active_storage/blobs/redirect/...",
///    )
///
/// 8. REPOSITORY RETURNS Either<Failure, List<Ebook>>
///    ↓
///    Right([Ebook(...), Ebook(...), ...])
///
/// 9. USE CASE RETURNS Either<Failure, List<Ebook>>
///    ↓
///    Passed to BLoC
///
/// 10. BLoC FOLDS Result
///     ↓
///     Success case: emit(EbookState(ebooks: ebooks))
///
/// 11. WIDGET REBUILDS
///     ↓
///     ListView.builder displays ebooks from state.ebooks
///
/// ============================================================================

// EXAMPLE OUTPUT:
// ============================================================================
//
// After complete flow, widget displays:
//
// ┌─────────────────────────────────────┐
// │ Digital Ebook Library               │
// ├─────────────────────────────────────┤
// │ 1. Flutter Clean Architecture       │
// │    Riya Sharma | 12.3 KB           │
// │                                     │
// │ 2. Dart Programming Guide          │
// │    John Doe | 54.3 KB              │
// │                                     │
// │ 3. Advanced Flutter Patterns        │
// │    Sarah Chen | 23.1 KB            │
// └─────────────────────────────────────┘
//
// All data from API, no mock data involved! ✅
