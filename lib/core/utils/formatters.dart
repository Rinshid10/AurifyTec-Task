//  <--------- Formatters Helper --------->
//* TO share small formatting helpers across screens
class Formatters {
  Formatters._();

  //  <--------- Number Formats --------->
  //* TO render prices, ratings and discount percentages as display strings
  static String price(double value) => '\$${value.toStringAsFixed(2)}';

  static String rating(double value) => value.toStringAsFixed(1);

  static String discount(double percentage) =>
      '-${percentage.toStringAsFixed(0)}%';

  //  <--------- Compact Count --------->
  //* TO shorten large counts, for example 1234 becomes 1.2k
  static String compact(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}m';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return '$value';
  }

  //  <--------- Category Label --------->
  //* TO turn a slug like mens-shirts into Mens Shirts
  static String categoryLabel(String slug) {
    return slug
        .split('-')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  //  <--------- Date Format --------->
  //* TO render a date like 2025-04-30 as 30 Apr 2025
  static String date(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }

  //  <--------- Initials --------->
  //* TO build avatar initials, for example Glamour Beauty becomes GB and Essence becomes ES
  static String initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final w = words.first;
      return w.length >= 2 ? w.substring(0, 2).toUpperCase() : w.toUpperCase();
    }
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }
}
