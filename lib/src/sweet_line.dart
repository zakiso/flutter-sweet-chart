import 'package:flutter/material.dart';
import 'package:sweet_chart/src/sweet_line_style.dart';
import 'package:sweet_chart/src/sweet_point.dart';

class SweetLine {
  List<SweetPoint> points;

  //线样式
  LineStyle style;

  num _maxYAxisValue;
  num _minYAxisValue;

  num get minYAxisValue => _minYAxisValue;

  num get maxYAxisValue => _maxYAxisValue;

  SweetLine(this.points, {this.style})
      : assert(points != null && points.length > 1) {
    _initData();
    style = style ?? LineStyle();
  }

  _initData() {
    _maxYAxisValue = points[0].value;
    _minYAxisValue = points[0].value;
    for (var i = 0; i < points.length; i++) {
      SweetPoint p = points[i];

      if (p.value > _maxYAxisValue) {
        _maxYAxisValue = p.value;
      }
      if (p.value < _minYAxisValue) {
        _minYAxisValue = p.value;
      }
    }
  }
}
