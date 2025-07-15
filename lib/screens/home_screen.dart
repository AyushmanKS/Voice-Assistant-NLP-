import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/voice_service.dart';
import '../providers/cart_provider.dart';

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
    if (index == 1) {
      Navigator.pushNamed(context, '/cart');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/info');
    }
  }

  void _showVoiceFeedback(String message) {
    setState(() => _listeningText = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _listeningText = '');
    });
  }

  void _handleVoiceCommand(String command) {
    command = command.toLowerCase().trim();

    if (command.contains("add")) {
      String itemName = command.replaceAll("add", "").replaceAll("to cart", "").trim();
      final match = _products.firstWhere(
            (p) => p.name.toLowerCase().contains(itemName),
        orElse: () => Product(name: '', image: '', price: 0),
      );

      if (match.name.isNotEmpty) {
        Provider.of<CartProvider>(context, listen: false).addToCart(match);
        _showVoiceFeedback('Casting “Add $itemName to cart” spell...');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${match.name} added to cart')));
      } else {
        _showVoiceFeedback('No magical item found for "$itemName".');
      }
    } else if (command.contains("checkout") || command.contains("check out")) {
      _showVoiceFeedback('Teleporting to checkout...');
      Navigator.pushNamed(context, '/cart');
    } else if (command.contains("search")) {
      String query = command.replaceAll("search", "").trim();
      setState(() => _searchQuery = query);
      _showVoiceFeedback('Revealing results for "$query"...');
    } else if (command.contains("go home") || command.contains("go back") || command == "home") {
      setState(() => _searchQuery = '');
      _showVoiceFeedback('Returning to Home...');
    } else {
      _showVoiceFeedback("That incantation isn't recognized.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F), // dark wizard theme
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        elevation: 4,
        title: const Text(
          'Wizard Cart',
          style: TextStyle(fontFamily: 'Cinzel', fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search magical items...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF2E2D3E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2D3E),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha :0.3),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Cinzel',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart, color: Colors.amberAccent),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).addToCart(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${product.name} added to cart')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_listeningText.isNotEmpty)
            Positioned(
              bottom: 90,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isListening ? Colors.redAccent : Colors.deepPurpleAccent,
        child: const Icon(Icons.mic),
        onPressed: () {
          setState(() => _isListening = true);
          _voiceService.listen((text) {
            _showVoiceFeedback("Heard: $text");
            _handleVoiceCommand(text);
            _voiceService.stop();
            setState(() => _isListening = false);
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF2E2D3E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
        ],
      ),
    );
  }
}
