import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/ebook.dart';
import '../../domain/repositories/ebook_repository.dart';
import '../../domain/usecases/delete_ebook.dart';
import '../../domain/usecases/get_ebooks.dart';
import '../../domain/usecases/search_ebooks.dart';
import '../../domain/usecases/upload_ebook.dart';

part 'ebook_event.dart';
part 'ebook_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    Timer? timer;
    StreamController<E>? controller;

    void onDone() {
      timer?.cancel();
      controller?.close();
    }

    controller = StreamController<E>(
      onListen: () {
        events.listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () => controller?.add(event));
          },
          onError: controller?.addError,
          onDone: onDone,
        );
      },
      onCancel: () {
        timer?.cancel();
      },
    );

    return controller.stream.asyncExpand(mapper);
  };
}

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  EbookBloc({
    required GetEbooks getEbooks,
    required SearchEbooks searchEbooks,
    required UploadEbook uploadEbook,
    required DeleteEbook deleteEbook,
    required EbookRepository repository,
  }) : _getEbooks = getEbooks,
       _searchEbooks = searchEbooks,
       _uploadEbook = uploadEbook,
       _deleteEbook = deleteEbook,
       _repository = repository,
       super(const EbookState()) {
    on<EbookLibraryRequested>(_onLibraryRequested);
    on<EbookSearchChanged>(
      _onSearchChanged,
      transformer: debounceDroppable(AppConstants.searchDebounce),
    );
    on<EbookSearchCleared>(_onSearchCleared);
    on<EbookUploadRequested>(_onUploadRequested);
    on<EbookUploadProgressChanged>(_onUploadProgressChanged);
    on<EbookDeleteRequested>(_onDeleteRequested);
    on<EbookReaderPageChanged>(_onReaderPageChanged);
  }

  final GetEbooks _getEbooks;
  final SearchEbooks _searchEbooks;
  final UploadEbook _uploadEbook;
  final DeleteEbook _deleteEbook;
  final EbookRepository _repository;

  Future<void> _onLibraryRequested(
    EbookLibraryRequested event,
    Emitter<EbookState> emit,
  ) async {
    emit(state.copyWith(status: EbookStatus.loading, clearError: true));
    final result = await _getEbooks();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EbookStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (ebooks) => emit(
        state.copyWith(
          status: ebooks.isEmpty ? EbookStatus.empty : EbookStatus.success,
          ebooks: ebooks,
          filteredEbooks: ebooks,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onSearchChanged(
    EbookSearchChanged event,
    Emitter<EbookState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredEbooks: state.ebooks));
      return;
    }

    emit(state.copyWith(searchQuery: query, clearError: true));
    final result = await _searchEbooks(query);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (ebooks) => emit(state.copyWith(filteredEbooks: ebooks)),
    );
  }

  void _onSearchCleared(EbookSearchCleared event, Emitter<EbookState> emit) {
    emit(state.copyWith(searchQuery: '', filteredEbooks: state.ebooks));
  }

  Future<void> _onUploadRequested(
    EbookUploadRequested event,
    Emitter<EbookState> emit,
  ) async {
    emit(
      state.copyWith(
        mutationStatus: EbookMutationStatus.uploading,
        uploadProgress: 0,
        clearError: true,
      ),
    );
    final result = await _uploadEbook(
      UploadEbookParams(
        title: event.title,
        author: event.author,
        filePath: event.filePath,
        filename: event.filename,
        fileSize: event.fileSize,
        onProgress: (progress) => add(EbookUploadProgressChanged(progress)),
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          mutationStatus: EbookMutationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (ebook) {
        final ebooks = [ebook, ...state.ebooks];
        emit(
          state.copyWith(
            status: EbookStatus.success,
            mutationStatus: EbookMutationStatus.success,
            ebooks: ebooks,
            filteredEbooks: state.isSearching ? state.filteredEbooks : ebooks,
            uploadProgress: 1,
            clearError: true,
          ),
        );
      },
    );
  }

  void _onUploadProgressChanged(
    EbookUploadProgressChanged event,
    Emitter<EbookState> emit,
  ) {
    emit(state.copyWith(uploadProgress: event.progress.clamp(0, 1)));
  }

  Future<void> _onDeleteRequested(
    EbookDeleteRequested event,
    Emitter<EbookState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: EbookMutationStatus.deleting));
    final result = await _deleteEbook(event.ebook.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          mutationStatus: EbookMutationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final ebooks =
            state.ebooks.where((ebook) => ebook.id != event.ebook.id).toList();
        final filtered = state.filteredEbooks
            .where((ebook) => ebook.id != event.ebook.id)
            .toList();
        emit(
          state.copyWith(
            status: ebooks.isEmpty ? EbookStatus.empty : EbookStatus.success,
            mutationStatus: EbookMutationStatus.success,
            ebooks: ebooks,
            filteredEbooks: filtered,
            lastDeletedEbook: event.ebook,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onReaderPageChanged(
    EbookReaderPageChanged event,
    Emitter<EbookState> emit,
  ) async {
    await _repository.rememberLastPage(event.ebookId, event.page);
  }
}
