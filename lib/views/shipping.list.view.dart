import 'package:flutter/material.dart';
import 'package:ishop/controllers/voice.controller.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  final _voiceController = VoiceController();
  @override
  Widget build(BuildContext context) {
    _voiceController.speek(message: "You are now in shipping list screen");
    return Scaffold();
  }
}
