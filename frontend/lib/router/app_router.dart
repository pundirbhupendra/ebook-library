import 'package:flutter/material.dart';
import 'package:frontend/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

import '../features/ebook/domain/entities/ebook.dart';
import '../features/ebook/presentation/pages/ebook_detail_page.dart';
import '../features/ebook/presentation/pages/library_page.dart';
import '../features/ebook/presentation/pages/pdf_reader_page.dart';
import '../features/ebook/presentation/pages/upload_ebook_page.dart';

class AppRouter {
  AppRouter()
    : _router = GoRouter(
        initialLocation: AppRouterName.libraryRoutePath,
        routes: [
          GoRoute(
            path: AppRouterName.libraryRoutePath,
            name: AppRouterName.libraryRouteName,
            pageBuilder: (context, state) => const MaterialPage(child: LibraryPage()),
          ),
          GoRoute(
            path: AppRouterName.uploadRoutePath,
            name: AppRouterName.uploadRouteName,
            pageBuilder: (context, state) =>
                CustomTransitionPage(key: state.pageKey, child: const UploadEbookPage(), transitionDuration: const Duration(milliseconds: 260), transitionsBuilder: _slideFromBottom),
          ),
          GoRoute(
            path: AppRouterName.ebookDetailRoutePath,
            name: AppRouterName.ebookDetailRouteName,
            pageBuilder: (context, state) {
              final ebook = state.extra as Ebook;
              return CustomTransitionPage(
                key: state.pageKey,
                child: EbookDetailPage(ebook: ebook),
                transitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: _fadeIn,
              );
            },
          ),
          GoRoute(
            path: AppRouterName.pdfReaderRoutePath,
            name: AppRouterName.pdfReaderRouteName,
            pageBuilder: (context, state) {
              final ebook = state.extra as Ebook;
              return CustomTransitionPage(
                key: state.pageKey,
                child: PdfReaderPage(ebook: ebook),
                transitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: _fadeIn,
              );
            },
          ),
        ],
      );

  final GoRouter _router;

  GoRouter get router => _router;

  static Widget _fadeIn(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _slideFromBottom(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
      child: child,
    );
  }
}
