import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/ebook.dart';

class BookCover extends StatelessWidget {
  const BookCover({required this.ebook, super.key, this.large = false});

  final Ebook ebook;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = _CoverPalette.from(ebook.id);
    if (ebook.coverImageUrl case final url?) {
      return AspectRatio(
        aspectRatio: 0.68,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => _GeneratedCover(
              ebook: ebook,
              colors: colors,
              large: large,
            ),
          ),
        ),
      );
    }
    return _GeneratedCover(ebook: ebook, colors: colors, large: large);
  }
}

class _GeneratedCover extends StatelessWidget {
  const _GeneratedCover({
    required this.ebook,
    required this.colors,
    required this.large,
  });

  final Ebook ebook;
  final _CoverPalette colors;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: large ? 24 : 12,
              offset: Offset(0, large ? 16 : 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.start, colors.end],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: large ? 24 : 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: large ? 18 : 10,
                top: large ? 18 : 10,
                child: Container(
                  width: large ? 52 : 30,
                  height: large ? 52 : 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.accent,
                  ),
                  child: Text(
                    ebook.fileType,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.74),
                      fontSize: large ? 12 : 7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: large ? 36 : 20,
                right: large ? 18 : 10,
                top: large ? 88 : 48,
                child: Text(
                  ebook.title,
                  maxLines: large ? 4 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: large ? 26 : 14,
                    fontWeight: FontWeight.w900,
                    height: 1.04,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Positioned(
                left: large ? 36 : 20,
                right: large ? 18 : 10,
                bottom: large ? 28 : 16,
                child: Text(
                  ebook.author.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: large ? 14 : 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.16),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPalette {
  const _CoverPalette(this.start, this.end, this.accent);

  final Color start;
  final Color end;
  final Color accent;

  static _CoverPalette from(String seed) {
    const palettes = [
      _CoverPalette(Color(0xFF18324D), Color(0xFF2F5F8F), Color(0xFFD8A748)),
      _CoverPalette(Color(0xFF9F2D35), Color(0xFFD7524A), Color(0xFFFFC857)),
      _CoverPalette(Color(0xFF0F766E), Color(0xFF45A29E), Color(0xFFFFE6A7)),
      _CoverPalette(Color(0xFF55346B), Color(0xFF8863A8), Color(0xFFF5B7C7)),
      _CoverPalette(Color(0xFF51633F), Color(0xFF7E8F55), Color(0xFFF1D36F)),
      _CoverPalette(Color(0xFFB15A2B), Color(0xFFE08E45), Color(0xFF2F4858)),
    ];
    final hash = seed.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return palettes[hash % palettes.length];
  }
}
