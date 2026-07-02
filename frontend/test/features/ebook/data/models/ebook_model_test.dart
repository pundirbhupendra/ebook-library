import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/ebook/data/models/ebook_model.dart';
import 'package:frontend/flavor/app_flavor.dart';

void main() {
  setUp(() {
    AppFlavor.initialize(Flavor.dev);
  });

  test('resolves relative download URLs against the app base URL', () {
    final model = EbookModel.fromJson({
      'id': 1,
      'title': 'Dummy PDF',
      'author': 'Author',
      'file_type': 'application/pdf',
      'file_size': 123,
      'filename': 'dummy.pdf',
      'uploaded_at': '2026-07-02T00:00:00.000Z',
      'download_url': '/rails/active_storage/blobs/redirect/test.pdf',
    });

    expect(model.downloadUrl, 'http://10.0.2.2:3000/rails/active_storage/blobs/redirect/test.pdf');
  });
}
