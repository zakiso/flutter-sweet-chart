import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sweet_chart/sweet_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SweetLine> lines = [];
  LineChartStyle chartStyle;

  @override
  void initState() {
    super.initState();

    List<SweetPoint> points = [];
    var rng = Random();
    for (var i = 0; i < 7; i++) {
      points.add(SweetPoint(value: rng.nextInt(300)));
    }

    var lineStyle = LineStyle(
        type: LineType.Curve,
        color: Colors.green[200],
        width: 2,
        showPoint: true,
        pointStyle: PointStyle(
            color: Colors.white,
            borderColor: Colors.green[200],
            borderWidth: 2,
            size: 2));
    SweetLine line = SweetLine(points, style: lineStyle);
    lines.add(line);

    chartStyle = LineChartStyle(showXAxis: true, showYAxis: true);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Wrap(
            direction: Axis.horizontal,
            spacing: 5,
            children: <Widget>[
              RaisedButton(
                  child: Text("显示/隐藏x轴文本"),
                  onPressed: () {
                    setState(() {
                      chartStyle.showXAxis = !chartStyle.showXAxis;
                    });
                  }),
              RaisedButton(
                  child: Text("显示/隐藏Y轴文本"),
                  onPressed: () {
                    setState(() {
                      chartStyle.showYAxis = !chartStyle.showYAxis;
                    });
                  }),
              RaisedButton(
                  //默认Y轴数据起始为数据最小值，顶点为数据最大值，可以通过设置yStartValue和yEndValue进行自定义
                  child: Text("自定义Y轴起始值和最大值"),
                  onPressed: () {
                    setState(() {
                      //如果不设置 x和y轴大最大值和最小值，则自动根据line的point中最大值最小值中获取
                      chartStyle.yStartValue =
                          chartStyle.yStartValue == null ? 0 : null;
                      chartStyle.yEndValue =
                          chartStyle.yEndValue == null ? 500 : null;
                    });
                  }),
              RaisedButton(
                  child: Text("图表内填充颜色"),
                  onPressed: () {
                    setState(() {
                      //如果不设置 x和y轴大最大值和最小值，则自动根据line的point中最大值最小值中获取
                      lines[0].style.fillColor = lines[0].style.fillColor !=
                              null
                          ? null
                          : FillColor(
                              startColor: lines[0].style.color.withAlpha(80),
                              endColor: lines[0].style.color.withAlpha(10));
                    });
                  }),
              RaisedButton(
                  child: Text("平滑曲线"),
                  onPressed: () {
                    setState(() {
                      lines.forEach((line) {
                        line.style.type = line.style.type == LineType.Curve
                            ? LineType.Straight
                            : LineType.Curve;
                      });
                    });
                  }),
              RaisedButton(
                  child: Text("增加1个Y轴刻度"),
                  onPressed: () {
                    setState(() {
                      chartStyle.yAxisPieceCount += 1;
                    });
                  }),
              RaisedButton(
                  child: Text("减少1个Y轴刻度"),
                  onPressed: () {
                    setState(() {
                      chartStyle.yAxisPieceCount -= 1;
                    });
                  }),
              RaisedButton(
                  child: Text("显示圆点"),
                  onPressed: () {
                    setState(() {
                      lines[0].style.showPoint = !lines[0].style.showPoint;
                    });
                  }),
              RaisedButton(
                  child: Text("增加/减少一条曲线"),
                  onPressed: () {
                    setState(() {
                      if (lines.length > 1) {
                        lines.removeLast();
                      } else {
                        lines.add(_makeNewLine());
                      }
                    });
                  }),
            ],
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: SweetLineChart(
              lines: lines,
              chartStyle: chartStyle,
              xTitles: {0: "07/18 00:00", 6: "08/18 23:50"},
              yTitles: {0: "0k", 1: "15k", 2: "30k"},
            ),
          ),
        ],
      ),
    );
  }

  SweetLine _makeNewLine() {
    List<SweetPoint> points = [];
    var rng = Random();
    for (var i = 0; i < 7; i++) {
      points.add(SweetPoint(value: rng.nextInt(300)));
    }
    SweetLine line = SweetLine(points,
        style: LineStyle(
            fillColor: FillColor(
                startColor: Colors.red[200].withAlpha(30),
                endColor: Colors.red[200].withAlpha(10)),
            type: LineType.Straight,
            color: Colors.red[200],
            width: 2));
    return line;
  }
}
