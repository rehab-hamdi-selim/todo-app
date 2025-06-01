import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.function,
    required this.color,
  });

  final IconData icon;
  final Function function;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        function();
      },
      icon: Icon(icon),
      color: color,
    );
  }
}
