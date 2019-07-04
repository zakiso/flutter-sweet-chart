import 'dart:ui';
import 'package:flutter/material.dart';

class SweetPoint {
  String title;
  String subTitle;
  Color color;
  num xAxis;
  num yAxis;

  SweetPoint(
      {this.title,
      this.subTitle,
      this.color,
      @required this.xAxis,
      @required this.yAxis});
}
