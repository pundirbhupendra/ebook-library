import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/ebook/domain/entities/ebook.dart';
import 'package:frontend/features/ebook/presentation/widgets/delete_ebook_dialog.dart';
import 'package:frontend/features/ebook/presentation/widgets/ebook_card.dart';
import 'package:frontend/features/ebook/presentation/widgets/ebook_search_bar.dart';
import 'package:frontend/features/ebook/presentation/widgets/empty_bookshelf.dart';

void main() {
  final ebook = Ebook(
    id: '1',
    title: 'Flutter Clean Architecture',
    author: 'Riya Sharma',
    fileType: 'PDF',
    fileSize: 1200000,
    filename: 'flutter-clean-architecture.pdf',
    uploadedAt: DateTime(2026, 6, 28),
  );

  testWidgets('EbookCard renders metadata and handles tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 320,
            child: EbookCard(ebook: ebook, onTap: () => tapped = true),
          ),
        ),
      ),
    );

    expect(find.text('Flutter Clean Architecture'), findsWidgets);
    expect(find.text('Riya Sharma'), findsOneWidget);
    await tester.tap(find.byType(EbookCard));
    expect(tapped, isTrue);
  });

  testWidgets('EmptyBookshelf shows helpful messaging', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyBookshelf(
          title: 'No ebooks yet',
          message: 'Upload your first ebook to start building your digital library.',
          action: FilledButton(onPressed: () {}, child: const Text('Upload Ebook')),
        ),
      ),
    );

    expect(find.text('No ebooks yet'), findsOneWidget);
    expect(find.text('Upload your first ebook to start building your digital library.'), findsOneWidget);
  });

  testWidgets('EbookSearchBar supports clear action', (tester) async {
    final controller = TextEditingController(text: 'rails');
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EbookSearchBar(
            controller: controller,
            onChanged: (_) {},
            onClear: () {
              controller.clear();
              cleared = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(cleared, isTrue);
    expect(controller.text, isEmpty);
  });

  testWidgets('DeleteEbookDialog returns confirmation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return FilledButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (_) => DeleteEbookDialog(ebook: ebook),
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('delete_ebook_dialog')), findsOneWidget);
    expect(find.text('Delete ebook?'), findsOneWidget);
    expect(find.text('Flutter Clean Architecture'), findsWidgets);
  });
}
