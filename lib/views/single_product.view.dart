import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ishop/controllers/cart.controller.dart';
import 'package:ishop/controllers/voice.controller.dart';
import 'package:ishop/models/cart.item.model.dart';
import 'package:ishop/models/product.model.dart';

class SingleProductView extends StatefulWidget {
  final Product product;

  const SingleProductView({super.key, required this.product});

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  final VoiceController voiceController = VoiceController();

  @override
  void initState() {
    voiceController.speek(
        message:
            "You are in ${widget.product.name} Product view. Tap to listent to description, and . double tap to buy item. swipe for go back");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.grey,
      ),
      body: GestureDetector(
        onTap: () {
          voiceController.speek(message: widget.product.description);
        },
        onDoubleTap: () {},
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Price: ${widget.product.price}',
                  style: const TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 20.0),
                Text(
                  widget.product.description,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final _cartController = CartController();
                    CartItem cartItem = CartItem(
                        productName: widget.product.name,
                        price: widget.product.price,
                        quantity: 1,
                        uid: FirebaseAuth.instance.currentUser?.uid ?? '');
                    await _cartController.addItemToCart(cartItem);
                    voiceController.speek(message: "Item added to cart");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
