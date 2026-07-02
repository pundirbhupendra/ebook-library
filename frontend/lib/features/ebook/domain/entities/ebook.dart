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

  Ebook copyWith({
    String? id,
    String? title,
    String? author,
    String? fileType,
    int? fileSize,
    String? filename,
    DateTime? uploadedAt,
    String? downloadUrl,
    String? coverImageUrl,
    int? lastPage,
  }) {
    return Ebook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      filename: filename ?? this.filename,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    fileType,
    fileSize,
    filename,
    uploadedAt,
    downloadUrl,
    coverImageUrl,
    lastPage,
  ];
}
