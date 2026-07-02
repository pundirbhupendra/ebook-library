import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../di/injection.dart';
import '../../domain/entities/ebook.dart';
import '../../domain/repositories/ebook_repository.dart';
import '../bloc/ebook_bloc.dart';

class PdfReaderPage extends StatefulWidget {
  const PdfReaderPage({required this.ebook, super.key});

  final Ebook ebook;

  @override
  State<PdfReaderPage> createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  late final PdfViewerController _controller;
  late final EbookBloc _ebookBloc;
  bool _fullscreen = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _ebookBloc = sl<EbookBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.ebook.downloadUrl;
    return Scaffold(
      appBar: _fullscreen
          ? null
          : AppBar(
              title: Text(widget.ebook.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              actions: [
                IconButton(tooltip: 'Previous page', onPressed: _controller.previousPage, icon: const Icon(Icons.keyboard_arrow_left_rounded)),
                IconButton(tooltip: 'Next page', onPressed: _controller.nextPage, icon: const Icon(Icons.keyboard_arrow_right_rounded)),
                IconButton(tooltip: 'Fullscreen', onPressed: () => setState(() => _fullscreen = true), icon: const Icon(Icons.fullscreen_rounded)),
              ],
            ),
      body: Stack(
        children: [
          if (url == null || url.isEmpty)
            const Center(child: Text('No readable PDF URL is available.'))
          else
            SfPdfViewer.network(
              url,
              controller: _controller,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onDocumentLoaded: (_) {
                setState(() => _loaded = true);
                final page = sl<EbookRepository>().lastPageFor(widget.ebook.id);
                if (page > 1) _controller.jumpToPage(page);
              },
              onPageChanged: (details) {
                _ebookBloc.add(EbookReaderPageChanged(ebookId: widget.ebook.id, page: details.newPageNumber));
              },
            ),
          if (url != null && url.isNotEmpty && !_loaded) const Center(child: CircularProgressIndicator()),
          if (_fullscreen)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              right: 12,
              child: IconButton.filledTonal(tooltip: 'Exit fullscreen', onPressed: () => setState(() => _fullscreen = false), icon: const Icon(Icons.fullscreen_exit_rounded)),
            ),
        ],
      ),
    );
  }
}
