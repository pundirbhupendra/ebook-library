import 'package:flutter/material.dart';

class EmptyBookshelf extends StatelessWidget {
  const EmptyBookshelf({
    required this.title,
    required this.message,
    required this.action,
    super.key,
  });

  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 124,
              child: CustomPaint(
                painter: _EmptyShelfPainter(theme.colorScheme),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            action,
          ],
        ),
      ),
    );
  }
}

class _EmptyShelfPainter extends CustomPainter {
  const _EmptyShelfPainter(this.scheme);

  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final shelfPaint = Paint()..color = scheme.primary.withValues(alpha: 0.72);
    final mutedPaint =
        Paint()..color = scheme.secondary.withValues(alpha: 0.84);
    final outlinePaint = Paint()
      ..color = scheme.onSurface.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final shelf = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height - 24, size.width, 18),
      const Radius.circular(6),
    );
    canvas.drawRRect(shelf, shelfPaint);

    final books = [
      Rect.fromLTWH(24, 42, 26, 58),
      Rect.fromLTWH(54, 24, 30, 76),
      Rect.fromLTWH(90, 50, 24, 50),
      Rect.fromLTWH(120, 34, 34, 66),
    ];

    for (final rect in books) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        mutedPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(3)),
        outlinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EmptyShelfPainter oldDelegate) {
    return oldDelegate.scheme != scheme;
  }
}
