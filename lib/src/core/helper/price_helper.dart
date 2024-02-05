class PriceHelper {
  // static method that take a double that is required to be formatted as a price and optional parameter that is the currency symbol and a boolean that is required to show the currency symbol after the price or not
  static String getFormattedPrice(double price,
      {String currency = '€', bool showBefore = true}) {
    String formattedPrice = price.toStringAsFixed(2);
    if (showBefore) {
      return '$currency$formattedPrice';
    } else {
      return '$formattedPrice$currency';
    }
  }
}
