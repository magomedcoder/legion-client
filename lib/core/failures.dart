sealed class Failure implements Exception {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

class WsFailure extends Failure {
  const WsFailure(super.message);
}
