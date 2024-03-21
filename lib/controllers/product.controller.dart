import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishop/models/product.model.dart';

class ProductController {
  Stream<List<Product>> getProductsStream() {
    // Access the 'products' collection in Firestore
    return FirebaseFirestore.instance
        .collection('inventory')
        .snapshots()
        .map((snapshot) {
      // Map each document in the snapshot to a Product
      return snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
