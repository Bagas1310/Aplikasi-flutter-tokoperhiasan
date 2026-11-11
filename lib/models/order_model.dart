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

  Map<String, dynamic> toMap({String? userId}) => {
        'id': id,
        if (userId != null) 'user_id': userId,
        'product_name': productName,
        'quantity': quantity,
        'total': total,
        'date': date.toIso8601String(),
        'status': status,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'quantity': quantity,
        'total': total,
        'date': date.toIso8601String(),
        'status': status,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: (map['id'] ?? map['order_id'])?.toString() ?? '',
        productName: (map['product_name'] ??
                map['productName'] ??
                map['nama_produk'])
            ?.toString() ??
            '',
        quantity: (map['quantity'] ?? map['jumlah'] as num?)?.toInt() ?? 1,
        total: (map['total'] ?? map['total_harga'] as num?)?.toDouble() ?? 0.0,
        date: map['date'] != null
            ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
            : (map['tanggal'] != null
                ? DateTime.tryParse(map['tanggal'].toString()) ?? DateTime.now()
                : DateTime.now()),
        status: (map['status'] ?? map['status_pesanan'])?.toString() ?? 'Selesai',
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      OrderModel.fromMap(json);

  OrderModel copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? total,
    DateTime? date,
    String? status,
  }) =>
      OrderModel(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        total: total ?? this.total,
        date: date ?? this.date,
        status: status ?? this.status,
      );
}
