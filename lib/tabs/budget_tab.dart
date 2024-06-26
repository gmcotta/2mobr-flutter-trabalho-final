import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trabalho_final_2mobr/dao/budget_item_dao.dart';
import 'package:trabalho_final_2mobr/database/app_database.dart';
import 'package:trabalho_final_2mobr/dialogs/delete_budget_item_dialog.dart';
import 'package:trabalho_final_2mobr/dialogs/filter_period_dialog.dart';
import 'package:trabalho_final_2mobr/dialogs/generic_error_dialog.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';
import 'package:trabalho_final_2mobr/entities/budget_period.dart';
import 'package:trabalho_final_2mobr/screens/edit_register_screen.dart';
import 'package:trabalho_final_2mobr/utils/functions.dart';

get budgetTab => const BudgetTab();

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  late AppDatabase _database;
  late BudgetItemDao _budgetItemDao;
  late SimpleDialog dialog;
  List<BudgetItem> rows = [];

  void _openDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    if (!mounted) return;
    int month = Provider.of<BudgetPeriodModel>(context, listen: false).month;
    int year = Provider.of<BudgetPeriodModel>(context, listen: false).year;
    _buildItems(month, year);
  }

  void _buildItems(int month, int year) async {
    _budgetItemDao = _database.budgetItemDao;
    List<BudgetItem>? itemsFromDB =
        await _budgetItemDao.findBudgetItemsByPeriod(month, year);
    if (itemsFromDB != null) {
      itemsFromDB.sort((a, b) => a.date.compareTo(b.date));
    }

    setState(() {
      rows = itemsFromDB ?? [];
    });
  }

  void _deleteItem(BudgetItem budgetItem) async {
    _budgetItemDao = _database.budgetItemDao;

    try {
      await _budgetItemDao.deleteBBudgetItem(budgetItem);
      if (!mounted) return;
      Navigator.pop(context, 'Sim');
    } catch (e) {
      showDialog(context: context, builder: (BuildContext context) => const GenericErrorDialog());
    }
    if (!mounted) return;
    int month = Provider.of<BudgetPeriodModel>(context, listen: false).month;
    int year = Provider.of<BudgetPeriodModel>(context, listen: false).year;
    _buildItems(month, year);
  }

  void _showDeleteDialog(BudgetItem budgetItem) {
    showDialog(
        context: context,
        builder: (BuildContext context) => DeleteBudgetItemDialog(budgetItem: budgetItem,deleteItem: _deleteItem));
  }

  @override
  void initState() {
    super.initState();

    dialog = FilterPeriodDialog(buildItems: _buildItems);
  }

  @override
  Widget build(BuildContext context) {
    _openDatabase();

    return Scaffold(
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.only(
                  left: 12, right: 12, top: 24, bottom: 12),
              child: Text(
                "Orçamento",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              )),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<BudgetPeriodModel>(
                  builder: (context, value, child) => Text(
                    'Período: ${addLeadingZeros(value.month.toString(), 1)}/${value.year}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context, builder: (context) => dialog);
                    },
                    child: const Icon(Icons.filter_alt))
              ],
            ),
          ),
          rows.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12);
                  },
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 24, bottom: 12),
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final typeIcon = rows[index].type == 'Receita'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward;
                    final typeIconColor = rows[index].type == 'Receita'
                        ? Colors.green
                        : Colors.red;
                    final typeText = rows[index].type == 'Despesa'
                        ? '${rows[index].type} - ${rows[index].category}'
                        : rows[index].type;
                    final formattedDate = formatDate(rows[index].date);

                    return ListTile(
                      leading: Icon(typeIcon, color: typeIconColor),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(typeText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(rows[index].description),
                          Row(
                            children: [
                              Text('$formattedDate - ${rows[index].amount}'),
                              const SizedBox(width: 8,),
                              rows[index].isPaidWithCreditCard
                                  ? const Icon(Icons.credit_card, color: Colors.blue,)
                                  : const Text(""),
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditRegisterScreen(
                                                    budgetItem: rows[index])));
                                  },
                                  child: const Icon(Icons.edit, size: 20)),
                              const SizedBox(
                                width: 60,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _showDeleteDialog(rows[index]);
                                  },
                                  child: const Icon(Icons.delete, size: 20))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ))
              : const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sem itens para o mês selecionado...'),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                              'Adicione uma receita ou despesa clicando no ícone de mais no canto inferior direito.'))
                    ],
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Adicionar lançamento',
        elevation: 5,
        splashColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 29,
        ),
      ),
    );
  }
}
