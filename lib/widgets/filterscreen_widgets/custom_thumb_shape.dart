import 'package:flutter/material.dart';

class CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double innerThumbRadius;

  CustomThumbShape({
    this.thumbRadius = 12.0,
    this.innerThumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Tween<double> radiusTween = Tween<double>(
      begin: innerThumbRadius,
      end: thumbRadius,
    );

    final Tween<double> fillOpacityTween = Tween<double>(
      begin: 1.0,
      end: 0.6,
    );

    final double radius = radiusTween.evaluate(activationAnimation);
    final double fillOpacity = fillOpacityTween.evaluate(activationAnimation);

    final Paint fillPaint = Paint()
      ..color = Colors.white.withOpacity(fillOpacity)
      ..style = PaintingStyle.fill;

    final Paint outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    context.canvas.drawCircle(center, radius, fillPaint);
    context.canvas.drawCircle(center, thumbRadius, outlinePaint);
  }
}
