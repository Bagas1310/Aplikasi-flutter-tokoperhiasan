import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _currentUserId;
  VoidCallback? _onCheckoutComplete;

  CartProvider({String? userId}) {
    _currentUserId = userId;
  }

  void setOnCheckoutComplete(VoidCallback callback) {
    _onCheckoutComplete = callback;
  }

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get grandTotal =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  Future<void> loadCart({String? userId}) async {
    _currentUserId = userId ?? 'default_user';
    _items.clear();
    final cartItems = await DatabaseHelper.instance.getCartItems(
      userId: _currentUserId,
    );
    _items.addAll(cartItems);
    notifyListeners();
  }

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final uId = _currentUserId ?? 'default_user';

    // Add to database
    await DatabaseHelper.instance.addToCart(
      product.id,
      quantity: quantity,
      userId: uId,
    );

    // Update in-memory
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  Future<void> removeFromCart(String productId) async {
    final uId = _currentUserId ?? 'default_user';

    // Remove from database
    await DatabaseHelper.instance.removeFromCart(productId, userId: uId);

    // Update in-memory
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  Future<void> increment(String productId) async {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;

      // Update in database
      final uId = _currentUserId ?? 'default_user';
      await DatabaseHelper.instance.updateCartQuantity(
        productId,
        _items[index].quantity,
        userId: uId,
      );

      notifyListeners();
    }
  }

  Future<void> decrement(String productId) async {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;

        // Update in database
        final uId = _currentUserId ?? 'default_user';
        await DatabaseHelper.instance.updateCartQuantity(
          productId,
          _items[index].quantity,
          userId: uId,
        );
      } else {
        await removeFromCart(productId);
        return;
      }
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    final uId = _currentUserId ?? 'default_user';

    // Clear in database
    await DatabaseHelper.instance.clearCart(userId: uId);

    // Clear in-memory
    _items.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    if (_items.isEmpty) return;

    final userId = _currentUserId ?? 'default_user';
    final timestamp = DateTime.now();
    final orders = [
      for (final item in _items)
        OrderModel(
          id: 'ORD-${timestamp.microsecondsSinceEpoch}-${item.product.id}',
          productName: item.product.name,
          quantity: item.quantity,
          total: item.subtotal,
          date: timestamp,
          status: 'Diproses',
        ),
    ];

    await DatabaseHelper.instance.completeCheckout(orders, userId: userId);
    _items.clear();
    notifyListeners();
    _onCheckoutComplete?.call();
  }
}

/// InheritedWidget wrapper
class CartProviderScope extends InheritedNotifier<CartProvider> {
  final CartProvider provider;

  const CartProviderScope({
    super.key,
    required this.provider,
    required super.child,
  }) : super(notifier: provider);

  static CartProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CartProviderScope>()!
        .provider;
  }
}
