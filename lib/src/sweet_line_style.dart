import 'dart:ui';
import 'package:flutter/material.dart';

/// x和y轴标题颜色
//class DefaultAxisTitleStyle extends TextStyle {
//
//  DefaultAxisTitleStyle()
//      : super(
//          color: Color(0xFFACB2C0),
//          decoration: TextDecoration.none,
//          fontSize: 16,
//        );
//}


class AxisStyle {


  static final defaultAxisTitleStyle = TextStyle( color: Color(0xFFACB2C0),
    decoration: TextDecoration.none,
    fontSize: 16,);


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

  AxisStyle(
      {this.xAxisColor,
      this.xAxisHeight,
      this.xAxisTitleStyle,
      this.yAxisColor,
      this.yAxisWidth,
      this.yAxisTitleStyle});
}
