// widgets/lightning_icon.dart
import 'package:flutter/material.dart';

class LightningIcon extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const LightningIcon({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: animation!,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.flash_on,
            size: 100,
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
