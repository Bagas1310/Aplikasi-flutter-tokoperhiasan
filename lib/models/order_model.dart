class OrderModel {
  final String id;
  final String productName;
  final int quantity;
  final double total;
  final DateTime date;
  final String status;

  const OrderModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.total,
    required this.date,
    required this.status,
  });
}
