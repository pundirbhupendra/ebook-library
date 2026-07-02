part of 'ebook_bloc.dart';

enum EbookStatus { initial, loading, success, empty, failure }

enum EbookMutationStatus { idle, uploading, success, failure, deleting }

class EbookState extends Equatable {
  const EbookState({
    this.status = EbookStatus.initial,
    this.mutationStatus = EbookMutationStatus.idle,
    this.ebooks = const <Ebook>[],
    this.filteredEbooks = const <Ebook>[],
    this.searchQuery = '',
    this.errorMessage,
    this.uploadProgress = 0,
    this.lastDeletedEbook,
  });

  final EbookStatus status;
  final EbookMutationStatus mutationStatus;
  final List<Ebook> ebooks;
  final List<Ebook> filteredEbooks;
  final String searchQuery;
  final String? errorMessage;
  final double uploadProgress;
  final Ebook? lastDeletedEbook;

  bool get isSearching => searchQuery.trim().isNotEmpty;
  List<Ebook> get visibleEbooks => isSearching ? filteredEbooks : ebooks;
  int get resultCount => visibleEbooks.length;

  EbookState copyWith({
    EbookStatus? status,
    EbookMutationStatus? mutationStatus,
    List<Ebook>? ebooks,
    List<Ebook>? filteredEbooks,
    String? searchQuery,
    String? errorMessage,
    double? uploadProgress,
    Ebook? lastDeletedEbook,
    bool clearError = false,
    bool clearDeleted = false,
  }) {
    return EbookState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      ebooks: ebooks ?? this.ebooks,
      filteredEbooks: filteredEbooks ?? this.filteredEbooks,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      lastDeletedEbook: clearDeleted
          ? null
          : lastDeletedEbook ?? this.lastDeletedEbook,
    );
  }

  @override
  List<Object?> get props => [
    status,
    mutationStatus,
    ebooks,
    filteredEbooks,
    searchQuery,
    errorMessage,
    uploadProgress,
    lastDeletedEbook,
  ];
}
