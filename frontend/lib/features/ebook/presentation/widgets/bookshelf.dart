import 'package:flutter/material.dart';

import '../../domain/entities/ebook.dart';
import 'ebook_card.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({required this.ebooks, required this.onBookTap, super.key});

  final List<Ebook> ebooks;
  final ValueChanged<Ebook> onBookTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const double coverWidth = 120.0;
        const double coverHeight = coverWidth / 0.68; // ~176.5

        final double availableWidth = width - 40; // 20 padding on each side

        // Responsive: 2 on mobile, up to 6 on desktop
        final int crossAxisCount =
            (availableWidth / (coverWidth + 24)).floor().clamp(2, 6);
        final double itemWidth = availableWidth / crossAxisCount;

        final rowCount = (ebooks.length / crossAxisCount).ceil();

        // Row height = cover + shelf thickness + gap for title/date below shelf
        const double shelfThickness = 14.0;
        const double metadataHeight = 72.0; // 16 gap + ~34 title (2 lines) + 4 gap + ~18 date
        const double totalRowHeight =
            coverHeight + shelfThickness + metadataHeight;

        return ListView.builder(
          key: const ValueKey('bookshelf_grid'),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 108),
          itemCount: rowCount,
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * crossAxisCount;
            final rowBooks =
                ebooks.skip(start).take(crossAxisCount).toList();

            // Shelf spans entire row width (edge-to-edge within padding)
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SizedBox(
                width: availableWidth,
                height: totalRowHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Wooden shelf: flush under the book covers
                    Positioned(
                      top: coverHeight - 4,
                      left: 0,
                      right: 0,
                      height: shelfThickness,
                      child: const _ShelfRowBackground(),
                    ),

                    // Row of ebook cards centered
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: rowBooks.length == crossAxisCount
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rowBooks.map((ebook) {
                          return SizedBox(
                            width: itemWidth,
                            child: EbookCard(
                              ebook: ebook,
                              coverWidth: coverWidth,
                              coverHeight: coverHeight,
                              onTap: () => onBookTap(ebook),
                            ),
                          );
                        }).toList(),
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
          colors: isLight
              ? const [Color(0xFFD4A76A), Color(0xFFAA7744)]
              : const [Color(0xFF5D4037), Color(0xFF3E2723)],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(3),
        ),
        border: Border(
          top: BorderSide(
            color: isLight
                ? const Color(0xFFF0D5B0).withOpacity(0.8)
                : const Color(0xFF8D6E63).withOpacity(0.5),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLight ? 0.12 : 0.25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(3),
        ),
        child: CustomPaint(painter: _WoodGrainPainter(isLight: isLight)),
      ),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  const _WoodGrainPainter({required this.isLight});

  final bool isLight;

  @override
  void paint(Canvas canvas, Size size) {
    final grainPaint = Paint()
      ..color = Colors.white.withOpacity(isLight ? 0.07 : 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Subtle horizontal wood grain lines
    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.25 + i * 0.25);
      final path = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(
          size.width * 0.3,
          y + 1.5,
          size.width * 0.5,
          y - 0.5,
        )
        ..quadraticBezierTo(
          size.width * 0.7,
          y + 1,
          size.width,
          y,
        );
      canvas.drawPath(path, grainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WoodGrainPainter oldDelegate) {
    return oldDelegate.isLight != isLight;
  }
}
