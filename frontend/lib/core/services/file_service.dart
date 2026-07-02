import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PickedEbookFile {
  const PickedEbookFile({required this.path, required this.name, required this.size});

  final String path;
  final String name;
  final int size;
}

class FileService {
  Future<PickedEbookFile?> pickPdf() async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['pdf'], withData: false);
    final file = result?.files.single;
    final path = file?.path;
    if (file == null || path == null) return null;

    return PickedEbookFile(path: path, name: file.name, size: file.size);
  }

  Future<File> createDownloadFile(String filename) async {
    final hasStorageAccess = await _requestStorageAccess();

    Directory targetDirectory;

    if (hasStorageAccess) {
      targetDirectory = Directory('/storage/emulated/0/Download');
    } else {
      targetDirectory = await getApplicationDocumentsDirectory();
    }

    await targetDirectory.create(recursive: true);

    return File('${targetDirectory.path}/$filename');
  }

  // Future<File> createDownloadFile(String filename) async {
  //   final hasStorageAccess = await _requestStorageAccess();
  //   final directory = Directory('/storage/emulated/0/Download');
  //   // hasStorageAccess ? await getDownloadsDirectory() : await getApplicationDocumentsDirectory();
  //   final targetDirectory = directory ?? await getApplicationDocumentsDirectory();
  //   await targetDirectory.create(recursive: true);
  //   return File('${targetDirectory.path}/$filename');
  // }

  Future<bool> _requestStorageAccess() async {
    if (!Platform.isAndroid) return false;

    try {
      final status = await Permission.storage.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }
}
