import '../models/order_model.dart';

class OrderData {
  OrderData._();

  static List<OrderModel> mockOrders = [
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
}
