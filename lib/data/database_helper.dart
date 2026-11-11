import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import 'order_data.dart';
import 'product_data.dart';

class DatabaseHelper {
  static const String _databaseName = 'barely_shop.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableUsers = 'users';
  static const String tableProducts = 'products';
  static const String tableCart = 'cart';
  static const String tableOrders = 'orders';

  // Users columns
  static const String colUserId = 'id';
  static const String colUsername = 'username';
  static const String colEmail = 'email';
  static const String colPassword = 'password';
  static const String colPhone = 'phone';
  static const String colAddress = 'address';
  static const String colBio = 'bio';
  static const String colAvatarUrl = 'avatar_url';
  static const String colProfilePicPath = 'profile_picture_path';
  static const String colMemberSince = 'member_since';

  // Products columns
  static const String colProdId = 'id';
  static const String colProdName = 'name';
  static const String colProdCategory = 'category';
  static const String colProdDescription = 'description';
  static const String colProdLongDescription = 'long_description';
  static const String colProdPrice = 'price';
  static const String colProdImageUrl = 'image_url';
  static const String colProdIsNew = 'is_new';
  static const String colProdRating = 'rating';

  // Cart columns
  static const String colCartId = 'id';
  static const String colCartUserId = 'user_id';
  static const String colCartProductId = 'product_id';
  static const String colCartQuantity = 'quantity';
  static const String colCartCreatedAt = 'created_at';

  // Orders columns
  static const String colOrderId = 'id';
  static const String colOrderUserId = 'user_id';
  static const String colOrderProductName = 'product_name';
  static const String colOrderQuantity = 'quantity';
  static const String colOrderTotal = 'total';
  static const String colOrderDate = 'date';
  static const String colOrderStatus = 'status';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  factory DatabaseHelper() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Table Users
    await db.execute('''
      CREATE TABLE $tableUsers (
        $colUserId TEXT PRIMARY KEY,
        $colUsername TEXT NOT NULL,
        $colEmail TEXT UNIQUE NOT NULL,
        $colPassword TEXT NOT NULL,
        $colPhone TEXT,
        $colAddress TEXT,
        $colBio TEXT,
        $colAvatarUrl TEXT,
        $colProfilePicPath TEXT,
        $colMemberSince TEXT NOT NULL
      )
    ''');

    // 2. Table Products (Bracelets)
    await db.execute('''
      CREATE TABLE $tableProducts (
        $colProdId TEXT PRIMARY KEY,
        $colProdName TEXT NOT NULL,
        $colProdCategory TEXT NOT NULL,
        $colProdDescription TEXT NOT NULL,
        $colProdLongDescription TEXT,
        $colProdPrice REAL NOT NULL,
        $colProdImageUrl TEXT NOT NULL,
        $colProdIsNew INTEGER NOT NULL DEFAULT 0,
        $colProdRating REAL NOT NULL DEFAULT 4.5
      )
    ''');

    // 3. Table Cart
    await db.execute('''
      CREATE TABLE $tableCart (
        $colCartId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCartUserId TEXT NOT NULL DEFAULT 'default_user',
        $colCartProductId TEXT NOT NULL,
        $colCartQuantity INTEGER NOT NULL DEFAULT 1,
        $colCartCreatedAt TEXT NOT NULL,
        FOREIGN KEY ($colCartProductId) REFERENCES $tableProducts ($colProdId) ON DELETE CASCADE
      )
    ''');

    // 4. Table Orders
    await db.execute('''
      CREATE TABLE $tableOrders (
        $colOrderId TEXT PRIMARY KEY,
        $colOrderUserId TEXT NOT NULL DEFAULT 'default_user',
        $colOrderProductName TEXT NOT NULL,
        $colOrderQuantity INTEGER NOT NULL DEFAULT 1,
        $colOrderTotal REAL NOT NULL,
        $colOrderDate TEXT NOT NULL,
        $colOrderStatus TEXT NOT NULL
      )
    ''');

    // Initial Data Seeding
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // Seed initial products from ProductData
    for (final product in ProductData.initialProducts) {
      await db.insert(
        tableProducts,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Seed mock orders from OrderData
    for (final order in OrderData.initialOrders) {
      await db.insert(
        tableOrders,
        order.toMap(userId: 'default_user'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Seed demo user
    await db.insert(
      tableUsers,
      {
        colUserId: 'usr_demo',
        colUsername: 'Bestie Barely',
        colEmail: 'bestie@barelyshop.com',
        colPassword: 'password123',
        colPhone: '0812-3456-7890',
        colAddress: 'Jl. Gelang Indah No. 7, Bandung',
        colBio: 'Pencinta gelang aesthetic 🌸 | Member since 2026',
        colAvatarUrl: '',
        colProfilePicPath: null,
        colMemberSince: DateTime(2026, 1, 1).toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // ==========================================
  // ─── USER / AUTH OPERATIONS ───
  // ==========================================

  Future<int> insertUser(UserModel user, String password) async {
    final db = await database;
    final map = user.toMap();
    map[colPassword] = password;
    return await db.insert(
      tableUsers,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      tableUsers,
      where: 'LOWER($colEmail) = ?',
      whereArgs: [email.toLowerCase().trim()],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await database;
    final results = await db.query(
      tableUsers,
      where: '$colUserId = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  Future<UserModel?> login(String email, String password) async {
    final userMap = await getUserByEmail(email);
    if (userMap != null) {
      if (userMap[colPassword] == password) {
        return UserModel.fromMap(userMap);
      }
    }
    return null;
  }

  Future<int> updateUserProfile(UserModel user) async {
    final db = await database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: '$colUserId = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateProfilePicture(String userId, String picturePath) async {
    final db = await database;
    return await db.update(
      tableUsers,
      {colProfilePicPath: picturePath},
      where: '$colUserId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final results = await db.query(tableUsers);
    return results.map((m) => UserModel.fromMap(m)).toList();
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(
      tableUsers,
      where: '$colUserId = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // ─── PRODUCT / BRACELETS OPERATIONS ───
  // ==========================================

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final results = await db.query(tableProducts);
    if (results.isEmpty) {
      // If table is somehow empty, reseed
      await _seedInitialData(db);
      final seeded = await db.query(tableProducts);
      return seeded.map((m) => Product.fromMap(m)).toList();
    }
    return results.map((m) => Product.fromMap(m)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final results = await db.query(
      tableProducts,
      where: '$colProdId = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Product.fromMap(results.first);
    }
    return null;
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await database;
    final results = await db.query(
      tableProducts,
      where: '$colProdCategory = ?',
      whereArgs: [category],
    );
    return results.map((m) => Product.fromMap(m)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final q = '%${query.toLowerCase()}%';
    final results = await db.query(
      tableProducts,
      where: 'LOWER($colProdName) LIKE ? OR LOWER($colProdCategory) LIKE ?',
      whereArgs: [q, q],
    );
    return results.map((m) => Product.fromMap(m)).toList();
  }

  Future<List<String>> getAllCategories() async {
    final products = await getAllProducts();
    return products.map((p) => p.category).toSet().toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      tableProducts,
      product.toMap(),
      where: '$colProdId = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete(
      tableProducts,
      where: '$colProdId = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // ─── CART OPERATIONS ───
  // ==========================================

  Future<List<CartItem>> getCartItems({String? userId}) async {
    final db = await database;
    final uId = userId ?? 'default_user';

    final results = await db.rawQuery('''
      SELECT 
        c.$colCartId as cart_id,
        c.$colCartQuantity as cart_qty,
        c.$colCartUserId as cart_user_id,
        p.$colProdId,
        p.$colProdName,
        p.$colProdCategory,
        p.$colProdDescription,
        p.$colProdLongDescription,
        p.$colProdPrice,
        p.$colProdImageUrl,
        p.$colProdIsNew,
        p.$colProdRating
      FROM $tableCart c
      INNER JOIN $tableProducts p ON c.$colCartProductId = p.$colProdId
      WHERE c.$colCartUserId = ?
      ORDER BY c.$colCartId ASC
    ''', [uId]);

    return results.map((row) {
      final product = Product.fromMap(row);
      final quantity = (row['cart_qty'] as num?)?.toInt() ?? 1;
      return CartItem(product: product, quantity: quantity);
    }).toList();
  }

  Future<void> addToCart(String productId,
      {int quantity = 1, String? userId}) async {
    final db = await database;
    final uId = userId ?? 'default_user';

    final existing = await db.query(
      tableCart,
      where: '$colCartUserId = ? AND $colCartProductId = ?',
      whereArgs: [uId, productId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final currentQty = (existing.first[colCartQuantity] as num).toInt();
      await db.update(
        tableCart,
        {colCartQuantity: currentQty + quantity},
        where: '$colCartUserId = ? AND $colCartProductId = ?',
        whereArgs: [uId, productId],
      );
    } else {
      await db.insert(tableCart, {
        colCartUserId: uId,
        colCartProductId: productId,
        colCartQuantity: quantity,
        colCartCreatedAt: DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity,
      {String? userId}) async {
    final db = await database;
    final uId = userId ?? 'default_user';

    if (quantity <= 0) {
      await removeFromCart(productId, userId: uId);
    } else {
      await db.update(
        tableCart,
        {colCartQuantity: quantity},
        where: '$colCartUserId = ? AND $colCartProductId = ?',
        whereArgs: [uId, productId],
      );
    }
  }

  Future<void> removeFromCart(String productId, {String? userId}) async {
    final db = await database;
    final uId = userId ?? 'default_user';
    await db.delete(
      tableCart,
      where: '$colCartUserId = ? AND $colCartProductId = ?',
      whereArgs: [uId, productId],
    );
  }

  Future<void> clearCart({String? userId}) async {
    final db = await database;
    if (userId != null) {
      await db.delete(
        tableCart,
        where: '$colCartUserId = ?',
        whereArgs: [userId],
      );
    } else {
      await db.delete(tableCart);
    }
  }

  Future<int> getCartItemCount({String? userId}) async {
    final items = await getCartItems(userId: userId);
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  // ==========================================
  // ─── ORDERS / RIWAYAT OPERATIONS ───
  // ==========================================

  Future<void> completeCheckout(
    List<OrderModel> orders, {
    required String userId,
  }) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final order in orders) {
        await txn.insert(
          tableOrders,
          order.toMap(userId: userId),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
      await txn.delete(
        tableCart,
        where: '$colCartUserId = ?',
        whereArgs: [userId],
      );
    });
  }

  Future<int> insertOrder(OrderModel order, {String? userId}) async {
    final db = await database;
    final map = order.toMap(userId: userId ?? 'default_user');
    return await db.insert(
      tableOrders,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<OrderModel>> getOrders({String? userId}) async {
    try {
      final db = await database;
      final uId = userId ?? 'default_user';

      final results = await db.query(
        tableOrders,
        where: '$colOrderUserId = ?',
        whereArgs: [uId],
        orderBy: '$colOrderDate DESC',
      );

      return results.map((m) => OrderModel.fromMap(m)).toList();
    } catch (e) {
      // Return empty list as fallback on error
      return [];
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    final db = await database;
    final results = await db.query(
      tableOrders,
      where: '$colOrderId = ?',
      whereArgs: [orderId],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return OrderModel.fromMap(results.first);
    }
    return null;
  }

  Future<int> updateOrderStatus(String orderId, String newStatus) async {
    final db = await database;
    return await db.update(
      tableOrders,
      {colOrderStatus: newStatus},
      where: '$colOrderId = ?',
      whereArgs: [orderId],
    );
  }

  Future<int> deleteOrder(String orderId) async {
    final db = await database;
    return await db.delete(
      tableOrders,
      where: '$colOrderId = ?',
      whereArgs: [orderId],
    );
  }

  // ==========================================
  // ─── UTILITY / RESET ───
  // ==========================================

  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete(tableCart);
    await db.delete(tableOrders);
    await db.delete(tableProducts);
    await db.delete(tableUsers);
    await _seedInitialData(db);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
