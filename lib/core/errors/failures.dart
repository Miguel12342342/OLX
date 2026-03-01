abstract class IFailure {
  final String message;
  final Exception? exception;

  IFailure(this.message, {this.exception});

  @override
  String toString() => 'Failure: $message';
}

class ServerFailure extends IFailure {
  ServerFailure(String message, {Exception? exception}) 
      : super(message, exception: exception);
}

class AuthFailure extends IFailure {
  AuthFailure(String message, {Exception? exception}) 
      : super(message, exception: exception);
}

class ValidationFailure extends IFailure {
  ValidationFailure(String message) : super(message);
}
