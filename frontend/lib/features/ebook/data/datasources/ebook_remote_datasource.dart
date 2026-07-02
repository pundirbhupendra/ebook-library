import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../flavor/app_flavor.dart';
import '../models/ebook_model.dart';

abstract class EbookRemoteDataSource {
  Future<List<EbookModel>> getEbooks();
  Future<EbookModel> getEbook(String id);
  Future<List<EbookModel>> searchEbooks(String query);
  Future<EbookModel> uploadEbook({required String title, required String author, required String filePath, required String filename, ProgressCallback? onSendProgress});
  Future<String> getDownloadUrl(String id);
  Future<void> deleteEbook(String id);
}

class EbookRemoteDataSourceImpl implements EbookRemoteDataSource {
  const EbookRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<EbookModel>> getEbooks() async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.ebooks);
    return _parseCollection(response.data);
  }

  @override
  Future<EbookModel> getEbook(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.ebook(id));
    return EbookModel.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<List<EbookModel>> searchEbooks(String query) async {
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.search(Uri.encodeQueryComponent(query)));
    return _parseCollection(response.data);
  }

  @override
  Future<EbookModel> uploadEbook({required String title, required String author, required String filePath, required String filename, ProgressCallback? onSendProgress}) async {
    final data = FormData.fromMap({'ebook[title]': title, 'ebook[author]': author, 'ebook[file]': await MultipartFile.fromFile(filePath, filename: filename)});
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.ebooks, data: data, onSendProgress: onSendProgress);
    return EbookModel.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<String> getDownloadUrl(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.download(id));
    final url = response.data?['download_url'];
    return _normalizeDownloadUrl(url is String ? url : null);
  }

  @override
  Future<void> deleteEbook(String id) async {
    await _dio.delete<void>(ApiEndpoints.ebook(id));
  }

  List<EbookModel> _parseCollection(List<dynamic>? data) {
    return (data ?? const <dynamic>[]).whereType<Map<String, dynamic>>().map(EbookModel.fromJson).toList();
  }

  String _normalizeDownloadUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';

    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.hasScheme) return rawUrl;

    final baseUrl = AppFlavor.current.baseUrl;
    if (baseUrl.isEmpty) return rawUrl;

    return Uri.parse(baseUrl).resolveUri(uri).toString();
  }
}
