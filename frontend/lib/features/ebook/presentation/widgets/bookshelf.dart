import 'package:flutter/material.dart';

import '../../domain/entities/ebook.dart';
import 'ebook_card.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({required this.ebooks, required this.onBookTap, super.key});

  final List<Ebook> ebooks;
  final ValueChanged<Ebook> onBookTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 900
        ? 5
        : width >= 620
        ? 4
        : 2;
    return GridView.builder(
      key: const ValueKey('bookshelf_grid'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 108),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 36,
        crossAxisSpacing: 18,
        childAspectRatio: 0.58,
      ),
      itemCount: ebooks.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -10,
                    right: -10,
                    bottom: 4,
                    height: 26,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFB9783D)
                            : const Color(0xFF5A3423),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: EbookCard(
                        ebook: ebooks[index],
                        onTap: () => onBookTap(ebooks[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              width: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFF8C6030)
                    : const Color(0xFF6B4A2A),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      },
    );
  }
}
