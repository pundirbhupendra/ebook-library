import 'package:flutter/material.dart';

import '../../domain/entities/ebook.dart';
import 'ebook_card.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({required this.ebooks, required this.onBookTap, super.key});

  final List<Ebook> ebooks;
  final ValueChanged<Ebook> onBookTap;

  static int _crossAxisCount(double width) {
    if (width >= 1080) return 6;
    if (width >= 860) return 5;
    if (width >= 680) return 4;
    if (width >= 480) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = _crossAxisCount(width);
        final rowCount = (ebooks.length / crossAxisCount).ceil();
        final bookWidth = (width - 40 - 14 * (crossAxisCount - 1)) / crossAxisCount;

        return ListView.builder(
          key: const ValueKey('bookshelf_grid'),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
          itemCount: rowCount,
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * crossAxisCount;
            final rowBooks = ebooks.skip(start).take(crossAxisCount).toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: SizedBox(
                height: 318,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(bottom: 0, left: 0, right: 0, height: 52, child: _ShelfRowBackground()),
                    Positioned.fill(
                      bottom: 36,
                      child: Row(
                        mainAxisAlignment: rowBooks.length == crossAxisCount ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: rowBooks
                            .map(
                              (ebook) => SizedBox(
                                width: bookWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 7),
                                  child: RepaintBoundary(
                                    child: EbookCard(ebook: ebook, onTap: () => onBookTap(ebook)),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ShelfRowBackground extends StatelessWidget {
  const _ShelfRowBackground();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isLight ? const [Color(0xFFBE8B54), Color(0xFF8B5D30)] : const [Color(0xFF4E342E), Color(0xFF35221B)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: CustomPaint(painter: _WoodGrainPainter(isLight: isLight)),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  const _WoodGrainPainter({required this.isLight});

  final bool isLight;

  @override
  void paint(Canvas canvas, Size size) {
    final grainPaint = Paint()..color = Colors.white.withOpacity(isLight ? 0.08 : 0.06);
    for (var i = 0; i < 6; i++) {
      final x = size.width * (0.1 + i * 0.15);
      final path = Path()
        ..moveTo(x, 4)
        ..quadraticBezierTo(x + 12, size.height * 0.22, x - 10, size.height * 0.5)
        ..quadraticBezierTo(x + 16, size.height * 0.78, x, size.height - 4);
      canvas.drawPath(path, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WoodGrainPainter oldDelegate) {
    return oldDelegate.isLight != isLight;
  }
}
