/// Rails API error response model
/// Example: { "errors": ["Title can't be blank", "File must be a PDF"] }
class ApiErrorModel {
  const ApiErrorModel({this.errors = const [], this.error, this.message});

  /// Parse from JSON response
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(errors: _parseErrors(json['errors']), error: json['error'] as String?, message: json['message'] as String?);
  }

  /// Parse errors list safely
  static List<String> _parseErrors(dynamic errors) {
    if (errors is List) {
      return errors.whereType<String>().toList();
    }
    return const [];
  }

  /// List of validation/error messages
  final List<String> errors;

  /// Single error message (alternative format)
  final String? error;

  /// Message field (alternative format)
  final String? message;

  /// Get first error message or fallback
  String getFirstError() {
    if (errors.isNotEmpty) return errors.first;
    if (error?.isNotEmpty ?? false) return error!;
    if (message?.isNotEmpty ?? false) return message!;
    return 'An unknown error occurred';
  }

  /// Get all error messages combined
  String getAllErrors() {
    final all = <String>[...errors, if (error?.isNotEmpty ?? false) error!, if (message?.isNotEmpty ?? false) message!];
    return all.isEmpty ? 'An unknown error occurred' : all.join(', ');
  }
}
