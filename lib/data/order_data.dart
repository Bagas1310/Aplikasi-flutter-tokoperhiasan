import '../models/order_model.dart';
import 'database_helper.dart';

class OrderData {
  OrderData._();

  static final List<OrderModel> initialOrders = [
    OrderModel(
      id: 'ORD-001',
      productName: 'Dreamy Pearl Beads',
      quantity: 2,
      total: 70000,
      date: DateTime(2026, 10, 15),
      status: 'Selesai',
    ),
    OrderModel(
      id: 'ORD-002',
      productName: 'Simple Thread Blue',
      quantity: 1,
      total: 15000,
      date: DateTime(2026, 10, 28),
      status: 'Selesai',
    ),
    OrderModel(
      id: 'ORD-003',
      productName: 'Couple Heart Set',
      quantity: 1,
      total: 85000,
      date: DateTime(2026, 11, 5),
      status: 'Dikirim',
    ),
  ];

  static List<OrderModel> _cachedOrders = [];

  static List<OrderModel> get mockOrders =>
      _cachedOrders.isNotEmpty ? _cachedOrders : initialOrders;

  static set mockOrders(List<OrderModel> orders) {
    _cachedOrders = orders;
  }

  static Future<List<OrderModel>> loadFromDatabase({String? userId}) async {
    final list = await DatabaseHelper.instance.getOrders(userId: userId);
    if (list.isNotEmpty) {
      _cachedOrders = list;
    }
    return mockOrders;
  }
}
