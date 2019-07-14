# flutter_sweet_chart

A flutter chart package.

### ScreenShot

![1563122544617537.2019-07-15 00_53_50](/Users/zhiqiangdeng/Documents/ProjectSource/FlutterProject/flutter_sweet_chart/media/1563122544617537.2019-07-15 00_53_50.gif)

### Getting Started

`pubspec.yaml` add dependence 

```
sweet_chart:
    git:
      url: git@github.com:zakiso/flutter-sweet-chart.git
```



### Basic Usage

```Dart
@override
Widget build(BuildContext context) {
    //define your lines set
    var lines = [];
    //define your data set
    List<SweetPoint> points = [];
        var rng = Random();
        for (var i = 0; i < 7; i++) {
          points.add(SweetPoint(
              //title and subtitle will show on user tap the point
              value: rng.nextInt(300), title: "title", subTitle: "subtitle"));
        }

    //define your chart line style, 
    //A chart can be include multiple lines
    //so you can set different style for different line.
    var lineStyle = LineStyle(
        color: Colors.green[200]); // you can run the example for view more option.
    SweetLine line = SweetLine(points, style: lineStyle);
    lines.add(line);
    // chart style 
    chartStyle = LineChartStyle(showXAxis: true, showYAxis: true);
	
    return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: SweetLineChart(
              lines: lines,
              chartStyle: chartStyle,
              //you can custom x and y axis title 
              xTitles: {0: "18", 2: "20", 4: "30", 5: "08/01", 6: "02"},
              yTitles: {0: "0k", 1: "5k", 5: "25k",6: "30k" },
            ),
          );
}
```



### Feature

1. show or hide x or y axis 
2. Custom x or y axis title
3. show curve or strait line
4. Fill gradient color
5. show popup tips on click point
6. Multi line 
7. …..and so on



**Want to get more info please download project and run it .**

**Welcome PR and star**

