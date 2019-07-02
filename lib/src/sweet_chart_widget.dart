import 'package:flutter/widgets.dart';
import 'package:sweet_chart/src/sweet_data.dart';
import 'package:sweet_chart/src/sweet_line_chart.dart';


enum SweetChartType {
  Line,
  Bar,
  Pie,
}

class SweetChart extends StatelessWidget {
  final SweetChartType type;

  final List<SweetData> dataList;

  SweetChart({@required this.type, @required this.dataList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
//      return
      if(type == SweetChartType.Line){
        return SweetLineChart(dataList);
      }
    });
  }
}
