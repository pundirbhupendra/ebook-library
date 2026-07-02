import 'package:flutter/material.dart';

import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/ebook.dart';
import 'book_cover.dart';

class DeleteEbookDialog extends StatelessWidget {
  const DeleteEbookDialog({required this.ebook, super.key});

  final Ebook ebook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      key: const ValueKey('delete_ebook_dialog'),
      title: const Text('Delete ebook?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 148,
            child: HeroMode(
              enabled: false,
              child: BookCover(ebook: ebook),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ebook.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${ebook.fileType} - ${FileSizeFormatter.format(ebook.fileSize)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This removes the book and its uploaded file. This action cannot be undone.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.delete_rounded),
          label: const Text('Delete'),
        ),
      ],
    );
  }
}
