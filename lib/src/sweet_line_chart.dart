import 'package:flutter/material.dart';
import 'package:sweet_chart/src/sweet_data.dart';


class SweetLineChart extends StatelessWidget {
  final List<SweetData> dataList;

  SweetLineChart(this.dataList);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SweetLineChartPainter(),
    );
  }
}

class SweetLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.green;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
