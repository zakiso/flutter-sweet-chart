import 'dart:ui';
import 'package:flutter/material.dart';

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

  //X轴数据分多少格
  int xAxisPieceCount;

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

  LineChartStyle(
      {this.xAxisColor,
      this.xAxisHeight,
      this.xAxisTitleStyle,
      this.xAxisToTitleSpace = defaultAxisToTitleSpace,
      this.yAxisColor,
      this.yAxisWidth,
      this.yAxisTitleStyle,
      this.yAxisToTitleSpace = defaultAxisToTitleSpace,
      this.showXAxis = true,
      this.showYAxis = true,
      this.xAxisPieceCount = defaultAxisPieceCount,
      this.yAxisPieceCount = defaultAxisPieceCount,
      this.xStartValue,
      this.xEndValue,
      this.yStartValue,
      this.yEndValue})
      : assert(xAxisPieceCount > 1 && yAxisPieceCount > 1) {
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
  }
}

//Curve or straight line
enum LineBorderType {
  //曲线
  Curve,
  //直线
  Straight
}

//折线图中间是否填充颜色
enum LineBodyType {
  //填充
  Fill,
  //空心
  Stroke
}

class LineStyle {
  Color color;
  double width;
  LineBorderType borderType;
  LineBodyType bodyType;

  LineStyle({this.color, this.width, this.borderType, this.bodyType}) {
    color = color ?? Colors.redAccent;
    borderType = borderType ?? LineBorderType.Straight;
    bodyType = bodyType ?? LineBodyType.Stroke;
    width = width ?? 1;
  }
}
