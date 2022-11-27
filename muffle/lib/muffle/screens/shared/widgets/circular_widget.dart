import 'package:flutter/material.dart';

import '../models/models.dart';

class CircleWidget extends StatelessWidget {
  final Widget child;
  final double radius;
  final bool hasBorder;
  final Color backgroundColor;

  const CircleWidget({
    Key? key,
    required this.child,
    this.radius = ProfileImageSize.medium,
    this.hasBorder = false,
    this.backgroundColor = Colors.white30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasBorder
          ? ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).hintColor,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
              ),
            )
          : null,
      child: CircleAvatar(
        minRadius: radius - 10,
        maxRadius: radius,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}
