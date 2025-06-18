import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(String id, Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index >= 0) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  void deleteOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }

  Order? findById(String id) {
    return _orders.firstWhere((order) => order.id == id, orElse: () => null);
  }
}
