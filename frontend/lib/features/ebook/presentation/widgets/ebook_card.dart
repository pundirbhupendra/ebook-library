import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_extensions.dart';
import '../../domain/entities/ebook.dart';
import 'book_cover.dart';

class EbookCard extends StatefulWidget {
  const EbookCard({
    required this.ebook,
    required this.onTap,
    required this.coverWidth,
    required this.coverHeight,
    super.key,
  });

  final Ebook ebook;
  final VoidCallback onTap;
  final double coverWidth;
  final double coverHeight;

  @override
  State<EbookCard> createState() => _EbookCardState();
}

class _EbookCardState extends State<EbookCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: _pressed ? 0.96 : 1,
            child: SizedBox(
              width: widget.coverWidth,
              height: widget.coverHeight,
              child: Hero(
                tag: 'book-cover-${widget.ebook.id}',
                child: BookCover(ebook: widget.ebook),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.ebook.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.ebook.uploadedAt.shortDisplayDate,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

