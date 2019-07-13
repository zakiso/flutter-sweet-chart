import 'dart:ui';
import 'package:flutter/material.dart';

enum LineAliment { StartEnd, Center }

class LineChartStyle {
  //默认横纵坐标的指标个数
  static const int defaultAxisPieceCount = 5;

  //轴与文本之间的距离
  static const int defaultAxisToTitleSpace = 8;

  //y轴文本文本的自身padding值
  static const int yAxisTitleInsetPadding = 2;

  //x轴颜色
  Color xAxisColor;

  //x轴线粗细
  num xAxisHeight;

  //x轴标题对齐方式
  LineAliment aliment;

  //x轴文本样式
  TextStyle xAxisTitleStyle;

  //y轴颜色
  Color yAxisColor;

  //y轴线粗细
  num yAxisWidth;

  //y轴文本样式
  TextStyle yAxisTitleStyle;

  //是否显示x轴
  bool showXAxis;

  //是否显示y轴
  bool showYAxis;

  //y轴数据分多少格
  int yAxisPieceCount;

  //x轴数据起始值大小，不设置默认取 数据源中最小值
  num xStartValue;

  //x轴数据结束值大小，不设置默认取 数据源中最大值
  num xEndValue;

  //x轴数据起始值大小，不设置默认取 数据源中最小值
  num yStartValue;

  //x轴数据结束值大小，不设置默认取 数据源中最大值
  num yEndValue;

  num xAxisToTitleSpace;
  num yAxisToTitleSpace;

  LineChartStyle({
    this.xAxisColor,
    this.xAxisHeight,
    this.xAxisTitleStyle,
    this.xAxisToTitleSpace = defaultAxisToTitleSpace,
    this.yAxisColor,
    this.yAxisWidth,
    this.yAxisTitleStyle,
    this.yAxisToTitleSpace = defaultAxisToTitleSpace,
    this.showXAxis = true,
    this.showYAxis = true,
    this.yAxisPieceCount = defaultAxisPieceCount,
    this.xStartValue,
    this.xEndValue,
    this.yStartValue,
    this.yEndValue,
    this.aliment,
  }) : assert(yAxisPieceCount > 1) {
    xAxisColor = xAxisColor ?? Colors.grey[300];
    xAxisHeight = xAxisHeight ?? 1;
    xAxisTitleStyle = xAxisTitleStyle ??
        TextStyle(
          color: Colors.grey,
          decoration: TextDecoration.none,
          fontSize: 16,
        );
    yAxisColor = yAxisColor ?? xAxisColor;
    yAxisWidth = yAxisWidth ?? xAxisHeight;
    yAxisTitleStyle = yAxisTitleStyle ?? xAxisTitleStyle;
    aliment = aliment ?? LineAliment.StartEnd;
  }
}

//Curve or straight line
enum LineType {
  //曲线
  Curve,
  //直线
  Straight
}

//折线图中间是否填充颜色
class FillColor {
  //渐变填充 开始颜色
  Color startColor;

  //渐变填充 结束颜色
  Color endColor;

  FillColor({@required this.startColor, @required this.endColor})
      : assert(startColor != null && endColor != null,
            "start color and end color must set of all");
}

class PointTitle {
  int index;
  String title;

  PointTitle({@required this.index, @required this.title})
      : assert(
            index != null && title != null, "index and title must not be null");
}

class LineStyle {
  //线条颜色
  Color color;

  //填充颜色
  FillColor fillColor;

  bool showPoint;

  PointStyle pointStyle;

  //线条的粗细
  double width;

  //线条样式，平滑曲线还是折线
  LineType type;

  LineStyle(
      {this.color,
      this.fillColor,
      this.width,
      this.type,
      this.showPoint,
      this.pointStyle}) {
    color = color ?? Colors.redAccent;
    type = type ?? LineType.Straight;
    width = width ?? 1;
    showPoint = showPoint ?? false;
    pointStyle = pointStyle ?? PointStyle();
  }
}

class PointStyle {
  Color color;
  Color borderColor;
  double borderWidth;
  double size;

  PointStyle({this.color, this.size, this.borderColor, this.borderWidth}) {
    size = size ?? 2.0;
    borderWidth = borderWidth ?? 0.0;
  }
}
