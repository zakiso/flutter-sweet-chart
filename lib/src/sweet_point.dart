import 'dart:ui';
import 'package:flutter/material.dart';

class SweetPoint {
  String title;
  String subTitle;
  Color color;
  num value;

  SweetPoint({
    @required this.value,
    this.title,
    this.subTitle,
    this.color,
  }) : assert(value != null, "the value must not null");
}
