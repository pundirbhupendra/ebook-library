import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../models/api_error_model.dart';
import '../models/ebook_model.dart';

/// Production-ready example of response parsing and error handling
///
/// Demonstrates:
/// 1. API response parsing with proper error handling
/// 2. List response mapping
/// 3. Single item response handling
/// 4. Error extraction and mapping
class ResponseParsingExample {
  // ============================================================================
  // EXAMPLE 1: Parse List Response (GET /api/ebooks)
  // ============================================================================

  /// Example API Response:
  /// ```json
  /// [
  ///   {
  ///     "id": 1,
  ///     "title": "Flutter Clean Architecture",
  ///     "author": "Riya Sharma",
  ///     "file_type": "application/pdf",
  ///     "file_size": 12345,
  ///     "filename": "flutter-clean-architecture.pdf",
  ///     "uploaded_at": "2026-07-02T00:00:00Z",
  ///     "download_url": "/rails/active_storage/blobs/redirect/eyJ..."
  ///   },
  ///   ...
  /// ]
  /// ```
  static Either<Failure, List<EbookModel>> parseListResponse(Response<dynamic> response, ErrorMapper errorMapper) {
    try {
      final data = response.data;

      // Validate response data
      if (data is! List) {
        return Left(ValidationFailure(message: 'Expected list response but got ${data.runtimeType}', code: response.statusCode));
      }

      // Parse each item
      final models = data.whereType<Map<String, dynamic>>().map((json) => EbookModel.fromJson(json)).toList();

      return Right(models);
    } catch (error) {
      return Left(errorMapper.map(error));
    }
  }

  // ============================================================================
  // EXAMPLE 2: Parse Single Item Response (GET /api/ebooks/:id)
  // ============================================================================

  /// Example API Response:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "title": "Flutter Clean Architecture",
  ///   "author": "Riya Sharma",
  ///   "file_type": "application/pdf",
  ///   "file_size": 12345,
  ///   "filename": "flutter-clean-architecture.pdf",
  ///   "uploaded_at": "2026-07-02T00:00:00Z",
  ///   "download_url": "/rails/active_storage/blobs/redirect/eyJ..."
  /// }
  /// ```
  static Either<Failure, EbookModel> parseSingleResponse(Response<dynamic> response, ErrorMapper errorMapper) {
    try {
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        return Left(ValidationFailure(message: 'Expected object response but got ${data.runtimeType}', code: response.statusCode));
      }

      final model = EbookModel.fromJson(data);
      return Right(model);
    } catch (error) {
      return Left(errorMapper.map(error));
    }
  }

  // ============================================================================
  // EXAMPLE 3: Parse Error Response (4xx/5xx errors)
  // ============================================================================

  /// Example Validation Error Response (422):
  /// ```json
  /// {
  ///   "errors": [
  ///     "Title can't be blank",
  ///     "File must be a PDF",
  ///     "File size must be less than 100MB"
  ///   ]
  /// }
  /// ```
  ///
  /// Example Server Error Response (500):
  /// ```json
  /// {
  ///   "error": "Internal Server Error",
  ///   "message": "Something went wrong"
  /// }
  /// ```
  static ApiErrorModel? tryParseErrorResponse(Response<dynamic>? response) {
    if (response == null) return null;
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ApiErrorModel.fromJson(data);
      }
    } catch (_) {
      // Ignore parse errors, return null
    }
    return null;
  }

  // ============================================================================
  // EXAMPLE 4: Full Remote Datasource Pattern
  // ============================================================================

  /// Complete example showing proper error handling in datasource methods
  static Future<Either<Failure, List<EbookModel>>> getEbooksWithErrorHandling(Dio dio, ErrorMapper errorMapper) async {
    try {
      final response = await dio.get<List<dynamic>>('/api/ebooks');

      if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
        return Left(ServerFailure(message: 'Invalid response status: ${response.statusCode}', code: response.statusCode));
      }

      final data = response.data;
      if (data == null) {
        return Left(ServerFailure(message: 'Empty response body', code: response.statusCode));
      }

      final models = data
          .whereType<Map<String, dynamic>>()
          .map((json) {
            try {
              return EbookModel.fromJson(json);
            } catch (_) {
              // Parse error - skip this item and continue with others
              return null;
            }
          })
          .whereType<EbookModel>()
          .toList();

      return Right(models);
    } on DioException catch (e) {
      return Left(errorMapper.map(e));
    } catch (error) {
      return Left(errorMapper.map(error));
    }
  }

  // ============================================================================
  // EXAMPLE 5: Paginated Response Parsing
  // ============================================================================

  /// Example Paginated API Response:
  /// ```json
  /// {
  ///   "data": [
  ///     { "id": 1, "title": "...", ... },
  ///     { "id": 2, "title": "...", ... }
  ///   ],
  ///   "pagination": {
  ///     "page": 1,
  ///     "per_page": 20,
  ///     "total": 100,
  ///     "total_pages": 5
  ///   }
  /// }
  /// ```
  static Either<Failure, (List<EbookModel>, PaginationInfo)> parsePaginatedResponse(Response<dynamic> response, ErrorMapper errorMapper) {
    try {
      final json = response.data as Map<String, dynamic>;

      final dataList = json['data'] as List?;
      if (dataList == null) {
        return Left(ValidationFailure(message: 'Missing "data" field in paginated response'));
      }

      final models = dataList.whereType<Map<String, dynamic>>().map((item) => EbookModel.fromJson(item)).toList();

      final paginationJson = json['pagination'] as Map<String, dynamic>?;
      final pagination = paginationJson != null ? PaginationInfo.fromJson(paginationJson) : PaginationInfo.empty();

      return Right((models, pagination));
    } catch (error) {
      return Left(errorMapper.map(error));
    }
  }
}

/// Pagination metadata model
class PaginationInfo {
  const PaginationInfo({required this.page, required this.perPage, required this.total, required this.totalPages});

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(page: json['page'] as int? ?? 1, perPage: json['per_page'] as int? ?? 20, total: json['total'] as int? ?? 0, totalPages: json['total_pages'] as int? ?? 0);
  }

  factory PaginationInfo.empty() {
    return const PaginationInfo(page: 1, perPage: 0, total: 0, totalPages: 0);
  }

  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}
