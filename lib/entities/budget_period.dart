import 'package:flutter/foundation.dart';

class BudgetPeriodModel extends ChangeNotifier {
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  int get month => _month;
  int get year => _year;

  void changePeriod(int newMonth, int newYear) {
    _month = newMonth;
    _year = newYear;

    notifyListeners();
  }
}