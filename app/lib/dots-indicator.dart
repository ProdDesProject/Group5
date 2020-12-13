import 'dart:math';

import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.color,
    this.selectedColor,
    this.dotSize: 7.0,
  }) : super(listenable: controller);

  // The PageController that this DotsIndicator is representing.
  final PageController controller;

  // The number of items managed by the PageController
  final int itemCount;

  // The color of the dots.
  final Color color;

  // The color of the selected dot (current page).
  final Color selectedColor;

  // The base size of the dots
  final double dotSize;

  // The distance between the center of each dot
  static const double _dotSpacing = 18.0;

  Widget _buildDot(int index) {
    Color currentColor = color;
    if (controller.page == null && index == 0) {
      currentColor = selectedColor;
    } else if (controller.page == index) {
      currentColor = selectedColor;
    }

    return Container(
      width: _dotSpacing,
      child: Center(
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color:  currentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}