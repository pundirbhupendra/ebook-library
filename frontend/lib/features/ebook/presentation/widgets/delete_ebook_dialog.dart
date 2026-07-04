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
    return Dialog(
      key: const ValueKey('delete_ebook_dialog'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with warning color
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: theme.colorScheme.error.withOpacity(0.08)),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: theme.colorScheme.error.withOpacity(0.12), shape: BoxShape.circle),
                      child: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error, size: 22),
                    ),
                    const SizedBox(height: 10),
                    Text('Delete ebook?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 18)),
                  ],
                ),
              ),

              // Scrollable book info section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      // Book cover thumbnail
                      SizedBox(
                        height: 200,
                        child: HeroMode(enabled: false, child: BookCover(ebook: ebook)),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        ebook.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 15, height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      // File info
                      Text(
                        '${ebook.fileType}  •  ${FileSizeFormatter.format(ebook.fileSize)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7), fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      //  Warning message
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.error.withOpacity(0.12)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 18, color: theme.colorScheme.error.withOpacity(0.8)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This action cannot be undone. The book and its file will be permanently removed.',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 12, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
