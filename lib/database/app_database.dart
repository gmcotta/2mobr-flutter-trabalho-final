import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:trabalho_final_2mobr/dao/budget_item_dao.dart';
import 'package:trabalho_final_2mobr/entities/budget_item.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [BudgetItem])
abstract class AppDatabase extends FloorDatabase {
  BudgetItemDao get budgetItemDao;
}
