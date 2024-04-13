import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  late SimpleDialog dialog;
  List<BudgetItem> rows = [];
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  final _formKey = GlobalKey<FormBuilderState>();

  void _openDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _buildItems(currentMonth, currentYear);
  }

  void _buildItems(int currentMonth, int currentYear) async {
    _budgetItemDao = _database.budgetItemDao;
    List<BudgetItem>? itemsFromDB = await _budgetItemDao.findBudgetItemsByPeriod(currentMonth, currentYear);
    if (itemsFromDB != null) {
      itemsFromDB.sort((a, b) => a.date.compareTo(b.date));
    }

    setState(() {
      rows = itemsFromDB ?? [];
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
    _buildItems(currentMonth, currentYear);
  }

  @override
  void initState() {
    super.initState();

    dialog = SimpleDialog(
      title: const Text('Filtrar período'),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              FormBuilder(
                  key: _formKey,
                  initialValue: {
                    'month': DateTime.now().month.toString(),
                    'year': DateTime.now().year.toString()
                  },
                  child: Column(
                    children: [
                      FormBuilderTextField(
                          name: 'month',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Mês'),
                          maxLength: 2,
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Campo obrigatório';
                            }
                            if (value.length > 2) {
                              return 'Digite um mês válido';
                            }
                            int valueInt = int.parse(value);
                            if (valueInt < 1 || valueInt > 12) {
                              return 'Digite um mês válido';
                            }
                            return null;
                          }),
                      FormBuilderTextField(
                          name: 'year',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Ano'),
                          maxLength: 4,
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Campo obrigatório';
                            }
                            if (value.length != 4) {
                              return 'Digite um ano com 4 dígitos';
                            }
                            int valueInt = int.parse(value);
                            if (valueInt > DateTime.now().year) {
                              return 'Digite um ano igual ou menor ao atual';
                            }
                            return null;
                          }),
                      ElevatedButton(
                          onPressed: () {
                            bool? isValid = _formKey.currentState?.saveAndValidate();

                            if (isValid != null && isValid) {
                              int month = int.parse((_formKey.currentState?.fields['month']?.value as String));
                              int year = int.parse((_formKey.currentState?.fields['year']?.value as String));

                              _buildItems(month, year);

                              setState(() {
                                currentMonth = month;
                                currentYear = year;
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Filtrar'))
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Período: $currentMonth/$currentYear'),
                ElevatedButton(
                    onPressed: () {
                      showDialog<void>(context: context, builder: (context) => dialog);
                    },
                    child: const Icon(Icons.filter_alt)
                )
              ],
            ),
          ),
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
                      Text('Sem itens para o mês selecionado.'),
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
