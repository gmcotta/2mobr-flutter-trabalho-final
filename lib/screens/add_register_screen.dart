import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import 'package:trabalho_final_2mobr/database/app_database.dart';
import 'package:trabalho_final_2mobr/dialogs/generic_error_dialog.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';

class AddRegisterScreen extends StatefulWidget {
  const AddRegisterScreen({super.key});

  @override
  State<AddRegisterScreen> createState() => _AddRegisterScreenState();
}

class _AddRegisterScreenState extends State<AddRegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isExpense = false;
  late AppDatabase _database;

  void _saveBudgetItem() async {
    String category = _formKey.currentState?.fields['category']?.value ?? '';
    String date =
        (_formKey.currentState?.fields['date']?.value as DateTime).toString();
    int month =
        (_formKey.currentState?.fields['date']?.value as DateTime).month;
    int year = (_formKey.currentState?.fields['date']?.value as DateTime).year;

    final budgetItem = BudgetItem(
        type: _formKey.currentState?.fields['type']?.value,
        category: category,
        description: _formKey.currentState?.fields['description']?.value,
        date: date,
        month: month,
        year: year,
        amount: _formKey.currentState?.fields['amount']?.value,
        isPaidWithCreditCard:
            _formKey.currentState?.fields['isPaidWithCreditCard']?.value);

    final budgetItemDao = _database.budgetItemDao;
    try {
      await budgetItemDao.insertBudgetItem(budgetItem);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(context: context, builder: (BuildContext context) => const GenericErrorDialog());
    }
  }

  void _openDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderChoiceChip(
                  name: 'type',
                  initialValue: 'Receita',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  spacing: 10,
                  options: const [
                    FormBuilderChipOption(value: 'Receita'),
                    FormBuilderChipOption(value: 'Despesa'),
                  ],
                  onChanged: (value) {
                    if (value == 'Receita') {
                      _formKey.currentState?.fields['category']?.reset();
                      _formKey.currentState?.fields['isPaidWithCreditCard']
                          ?.reset();
                      setState(() {
                        isExpense = false;
                      });
                    } else {
                      setState(() {
                        isExpense = true;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Tipo de lançamento obrigatório';
                    }
                    return null;
                  },
                ),
                FormBuilderDropdown(
                  name: 'category',
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: [
                    'Alimentação',
                    'Moradia',
                    'Educação',
                    'Pets',
                    'Saúde',
                    'Transporte',
                    'Pessoais',
                    'Lazer',
                    'Outros'
                  ]
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  enabled: isExpense,
                  validator: (value) {
                    if (value == null && isExpense) {
                      return 'Categoria obrigatória para despesas';
                    }
                    return null;
                  },
                ),
                FormBuilderTextField(
                    name: 'description',
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Campo obrigatório';
                      }
                      return null;
                    }),
                FormBuilderDateTimePicker(
                    name: 'date',
                    decoration: const InputDecoration(labelText: 'Data'),
                    lastDate: DateTime.now(),
                    format: DateFormat("dd/MM/yyyy"),
                    locale: const Locale('pt', 'BR'),
                    inputType: InputType.date,
                    validator: (value) {
                      if (value == null) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    }),
                FormBuilderTextField(
                    name: 'amount',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: 'pt_BR',
                        decimalDigits: 2,
                        symbol: 'R\$',
                        turnOffGrouping: true
                      )
                    ],
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Campo obrigatório';
                      }
                      return null;
                    }),
                FormBuilderCheckbox(
                  // Core attributes
                  name: 'isPaidWithCreditCard',
                  initialValue: false,
                  title: const Text('Pago com o cartão de crédito?'),
                  enabled: isExpense,
                ),
                ElevatedButton(
                    onPressed: () {
                      bool? isValid = _formKey.currentState?.saveAndValidate();

                      if (isValid != null && isValid) {
                        _saveBudgetItem();
                      }
                    },
                    child: const Text("Enviar"))
              ],
            )),
      )),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Adicionar lançamento'),
      ),
    );
  }
}
