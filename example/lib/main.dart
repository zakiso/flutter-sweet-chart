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
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Container(
        color: Colors.white,
        width: 400,
        height: 200,
        child: SweetLineChart(
          lines: lines,
          chartStyle: LineChartStyle(
            showXAxis: false,
            showYAxis: true
          ),
        ),
      )),
    );
  }
}
