import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/voice_service.dart';
import '../providers/cart_provider.dart';
import './product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceService _voiceService = VoiceService();

  final List<Product> _products = [
    Product(name: 'Wand of Elder', image: 'assets/images/wand.jpeg', price: 299.99),
    Product(name: 'Invisibility Cloak', image: 'assets/images/cloak.jpeg', price: 499.99),
    Product(name: 'Potion Kit', image: 'assets/images/potion.jpeg', price: 149.99),
    Product(name: 'Flying Broomstick', image: 'assets/images/broom.jpeg', price: 999.99),
    Product(name: 'Time Turner', image: 'assets/images/time_turner.jpeg', price: 799.99),
    Product(name: 'Hogwarts Robe', image: 'assets/images/robe.jpeg', price: 199.99),
    Product(name: 'Spell Book', image: 'assets/images/book.jpeg', price: 99.99),
    Product(name: 'Owl Messenger', image: 'assets/images/owl.jpeg', price: 249.99),
  ];

  String _searchQuery = '';
  int _selectedIndex = 0;
  bool _isListening = false;
  String _listeningText = '';

  @override
  void initState() {
    super.initState();
    _initializeVoice();
  }

  Future<void> _initializeVoice() async {
    bool available = await _voiceService.initSpeech();
    print("Voice initialized: $available");
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) Navigator.pushNamed(context, '/cart');
    if (index == 2) Navigator.pushNamed(context, '/info');
  }

  void _showVoiceFeedback(String message) {
    setState(() => _listeningText = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _listeningText = '');
    });
  }

  void _handleIntent(String intent, String originalText) {
    final command = intent.toLowerCase();
    final lowerCaseText = originalText.toLowerCase();

    if (command == "add_to_cart") {
      Product? match;
      for (final product in _products) {
        if (lowerCaseText.contains(product.name.toLowerCase())) {
          match = product;
          break;
        }
      }
      if (match != null) {
        Provider.of<CartProvider>(context, listen: false).addToCart(match);
        _showVoiceFeedback('Casting “Add ${match.name} to cart” spell...');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${match.name} added to cart')));
      } else {
        _showVoiceFeedback('No magical item found in your command.');
      }
    } else if (command == "checkout") {
      _showVoiceFeedback('Teleporting to checkout...');
      Navigator.pushNamed(context, '/cart');

    } else if (command == "search_product") {
      String query = lowerCaseText.replaceAll(RegExp(r'search|find|look for'), '').trim();
      setState(() => _searchQuery = query);
      _showVoiceFeedback('Revealing results for "$query"...');

    } else if (command == "go_home" || command == "home") {
      setState(() => _searchQuery = '');
      _showVoiceFeedback('Returning to Home...');
    } else {
      _showVoiceFeedback("That incantation isn't recognized.");
    }
  }
  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: const Text('WizardCart', style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.amberAccent),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.purple.shade900.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Summon an item by name...',
                      hintStyle: TextStyle(color: Colors.purple.shade200.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.search, color: Colors.purple.shade200),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.purple.shade700, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade900.withOpacity(0.6), Colors.black.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.purple.shade800.withOpacity(0.8), width: 1.5),
                            boxShadow: [
                              BoxShadow(color: Colors.purple.shade900.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Hero(
                                      tag: product.name,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(product.image, fit: BoxFit.cover, width: double.infinity),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 2),
                                    child: Text(
                                      product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15, fontFamily: 'Cinzel'),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CartProvider>(context, listen: false).addToCart(product);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
                                            ),
                                            child: const Icon(Icons.add_shopping_cart, color: Colors.amber, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_listeningText.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amberAccent),
                ),
                child: Text(
                  _listeningText,
                  style: const TextStyle(color: Colors.amberAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            if (_isListening)
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.7),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            BoxShadow(
              color: Colors.purple.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: _isListening ? Colors.redAccent.shade100 : Colors.purple.shade800,
          child: const Icon(Icons.mic, color: Colors.white),
          onPressed: () {
            setState(() => _isListening = true);
            _voiceService.listen((intent, originalText) {
              _showVoiceFeedback("Heard: $originalText");
              _handleIntent(intent, originalText);
              _voiceService.stop();
              setState(() => _isListening = false);
            });
          },
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            selectedItemColor: Colors.amberAccent,
            unselectedItemColor: Colors.purple.shade200,
            backgroundColor: Colors.black.withOpacity(0.5),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
            ],
          ),
        ),
      ),
    );
  }
}