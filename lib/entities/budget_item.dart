import 'package:floor/floor.dart';

@entity
class BudgetItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String type;
  final String? category;
  final String description;
  final String date;
  final int month;
  final int year;
  final String amount;
  final bool isPaidWithCreditCard;

  BudgetItem(
      {this.id,
      required this.type,
      required this.category,
      required this.description,
      required this.date,
      required this.month,
      required this.year,
      required this.amount,
      required this.isPaidWithCreditCard});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'description': description,
      'date': date,
      'month': month,
      'year': year,
      'amount': amount,
      'isPaidWithCreditCard': isPaidWithCreditCard
    };
  }
}
