import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extensions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../di/injection.dart';
import '../../domain/entities/ebook.dart';
import '../bloc/ebook_bloc.dart';
import '../widgets/book_cover.dart';
import '../widgets/delete_ebook_dialog.dart';

class EbookDetailPage extends StatefulWidget {
  const EbookDetailPage({required this.ebook, super.key});

  final Ebook ebook;

  @override
  State<EbookDetailPage> createState() => _EbookDetailPageState();
}

class _EbookDetailPageState extends State<EbookDetailPage> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final ebook = widget.ebook;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3, fontSize: 18)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 840;
            final content = Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 280),
                                  child: Hero(
                                    tag: 'book-cover-${ebook.id}',
                                    child: BookCover(ebook: ebook, large: false),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            flex: 5,
                            child: _DetailInfoSection(ebook: ebook, isDownloading: _isDownloading, onDownload: () => _downloadEbook(context, ebook), onDelete: () => _confirmDelete(context, ebook)),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 240),
                            child: Hero(
                              tag: 'book-cover-${ebook.id}',
                              child: BookCover(ebook: ebook, large: false),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _DetailInfoSection(ebook: ebook, isDownloading: _isDownloading, onDownload: () => _downloadEbook(context, ebook), onDelete: () => _confirmDelete(context, ebook)),
                        ],
                      ),
              ),
            );

            return SingleChildScrollView(child: content);
          },
        ),
      ),
    );
  }

  Future<void> _downloadEbook(BuildContext context, Ebook ebook) async {
    if (_isDownloading) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isDownloading = true);

    try {
      final response = await sl<Dio>().get<List<int>>(
        ApiEndpoints.download(ebook.id.toString()),
        options: Options(responseType: ResponseType.bytes, followRedirects: true, validateStatus: (status) => status != null && status < 500),
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw const HttpException('Download failed');
      }

      final fileName = ebook.filename.isNotEmpty ? ebook.filename : '${ebook.title}.pdf';
      final downloadFile = await sl<FileService>().createDownloadFile(fileName);
      await downloadFile.writeAsBytes(data, flush: true);

      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Downloaded $fileName')));
      debugPrint('File saved at: ${downloadFile.path}');
    } catch (_) {
      if (!context.mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Download failed. Please try again.')));
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, Ebook ebook) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteEbookDialog(ebook: ebook),
    );
    if (confirmed != true || !context.mounted) return;
    sl<EbookBloc>().add(EbookDeleteRequested(ebook));
    context.pop();
  }
}

class _DetailInfoSection extends StatelessWidget {
  const _DetailInfoSection({required this.ebook, required this.isDownloading, required this.onDownload, required this.onDelete});

  final Ebook ebook;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(ebook.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(ebook.author, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoTile(icon: Icons.description_rounded, label: ebook.fileType),
                  const SizedBox(width: 12),
                  _InfoTile(icon: Icons.calendar_month_rounded, label: ebook.uploadedAt.displayDate),
                  // const SizedBox(width: 12),
                  // _InfoTile(icon: Icons.storage_rounded, label: FileSizeFormatter.format(ebook.fileSize)),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'A lighter, easier-to-scan details view keeps your library feeling premium while preserving the same book metadata you expect.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => context.pushNamed(AppRouterName.pdfReaderRouteName, extra: ebook),
              icon: const FaIcon(FontAwesomeIcons.bookOpen),
              label: const Text('Read'),
            ),
            OutlinedButton.icon(
              onPressed: isDownloading ? null : onDownload,
              icon: isDownloading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const FaIcon(FontAwesomeIcons.download),
              label: Text(isDownloading ? 'Downloading...' : 'Download'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
              onPressed: onDelete,
              icon: const FaIcon(FontAwesomeIcons.trash),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
