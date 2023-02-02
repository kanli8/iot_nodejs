import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({
    Key? key,
    required this.icon,
    required this.text,
  }):super(key:key );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15.0,
          color: Colors.orange,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
