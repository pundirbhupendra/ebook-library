import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key});

  static int _columnsForWidth(double width) {
    if (width >= 1080) return 6;
    if (width >= 860) return 5;
    if (width >= 680) return 4;
    if (width >= 480) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _columnsForWidth(constraints.maxWidth);
        return Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 108, 20, 96),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, mainAxisSpacing: 28, crossAxisSpacing: 18, childAspectRatio: 0.62),
            itemCount: crossAxisCount * 3,
            itemBuilder: (_, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 12,
                    decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 72,
                    decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(6)),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
