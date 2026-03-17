/// Exception that represents an API error.
class ApiException implements Exception {
  /// The HTTP status code associated with the error.
  late final int statusCode;
  final String? message;

  /// Constructs an instance of [ApiException] with the given [statusCode].
  ApiException(this.statusCode, {this.message});

  @override
  String toString() {
    return "Status Code: $statusCode${message != null ? " | Message: $message" : ""}";
  }
}
