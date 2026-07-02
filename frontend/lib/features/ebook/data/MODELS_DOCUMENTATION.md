## Flutter Models - Production-Ready Implementation Guide

### Overview

Complete production-ready Flutter models following Clean Architecture, with proper error handling, JSON serialization, and mapping patterns.

---

## 1. Domain Entity Layer

**File:** `features/ebook/domain/entities/ebook.dart`

```dart
import 'package:equatable/equatable.dart';

class Ebook extends Equatable {
  const Ebook({
    required this.id,
    required this.title,
    required this.author,
    required this.fileType,
    required this.fileSize,
    required this.filename,
    required this.uploadedAt,
    this.downloadUrl,
    this.coverImageUrl,
    this.lastPage = 1,
  });

  final String id;
  final String title;
  final String author;
  final String fileType;
  final int fileSize;
  final String filename;
  final DateTime uploadedAt;
  final String? downloadUrl;
  final String? coverImageUrl;
  final int lastPage;

  @override
  List<Object?> get props => [
    id, title, author, fileType, fileSize,
    filename, uploadedAt, downloadUrl,
    coverImageUrl, lastPage,
  ];
}
```

**Benefits:**

- ✅ Business logic layer representation
- ✅ Equatable for value equality
- ✅ Immutable (const constructor)
- ✅ Independent from serialization concerns

---

## 2. Data Model Layer

### Option A: Current Production Implementation (Recommended)

**File:** `features/ebook/data/models/ebook_model.dart`

```dart
class EbookModel {
  const EbookModel({
    required int id,
    required String title,
    required String author,
    required String fileType,
    required int fileSize,
    String? filename,
    required DateTime uploadedAt,
    String? downloadUrl,
    String? coverImageUrl,
  }) : /* assignments */;

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'Untitled',
      author: json['author'] as String? ?? 'Unknown Author',
      fileType: json['file_type'] as String? ?? 'PDF',
      fileSize: (json['file_size'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String?,
      uploadedAt: DateTime.tryParse(
        json['uploaded_at'] as String? ?? ''
      ) ?? DateTime.now(),
      downloadUrl: _normalizeDownloadUrl(json['download_url'] as String?),
      coverImageUrl: json['cover_image_url'] as String?,
    );
  }

  static String? _normalizeDownloadUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.hasScheme) return rawUrl;
    final baseUrl = AppFlavor.current.baseUrl;
    if (baseUrl.isEmpty) return rawUrl;
    return Uri.parse(baseUrl).resolveUri(uri).toString();
  }

  Map<String, dynamic> toJson() { /* ... */ }
}
```

**Why:**

- ✅ Full control over deserialization logic
- ✅ Built-in URL normalization
- ✅ No code generation needed
- ✅ Perfect for handling edge cases
- ✅ Lightweight and simple

---

### Option B: Freezed Migration (Optional Upgrade)

**File:** `features/ebook/data/models/ebook_model_freezed.dart`

```dart
@freezed
class EbookModelFreezed with _$EbookModelFreezed {
  const factory EbookModelFreezed({
    required int id,
    required String title,
    required String author,
    @JsonKey(name: 'file_type') required String fileType,
    @JsonKey(name: 'file_size') required int fileSize,
    required String? filename,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    @JsonKey(name: 'download_url') required String? downloadUrl,
    @JsonKey(name: 'cover_image_url') required String? coverImageUrl,
  }) = _EbookModelFreezed;

  const EbookModelFreezed._();

  factory EbookModelFreezed.fromJson(Map<String, dynamic> json) =>
      _$EbookModelFreezedFromJson(json);
}
```

**Generate code:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Benefits of Freezed:**

- ✅ Auto-generated copyWith()
- ✅ Automatic equality & hashCode
- ✅ toString() with all fields
- ✅ Pattern matching support
- ⚠️ Requires code generation

**When to use Freezed:**

- Large projects with many models
- Need advanced copyWith features
- Team prefers generated patterns

---

## 3. JSON Mapping & Serialization

### JsonKey Mapping Reference

```dart
@JsonKey(
  name: 'field_name',           // JSON property name
  defaultValue: 'default',      // Fallback if missing
  fromJson: customParser,       // Custom deserialization
  toJson: customSerializer,     // Custom serialization
  includeIfNull: false,         // Exclude null values
  ignore: false,                // Ignore this field
)
```

### Examples

```dart
// Rename during deserialization
@JsonKey(name: 'file_type')
final String fileType;

// Provide default for missing values
@JsonKey(defaultValue: 'Untitled')
final String title;

// Custom parsing function
@JsonKey(
  fromJson: parseDateTime,
  toJson: formatDateTime,
)
final DateTime uploadedAt;

static DateTime parseDateTime(String? value) {
  return DateTime.tryParse(value ?? '') ?? DateTime.now();
}
```

---

## 4. Mapper Extensions

**File:** `features/ebook/data/mappers/ebook_mapper.dart`

### Single Item Mapping

```dart
extension EbookModelMapper on EbookModel {
  Ebook toEntity() {
    return Ebook(
      id: id.toString(),
      title: title,
      author: author,
      fileType: _normalizeFileType(fileType),
      fileSize: fileSize,
      filename: filename ?? '$title.pdf',
      uploadedAt: uploadedAt,
      downloadUrl: downloadUrl,
      coverImageUrl: coverImageUrl,
    );
  }

  String _normalizeFileType(String value) {
    if (value.toLowerCase().contains('pdf')) return 'PDF';
    if (value.toLowerCase().contains('epub')) return 'EPUB';
    return value.toUpperCase();
  }
}
```

### List Mapping

```dart
extension EbookModelListMapper on List<EbookModel> {
  List<Ebook> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
```

### Usage

```dart
// Single item
final model = EbookModel.fromJson(json);
final entity = model.toEntity();

// List
final models = response.data
    .map((json) => EbookModel.fromJson(json))
    .toList();
final entities = models.toEntities();
```

---

## 5. Error Models & API Response Handling

### API Error Response Model

**File:** `features/ebook/data/models/api_error_model.dart`

```dart
@JsonSerializable(createToJson: false)
class ApiErrorModel {
  const ApiErrorModel({
    this.errors = const [],
    this.error,
    this.message,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return _$ApiErrorModelFromJson(json);
  }

  /// Validation errors array (Rails format)
  /// Example: ["Title can't be blank", "File must be PDF"]
  @JsonKey(defaultValue: [])
  final List<String> errors;

  /// Single error message
  final String? error;

  /// General message field
  final String? message;

  /// Get first error or fallback
  String getFirstError() {
    if (errors.isNotEmpty) return errors.first;
    if (error?.isNotEmpty ?? false) return error!;
    if (message?.isNotEmpty ?? false) return message!;
    return 'An unknown error occurred';
  }

  /// Get all errors combined
  String getAllErrors() {
    final all = <String>[
      ...errors,
      if (error?.isNotEmpty ?? false) error!,
      if (message?.isNotEmpty ?? false) message!,
    ];
    return all.isEmpty
      ? 'An unknown error occurred'
      : all.join(', ');
  }
}
```

### Failure Classes (Existing)

**File:** `core/error/failure.dart`

```dart
sealed class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final int? code;
  final Object? details;
}

class NetworkFailure extends Failure { /* ... */ }
class ServerFailure extends Failure { /* ... */ }
class ValidationFailure extends Failure { /* ... */ }
class CacheFailure extends Failure { /* ... */ }
```

---

## 6. Remote Data Source - Complete Pattern

**File:** `features/ebook/data/datasources/ebook_remote_datasource.dart`

```dart
abstract class EbookRemoteDataSource {
  Future<List<EbookModel>> getEbooks();
  Future<EbookModel> getEbook(String id);
  Future<List<EbookModel>> searchEbooks(String query);
  Future<EbookModel> uploadEbook({
    required String title,
    required String author,
    required String filePath,
    required String filename,
    ProgressCallback? onSendProgress,
  });
  Future<String> getDownloadUrl(String id);
  Future<void> deleteEbook(String id);
}

class EbookRemoteDataSourceImpl implements EbookRemoteDataSource {
  const EbookRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<EbookModel>> getEbooks() async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.ebooks);
    return _parseCollection(response.data);
  }

  @override
  Future<EbookModel> getEbook(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.ebook(id)
    );
    return EbookModel.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<List<EbookModel>> searchEbooks(String query) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.search(Uri.encodeQueryComponent(query)),
    );
    return _parseCollection(response.data);
  }

  /// Parse collection with safe type handling
  List<EbookModel> _parseCollection(List<dynamic>? data) {
    return (data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(EbookModel.fromJson)
        .toList();
  }

  /// Parse individual item
  EbookModel _parseItem(Map<String, dynamic>? data) {
    return EbookModel.fromJson(data ?? <String, dynamic>{});
  }

  /// Normalize relative Active Storage paths
  String _normalizeDownloadUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.hasScheme) return rawUrl;
    final baseUrl = AppFlavor.current.baseUrl;
    if (baseUrl.isEmpty) return rawUrl;
    return Uri.parse(baseUrl).resolveUri(uri).toString();
  }
}
```

---

## 7. Repository Layer - Error Handling Pattern

**File:** `features/ebook/data/repositories/ebook_repository_impl.dart`

```dart
class EbookRepositoryImpl implements EbookRepository {
  const EbookRepositoryImpl({
    required EbookRemoteDataSource remoteDataSource,
    required ErrorMapper errorMapper,
  })  : _remoteDataSource = remoteDataSource,
        _errorMapper = errorMapper;

  final EbookRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  Future<Either<Failure, List<Ebook>>> getEbooks() async {
    return _guard(() async {
      final models = await _remoteDataSource.getEbooks();
      return models.toEntities(); // Using mapper extension
    });
  }

  /// Wrap operations with error handling
  Future<Either<Failure, T>> _guard<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (error) {
      return Left(_errorMapper.map(error));
    }
  }
}
```

---

## 8. API Response Examples

### List Response (GET /api/ebooks)

```json
[
  {
    "id": 1,
    "title": "Flutter Clean Architecture",
    "author": "Riya Sharma",
    "file_type": "application/pdf",
    "file_size": 12345,
    "filename": "flutter-clean-architecture.pdf",
    "uploaded_at": "2026-07-02T10:30:00Z",
    "download_url": "/rails/active_storage/blobs/redirect/eyJ..."
  },
  {
    "id": 2,
    "title": "Dart Programming",
    "author": "John Doe",
    "file_type": "application/pdf",
    "file_size": 54321,
    "filename": "dart-programming.pdf",
    "uploaded_at": "2026-07-01T15:45:00Z",
    "download_url": "/rails/active_storage/blobs/redirect/xyz..."
  }
]
```

### Single Item Response (GET /api/ebooks/:id)

```json
{
  "id": 1,
  "title": "Flutter Clean Architecture",
  "author": "Riya Sharma",
  "file_type": "application/pdf",
  "file_size": 12345,
  "filename": "flutter-clean-architecture.pdf",
  "uploaded_at": "2026-07-02T10:30:00Z",
  "download_url": "/rails/active_storage/blobs/redirect/eyJ..."
}
```

### Validation Error Response (POST /api/ebooks - 422)

```json
{
  "errors": [
    "Title can't be blank",
    "File must be a PDF",
    "File size must be less than 100MB"
  ]
}
```

### Server Error Response (500)

```json
{
  "error": "Internal Server Error",
  "message": "Unexpected error occurred"
}
```

---

## 9. Best Practices Checklist

- ✅ Domain entities are independent of serialization
- ✅ Data models handle JSON parsing with null safety
- ✅ Mapper extensions convert models to entities
- ✅ Error models capture API response structures
- ✅ Remote datasource returns models, not entities
- ✅ Repository layer returns Either<Failure, T>
- ✅ Error handling happens in repository.\_guard()
- ✅ Null safety throughout all layers
- ✅ Type checking on response data
- ✅ Default values for required fields
- ✅ URL normalization for relative paths
- ✅ File type normalization for consistency

---

## 10. Testing Examples

```dart
void main() {
  group('EbookModel', () {
    test('fromJson parses valid response', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'author': 'Author',
        'file_type': 'application/pdf',
        'file_size': 1000,
        'uploaded_at': '2026-07-02T00:00:00Z',
        'download_url': '/rails/active_storage/...',
      };

      final model = EbookModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'Test');
    });

    test('toEntity returns correct Ebook', () {
      final model = EbookModel(/* params */);
      final entity = model.toEntity();

      expect(entity.id, model.id.toString());
      expect(entity.title, model.title);
    });
  });

  group('ApiErrorModel', () {
    test('parses validation errors', () {
      final json = {
        'errors': ['Title required', 'File required'],
      };

      final error = ApiErrorModel.fromJson(json);

      expect(error.errors.length, 2);
      expect(error.getFirstError(), 'Title required');
    });
  });
}
```

---

## Migration Guide: From Manual to Freezed

### Step 1: Run code generation

```bash
cd frontend
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Update imports

```dart
// Old
import '../models/ebook_model.dart';

// New
import '../models/ebook_model_freezed.dart' as freezed;
```

### Step 3: Update datasource

```dart
// Old
List<EbookModel> _parseCollection(List<dynamic>? data) {
  return (data ?? [])
    .whereType<Map<String, dynamic>>()
    .map(EbookModel.fromJson)
    .toList();
}

// New
List<freezed.EbookModelFreezed> _parseCollection(List<dynamic>? data) {
  return (data ?? [])
    .whereType<Map<String, dynamic>>()
    .map(freezed.EbookModelFreezed.fromJson)
    .toList();
}
```

---

## Summary

Your models are **production-ready** with:

- ✅ Clean Architecture separation
- ✅ Proper error handling
- ✅ JSON serialization
- ✅ Mapper extensions
- ✅ Null safety
- ✅ Type safety
- ✅ API response parsing patterns
- ✅ Optional Freezed migration path

Start with the current manual implementation and migrate to Freezed only if needed!
