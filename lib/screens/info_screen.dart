import 'dart:ui'; // Needed for the backdrop filter
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<Map<String, String>> _defaultCommands = [
    {"command": "Add [Item Name]", "description": "Adds a product to your cart by name."},
    {"command": "Search for [Item]", "description": "Filters products by a keyword."},
    {"command": "Checkout / Open Cart", "description": "Navigates to the cart screen."},
    {"command": "Clear Search / Go Home", "description": "Clears the search and shows all items."},
    {"command": "Clear Cart", "description": "Removes all items from the cart."},
    {"command": "Remove [Item Name]", "description": "Removes a specific product from the cart."},
  ];

  final List<Map<String, String>> _customCommands = [];

  void _showAddCommandDialog() {
    final TextEditingController commandController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        // --- STYLED DIALOG ---
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.purple.shade900.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.purple.shade700),
            ),
            title: const Text("Create Your Own Spell", style: TextStyle(color: Colors.amberAccent, fontFamily: 'Cinzel')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: commandController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Incantation (Voice Command)",
                    labelStyle: TextStyle(color: Colors.purple.shade200),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Effect (Description)",
                    labelStyle: TextStyle(color: Colors.purple.shade200),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Bind Spell"),
                onPressed: () {
                  final command = commandController.text.trim();
                  final description = descriptionController.text.trim();
                  if (command.isNotEmpty && description.isNotEmpty) {
                    setState(() {
                      _customCommands.add({"command": command, "description": description});
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteCustomCommand(int index) {
    showDialog(
      context: context,
      builder: (context) {
        // --- STYLED DIALOG ---
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.purple.shade900.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.purple.shade700)),
            title: const Text("Break the Spell", style: TextStyle(color: Colors.white, fontFamily: 'Cinzel')),
            content: const Text("Are you sure you want to unbind this custom spell?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text("Unbind"),
                onPressed: () {
                  setState(() => _customCommands.removeAt(index));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.amberAccent,
          shadows: [Shadow(color: Colors.amberAccent, blurRadius: 5)],
        ),
      ),
    );
  }

  Widget _buildCommandCard(Map<String, String> cmd, bool isDeletable, int index) {
    // --- STYLED COMMAND CARD ---
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.purple.shade900.withOpacity(0.5), Colors.black.withOpacity(0.6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border.all(color: Colors.purple.shade800.withOpacity(0.8), width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Icon(Icons.auto_awesome, color: Colors.amberAccent.withOpacity(0.8)),
              title: Text(
                cmd["command"]!,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cinzel', fontSize: 16),
              ),
              subtitle: Text(cmd["description"]!, style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.4)),
              trailing: isDeletable
                  ? IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () => _deleteCustomCommand(index),
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: const Text("Voice Spellbook", style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold, fontSize: 24)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // --- MAGICAL BACKGROUND ---
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.purple.shade900.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // --- MAIN CONTENT ---
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                _buildSectionHeader("Known Incantations"),
                ..._defaultCommands.map((cmd) => _buildCommandCard(cmd, false, 0)),

                if (_customCommands.isNotEmpty)
                  _buildSectionHeader("Your Custom Spells"),
                ..._customCommands.asMap().entries.map((entry) => _buildCommandCard(entry.value, true, entry.key)),
              ],
            ),
          ),
        ],
      ),
      // --- STYLED "ADD NEW SPELL" BUTTON ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GestureDetector(
          onTap: _showAddCommandDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
              boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.black87),
                SizedBox(width: 12),
                Text(
                  "Add New Spell",
                  style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}