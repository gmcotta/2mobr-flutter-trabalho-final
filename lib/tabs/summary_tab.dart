import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trabalho_final_2mobr/dao/budget_item_dao.dart';
import 'package:trabalho_final_2mobr/database/app_database.dart';
import 'package:trabalho_final_2mobr/dialogs/generic_error_dialog.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';
import 'package:trabalho_final_2mobr/entities/budget_period.dart';
import 'package:trabalho_final_2mobr/utils/functions.dart';

get summaryTab => const SummaryTab();

class SummaryTab extends StatefulWidget {
  const SummaryTab({super.key});

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  late AppDatabase _database;
  late BudgetItemDao _budgetItemDao;
  String totalIncomes = 'R\$ 0,00';
  String totalExpenses = 'R\$ 0,00';
  String balance = 'R\$ 0,00';
  String highestExpense = 'Sem despesas no momento...';
  List<BudgetItem> creditCardExpenses = [];
  String totalCreditCardExpenses = 'R\$ 0,00';

  void _getSummaryInfo() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    if (!mounted) return;
    int month = Provider.of<BudgetPeriodModel>(context, listen: false).month;
    int year = Provider.of<BudgetPeriodModel>(context, listen: false).year;
    _budgetItemDao = _database.budgetItemDao;

    try {
      List<BudgetItem>? allIncomes =
      await _budgetItemDao.findBudgetIncomesByPeriod(month, year);
      double income = sumBudgetItemListAmount(allIncomes);

      List<BudgetItem>? allExpenses =
      await _budgetItemDao.findBudgetExpensesByPeriod(month, year);
      double expense = sumBudgetItemListAmount(allExpenses);

      setState(() {
        totalIncomes = convertDoubleToCurrency(income);
        totalExpenses = convertDoubleToCurrency(expense);
        balance = convertDoubleToCurrency(income - expense);
      });

      if (allExpenses != null && allExpenses.isNotEmpty) {
        BudgetItem biggestExpense = allExpenses.reduce((value, element) =>
        convertCurrencyToDouble(value.amount) >
            convertCurrencyToDouble(element.amount)
            ? value
            : element);

        List<BudgetItem> expensesPaidWithCreditCard =
        allExpenses.where((element) => element.isPaidWithCreditCard).toList();
        expensesPaidWithCreditCard.sort((a, b) => a.date.compareTo(b.date));
        double totalAmountExpensesCreditCard =
        sumBudgetItemListAmount(expensesPaidWithCreditCard);

        setState(() {
          highestExpense =
          '${biggestExpense.description} - ${biggestExpense.amount}';
          creditCardExpenses = expensesPaidWithCreditCard;
          totalCreditCardExpenses =
              convertDoubleToCurrency(totalAmountExpensesCreditCard);
        });
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(context: context, builder: (BuildContext context) => const GenericErrorDialog());
    }
  }


  @override
  void initState() {
    super.initState();
    _getSummaryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 24, bottom: 12),
              child: Consumer<BudgetPeriodModel>(
                builder: (context, value, child) => Text(
                  "Resumo: ${addLeadingZeros(value.month.toString(), 1)}/${value.year}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 12),
              child: Text(
                "Receitas: $totalIncomes",
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 12),
              child: Text(
                "Despesas: $totalExpenses",
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 12),
              child: Text(
                "Saldo: $balance",
                style: Theme.of(context).textTheme.titleLarge,
              )),
          const Padding(
              padding: EdgeInsets.only(
                  left: 12, right: 12, top: 48, bottom: 12),
              child: Text(
                "Despesa mais alta",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 12),
              child: Text(
                highestExpense,
                style: Theme.of(context).textTheme.titleMedium,
              )),
          const Padding(
              padding: EdgeInsets.only(
                  left: 12, right: 12, top: 48, bottom: 12),
              child: Text(
                "Despesas pagas com cartão de crédito",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )),
          Padding(
              padding: const EdgeInsets.all(12),
              child: creditCardExpenses.isEmpty
                  ? const Text("Sem despesas no momento...")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: creditCardExpenses.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = creditCardExpenses[index];
                              final formattedDate = formatDate(item.date);
                              return ListTile(
                                leading: const Icon(Icons.check),
                                title: Text(
                                    '${item.category} - ${item.description}'),

                                subtitle:
                                    Text('$formattedDate - ${item.amount}'),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Total: $totalCreditCardExpenses',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ],
                    ))
        ],
      ),
    ));
  }
}
