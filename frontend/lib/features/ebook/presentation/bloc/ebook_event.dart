part of 'ebook_bloc.dart';

sealed class EbookEvent extends Equatable {
  const EbookEvent();

  @override
  List<Object?> get props => [];
}

class EbookLibraryRequested extends EbookEvent {
  const EbookLibraryRequested();
}

class EbookSearchChanged extends EbookEvent {
  const EbookSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class EbookSearchCleared extends EbookEvent {
  const EbookSearchCleared();
}

class EbookUploadRequested extends EbookEvent {
  const EbookUploadRequested({
    required this.title,
    required this.author,
    required this.filePath,
    required this.filename,
    required this.fileSize,
  });

  final String title;
  final String author;
  final String filePath;
  final String filename;
  final int fileSize;

  @override
  List<Object?> get props => [title, author, filePath, filename, fileSize];
}

class EbookDeleteRequested extends EbookEvent {
  const EbookDeleteRequested(this.ebook);

  final Ebook ebook;

  @override
  List<Object?> get props => [ebook];
}

class EbookUploadProgressChanged extends EbookEvent {
  const EbookUploadProgressChanged(this.progress);

  final double progress;

  @override
  List<Object?> get props => [progress];
}

class EbookReaderPageChanged extends EbookEvent {
  const EbookReaderPageChanged({required this.ebookId, required this.page});

  final String ebookId;
  final int page;

  @override
  List<Object?> get props => [ebookId, page];
}
