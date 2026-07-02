import 'package:flutter/material.dart';
import 'package:frontend/router/app_router_name.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../di/injection.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/ebook.dart';
import '../bloc/ebook_bloc.dart';
import '../widgets/bookshelf.dart';
import '../widgets/ebook_search_bar.dart';
import '../widgets/empty_bookshelf.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final EbookBloc _bloc;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = sl<EbookBloc>()..add(const EbookLibraryRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<EbookBloc, EbookState>(
        listenWhen: (previous, current) => previous.mutationStatus != current.mutationStatus,
        listener: (context, state) {
          if (state.mutationStatus == EbookMutationStatus.success && state.lastDeletedEbook != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.lastDeletedEbook!.title} deleted')));
          }
          if (state.mutationStatus == EbookMutationStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('My Library', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            actions: [
              IconButton(tooltip: 'Upload', icon: const Icon(Icons.upload_file_rounded), onPressed: () => context.pushNamed(AppRouterName.uploadRouteName)),
              const SizedBox(width: 8),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.light ? const [Color(0xFFFFF3D8), Color(0xFFFFFBF4)] : const [Color(0xFF221914), Color(0xFF15110F)],
              ),
            ),
            child: SafeArea(
              child: BlocBuilder<EbookBloc, EbookState>(
                builder: (context, state) => AnimatedSwitcher(duration: const Duration(milliseconds: 240), child: _buildBody(context, state)),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(onPressed: () => context.pushNamed(AppRouterName.uploadRouteName), icon: const Icon(Icons.add_rounded), label: const Text('Upload')),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EbookState state) {
    if (state.status == EbookStatus.loading || state.status == EbookStatus.initial) {
      return const AppShimmer(key: ValueKey('loading'));
    }
    if (state.status == EbookStatus.failure) {
      return AppErrorView(key: const ValueKey('error'), message: state.errorMessage ?? 'The library could not be loaded.', onRetry: () => context.read<EbookBloc>().add(const EbookLibraryRequested()));
    }
    if (state.status == EbookStatus.empty) {
      return EmptyBookshelf(
        key: const ValueKey('empty'),
        title: 'No ebooks yet',
        message: 'Upload your first ebook to start building your digital library.',
        action: FilledButton.icon(onPressed: () => context.pushNamed(AppRouterName.uploadRouteName), icon: const Icon(Icons.upload_file_rounded), label: const Text('Upload Ebook')),
      );
    }

    return Column(
      key: const ValueKey('success'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: Column(
            children: [
              EbookSearchBar(
                controller: _searchController,
                onChanged: (value) => context.read<EbookBloc>().add(EbookSearchChanged(value)),
                onClear: () {
                  _searchController.clear();
                  context.read<EbookBloc>().add(const EbookSearchCleared());
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.auto_stories_rounded, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(state.isSearching ? '${state.resultCount} results' : '${state.ebooks.length} books', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: state.visibleEbooks.isEmpty
              ? EmptyBookshelf(
                  title: 'No books found',
                  message: 'Try a different title, author, or filename.',
                  action: OutlinedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      context.read<EbookBloc>().add(const EbookSearchCleared());
                    },
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Clear Search'),
                  ),
                )
              : Bookshelf(ebooks: state.visibleEbooks, onBookTap: (ebook) => _openDetail(context, ebook)),
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, Ebook ebook) {
    context.pushNamed(AppRouterName.ebookDetailRouteName, extra: ebook);
  }
}
