class AppException implements Exception {
  final String message;
  final dynamic cause;

  AppException(this.message, [this.cause]);

  @override
  String toString() => 'AppException: $message${cause != null ? '\nCause: $cause' : ''}';
}

class DatabaseException extends AppException {
  DatabaseException(String message, [dynamic cause]) : super(message, cause);
}

class ValidationException extends AppException {
  ValidationException(String message, [dynamic cause]) : super(message, cause);
}

class StateException extends AppException {
  StateException(String message, [dynamic cause]) : super(message, cause);
}
