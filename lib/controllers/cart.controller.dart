import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishop/models/cart.item.model.dart';

class CartController {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('carts');

  Future<void> addItemToCart(CartItem item) async {
    try {
      await _cartCollection.doc(item.id).set(item.toMap());
    } catch (e) {
      print('Error adding item to cart: $e');
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> updateCartItem(CartItem item) async {
    try {
      await _cartCollection.doc(item.id).update(item.toMap());
    } catch (e) {
      print('Error updating item in cart: $e');
      throw Exception('Failed to update item in cart');
    }
  }

  Future<void> removeItemFromCart(String itemId) async {
    try {
      await _cartCollection.doc(itemId).delete();
    } catch (e) {
      print('Error removing item from cart: $e');
      throw Exception('Failed to remove item from cart');
    }
  }

  Stream<List<CartItem>> getCartItemsStream() {
    return _cartCollection
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromDocumentSnapshot(doc))
            .toList());
  }
}
