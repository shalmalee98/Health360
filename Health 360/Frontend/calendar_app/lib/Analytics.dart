import 'dart:convert';
import 'package:Health_Guardian/task_page.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/widgetpane.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'package:Health_Guardian/environment.dart';
import 'package:intl/intl.dart';
import 'Constants/urlConstant.dart';
import 'GetSampleApi.dart';
import 'apiCall.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import 'loginpage.dart';

GlobalKey<SfCartesianChartState> _chartKey = GlobalKey<SfCartesianChartState>();

// final totalTaskKey = GlobalKey<SfCircularChartState>();
// final GlobalKey<SfRadialGaugeState> avgPHQKey = GlobalKey<SfRadialGaugeState>();
// final GlobalKey<SfRadialGaugeState>avgSleepKey = GlobalKey<SfRadialGaugeState>();
// final PHQScoreKey = GlobalKey<SfCartesianChartState>();
// final PHQScoreOTKey = GlobalKey<SfCartesianChartState>();
// final SleepScoreKey = GlobalKey<SfCartesianChartState>();
// final SleepScoreOTKey = GlobalKey<SfCartesianChartState>();
int triggerKey = 0;
final List<String> monthPrefixes = [
  '', // Index 0 is not used, so leave an empty string here
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];
final List<DateTime> PHQ8Dates = [];
final List<int> PHQ8Scores = [];

final List<DateTime> SleepDates = [];
final List<int> SleepScores = [];

final List<DateTime> AUDITDates = [];
final List<int> AUDITScores = [];

final List<DateTime> GAD7Dates = [];
final List<int> GAD7Scores = [];

final List<DateTime> DiabetesDates = [];
final List<int> DiabetesScores = [];

final List<DateTime> ParkinsonDates = [];
final List<int> ParkinsonScores = [];

final List<DateTime> AlzheimerDates = [];
final List<int> AlzheimerScores = [];

Map<DateTime, int> DiabetesDatasets = {};
Map<DateTime, int> ParkinsonDatasets = {};
Map<DateTime, int> AlzheimerDatasets = {};

double averagePHQ8Score = 0;
double averageSleepScore = 0;
double averageGAD7Score = 0;
double averageAUDITScore = 0;

int countPHQ8Score = 0;
int countSleepScore = 0;
int countGAD7Score = 0;
int countAUDITScore = 0;
int countDiabetesScore = 0;
int countParkinsonScore = 0;
int countAlzheimerScore = 0;

int sumPHQ8Score = 0;
int sumSleepScore = 0;
int sumAUDITScore = 0;
int sumGAD7Score = 0;
int sumDiabetesScore = 0;
int sumParkinsonScore = 0;
int sumAlzheimerScore = 0;

class AnalyticsPage extends StatefulWidget {
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class donutData extends _AnalyticsPageState {
  donutData(this.task, this.totalCount);
  String task;
  int totalCount;
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool _isloading = true;
  List<DateTime>? dateList;
  List<GetSampleApi>? apiList;
  // final List<String> idList=[];

  void initState() {
    super.initState();
    getDates();
    print("function call"); //print(apiList);
    print('Value of Trigger key: $triggerKey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: WidgetPane(initialSelectedIndex: 3),
        body: _isloading
            ? SafeArea(
                child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: CircularProgressIndicator()),
              ))
            : content());
  }

  Widget content() {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        child: Column(children: [
          // SingleChildScrollView(
          // child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 0)),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TaskPage()))),
                  Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
                  Text(
                    "Health 360",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                        2.5 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCircularChart(
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      title: ChartTitle(
                        text: "Total Tasks",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.right,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      // key: totalTaskKey,
                      series: <CircularSeries>[
                        DoughnutSeries<donutData, String>(
                          dataSource: [
                            donutData("PHQ-8 Survey", countPHQ8Score),
                            donutData("Sleep Survey", countSleepScore),
                            donutData("GAD-7 Survey", countGAD7Score),
                            donutData("AUDIT Survey", countAUDITScore),
                            donutData("Diabetes Test", countDiabetesScore),
                            donutData("Parkinson's Test", countParkinsonScore),
                            donutData("Alzheimer's Test", countAlzheimerScore),
                          ],
                          xValueMapper: (donutData donut, _) => donut.task,
                          yValueMapper: (donutData donut, _) =>
                              donut.totalCount,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                          ),
                          enableTooltip: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                        3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfRadialGauge(
                        // key: avgPHQKey,
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        title: GaugeTitle(
                          text: "Average PHQ-8 Score",
                          textStyle: TextStyle(fontSize: 17),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                              minimum: 0,
                              maximum: 24,
                              interval: 2,
                              canScaleToFit: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  enableAnimation: true,
                                  value: averagePHQ8Score,
                                  width: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color(0xFFCC2B5E),
                                    Color(0xFF753A88)
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ]),
                                )
                              ]),
                        ]),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                        3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfRadialGauge(
                        // key: avgSleepKey,
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        title: GaugeTitle(
                          text: "Average Sleep Score",
                          textStyle: TextStyle(fontSize: 17),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                              minimum: 1,
                              maximum: 7,
                              interval: 1,
                              canScaleToFit: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  enableAnimation: true,
                                  value: averageSleepScore,
                                  width: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color(0xFFCC2B5E),
                                    Color(0xFF753A88)
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ]),
                                )
                              ]),
                        ]),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                    3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfRadialGauge(
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        title: GaugeTitle(
                          text: "Average AUDIT Score",
                          textStyle: TextStyle(fontSize: 17),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                              minimum: 0,
                              maximum: 12,
                              interval: 2,
                              canScaleToFit: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  enableAnimation: true,
                                  value: averageAUDITScore,
                                  width: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color(0xFFCC2B5E),
                                    Color(0xFF753A88)
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ]),
                                )
                              ]),
                        ]),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                    3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfRadialGauge(
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        title: GaugeTitle(
                          text: "Average GAD-7 Score",
                          textStyle: TextStyle(fontSize: 17),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                              minimum: 0,
                              maximum: 21,
                              interval: 4,
                              canScaleToFit: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.1,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  enableAnimation: true,
                                  value: averageGAD7Score,
                                  width: 0.1,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color(0xFFCC2B5E),
                                    Color(0xFF753A88)
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ]),
                                )
                              ]),
                        ]),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "PHQ-8 Score",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelRotation: 0,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries>[
                        BarSeries<int, String>(
                          color: Colors.red, // set the color to red
                          dataSource: List.generate(PHQ8Scores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[PHQ8Dates[index].month]}/${PHQ8Dates[index].day}",
                          yValueMapper: (int index, _) => PHQ8Scores[index],
                          isTrackVisible: false, // Set this to false to make vertical bars
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                        3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      // key:PHQScoreOTKey,
                      title: ChartTitle(
                        text: "PHQ-8 Score Over Time",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelIntersectAction:
                            AxisLabelIntersectAction.multipleRows,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}',
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        StackedLineSeries<int, String>(
                          dataSource: List.generate(
                              PHQ8Scores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                              "${monthPrefixes[PHQ8Dates[index].month]}/${PHQ8Dates[index].day}",
                          yValueMapper: (int index, _) => PHQ8Scores[index],
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                    3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "Sleep Questionnaire Score",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        //labelIntersectAction: AxisLabelIntersectAction.rotate,
                        labelRotation: 0,
                        majorTickLines: MajorTickLines(width: 0),
                        //valueType: AxisValueType.category,
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries>[
                        BarSeries<int, String>(
                          color: Colors.red,
                          dataSource: List.generate(SleepScores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[SleepDates[index].month]}/${SleepDates[index].day}",
                          yValueMapper: (int index, _) => SleepScores[index],
                          markerSettings: MarkerSettings(
                            shape: DataMarkerType.circle,
                            color: Colors.blue,
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                      aspectRatio:
                          3 / 2, // replace with the aspect ratio of your chart
                      // your chart widget here,
                      child: SfCartesianChart(
                        // key:SleepScoreOTKey,
                        title: ChartTitle(
                          text: "Sleep Questionnaire Score Over Time",
                          textStyle: TextStyle(fontSize: 15),
                        ),
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        primaryXAxis: CategoryAxis(
                          labelRotation: 45,
                          labelIntersectAction:
                              AxisLabelIntersectAction.multipleRows,
                          majorTickLines: MajorTickLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: AxisLine(width: 0),
                          labelFormat: '{value}',
                          majorTickLines: MajorTickLines(width: 0),
                        ),
                        series: <ChartSeries>[
                          StackedLineSeries<int, String>(
                            dataSource: List.generate(
                                SleepScores.length, (index) => index),
                            xValueMapper: (int index, _) =>
                                "${monthPrefixes[SleepDates[index].month]}/${SleepDates[index].day}",
                            yValueMapper: (int index, _) => SleepScores[index],
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside),
                          ),
                        ],
                      ));
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "AUDIT Score",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelRotation: 0,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries>[
                        BarSeries<int, String>(
                          color: Colors.red, // set the color to red
                          dataSource: List.generate(AUDITScores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[AUDITDates[index].month]}/${AUDITDates[index].day}",
                          yValueMapper: (int index, _) => AUDITScores[index],
                          isTrackVisible: false, // Set this to false to make vertical bars
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                    3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "AUDIT Score Over Time",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelIntersectAction:
                        AxisLabelIntersectAction.multipleRows,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}',
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        StackedLineSeries<int, String>(
                          dataSource: List.generate(
                              AUDITScores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[AUDITDates[index].month]}/${AUDITDates[index].day}",
                          yValueMapper: (int index, _) => AUDITScores[index],
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "GAD-7 Score",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelRotation: 0,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries>[
                        BarSeries<int, String>(
                          color: Colors.red, // set the color to red
                          dataSource: List.generate(GAD7Scores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[GAD7Dates[index].month]}/${GAD7Dates[index].day}",
                          yValueMapper: (int index, _) => GAD7Scores[index],
                          isTrackVisible: false, // Set this to false to make vertical bars
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio:
                    3 / 2, // replace with the aspect ratio of your chart
                    // your chart widget here,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "GAD-7 Score Over Time",
                        textStyle: TextStyle(fontSize: 15),
                      ),
                      backgroundColor: Color.fromARGB(255, 240, 240, 240),
                      primaryXAxis: CategoryAxis(
                        labelIntersectAction:
                        AxisLabelIntersectAction.multipleRows,
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: AxisLine(width: 0),
                        labelFormat: '{value}',
                        majorTickLines: MajorTickLines(width: 0),
                      ),
                      series: <ChartSeries>[
                        StackedLineSeries<int, String>(
                          dataSource: List.generate(
                              GAD7Scores.length, (index) => index),
                          xValueMapper: (int index, _) =>
                          "${monthPrefixes[GAD7Dates[index].month]}/${GAD7Dates[index].day}",
                          yValueMapper: (int index, _) => GAD7Scores[index],
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                'Diabetes Classification Over Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,backgroundColor: Color.fromARGB(255, 240, 240, 240)),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Color.fromARGB(255, 240, 240, 240), // Set the desired background color
                      child: HeatMap(
                        // datasets: {
                        //   // DateTime(2023, 8, 6): 0,
                        //   // DateTime(2023, 8, 7): 2,
                        //   // DateTime(2023, 8, 8): 2,
                        //   // DateTime(2023, 8, 9): 0,
                        //   // DateTime(2023, 8, 13): 0,
                        //   DiabetesDatasets,
                        // },
                        datasets: DiabetesDatasets,
                        size: 40,
                        showText: true,
                        textColor: Colors.black,
                        scrollable: true,
                        colorMode: ColorMode.color,
                        showColorTip: false,
                        colorsets: {
                          0: Colors.green,
                          1: Colors.orangeAccent,
                          2: Colors.red,
                        },
                      ),
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                'Parkinsons Classification Over Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, backgroundColor: Color.fromARGB(255, 240, 240, 240)),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Color.fromARGB(255, 240, 240, 240), // Set the desired background color
                      child: HeatMap(
                        datasets: ParkinsonDatasets,
                        size: 40,
                        showText: true,
                        textColor: Colors.black,
                        scrollable: true,
                        showColorTip: false,
                        colorMode: ColorMode.color,
                        colorsets: {
                          0: Colors.green,
                          1: Colors.red,
                        },
                      ),
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                'Alzheimer Classification Over Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, backgroundColor: Color.fromARGB(255, 240, 240, 240) ),
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Color.fromARGB(255, 240, 240, 240), // Set the desired background color
                      child: HeatMap(
                        datasets: AlzheimerDatasets,
                        size: 40,
                        showText: true,
                        textColor: Colors.black,
                        scrollable: true,
                        showColorTip: false,
                        colorMode: ColorMode.color,
                        colorsets: {
                          0: Colors.green,
                          1: Colors.red,
                        },
                      ),
                    ),
                  );
                },
              ),
              Text(
                '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),

            ],
          ),
          //),
        ]),
      ),
    ));
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'PostmanRuntime/7.31.1',
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg2NTkzNjE2LCJpYXQiOjE2Nzg4MTc2MTYsImp0aSI6ImI5YzM1MDNjMTk1YTQ0NmU5MjVmNWU3N2JiMWZlZWNlIiwidXNlcl9pZCI6MTEyfQ.r6dMDcY9HkB7zUrCo3m2u3-Bou72kPWiXEVGjbkJoDE'
  };

  Future<void> getDates() async {
    final List<DateTime> dates = [];
    final List<String> taskUid = [];
    final List<String> taskHid = [];

    if (setEnvironment.env == environment.mock && triggerKey == 0) {
      setState(() {
        _isloading = true;
      });
      triggerKey = 99;
      print(setEnvironment.env);
      await getCallMockAPI("${setEnvironment.calendarUrl}/${user}", "");
      print("ANALYTICS TASKLIST");

      for (var i = 0; i < taskList.length; i++) {
        print('Value of Trigger key: $triggerKey');
        String strCreatedDate = taskList[i]['created'];
        String strHid = taskList[i]['hid'];
        String strUid = taskList[i]['uid'];
        int task_score = taskList[i]['task_score'];
        // int? task_score = int.tryParse(strTask_score.trim());
        DateFormat format = DateFormat("yyyy-MM-dd");
        DateTime myDate = format.parse(strCreatedDate);

        if (strHid.contains("PHQ-8")) {
          countPHQ8Score = countPHQ8Score + 1;
          sumPHQ8Score = sumPHQ8Score + task_score!;
          PHQ8Dates.add(myDate);
          PHQ8Scores.add(task_score);
        } else if (strHid.contains("sleep_questionnaire")) {
          countSleepScore = countSleepScore + 1;
          sumSleepScore = sumSleepScore + task_score!;
          SleepDates.add(myDate);
          SleepScores.add(task_score);
        }
        else if (strHid.contains("AUDIT")) {
          countAUDITScore = countAUDITScore + 1;
          sumAUDITScore = sumAUDITScore + task_score!;
          AUDITDates.add(myDate);
          AUDITScores.add(task_score);
        }
        else if (strHid.contains("GAD-7")) {
          countGAD7Score = countGAD7Score + 1;
          sumGAD7Score = sumGAD7Score + task_score!;
          GAD7Dates.add(myDate);
          GAD7Scores.add(task_score);
        }
        else if (strHid.contains("diabetes")) {
          countDiabetesScore = countDiabetesScore + 1;
          sumDiabetesScore = sumDiabetesScore + task_score!;
          DiabetesDates.add(myDate);
          DiabetesScores.add(task_score);
        }
        else if (strHid.contains("parkinsons")) {
          countParkinsonScore = countParkinsonScore + 1;
          sumParkinsonScore = sumParkinsonScore + task_score!;
          ParkinsonDates.add(myDate);
          ParkinsonScores.add(task_score);
        }
        else if (strHid.contains("alzheimer")) {
          countAlzheimerScore = countAlzheimerScore + 1;
          sumAlzheimerScore = sumAlzheimerScore + task_score!;
          AlzheimerDates.add(myDate);
          AlzheimerScores.add(task_score);
        }
      }
      print('Value of Trigger key: $triggerKey');
    } else if (setEnvironment.env == environment.realService) {
      http.Response response = await http.get(
        Uri.parse(setEnvironment.calendarUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Success");
        final Data = jsonDecode(response.body);
        print("=======================");
        print(Data.length);
        List<DateTime> dates = [];
        List<String> taskUid = [];
        List<String> taskHid = [];

        for (var i = 0; i < Data.length; i++) {
          String strCreatedDate = Data[i]['created'];
          String strHid = Data[i]['hid'];
          String strUid = Data[i]['uid'];
          DateFormat format = DateFormat("yyyy-MM-dd");
          DateTime myDate = format.parse(strCreatedDate);
          //DateTime myDate = DateTime.parse(strCreatedDate);

          dates.add(myDate);
          taskUid.add(strUid);
          taskHid.add(strHid);
          //print("INDIVIDUAL DATES: ");
          // print(myDate);
          // print(strHid);
          // print(strUid);
          if (strHid.contains("PHQ-8")) {
            String dataendpoint =
                "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/" +
                    strUid;
            Map data = {"data_endpoint": dataendpoint};
            await makePostCalendarCall(setEnvironment.apiBaseUrlPHQ,
                phq_unencoded_post, jsonEncode(data));
            // idList.add(id);
            // print(idList);
            await makeGetApiCallPHQ(setEnvironment.apiBaseUrlPHQ, id);
            //print("ID " + id.toString());
            if (phq_score != -1) {
              countPHQ8Score = countPHQ8Score + 1;
              sumPHQ8Score = sumPHQ8Score + phq_score;
              PHQ8Dates.add(myDate);
              PHQ8Scores.add(phq_score);
              // print("PHQ TASK");
              // print("DATE TAKEN: " + myDate.toString());
              // print("PHQ SCORE:" + phq_score.toString());

              for (int i = 0; i < PHQ8Dates.length; i++) {
                //print("My IFF --------------------------");
                print("Date: ${PHQ8Dates[i]}, Score: ${PHQ8Scores[i]}");
              }
            }
          } else if (strHid.contains("sleep_questionnaire_task")) {
            String dataendpoint =
                "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/" +
                    strUid;
            Map data = {"data_endpoint": dataendpoint};
            await makePostCalendarCall(setEnvironment.apiBaseUrlSleepQ,
                sleepq_unencoded_post, jsonEncode(data));
            // idList.add(id);
            // print(idList);
            //print(id);
            await makeGetApiCallSleepQ(setEnvironment.apiBaseUrlSleepQ, id);
            // print("ID " + id.toString());
            if (sleep_score != -1) {
              countSleepScore = countSleepScore + 1;
              sumSleepScore = sumSleepScore + sleep_score;
              SleepDates.add(myDate);
              SleepScores.add(sleep_score);

              // print("SLEEPQ TASK");
              // print("DATE TAKEN: " + myDate.toString());
              // print("SLEEP SCORE:" + sleep_score.toString());

              for (int i = 0; i < SleepDates.length; i++) {
                //print("My IFF --------------------------");
                print("Date: ${SleepDates[i]}, Score: ${SleepScores[i]}");
              }
            }
          }
        }
      } else {
        print("Something went wrong");
      }
    }

    setState(() {
      _isloading = false;
    });

    averagePHQ8Score = (sumPHQ8Score / countPHQ8Score).ceilToDouble();
    averageSleepScore = (sumSleepScore / countSleepScore).ceilToDouble();
    averageAUDITScore = (sumAUDITScore / countAUDITScore).ceilToDouble();
    averageGAD7Score = (sumGAD7Score / countGAD7Score).ceilToDouble();
    //averageSleepScore = averageSleepScore.ceil();
    print(
        "Hey This is my average ????????????????????????????????????????????????????????");
    print(DiabetesDates);
    print(DiabetesDates[0].runtimeType);
    print(DiabetesScores);
    print(ParkinsonDates);
    print(ParkinsonDates[0].runtimeType);
    print(ParkinsonScores);
    print(AlzheimerDates);
    print(AlzheimerDates[0].runtimeType);
    print(AlzheimerScores);
    print("My Average finally :" + averageSleepScore.toString());

    // Populate the map using the two lists
    for (int i = 0; i < DiabetesDates.length; i++) {
      DiabetesDatasets[DiabetesDates[i]] = DiabetesScores[i];
    }
    for (int i = 0; i < ParkinsonDates.length; i++) {
      ParkinsonDatasets[ParkinsonDates[i]] = ParkinsonScores[i];
    }
    for (int i = 0; i < AlzheimerDates.length; i++) {
      AlzheimerDatasets[AlzheimerDates[i]] = AlzheimerScores[i];
    }

    print(DiabetesDatasets);
    print(ParkinsonDatasets);
    print(AlzheimerDatasets);

    //dateList = dates.toSet().toList();
  }
}
