import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ishop/controllers/cart.controller.dart';
import 'package:ishop/controllers/product.controller.dart';
import 'package:ishop/controllers/voice.controller.dart';
import 'package:ishop/models/cart.item.model.dart';
import 'package:ishop/models/product.model.dart';
import 'package:ishop/utils/index.dart';
import 'package:ishop/views/cart.view.dart';
import 'package:ishop/views/shipping.list.view.dart';
import 'package:ishop/views/single_product.view.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String activeScreen = "products";
  final PageController _controller = PageController();
  final _cartController = CartController();
  Product? activeProduct;
  int activeIndex = 0;
  Map<String, Widget> get screens => {
        "products": ProductList(
            onProductChange: onProductChange,
            controller: _controller,
            productController: _productController,
            voiceController: _voiceController),
        "cart": const CartView(),
        "shopping_list": const ShoppingListView(),
      };
  final ProductController _productController = ProductController();
  final VoiceController _voiceController = VoiceController();

  SpeechToText _speechToText = SpeechToText();

  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _voiceController.speek(
      message:
          "Welcome to products screen. Swipe left, or , right to navigate through products. Tap once to get product details. double tap to buy the product. Long press to send commands. Thank you!",
    );
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    try {
      await _speechToText.initialize(onError: (err) {
        context.showSnackBar("Error while intializing speech to text");
      });

      setState(() {});
    } catch (e) {
      context.showSnackBar("Speech to text initialze failed $e");
    }
  }

  void _startListening() async {
    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
      );
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      context.showSnackBar(e.toString());
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    _lastWords = result.recognizedWords.toLowerCase();
    print(_lastWords);
    if (_lastWords.contains("go to") || _lastWords.contains("navigate to")) {
      if (_lastWords.contains("products")) {
        setState(() {
          activeScreen = "products";
        });
      }
      if (_lastWords.contains("cart")) {
        setState(() {
          activeScreen = "cart";
        });
      }
      if (_lastWords.contains("shopping list")) {
        setState(() {
          activeScreen = "shopping_list";
        });
      }
    }
    if (_lastWords.contains("add to cart") ||
        _lastWords.contains("add this item to cart") ||
        _lastWords.contains("product to cart")) {
      addToCart();
    }
    if (_lastWords.contains("help")) {
      await _voiceController.speek(message: "Swipe top to add product to cart");
      await _voiceController.speek(
          message: "Swipe down to add product to shop list");
    }
  }

  void addToCart() async {
    try {
      if (activeProduct != null) {
        CartItem cartItem = CartItem(
            productName: activeProduct!.name,
            price: activeProduct!.price,
            quantity: 1,
            uid: FirebaseAuth.instance.currentUser?.uid ?? "");
        await _cartController.addItemToCart(cartItem);
        await _voiceController.speek(
            message: "${activeProduct!.name}, added to cart successfully!");
      }
    } catch (e) {
      context.showSnackBar(e.toString());
      await _voiceController.speek(message: "Add to cart failed !");
    }
  }

  void onProductChange(Product product) {
    activeProduct = product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I Shop'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
              onPressed: () {
                context.navigator(context, CartView(),
                    shouldAuthenticate: false);
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: GestureDetector(
        onLongPress: _startListening,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            addToCart();
          } else if (details.primaryVelocity! < 0) {
            // Swiped from bottom to top
            print('Swiped from bottom to top');
          } else {
            print("Asda");
          }
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: screens[activeScreen]),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.onProductChange,
    required this.controller,
    required ProductController productController,
    required VoiceController voiceController,
  })  : _productController = productController,
        _voiceController = voiceController;

  final ProductController _productController;
  final VoiceController _voiceController;
  final PageController controller;
  final Function(Product) onProductChange;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: _productController.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];

        return PageView.builder(
          itemCount: products.length,
          onPageChanged: (val) {
            onProductChange(products[val]);
          },
          itemBuilder: (context, index) {
            final product = products[index];

            return GestureDetector(
              onTap: () {
                _voiceController.speek(
                  message:
                      '${product.name}. The product price is ${product.price}. Double tap to buy the item. Long press for more details.',
                );
              },
              onDoubleTap: () {
                context.navigator(context, SingleProductView(product: product),
                    shouldAuthenticate: false);
              },
              child: Container(
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 48.0, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        product.description,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Price: ${product.price}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
