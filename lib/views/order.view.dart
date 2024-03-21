import 'package:flutter/material.dart';
import 'package:ishop/controllers/voice.controller.dart';
import 'package:ishop/models/cart.item.model.dart';

class OrderView extends StatefulWidget {
  final CartItem product;
  const OrderView({Key? key, required this.product}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final VoiceController _voiceController = VoiceController();
  String cardDetails = '';
  String address = '';
  String name = '';

  @override
  void initState() {
    _voiceController.speek(
        message:
            "You are in order view now. Tap to place cash on delivery order. Double tap to provide card details.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        backgroundColor: Colors.grey,
      ),
      body: GestureDetector(
        onTap: () {
          placeCashOnDeliveryOrder();
        },
        onDoubleTap: () {
          provideCardDetails();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.product.productName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ${widget.product.price}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void placeCashOnDeliveryOrder() {
    _voiceController.speek(message: 'Cash on delivery order placed');
    Navigator.pop(context);
  }

  void provideCardDetails() async {
    _voiceController.speek(
        message: 'Please provide your card details, address, and name');
  }
}
