import 'package:flutter/material.dart';

class IconProgressInidcator extends StatefulWidget {
  const IconProgressInidcator({super.key});

  @override
  _IconProgressInidcatorState createState() => _IconProgressInidcatorState();
}

class _IconProgressInidcatorState extends State<IconProgressInidcator>
    with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    int _currentIconIndex = 0;

    final List<String> _iconPaths = [
      'assets/favicons/burguer-icon.png',
      'assets/favicons/cheescake-icon.png',
      'assets/favicons/egg-icon.png',
      'assets/favicons/fried-icon.png',
      'assets/favicons/fideos-icon.png',
      'assets/favicons/sandwich-icon.png',
    ];
    

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat();
    //_controller.repeat(reverse: true);
    _controller.addListener(_updateIconIndex);
  }

  void _updateIconIndex(){
    setState(() {
      _currentIconIndex = (_controller.value * _iconPaths.length).floor();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Image.asset(
              _iconPaths[_currentIconIndex],
              width: 50,
              height: 50,
            );
          },
        ),
        const SizedBox(height: 10),

        const Text(
          'Cargando',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),

        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            int count = (_controller.value * 3).floor() + 1;
            return Text('.' * count, style: const TextStyle(fontSize: 16));
          },
        ),
      ],
    );
  }
}