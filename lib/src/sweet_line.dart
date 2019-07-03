import 'package:sweet_chart/src/sweet_point.dart';

class SweetLine {
  List<SweetPoint> points;

  num _maxXAxisValue;
  num _minXAxisValue;
  num _maxYAxisValue;
  num _minYAxisValue;

  num get minYAxisValue => _minYAxisValue;

  num get maxYAxisValue => _maxYAxisValue;

  num get minXAxisValue => _minXAxisValue;

  num get maxXAxisValue => _maxXAxisValue;

  SweetLine(this.points) : assert(points != null && points.length > 0) {
    _initData();
  }

  _initData() {
    _maxXAxisValue = points[0].xAxis;
    _minXAxisValue = points[0].xAxis;
    _maxYAxisValue = points[0].yAxis;
    _minYAxisValue = points[0].yAxis;
    for(var i=0;i<points.length;i++){
      SweetPoint p = points[i];
      if (p.xAxis > _maxXAxisValue) {
        _maxXAxisValue = p.xAxis;
      }
      if (p.xAxis < _minXAxisValue) {
        _minXAxisValue = p.xAxis;
      }
      if (p.yAxis > _maxYAxisValue) {
        _maxYAxisValue = p.yAxis;
      }
      if (p.yAxis < _minYAxisValue) {
        _minYAxisValue = p.yAxis;
      }
    }
  }
}
