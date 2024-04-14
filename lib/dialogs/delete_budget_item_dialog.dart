import 'package:flutter/material.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';

class DeleteBudgetItemDialog extends AlertDialog {
  final BudgetItem budgetItem;
  final Function deleteItem;

  const DeleteBudgetItemDialog({super.key, required this.budgetItem, required this.deleteItem});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir item'),
      content: Text('Deseja realmente excluir o item ${budgetItem.type} - ${budgetItem.description}?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'Não'),
            child: const Text('Não')),
        TextButton(
            onPressed: () => deleteItem(budgetItem),
            child: const Text('Sim'))
      ],
    );
  }
}