import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sweet_chart/src/sweet_line.dart';
import 'package:sweet_chart/src/sweet_line_style.dart';
import 'package:sweet_chart/sweet_chart.dart';
import 'dart:ui' as ui;

class SweetLineChart extends StatefulWidget {
  final List<SweetLine> lines;

  final LineChartStyle chartStyle;
  final Map<int, String> xTitles;
  final Map<int, String> yTitles;

  SweetLineChart(
      {@required this.lines,
      @required this.xTitles,
      this.yTitles,
      this.chartStyle})
      : assert(lines != null && lines.length > 0,
            "lines must contains one element at least");

  @override
  State createState() {
    return SweetLineChartState();
  }
}

class SweetLineChartState extends State<SweetLineChart>
    with SingleTickerProviderStateMixin {
  List<SweetLine> lines;
  LineChartStyle chartStyle;
  AnimationController _controller;
  Animation<double> _animation;
  Offset tapPoint;

  @override
  void initState() {
    super.initState();
    lines = widget.lines;
    chartStyle = widget.chartStyle ?? LineChartStyle();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (tapDetail) {
        setState(() {
          tapPoint = tapDetail.localPosition;
        });
      },
      onHorizontalDragStart: (detail) {
        setState(() {
          tapPoint = detail.localPosition;
        });
      },
      onHorizontalDragUpdate: (detail) {
        setState(() {
          tapPoint = detail.localPosition;
        });
      },
      child: CustomPaint(
        painter: SweetLineChartPainter(lines, chartStyle, _animation.value,
            widget.xTitles, widget.yTitles, this.tapPoint),
      ),
    );
  }
}

class SweetLineChartPainter extends CustomPainter {
  List<SweetLine> lines;
  LineChartStyle chartStyle;
  double animationValue;
  Map<int, String> xTitles;
  Map<int, String> yTitles;
  Offset tapPoint;

  SweetLineChartPainter(this.lines, this.chartStyle, this.animationValue,
      this.xTitles, this.yTitles, this.tapPoint);

  var maxPointCount;
  var maxYAxisValue;
  var minYAxisValue;

  var pen = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    //计算横纵坐标的最大值最小值
    _calculateValue();
    //绘制横纵坐标
    Size axisSize = _drawAxis(canvas, size);
    //绘制图表
    _drawChart(canvas, size, axisSize);
  }

  _calculateValue() {
    //计算纵坐标的最大坐标和最小坐标
    maxPointCount = 0;
    maxYAxisValue = chartStyle.yEndValue ?? lines[0].maxYAxisValue;
    minYAxisValue = chartStyle.yStartValue ?? lines[0].minYAxisValue;
    lines.forEach((line) {
      if (line.maxYAxisValue > maxYAxisValue) {
        maxYAxisValue = line.maxYAxisValue;
      }
      if (line.minYAxisValue < minYAxisValue) {
        minYAxisValue = line.minYAxisValue;
      }
      var count = line.points.length;
      maxPointCount = maxPointCount > count ? maxPointCount : count;
    });
  }

  ///绘制坐标轴
  Size _drawAxis(Canvas canvas, Size size) {
    TextStyle yAxisTitleStyle = chartStyle.yAxisTitleStyle;
    TextStyle xAxisTitleStyle = chartStyle.xAxisTitleStyle;

    int yAxisPieceCount =
        chartStyle.yAxisPieceCount > 1 ? chartStyle.yAxisPieceCount : 2;

    //——x轴总高度，包含文本宽度和本身的padding
    double xAxisHeight = chartStyle.showXAxis
        ? xAxisTitleStyle.fontSize + chartStyle.xAxisToTitleSpace
        : 0.0;

    num spaceY = (size.height - xAxisHeight) / (yAxisPieceCount - 1);
    num spaceYValue = (maxYAxisValue - minYAxisValue) / (yAxisPieceCount - 1);

    num yAxisWidth = 0.0;
    //画y轴文本
    if (chartStyle.showYAxis) {
      for (int i = 0; i < yAxisPieceCount; i++) {
        var title;
        if (yTitles != null && yTitles.length > 0) {
          title = yTitles[i] ?? "";
        } else {
          title = "${(minYAxisValue + (spaceYValue * i)).toInt()}";
        }
        TextSpan span = new TextSpan(style: yAxisTitleStyle, text: title);
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        var y = size.height - xAxisHeight - (spaceY * i) - (tp.height / 2);
        if (i == 0) {
          y = y - (tp.height / 2);
        } else if (i == yAxisPieceCount - 1) {
          y = y + (tp.height / 2);
        }
        tp.paint(canvas, Offset(0, y));
        if (tp.size.width > yAxisWidth) {
          yAxisWidth = tp.size.width;
        }
      }
    }
    //|y轴总宽度，包含文本宽度和本身的padding
    yAxisWidth += chartStyle.showYAxis ? chartStyle.yAxisToTitleSpace : 0.0;
    //画x轴横线
    for (int i = 0; i < yAxisPieceCount; i++) {
      pen
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeWidth = 0.5;
      var y = size.height - xAxisHeight - (spaceY * i);
      canvas.drawLine(Offset(yAxisWidth, y), Offset(size.width, y), pen);
    }

    var aliStartEnd = chartStyle.aliment == LineAliment.StartEnd;
    var xPiece = aliStartEnd ? maxPointCount - 1 : maxPointCount;
    num spaceX = (size.width - yAxisWidth) / (xPiece);
    //画x轴标题
    if (chartStyle.showXAxis && xTitles != null && xTitles.length > 0) {
      for (var i = 0; i < maxPointCount; i++) {
        //画x轴文本
        var title = xTitles[i] ?? "";
        TextSpan span = new TextSpan(style: xAxisTitleStyle, text: title);
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();

        var y = size.height - tp.height;
        //注意x轴如果是最后一个点需要再减去自身文本宽度

        var x = yAxisWidth + (spaceX * i) - (tp.size.width / 2);
        if (aliStartEnd && i == 0) {
          x = yAxisWidth + (spaceX * i);
        }
        if (aliStartEnd && i == (maxPointCount - 1)) {
          x = yAxisWidth + (spaceX * i) - tp.size.width;
        }
        tp.paint(canvas, Offset(x, y));
      }
    }
    //返回x轴高度和y轴占用的宽度，用于画图表内容时，获取正确的面积
    return Size(yAxisWidth, xAxisHeight);
  }

  ///绘制数据
  void _drawChart(Canvas canvas, Size size, Size axisSize) {
    //画折线图上的点
    var startX = axisSize.width; //y轴的宽度
    var startY = size.height - axisSize.height; //totalHeight - axis height
    var availableWidth = size.width - axisSize.width;
    var availableHeight = size.height - axisSize.height;
    var xPerValue = availableWidth / (maxPointCount - 1);
    var yPerValue = availableHeight / (maxYAxisValue - minYAxisValue);

    for (var line in lines) {
      Path path = Path();
      Paint paint = Paint();
      paint.color = line.style.color;
      paint.strokeWidth = line.style.width;
      paint.style = PaintingStyle.stroke;

      //calculate all point
      List<Offset> points = [];
      for (int i = 0; i < line.points.length; i++) {
        var point = line.points[i];
        var x = startX + (i * xPerValue);
        var y = startY -
            (((point.value - minYAxisValue) * yPerValue) * animationValue);
        points.add(Offset(x, y));
      }

      path.moveTo(points[0].dx, points[0].dy);
      if (line.style.type == LineType.Curve) {
        _makeCurveLine(points, path, canvas);
      }
      if (line.style.type == LineType.Straight) {
        _makeStraightLine(points, path, canvas);
      }
      canvas.drawPath(path, paint);

      // draw point
      if (line.style.showPoint) {
        _drawPoint(points, line, canvas);
      }

      // draw line gradient shape
      if (line.style.fillColor != null) {
        path.lineTo(points.last.dx, startY);
        path.lineTo(points.first.dx, startY);
        path.close();
        Paint bodyPaint = Paint();
        var gradientTop = availableHeight - line.minYAxisValue * yPerValue;
        bodyPaint.shader = ui.Gradient.linear(
            Offset(0.0, gradientTop), Offset(0.0, size.height), [
          line.style.fillColor.startColor,
          line.style.fillColor.endColor,
        ]);
        canvas.drawPath(path, bodyPaint);
      }
      if (line.style.showPopTips) {
        var pointIndex = getTouchPoint(points);
        if (pointIndex != -1) {
          _drawTips(
              points[pointIndex], line.points[pointIndex], line, canvas, size);
        }
      }
    }
  }

  int getTouchPoint(List<Offset> points) {
    var touchArea = 10;

    for (var i = 0; i < points.length; i++) {
      var offset = points[i];
      //判断是否在点击区域中
      if (tapPoint.dx > offset.dx - touchArea &&
          tapPoint.dx < offset.dx + touchArea) {
        return i;
      }
    }
    return -1;
  }

  _drawPoint(List<Offset> points, SweetLine line, Canvas canvas) {
    var pointPaint = Paint();
    points.forEach((p) {
      pointPaint.style = PaintingStyle.fill;
      pointPaint.color = line.style.pointStyle.color ?? line.style.color;
      canvas.drawCircle(p, line.style.pointStyle.size, pointPaint);
      if (line.style.pointStyle.borderWidth > 0) {
        pointPaint.style = PaintingStyle.stroke;
        pointPaint.color =
            line.style.pointStyle.borderColor ?? line.style.color;
        pointPaint.strokeWidth = line.style.pointStyle.borderWidth;
        var size =
            line.style.pointStyle.size + line.style.pointStyle.borderWidth / 2;
        canvas.drawCircle(p, size, pointPaint);
      }
    });
  }

  _drawTips(Offset offset, SweetPoint point, SweetLine line, Canvas canvas,
      Size size) {
    var triangleSize = 8;
    TextSpan span = new TextSpan(
        style: line.style.popTipStyle.titleStyle, text: point.title ?? "");
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();

    TextSpan subSpan = new TextSpan(
        style: line.style.popTipStyle.subTitleStyle,
        text: point.subTitle ?? "");
    TextPainter subTp = new TextPainter(
        text: subSpan,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    subTp.layout();

    double width = (tp.width > subTp.width ? tp.width : subTp.width) +
        (line.style.popTipStyle.padding * 2);
    double height = tp.height +
        subTp.height +
        line.style.popTipStyle.padding * 2 +
        line.style.popTipStyle.lineSpace;
    double left, top, right, bottom;

    if (offset.dx < width / 2) {
      left = 0;
      right = 0 + width;
    } else if ((size.width - offset.dx) < width / 2) {
      right = width;
      left = size.width - width;
    } else {
      left = offset.dx - width / 2;
      right = offset.dx + width / 2;
    }

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = line.style.popTipStyle.color ?? line.style.color;
    //弹出框向上
    if (offset.dy >
        (height + triangleSize + line.style.popTipStyle.pointToTipSpace)) {
      top = offset.dy -
          line.style.popTipStyle.pointToTipSpace -
          triangleSize -
          height;
      bottom = top + height;
      //draw triangle
      Path p = Path();
      p.moveTo(offset.dx, offset.dy - line.style.popTipStyle.pointToTipSpace);
      p.lineTo(offset.dx - triangleSize / 2, bottom);
      p.lineTo(offset.dx + triangleSize / 2, bottom);
      p.close();
      canvas.drawPath(p, paint);
    } else {
      //弹出框向下
      top = offset.dy + line.style.popTipStyle.pointToTipSpace + triangleSize;
      bottom = top + height;
      //draw triangle
      Path p = Path();
      p.moveTo(offset.dx, offset.dy + line.style.popTipStyle.pointToTipSpace);
      p.lineTo(offset.dx - triangleSize / 2, top);
      p.lineTo(offset.dx + triangleSize / 2, top);
      p.close();
      canvas.drawPath(p, paint);
    }

    var radius = Radius.circular(line.style.popTipStyle.radius);
    var rect = RRect.fromLTRBAndCorners(left, top, right, bottom,
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius);
    canvas.drawRRect(rect, paint);
    tp.paint(canvas,
        Offset(offset.dx - tp.width / 2, top + line.style.popTipStyle.padding));
    subTp.paint(
        canvas,
        Offset(
            offset.dx - subTp.width / 2,
            top +
                line.style.popTipStyle.padding +
                tp.height +
                line.style.popTipStyle.lineSpace));
  }

  _makeStraightLine(List<Offset> points, Path path, Canvas canvas) {
    points.forEach((p) {
      path.lineTo(p.dx, p.dy);
    });
  }

  _makeCurveLine(List<Offset> points, Path path, Canvas canvas) {
    var scale = 0.1;
    //draw bezier curve
    //control points A B
    points.asMap().forEach((index, p) {
      if (index >= points.length - 1) {
        return;
      }
      var preIndex = index == 0 ? 0 : index - 1;
      var ax = p.dx + scale * (points[index + 1].dx - points[preIndex].dx);
      var ay = p.dy + scale * (points[index + 1].dy - points[preIndex].dy);
      var nexIndex = index == (points.length - 2) ? index + 1 : index + 2;
      var bx = points[index + 1].dx - scale * (points[nexIndex].dx - p.dx);
      var by = points[index + 1].dy - scale * (points[nexIndex].dy - p.dy);
      path.cubicTo(ax, ay, bx, by, points[index + 1].dx, points[index + 1].dy);
    });
  }

  @override
  bool shouldRepaint(SweetLineChartPainter oldDelegate) {
    return oldDelegate != this ||
        oldDelegate.animationValue != this.animationValue ||
        oldDelegate.tapPoint != this.tapPoint;
  }
}
