import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_final_2mobr/entities/budget_period.dart';

class FilterPeriodDialog extends SimpleDialog {
  final Function buildItems;
  final _formKey = GlobalKey<FormBuilderState>();

  FilterPeriodDialog({super.key, required this.buildItems});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
                            bool? isValid =
                            _formKey.currentState?.saveAndValidate();

                            if (isValid != null && isValid) {
                              int month = int.parse((_formKey.currentState
                                  ?.fields['month']?.value as String));
                              int year = int.parse((_formKey.currentState
                                  ?.fields['year']?.value as String));

                              DateTime chosenPeriod = DateTime(year, month);

                              if (chosenPeriod.compareTo(DateTime.now()) > 0) {
                                _formKey.currentState?.fields['month']?.invalidate(
                                    'Digite o período igual ou menor ao atual');
                                return;
                              }

                              buildItems(month, year);

                              Provider.of<BudgetPeriodModel>(context,
                                  listen: false)
                                  .changePeriod(month, year);
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

}
