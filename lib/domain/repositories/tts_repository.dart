abstract interface class TtsRepository {
  Future<String> synthesize(String text);
}
