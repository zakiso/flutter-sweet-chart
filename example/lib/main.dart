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
  List<SweetLine> lines;
  LineChartStyle chartStyle;

  @override
  void initState() {
    super.initState();
    lines = [];

    List<SweetPoint> points = [];
    var axisData = [
      {"x": 0, "y": 38},
      {"x": 1, "y": 100},
      {"x": 2, "y": 50},
      {"x": 3, "y": 88},
      {"x": 4, "y": 60},
      {"x": 5, "y": 88},
      {"x": 6, "y": 105},
      {"x": 7, "y": 99},
      {"x": 8, "y": 30},
      {"x": 9, "y": 100},
    ];
    axisData.forEach((data) {
      points.add(SweetPoint(xAxis: data["x"], yAxis: data["y"]));
    });

    SweetLine line = SweetLine(points,
        lineStyle: LineStyle(
            bodyType: LineBodyType.Stroke,
            borderType: LineBorderType.Curve,
            color: Colors.green[200],
            width: 2));
    lines.add(line);

    List<SweetPoint> pointsTwo = [];
    var axisDataTwo = [
      {"x": 0, "y": 88},
      {"x": 1, "y": 30},
      {"x": 2, "y": 66},
      {"x": 3, "y": 33},
      {"x": 4, "y": 55},
      {"x": 5, "y": 99},
      {"x": 6, "y": 139},
      {"x": 7, "y": 109},
      {"x": 8, "y": 151},
      {"x": 9, "y": 28},
    ];
    axisDataTwo.forEach((data) {
      pointsTwo.add(SweetPoint(xAxis: data["x"], yAxis: data["y"]));
    });

    SweetLine lineTwo = SweetLine(pointsTwo,
        lineStyle: LineStyle(
            bodyType: LineBodyType.Stroke,
            borderType: LineBorderType.Curve,
            color: Colors.indigoAccent[200],
            width: 2));
    lines.add(lineTwo);

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
                  child: Text("修改/还原Y轴起点数据为0和最大数据为300"),
                  onPressed: () {
                    setState(() {
                      //如果不设置 x和y轴大最大值和最小值，则自动根据line的point中最大值最小值中获取
                      chartStyle.yStartValue =
                          chartStyle.yStartValue == null ? 0 : null;
                      chartStyle.yEndValue =
                          chartStyle.yEndValue == null ? 300 : null;
                    });
                  }),
              RaisedButton(
                  child: Text("图表内填充颜色"),
                  onPressed: () {
                    setState(() {
                      //如果不设置 x和y轴大最大值和最小值，则自动根据line的point中最大值最小值中获取
                      lines[0].lineStyle.bodyType =
                          lines[0].lineStyle.bodyType == LineBodyType.Fill
                              ? LineBodyType.Stroke
                              : LineBodyType.Fill;
                    });
                  }),
              RaisedButton(
                  child: Text("平滑曲线"),
                  onPressed: () {
                    setState(() {
                      lines.forEach((line) {
                        line.lineStyle.borderType =
                            line.lineStyle.borderType == LineBorderType.Curve
                                ? LineBorderType.Straight
                                : LineBorderType.Curve;
                      });
                    });
                  }),
              RaisedButton(
                  child: Text("增加1个X轴刻度"),
                  onPressed: () {
                    setState(() {
                      chartStyle.xAxisPieceCount += 1;
                    });
                  }),
              RaisedButton(
                  child: Text("减少1个X轴刻度"),
                  onPressed: () {
                    setState(() {
                      chartStyle.xAxisPieceCount -= 1;
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
                  })
            ],
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: SweetLineChart(
              lines: lines,
              chartStyle: chartStyle,
            ),
          ),
        ],
      ),
    );
  }
}
