import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';


class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();
  static Database? _database;

  ProductDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        image TEXT,
        rate REAL,
        count INTEGER
      )
    ''');
  }

  Future<void> syncProducts(List<ProductsModel> products) async {
    final db = await instance.database;

    final current = await getAllProducts();
    final existingIds = current.map((e) => e.id).toSet();
    final newIds = products.map((e) => e.id).toSet();

    final batch = db.batch();

    for (var product in products) {
      batch.insert(
        'products',
        {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rate': product.rating?.rate,
          'count': product.rating?.count
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final idsToDelete = existingIds.difference(newIds);
    for (var id in idsToDelete) {
      batch.delete('products', where: 'id = ?', whereArgs: [id]);
    }

    await batch.commit(noResult: true);
    print("✅ Synced ${products.length} products to local DB.");
  }


  Future<List<ProductsModel>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) {
      return ProductsModel(
        id: json['id'] as int,
        title: json['title'] as String?,
        price: json['price'] as double?,
        description: json['description'] as String?,
        category: json['category'] as String?,
        image: json['image'] as String?,
        rating: Rating(
          rate: json['rate'] as double?,
          count: json['count'] as int?,
        )
      );
    }).toList();
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

}
