import 'package:flutter/material.dart';
import 'package:sweet_chart/src/sweet_line.dart';
import 'package:sweet_chart/src/sweet_line_style.dart';

class SweetLineChart extends StatelessWidget {
  //默认横纵坐标的指标个数
  static const int defaultAxisPointCount = 5;

  //Y轴与文本之间的距离
  static const int yAxisToTitleSpace = 8;

  //X轴与文本之间的距离
  static const int xAxisToTitleSpace = 8;

  //y轴文本文本的自身padding值
  static const int yAxisTitleInsetPadding = 2;

  final List<SweetLine> lines;
  final TextStyle xAxisTitleStyle;
  final TextStyle yAxisTitleStyle;
  final bool showXAxisTitle;
  final bool showYAxisTitle;
  final int xAxisPointCount;
  final int yAxisPointCount;
  final num xStartValue;
  final num xEndValue;
  final num yStartValue;
  final num yEndValue;

  SweetLineChart(
      {this.lines,
      this.xAxisTitleStyle,
      this.yAxisTitleStyle,
      this.showXAxisTitle,
      this.showYAxisTitle,
      this.xAxisPointCount = SweetLineChart.defaultAxisPointCount,
      this.yAxisPointCount = SweetLineChart.defaultAxisPointCount,
      this.xStartValue,
      this.xEndValue,
      this.yStartValue,
      this.yEndValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SweetLineChartPainter(this),
    );
  }
}

class SweetLineChartPainter extends CustomPainter {
  SweetLineChart widget;

  SweetLineChartPainter(this.widget);

  var pen = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
  }

  ///绘制坐标轴
  void _drawAxis(Canvas canvas, Size size) {
    //计算横纵坐标的最大坐标和最小坐标
    var maxXAxisValue = widget.xEndValue ?? widget.lines[0].maxXAxisValue;
    var minXAxisValue = widget.xStartValue ?? widget.lines[0].minXAxisValue;
    var maxYAxisValue = widget.yEndValue ?? widget.lines[0].maxYAxisValue;
    var minYAxisValue = widget.yStartValue ?? widget.lines[0].minYAxisValue;
    widget.lines.forEach((line) {
      if (line.maxXAxisValue > maxXAxisValue) {
        maxXAxisValue = line.maxXAxisValue;
      }
      if (line.minXAxisValue < minXAxisValue) {
        minXAxisValue = line.minXAxisValue;
      }
      if (line.maxYAxisValue > maxYAxisValue) {
        maxYAxisValue = line.maxYAxisValue;
      }
      if (line.minYAxisValue < minYAxisValue) {
        minYAxisValue = line.minYAxisValue;
      }
    });

    TextStyle yAxisTitleStyle =
        widget.yAxisTitleStyle ?? AxisStyle.defaultAxisTitleStyle;
    TextStyle xAxisTitleStyle =
        widget.xAxisTitleStyle ?? AxisStyle.defaultAxisTitleStyle;

    //y轴总宽度，包含文本宽度和本身的padding
    var xAxisHeight =
        xAxisTitleStyle.fontSize + SweetLineChart.xAxisToTitleSpace;

    num spaceY = (size.height - xAxisHeight) / (widget.yAxisPointCount - 1);
    num spaceYValue =
        (maxYAxisValue - minYAxisValue) / (widget.yAxisPointCount - 1);
    num yAxisTitleWidth = 0;

    //画y轴文本
    for (int i = 0; i < widget.yAxisPointCount; i++) {
      TextSpan span = new TextSpan(
          style: yAxisTitleStyle,
          text: "${(minYAxisValue + (spaceYValue * i)).toInt()}");
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      var y = size.height -
          xAxisHeight -
          (spaceY * i) -
          SweetLineChart.yAxisTitleInsetPadding;
      tp.paint(canvas, Offset(0, y));
      if (tp.size.width > yAxisTitleWidth) {
        yAxisTitleWidth = tp.size.width;
      }
    }

    //y轴总宽度，包含文本宽度和本身的padding
    var yAxisWidth = yAxisTitleWidth + SweetLineChart.yAxisToTitleSpace;

    //画x轴横线
    for (int i = 0; i < widget.yAxisPointCount; i++) {
      pen
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeWidth = 0.5;

      var y = size.height - xAxisHeight - (spaceY * i);

      canvas.drawLine(Offset(yAxisWidth, y), Offset(size.width, y), pen);
    }

    num spaceXValue = (maxXAxisValue - minXAxisValue) / widget.xAxisPointCount;
    num spaceX = (size.width - yAxisWidth) / widget.yAxisPointCount;
    //画x轴标题
    for (var i = 0; i < widget.xAxisPointCount; i++) {
      //画x轴文本
      TextSpan span = new TextSpan(
          style: xAxisTitleStyle,
          text: "${(minXAxisValue + (spaceXValue * i)).toInt()}");
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          Offset(yAxisWidth + (spaceX / 2) - (tp.width / 2) + (spaceX * i),
              size.height - tp.height));
    }
    //画折线图上的点
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
