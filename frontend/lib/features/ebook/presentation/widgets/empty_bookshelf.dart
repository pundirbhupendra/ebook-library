import 'package:flutter/material.dart';

class EmptyBookshelf extends StatelessWidget {
  const EmptyBookshelf({required this.title, required this.message, required this.action, super.key});

  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: Theme.of(context).brightness == Brightness.light ? const [Color(0xFFFFF7E3), Color(0xFFF6E0C4)] : const [Color(0xFF2C1F18), Color(0xFF1B140F)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 24, offset: const Offset(0, 12))],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: CustomPaint(painter: _EmptyShelfPainter(theme.colorScheme), child: const SizedBox.expand()),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(width: 220, child: action),
            ],
          ),
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
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [scheme.surfaceVariant.withOpacity(0.12), scheme.surface.withOpacity(0.02)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final shelfPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFC99A66), const Color(0xFF8B5C2E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, size.height - 42, size.width, 42));
    final shelf = RRect.fromRectAndRadius(Rect.fromLTWH(0, size.height - 42, size.width, 42), const Radius.circular(16));
    canvas.drawRRect(shelf, shelfPaint);

    final grainPaint = Paint()..color = Colors.white.withOpacity(0.12);
    for (var i = 0; i < 5; i++) {
      final startX = size.width * (0.16 + i * 0.14);
      final path = Path()
        ..moveTo(startX, size.height - 42)
        ..quadraticBezierTo(startX + 10, size.height - 22, startX - 8, size.height - 4);
      canvas.drawPath(path, grainPaint);
    }

    final bookPaint = Paint()..color = scheme.primary.withOpacity(0.86);
    final accentPaint = Paint()..color = scheme.onPrimary.withOpacity(0.88);
    final books = [
      Rect.fromLTWH(36, size.height - 132, 24, 90),
      Rect.fromLTWH(84, size.height - 152, 30, 110),
      Rect.fromLTWH(148, size.height - 122, 22, 80),
      Rect.fromLTWH(196, size.height - 140, 28, 98),
    ];

    for (final rect in books) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), bookPaint);
      canvas.drawLine(rect.topLeft, rect.bottomLeft, accentPaint..strokeWidth = 3);
      canvas.drawLine(rect.topRight, rect.bottomRight, accentPaint..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant _EmptyShelfPainter oldDelegate) {
    return oldDelegate.scheme != scheme;
  }
}
