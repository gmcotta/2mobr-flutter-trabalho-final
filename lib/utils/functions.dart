import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

String convertDoubleToCurrency(double amount) {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'pt_BR', decimalDigits: 2, symbol: 'R\$', turnOffGrouping: true);

  return formatter.formatDouble(amount);
}

double convertCurrencyToDouble(String currency) {
  String amount = currency.replaceAllMapped(RegExp(r'R\$\s(\d+)\,(\d+)'),
      (Match m) => '${m[1].toString()}.${m[2].toString()}');
  return double.parse(amount);
}

String formatDate(String rawDate, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(DateTime.parse(rawDate));
}
