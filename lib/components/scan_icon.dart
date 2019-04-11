import 'dart:math';
import 'package:flutter/material.dart';

class ScanIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double _distribution = 32;
    double _unit = min(size.width, size.height) / _distribution;
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.white;
    paint.strokeWidth = _unit;
    Offset center = Offset(_unit * 16, _unit * 16);
    canvas.drawCircle(center, _unit * 15, paint);

    Rect rect = Rect.fromCircle(center: center, radius: _unit * 8);
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(2.0));
    canvas.drawRRect(rRect, paint);

    Path scanPath = Path();
    scanPath.moveTo(_unit * 10, _unit * 16);
    scanPath.relativeLineTo(_unit * 12, 0);
    canvas.drawPath(scanPath, paint);

    Path lockOnUpLeftPath = Path();
    lockOnUpLeftPath.moveTo(_unit * 10, _unit * 12);
    lockOnUpLeftPath.relativeLineTo(0, -_unit * 2);
    lockOnUpLeftPath.relativeConicTo(
      0,
      -_unit * 0.1,
      _unit * 0.1,
      0,
      _unit * 0.1,
    );
    lockOnUpLeftPath.relativeLineTo(_unit * 2, 0);
    canvas.drawPath(lockOnUpLeftPath, paint);

    Path lockOnUpRightPath = Path();
    lockOnUpRightPath.moveTo(_unit * 22, _unit * 12);
    lockOnUpRightPath.relativeLineTo(0, -_unit * 2);
    lockOnUpRightPath.relativeConicTo(
      0,
      -_unit * 0.1,
      -_unit * 0.1,
      0,
      _unit * 0.1,
    );
    lockOnUpRightPath.relativeLineTo(-_unit * 2, 0);
    canvas.drawPath(lockOnUpRightPath, paint);

    Path lockOnDownLeftPath = Path();
    lockOnDownLeftPath.moveTo(_unit * 10, _unit * 20);
    lockOnDownLeftPath.relativeLineTo(0, _unit * 2);
    lockOnDownLeftPath.relativeConicTo(
      0,
      _unit * 0.1,
      _unit * 0.1,
      0,
      _unit * 0.1,
    );
    lockOnDownLeftPath.relativeLineTo(_unit * 2, 0);
    canvas.drawPath(lockOnDownLeftPath, paint);

    Path lockOnDownRightPath = Path();
    lockOnDownRightPath.moveTo(_unit * 22, _unit * 20);
    lockOnDownRightPath.relativeLineTo(0, _unit * 2);
    lockOnDownRightPath.relativeConicTo(
      0,
      _unit * 0.1,
      -_unit * 0.1,
      0,
      _unit * 0.1,
    );
    lockOnDownRightPath.relativeLineTo(-_unit * 2, 0);
    canvas.drawPath(lockOnDownRightPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
