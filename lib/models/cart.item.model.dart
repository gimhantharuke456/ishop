import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String? id;
  final String productName;
  final double price;
  final int quantity;
  final String uid;

  CartItem({
    this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.uid,
  });

  factory CartItem.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CartItem(
        id: snapshot.id,
        productName: data['productName'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        quantity: data['quantity'] ?? 0,
        uid: data['uid'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'uid': uid,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
        id: map['id'],
        productName: map['productName'],
        price: map['price'],
        quantity: map['quantity'],
        uid: map['uid']);
  }
}
