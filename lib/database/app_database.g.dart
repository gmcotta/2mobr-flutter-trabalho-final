// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BudgetItemDao? _budgetItemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BudgetItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `type` TEXT NOT NULL, `category` TEXT, `description` TEXT NOT NULL, `date` TEXT NOT NULL, `month` INTEGER NOT NULL, `year` INTEGER NOT NULL, `amount` TEXT NOT NULL, `isPaidWithCreditCard` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BudgetItemDao get budgetItemDao {
    return _budgetItemDaoInstance ??= _$BudgetItemDao(database, changeListener);
  }
}

class _$BudgetItemDao extends BudgetItemDao {
  _$BudgetItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _budgetItemInsertionAdapter = InsertionAdapter(
            database,
            'BudgetItem',
            (BudgetItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'category': item.category,
                  'description': item.description,
                  'date': item.date,
                  'month': item.month,
                  'year': item.year,
                  'amount': item.amount,
                  'isPaidWithCreditCard': item.isPaidWithCreditCard ? 1 : 0
                }),
        _budgetItemUpdateAdapter = UpdateAdapter(
            database,
            'BudgetItem',
            ['id'],
            (BudgetItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'category': item.category,
                  'description': item.description,
                  'date': item.date,
                  'month': item.month,
                  'year': item.year,
                  'amount': item.amount,
                  'isPaidWithCreditCard': item.isPaidWithCreditCard ? 1 : 0
                }),
        _budgetItemDeletionAdapter = DeletionAdapter(
            database,
            'BudgetItem',
            ['id'],
            (BudgetItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'category': item.category,
                  'description': item.description,
                  'date': item.date,
                  'month': item.month,
                  'year': item.year,
                  'amount': item.amount,
                  'isPaidWithCreditCard': item.isPaidWithCreditCard ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BudgetItem> _budgetItemInsertionAdapter;

  final UpdateAdapter<BudgetItem> _budgetItemUpdateAdapter;

  final DeletionAdapter<BudgetItem> _budgetItemDeletionAdapter;

  @override
  Future<List<BudgetItem>> findAllBudgetItems() async {
    return _queryAdapter.queryList('SELECT * FROM BudgetItem',
        mapper: (Map<String, Object?> row) => BudgetItem(
            id: row['id'] as int?,
            type: row['type'] as String,
            category: row['category'] as String?,
            description: row['description'] as String,
            date: row['date'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as String,
            isPaidWithCreditCard: (row['isPaidWithCreditCard'] as int) != 0));
  }

  @override
  Future<BudgetItem?> findBudgetItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM BudgetItem WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BudgetItem(
            id: row['id'] as int?,
            type: row['type'] as String,
            category: row['category'] as String?,
            description: row['description'] as String,
            date: row['date'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as String,
            isPaidWithCreditCard: (row['isPaidWithCreditCard'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<BudgetItem>?> findBudgetItemsByPeriod(
    int month,
    int year,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM BudgetItem WHERE month = ?1 AND year = ?2',
        mapper: (Map<String, Object?> row) => BudgetItem(
            id: row['id'] as int?,
            type: row['type'] as String,
            category: row['category'] as String?,
            description: row['description'] as String,
            date: row['date'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as String,
            isPaidWithCreditCard: (row['isPaidWithCreditCard'] as int) != 0),
        arguments: [month, year]);
  }

  @override
  Future<void> insertBudgetItem(BudgetItem budgetItem) async {
    await _budgetItemInsertionAdapter.insert(
        budgetItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBudgetItem(BudgetItem budgetItem) async {
    await _budgetItemUpdateAdapter.update(budgetItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBBudgetItem(BudgetItem budgetItem) async {
    await _budgetItemDeletionAdapter.delete(budgetItem);
  }
}
