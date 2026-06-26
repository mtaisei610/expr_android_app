import 'package:flutter/material.dart';

class EggSelectorButton extends StatelessWidget {
  final String label;
  final int minutes;
  final VoidCallback onPressed;

  const EggSelectorButton({
    super.key,
    required this.label,
    required this.minutes,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.egg_alt, size: 48, color: Colors.orangeAccent),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}