import 'package:floor/floor.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';

@dao
abstract class BudgetItemDao {
  @Query('SELECT * FROM BudgetItem')
  Future<List<BudgetItem>> findAllBudgetItems();

  @Query('SELECT * FROM BudgetItem WHERE id = :id')
  Future<BudgetItem?> findBudgetItemById(int id);

  @insert
  Future<void> insertBudgetItem(BudgetItem budgetItem);

  @update
  Future<void> updateBudgetItem(BudgetItem budgetItem);

  @delete
  Future<void> deleteBBudgetItem(BudgetItem budgetItem);
}