import 'package:flutter/material.dart';
import 'package:sweet_chart/src/sweet_line.dart';
import 'package:sweet_chart/src/sweet_line_style.dart';

class SweetLineChart extends StatefulWidget {
  final List<SweetLine> lines;

  final LineChartStyle chartStyle;

  SweetLineChart({@required this.lines, this.chartStyle})
      : assert(lines != null && lines.length > 0);

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

  @override
  void initState() {
    super.initState();
    lines = widget.lines;
    chartStyle = widget.chartStyle ?? LineChartStyle();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 850));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
        });
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SweetLineChartPainter(lines, chartStyle, _animation.value),
    );
  }
}

class SweetLineChartPainter extends CustomPainter {
  List<SweetLine> lines;
  LineChartStyle chartStyle;
  double animationValue;

  SweetLineChartPainter(this.lines, this.chartStyle, this.animationValue);

  var maxXAxisValue;
  var minXAxisValue;
  var maxYAxisValue;
  var minYAxisValue;

  var pen = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    print("animationValue:$animationValue");
    //计算横纵坐标的最大值最小值
    _calculateValue();
    //绘制横纵坐标
    Size axisSize = _drawAxis(canvas, size);
    //绘制图表
    _drawChart(canvas, size, axisSize);
  }

  _calculateValue() {
    //计算横纵坐标的最大坐标和最小坐标
    maxXAxisValue = chartStyle.xEndValue ?? lines[0].maxXAxisValue;
    minXAxisValue = chartStyle.xStartValue ?? lines[0].minXAxisValue;
    maxYAxisValue = chartStyle.yEndValue ?? lines[0].maxYAxisValue;
    minYAxisValue = chartStyle.yStartValue ?? lines[0].minYAxisValue;
    lines.forEach((line) {
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
  }

  ///绘制坐标轴
  Size _drawAxis(Canvas canvas, Size size) {
    TextStyle yAxisTitleStyle = chartStyle.yAxisTitleStyle;
    TextStyle xAxisTitleStyle = chartStyle.xAxisTitleStyle;

    //——x轴总高度，包含文本宽度和本身的padding
    double xAxisHeight = chartStyle.showXAxis
        ? xAxisTitleStyle.fontSize + chartStyle.xAxisToTitleSpace
        : 0.0;

    num spaceY = (size.height - xAxisHeight) / (chartStyle.yAxisPieceCount - 1);
    num spaceYValue =
        (maxYAxisValue - minYAxisValue) / (chartStyle.yAxisPieceCount - 1);

    num yAxisWidth = 0.0;
    //画y轴文本
    if (chartStyle.showYAxis) {
      for (int i = 0; i < chartStyle.yAxisPieceCount; i++) {
        TextSpan span = new TextSpan(
            style: yAxisTitleStyle,
            text: "${(minYAxisValue + (spaceYValue * i)).toInt()}");
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        var y = size.height - xAxisHeight - (spaceY * i) - (tp.height / 2);
        if (i == 0) {
          y = y - (tp.height / 2);
        } else if (i == chartStyle.yAxisPieceCount - 1) {
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
    for (int i = 0; i < chartStyle.yAxisPieceCount; i++) {
      pen
        ..style = PaintingStyle.stroke
        ..color = Colors.black12
        ..strokeWidth = 0.5;
      var y = size.height - xAxisHeight - (spaceY * i);
      canvas.drawLine(Offset(yAxisWidth, y), Offset(size.width, y), pen);
    }

    num spaceXValue =
        (maxXAxisValue - minXAxisValue) / (chartStyle.xAxisPieceCount - 1);
    num spaceX = (size.width - yAxisWidth) / (chartStyle.xAxisPieceCount - 1);
    //画x轴标题
    if (chartStyle.showXAxis) {
      for (var i = 0; i < chartStyle.xAxisPieceCount; i++) {
        //画x轴文本
        TextSpan span = new TextSpan(
            style: xAxisTitleStyle,
            text: "${(minXAxisValue + (spaceXValue * i)).ceil()}");
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();

        var y = size.height - tp.height;
        //注意x轴如果是最后一个点需要再减去自身文本宽度
        var x;
        if (i == 0) {
          x = yAxisWidth + (spaceX * i);
        } else if (i == (chartStyle.xAxisPieceCount - 1)) {
          x = yAxisWidth + (spaceX * i) - tp.size.width;
        } else {
          x = yAxisWidth + (spaceX * i) - (tp.size.width / 2);
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
    var startY = size.height - axisSize.height; //总高度减去x轴高度
    var availableWidth = size.width - axisSize.width;
    var availableHeight = size.height - axisSize.height;
    var xPerValue = availableWidth / (maxXAxisValue - minXAxisValue);
    var yPerValue = availableHeight / (maxYAxisValue - minYAxisValue) ;
    for (var line in lines) {
      Path path = Path();
      Paint paint = Paint();
      paint.color = line.lineStyle.color;
      paint.strokeWidth = line.lineStyle.width;

      if (line.lineStyle.bodyType == LineBodyType.Fill) {
        paint.style = PaintingStyle.fill;
      } else {
        paint.style = PaintingStyle.stroke;
      }

      for (var i = 0; i < line.points.length; i++) {
        var point = line.points[i];
        var x = startX + ((point.xAxis - minXAxisValue) * xPerValue);
        var y = startY - (((point.yAxis - minYAxisValue) * yPerValue) * animationValue);
        if (i == 0) {
          if (line.lineStyle.bodyType == LineBodyType.Fill) {
            path.moveTo(x, startY);
            path.lineTo(x, y);
          } else {
            path.moveTo(x, y);
          }
        } else if (i == line.points.length - 1) {
          path.lineTo(x, y);
          if (line.lineStyle.bodyType == LineBodyType.Fill) {
            path.lineTo(x, startY);
          }
        } else {
          path.lineTo(x, y);
        }
      }
      if (line.lineStyle.bodyType == LineBodyType.Fill) {
        path.close();
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SweetLineChartPainter oldDelegate) {
    return oldDelegate != this ||
        oldDelegate.animationValue != this.animationValue;
  }
}
