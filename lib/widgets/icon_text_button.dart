import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? deleteButton;
  final double height;
  final double width;
  final bool canDeleted;

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
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Fondo blanco (superficie), pero controla el foreground para que contraste
            backgroundColor: APP_SURFACE_COLOR,
            foregroundColor: colorScheme.primary, // asegura que icon/text sean visibles
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0.3,
          ),
          onPressed: onTap,
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Forzar color del icono usando colorScheme.primary
                Icon(icon, size: 45, color: colorScheme.primary),
                const SizedBox(height: 10),
                Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.primary, // asegura contraste
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // Botón de eliminar en la esquina
        Visibility(
          visible: canDeleted,
          child: Positioned(
            top: -1,
            right: -1,
            child: ElevatedButton(
              onPressed: deleteButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: APP_SURFACE_COLOR,
                foregroundColor: APP_PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 40),
                alignment: Alignment.center,
                elevation: 0.3,
              ),
              child: const Icon(Icons.close, size: 18, color: APP_PRIMARY_COLOR),
            ),
          ),
        ),
      ],
    );
  }
}