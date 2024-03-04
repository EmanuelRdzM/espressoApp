import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final VoidCallback? onTap;
  final double height;
  final double width; 

  const IconTextButton({
    super.key, 
    required this.labelText, 
    required this.icon,
    required this.onTap,
    this.height = 120.0,
    this.width = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(labelText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      onPressed: () {
        onTap!();
      },
    );
  }
}