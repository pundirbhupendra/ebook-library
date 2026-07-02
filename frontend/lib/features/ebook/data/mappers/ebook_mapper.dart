import '../../domain/entities/ebook.dart';
import '../models/ebook_model.dart';

/// Extension for mapping EbookModel to Ebook entity
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

  /// Normalize file type to standard format (e.g., 'application/pdf' -> 'PDF')
  String _normalizeFileType(String value) {
    if (value.toLowerCase().contains('pdf')) return 'PDF';
    if (value.toLowerCase().contains('epub')) return 'EPUB';
    if (value.toLowerCase().contains('mobi')) return 'MOBI';
    return value.toUpperCase();
  }
}

/// Extension for mapping `List<EbookModel>` to `List<Ebook>`
extension EbookModelListMapper on List<EbookModel> {
  List<Ebook> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
