import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:trabalho_final_2mobr/database/app_database.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';
import 'package:trabalho_final_2mobr/screens/edit_register_screen.dart';
import 'package:trabalho_final_2mobr/dao/budget_item_dao.dart';

get budgetTab => const BudgetTab();

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  late AppDatabase _database;
  late BudgetItemDao _budgetItemDao;
  List<BudgetItem> rows = [];

  void _openDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _buildItems();
  }

  void _buildItems() async {
    _budgetItemDao = _database.budgetItemDao;
    List<BudgetItem> itemsFromDB = await _budgetItemDao.findAllBudgetItems();

    setState(() {
      rows = itemsFromDB;
    });
  }

  void _showDeleteDialog(BudgetItem budgetItem) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Excluir item'),
              content: const Text('Deseja realmente excluir esse item?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, 'Não'),
                    child: const Text('Não')),
                TextButton(
                    onPressed: () => _deleteItem(budgetItem),
                    child: const Text('Sim'))
              ],
            ));
  }

  void _deleteItem(BudgetItem budgetItem) async {
    _budgetItemDao = _database.budgetItemDao;

    try {
      await _budgetItemDao.deleteBBudgetItem(budgetItem);
      Navigator.pop(context, 'Sim');
    } catch (e) {
      print('deu ruim');
    }
    _buildItems();
  }

  @override
  Widget build(BuildContext context) {
    _openDatabase();

    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 24, bottom: 12),
              child: Text(
                "Orçamento",
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          rows.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
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
                    final formattedDate = DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(rows[index].date));

                    return ListTile(
                      leading: Icon(typeIcon, color: typeIconColor),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(typeText),
                          Text(rows[index].description),
                          Text(formattedDate),
                          Row(
                            children: [
                              Text(rows[index].amount),
                              rows[index].isPaidWithCreditCard
                                  ? const Icon(Icons.credit_card)
                                  : const Text(""),
                            ],
                          )
                        ],
                      ),
                      trailing: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditRegisterScreen(
                                                    budgetItem: rows[index])));
                                  },
                                  child: const Icon(Icons.edit,
                                      color: Colors.black, size: 20)),
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      _showDeleteDialog(rows[index]);
                                    },
                                    child: const Icon(Icons.delete,
                                        color: Colors.black, size: 20))),
                          ]),
                    );
                  },
                ))
              : const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text('Sem itens para o mês'),
                      Text(
                          'Adicione uma receita ou despesa clicando no ícone de mais no canto inferior direito.')
                    ],
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Adicionar registro',
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
