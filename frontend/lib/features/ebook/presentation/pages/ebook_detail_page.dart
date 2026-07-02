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
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          Center(
            child: SizedBox(
              height: 300,
              child: Hero(
                tag: 'book-cover-${ebook.id}',
                child: BookCover(ebook: ebook, large: true),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            ebook.title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            ebook.author,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _MetaChip(icon: Icons.description_rounded, label: ebook.fileType),
              _MetaChip(
                icon: Icons.storage_rounded,
                label: FileSizeFormatter.format(ebook.fileSize),
              ),
              _MetaChip(
                icon: Icons.calendar_month_rounded,
                label: ebook.uploadedAt.displayDate,
              ),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.pushNamed(
              AppRouterName.pdfReaderRouteName,
              extra: ebook,
            ),
            icon: const FaIcon(FontAwesomeIcons.bookOpen),
            label: const Text('Read'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isDownloading
                ? null
                : () => _downloadEbook(context, ebook),
            icon: _isDownloading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const FaIcon(FontAwesomeIcons.download),
            label: Text(_isDownloading ? 'Downloading...' : 'Download'),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => _confirmDelete(context, ebook),
            icon: const FaIcon(FontAwesomeIcons.trash),
            label: const Text('Delete'),
          ),
        ],
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
