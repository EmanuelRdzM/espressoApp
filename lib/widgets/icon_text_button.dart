import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? deleteButton;
  final double height;
  final double width; 
  final bool canDeleted ;

  const IconTextButton({
    super.key, 
    required this.labelText, 
    required this.icon,
    required this.onTap,
    this.deleteButton,
    this.height = 120.0,
    this.width = 120.0,
    this.canDeleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            disabledForegroundColor: Colors.amber,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0.3,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 45),
                const SizedBox(height: 10),
                Text(labelText, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              ],
            ),
          ),
          onPressed: () {
            onTap!();
          },
        ),
        Visibility(
          visible: canDeleted,
          child: Positioned(
            top: -1,
            right: -1,
            child: ElevatedButton(
              onPressed: () {
                deleteButton!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 50),
                alignment: Alignment.center,
                
              ),
              child: const Icon(Icons.close, color: Colors.pink),
            )
          ),
        )
      ],
    );
  }
}