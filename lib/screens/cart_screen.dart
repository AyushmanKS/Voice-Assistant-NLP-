import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../services/voice_service.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final VoiceService _voiceService = VoiceService();
  bool _isListening = false;
  String _listeningText = '';

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    bool available = await _voiceService.initSpeech();
    print("Voice initialized on CartScreen: $available");
  }

  void _showVoiceFeedback(String message) {
    setState(() => _listeningText = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _listeningText = '');
    });
  }

  void _handleCartVoiceCommand(String command, CartProvider cartProvider) {
    command = command.toLowerCase();

    if (command == "clear cart" ||
        command == "clearcart" ||
        command == "clear") {
      _showVoiceFeedback("Clearing entire cart...");
      cartProvider.clearCart();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cart cleared.")));
      return;
    }

    if (command.contains("remove")) {
      Product? match;

      for (final item in cartProvider.cartItems) {
        if (command.contains(item.name.toLowerCase())) {
          match = item;
          break;
        }
      }

      if (match != null) {
        cartProvider.removeFromCart(match);
        _showVoiceFeedback("Removed ${match.name} from cart");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${match.name} removed from cart')),
        );
      } else {
        String potentialItem = command.replaceAll("remove", "").trim();
        _showVoiceFeedback('Could not find "$potentialItem" in your cart.');
      }
      return;
    }

    _showVoiceFeedback(
      "Command not recognized. Try 'clear cart' or 'remove [item name]'.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        elevation: 4,
        title: const Text(
          "Wizard Cart",
          style: TextStyle(fontFamily: 'Cinzel', fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          cartItems.isEmpty
              ? const Center(
                  child: Text(
                    "Your magical cart is empty",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2D3E),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cinzel',
                            ),
                          ),
                          subtitle: Text(
                            "\$${item.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              cartProvider.removeFromCart(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item.name} removed from cart',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
          if (_listeningText.isNotEmpty)
            Positioned(
              bottom: 90,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _listeningText,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent.withValues(alpha: 0.9),
                        Colors.indigo.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Checkout (\$${cartProvider.totalPrice.toStringAsFixed(2)})",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Checkout successful (demo)!"),
                        ),
                      );
                      cartProvider.clearCart();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: const Icon(Icons.mic),
        onPressed: () {
          setState(() => _isListening = true);
          _voiceService.listen((intent, text) {
            _showVoiceFeedback("Heard: $text");
            _handleCartVoiceCommand(text, cartProvider);
            _voiceService.stop();
            setState(() => _isListening = false);
          });
        },
      ),
    );
  }
}
