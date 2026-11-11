import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toMap({String? userId}) => {
        if (userId != null) 'user_id': userId,
        'product_id': product.id,
        'quantity': quantity,
      };

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) =>
      CartItem(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );
}
