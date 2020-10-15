import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home_humidity/utils.dart';

class HumidityControllerPainter extends CustomPainter {
  final double currentHumidity, currentTemperature;
  final Offset tapPosition;
  final Offset dragePosition;
  final Function(bool shouldDraw) onShouldDraw;
  final int currentCelsius;
  final bool validPressed;
  HumidityControllerPainter(
      {this.currentCelsius,
      this.currentTemperature,
      this.currentHumidity,
      @required this.tapPosition,
      @required this.dragePosition,
      @required this.validPressed,
      @required this.onShouldDraw});
  @override
  void paint(Canvas canvas, Size size) {
    final centerPoint = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 5.0;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.red[800],
        Colors.red[600],
        Colors.purple,
        Colors.purple,
        Colors.blue[600],
        Colors.blue[800],
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    var wavePoint = Utils.valueBetween(
        dragePosition.dy, size.height * 0.1, size.height * 0.9);

    var selectedPercent =
        (100 - (100 * (wavePoint - (size.height * 0.1))) / (size.height * 0.8))
            .toInt();

    double demoWavePoint = (size.height * 0.1) +
        (((size.height * 0.8) * (100 - currentHumidity)) / 100);

    selectedPercent = currentHumidity.toInt();
    wavePoint = demoWavePoint;
    // print("-         dragePosition.dy ${dragePosition.dy}");
    // print("--          wavePoint: $wavePoint");
    // print("---           selectedPercent: $selectedPercent");
    // print("----            demoWavePoint: $demoWavePoint");

    final gradientRect = Rect.fromCenter(
        center: centerPoint, height: size.height, width: size.width);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(gradientRect);
    final controllOffset = Offset(size.width * 0.44, wavePoint);
    final rect = Rect.fromCircle(center: controllOffset, radius: 25);
    double controllRadius;
    if (rect.contains(tapPosition) || validPressed) {
      controllRadius = 30;
      onShouldDraw(true);
    } else {
      controllRadius = 25;
      onShouldDraw(false);
    }
    final path = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.4, wavePoint - 65)
      ..quadraticBezierTo(
          size.width * 0.4, wavePoint - 45, size.width * (0.35), wavePoint - 25)
      ..quadraticBezierTo(
          size.width * 0.29, wavePoint, size.width * 0.35, wavePoint + 25)
      ..quadraticBezierTo(
          size.width * 0.4, wavePoint + 45, size.width * 0.4, wavePoint + 75)
      ..lineTo(size.width * 0.4, size.height);

    final path2 = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.4, wavePoint - 65)
      ..quadraticBezierTo(
          size.width * 0.4, wavePoint - 45, size.width * (0.35), wavePoint - 25)
      ..quadraticBezierTo(
          size.width * 0.29, wavePoint, size.width * 0.35, wavePoint + 25)
      ..quadraticBezierTo(
          size.width * 0.4, wavePoint + 45, size.width * 0.4, wavePoint + 75)
      ..lineTo(size.width * 0.4, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    paint
      ..color = paint.color.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path2, paint);
    paint
      ..color = paint.color.withOpacity(1)
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    canvas.drawCircle(
        controllOffset, controllRadius, paint..style = PaintingStyle.fill);
    final pathMetric = path.computeMetrics().first;
    final n = 70;
    final spaceBetweenLine = pathMetric.length / n;
    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.white;
    for (var i = 0; i < n; i++) {
      final startPosition =
          pathMetric.getTangentForOffset(spaceBetweenLine * i).position -
              Offset(10, 0);
      final endPosition = startPosition -
          Offset(i % 4 == 0 ? size.width * 0.09 : size.width * 0.08, 0);
      canvas.drawLine(startPosition, endPosition, linePaint);
    }

    final labelStyle = ui.TextStyle(color: Colors.white, fontSize: 15);
    final labelValueStyle = ui.TextStyle(
        color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold);
    final returnTempLable =
        Utils.generateParagraph("Temperature", style: labelStyle);
    final labelHumidity =
        Utils.generateParagraph("Humidity", style: labelStyle);
    final tempLabelValue = Utils.generateParagraph(
        "${currentTemperature.toStringAsFixed(1)}℃",
        style: labelValueStyle);
    final selectedLabelValue = Utils.generateParagraph(
        "${currentHumidity.toStringAsFixed(1)}%",
        style: labelValueStyle);

    canvas.drawParagraph(
        returnTempLable, Offset(controllOffset.dx + 40, size.height * 0.3));
    canvas.drawParagraph(
        tempLabelValue, Offset(controllOffset.dx + 40, size.height * 0.33));
    canvas.drawParagraph(
        labelHumidity, Offset(controllOffset.dx + 40, size.height * 0.5));
    canvas.drawParagraph(
        selectedLabelValue,
        Offset(controllOffset.dx + 40,
            (size.height * 0.57) - selectedLabelValue.height / 2));

    final currentSelectedLabelPercent = Utils.generateParagraph(
        "$selectedPercent%",
        style: ui.TextStyle(
            color: Colors.blueAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold));
    canvas.drawParagraph(currentSelectedLabelPercent,
        Offset(10, wavePoint - currentSelectedLabelPercent.height / 2));

    final labelCount = 10;
    final spaceBetweenLabel = size.height * 0.8 / labelCount;
    int startValue = 10;
    for (var i = 0; i <= labelCount; i++) {
      final labelPercent = 10 * startValue--;
      final textStyle = ui.TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
      final label = Utils.generateParagraph("$labelPercent%", style: textStyle);

      // Gạch
      if (labelPercent - 5 >= selectedPercent ||
          labelPercent < selectedPercent - 5) {
        canvas.drawParagraph(
            label,
            Offset(
                10,
                spaceBetweenLabel * i +
                    (size.height * 0.1) -
                    label.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(HumidityControllerPainter oldDelegate) {
    return true;
  }
}
