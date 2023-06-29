extension StringExtension on String {

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toSentenceCase() {
    final words = split('_').map((word) => word.toLowerCase()).toList();

    if (words.isNotEmpty) {
      words[0] = words[0].capitalize();
    }

    return words.join(' ');
  }

  String elipsis(int count) {
    if (length <= count) {
      return this;
    }
    return '${substring(0, count)}...';
  }
}