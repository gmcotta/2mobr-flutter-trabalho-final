import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';

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

String addLeadingZeros(String value, int quantity) {
  return value.padLeft(quantity + 1, '0');
}

double sumBudgetItemListAmount(List<BudgetItem>? items) {
  if (items == null || items.isEmpty) {
    return 0;
  }
  Iterable<double> itemsAmount =
  items.map((e) => convertCurrencyToDouble(e.amount));
  double amountSum = itemsAmount.reduce((value, element) => value + element);
  return amountSum;
}
