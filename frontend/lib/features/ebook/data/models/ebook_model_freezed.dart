import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ebook.dart';
import '../../../../flavor/app_flavor.dart';

part 'ebook_model_freezed.freezed.dart';
part 'ebook_model_freezed.g.dart';

/// Production-ready Freezed Ebook Data Model
///
/// Migration path for replacing current EbookModel
/// Benefits:
/// - CopyWith generation
/// - Equality & hashCode auto-implementation
/// - ToString & debugFillProperties
/// - Sealed/pattern matching support
///
/// Usage: flutter pub run build_runner build --delete-conflicting-outputs
@freezed
abstract class EbookModelFreezed with _$EbookModelFreezed {
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

  /// Map to domain entity
  Ebook toEntity() {
    return Ebook(
      id: id.toString(),
      title: title,
      author: author,
      fileType: _normalizeFileType(fileType),
      fileSize: fileSize,
      filename: filename ?? '$title.pdf',
      uploadedAt: uploadedAt,
      downloadUrl: _normalizeDownloadUrl(downloadUrl),
      coverImageUrl: coverImageUrl,
    );
  }

  /// Normalize relative Active Storage paths to absolute URLs
  static String? _normalizeDownloadUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;

    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.hasScheme) return rawUrl;

    final baseUrl = AppFlavor.current.baseUrl;
    if (baseUrl.isEmpty) return rawUrl;

    return Uri.parse(baseUrl).resolveUri(uri).toString();
  }

  /// Normalize file type to standard format
  static String _normalizeFileType(String value) {
    if (value.toLowerCase().contains('pdf')) return 'PDF';
    if (value.toLowerCase().contains('epub')) return 'EPUB';
    if (value.toLowerCase().contains('mobi')) return 'MOBI';
    return value.toUpperCase();
  }
}

/// Extension for List mapping
extension EbookModelFreezedListMapper on List<EbookModelFreezed> {
  List<Ebook> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
