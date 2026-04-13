import 'dart:math';
import 'package:flutter/material.dart';

class ScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final double strokeWidth;

  const ScoreRing({
    super.key,
    required this.score,
    this.size = 120,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ScoreRingPainter(
          score: score / 100,
          backgroundColor: colors.surfaceContainerHighest,
          foregroundColor: _getColor(colors),
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.round().toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getColor(colors),
                    ),
              ),
              Text(
                '分',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(ColorScheme colors) {
    if (score >= 80) return colors.primary;
    if (score >= 60) return colors.tertiary;
    return colors.error;
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double score;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.score,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * score,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.score != score;
}
