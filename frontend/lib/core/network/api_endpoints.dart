class ApiEndpoints {
  const ApiEndpoints._();

  static const ebooks = '/api/ebooks';

  static String ebook(String id) => '$ebooks/$id';
  static String search(String query) => '$ebooks/search?q=$query';
  static String download(String id) => '$ebooks/$id/download';
}
