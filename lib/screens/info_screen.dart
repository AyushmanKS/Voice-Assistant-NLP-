import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<Map<String, String>> _defaultCommands = [
    {
      "command": "Add iPhone to cart",
      "description": "Adds a product to your cart by name.",
    },
    {
      "command": "Search MacBook",
      "description": "Filters products by the word 'MacBook'.",
    },
    {
      "command": "Checkout",
      "description": "Opens the cart screen to review and purchase.",
    },
    {
      "command": "Clear search",
      "description": "Clears the current search query.",
    },
    {"command": "Open cart", "description": "Navigates to the cart screen."},
    {
      "command": "Go home",
      "description": "Returns to the home screen with all products.",
    },
    {
      "command": "Clear cart",
      "description": "Removes all items from the cart.",
    },
    {
      "command": "Clear iPhone",
      "description": "Removes a specific product from the cart.",
    },
  ];

  final List<Map<String, String>> _customCommands = [];

  void _showAddCommandDialog() {
    final TextEditingController commandController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E2D3E),
        title: const Text("Create Your Own Spell", style: TextStyle(color: Colors.amberAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commandController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Voice Command",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.white70),
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
            child: const Text("Add"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () {
              final command = commandController.text.trim();
              final description = descriptionController.text.trim();
              if (command.isNotEmpty && description.isNotEmpty) {
                setState(() {
                  _customCommands.add({
                    "command": command,
                    "description": description,
                  });
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _deleteCustomCommand(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E2D3E),
        title: const Text("Delete Spell", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this command?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Delete"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                _customCommands.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommandCard(Map<String, String> cmd, bool isDeletable, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3D50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        leading: const Icon(Icons.mic, color: Colors.amberAccent),
        title: Text(
          cmd["command"]!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cinzel',
          ),
        ),
        subtitle: Text(
          cmd["description"]!,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: isDeletable
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _deleteCustomCommand(index),
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCommands = [
      ..._defaultCommands.map((cmd) => _buildCommandCard(cmd, false, 0)),
      ..._customCommands.asMap().entries.map(
            (entry) => _buildCommandCard(entry.value, true, entry.key),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2F),
      appBar: AppBar(
        title: const Text('Voice Spellbook'),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Use magical voice spells to control the app effortlessly. Here are some known incantations:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Cinzel',
            ),
          ),
          const SizedBox(height: 20),
          ...allCommands,
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: _showAddCommandDialog,
          icon: const Icon(Icons.add),
          label: const Text("Add New Spell"),
        ),
      ),
    );
  }
}
