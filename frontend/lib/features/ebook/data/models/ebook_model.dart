import '../../../../flavor/app_flavor.dart';

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
  }) : id = id,
       title = title,
       author = author,
       fileType = fileType,
       fileSize = fileSize,
       filename = filename,
       uploadedAt = uploadedAt,
       downloadUrl = downloadUrl,
       coverImageUrl = coverImageUrl;

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'Untitled',
      author: json['author'] as String? ?? 'Unknown Author',
      fileType: json['file_type'] as String? ?? 'PDF',
      fileSize: (json['file_size'] as num?)?.toInt() ?? 0,
      filename: json['filename'] as String?,
      uploadedAt: DateTime.tryParse(json['uploaded_at'] as String? ?? '') ?? DateTime.now(),
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

  final int id;
  final String title;
  final String author;
  final String fileType;
  final int fileSize;
  final String? filename;
  final DateTime uploadedAt;
  final String? downloadUrl;
  final String? coverImageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'file_type': fileType,
      'file_size': fileSize,
      'filename': filename,
      'uploaded_at': uploadedAt.toIso8601String(),
      'download_url': downloadUrl,
      'cover_image_url': coverImageUrl,
    };
  }
}
