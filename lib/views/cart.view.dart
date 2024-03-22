import 'package:flutter/material.dart';
import 'package:ishop/controllers/cart.controller.dart';
import 'package:ishop/controllers/voice.controller.dart';
import 'package:ishop/models/cart.item.model.dart';
import 'package:ishop/utils/index.dart';
import 'package:ishop/views/order.view.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController _cartController = CartController();
  final VoiceController _voiceController = VoiceController();

  @override
  void initState() {
    _voiceController.speek(message: "You are now on cart view.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _cartController.getCartItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final cartItems = snapshot.data ?? [];
          if (cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }
          return PageView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return GestureDetector(
                onTap: () {
                  _voiceController.speek(
                    message:
                        'Product: ${cartItem.productName}\nPrice: ${cartItem.price}. Double tap to buy this product.',
                  );
                },
                onDoubleTap: () {
                  context.navigator(context, OrderView(product: cartItem));
                },
                onVerticalDragDown: (details) {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cartItem.productName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Price: ${cartItem.price}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
