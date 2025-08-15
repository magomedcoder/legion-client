class Env {
  static const String baseUrl = '127.0.0.1:8000';

  static String get http => 'http://$baseUrl';

  static String get ws => 'ws://$baseUrl';
}
