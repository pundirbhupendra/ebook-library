import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extensions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/file_service.dart';
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
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Delete ebook',
            onPressed: () => _confirmDelete(context, ebook),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 840;
            final content = Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
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
                                  constraints: const BoxConstraints(
                                    maxHeight: 280,
                                  ),
                                  child: Hero(
                                    tag: 'book-cover-${ebook.id}',
                                    child: BookCover(
                                      ebook: ebook,
                                      large: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 5,
                            child: _DetailInfoSection(
                              ebook: ebook,
                              isDownloading: _isDownloading,
                              onDownload: () => _downloadEbook(context, ebook),
                            ),
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
                          const SizedBox(height: 28),
                          _DetailInfoSection(
                            ebook: ebook,
                            isDownloading: _isDownloading,
                            onDownload: () => _downloadEbook(context, ebook),
                          ),
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
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final data = response.data;
      if (response.statusCode != 200 || data == null) {
        throw const HttpException('Download failed');
      }

      final fileName = ebook.filename.isNotEmpty
          ? ebook.filename
          : '${ebook.title}.pdf';
      final downloadFile = await sl<FileService>().createDownloadFile(fileName);
      await downloadFile.writeAsBytes(data, flush: true);

      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Downloaded $fileName')));
      debugPrint('File saved at: ${downloadFile.path}');
    } catch (_) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
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
  const _DetailInfoSection({
    required this.ebook,
    required this.isDownloading,
    required this.onDownload,
  });

  final Ebook ebook;
  final bool isDownloading;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Book Title — focal heading, semibold, max 2 lines
        Text(
          ebook.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            height: 1.3,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 6),
        // Author — secondary emphasis with "by" prefix
        Text(
          'by ${ebook.author}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.75),
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),

        // Book Details Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light
                ? Colors.white.withOpacity(0.85)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _DetailItem(
                    icon: Icons.description_outlined,
                    label: 'Format',
                    value: ebook.fileType,
                  ),
                  const SizedBox(width: 16),
                  _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Uploaded',
                    value: ebook.uploadedAt.shortDisplayDate,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'A lighter, easier-to-scan details view keeps your library feeling premium while preserving the same book metadata you expect.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  height: 1.6,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => context.pushNamed(
                  AppRouterName.pdfReaderRouteName,
                  extra: ebook,
                ),
                icon: const FaIcon(FontAwesomeIcons.bookOpen, size: 16),
                label: const Text('Read'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isDownloading ? null : onDownload,
                icon: isDownloading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const FaIcon(FontAwesomeIcons.download, size: 16),
                label: Text(isDownloading ? 'Downloading...' : 'Download'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

