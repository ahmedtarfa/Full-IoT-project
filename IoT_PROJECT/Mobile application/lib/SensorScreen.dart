import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  List<SensorData> temperatureChartData = [];
  double temperature = 0.0;

  List<SensorData> flameSensorChartData = [];
  double flameSensor = 0.0;

  List<SensorData> gasSensorChartData = [];
  double gasSensor = 0.0;

  final ValueNotifier<List<SensorData>> dataNotifier = ValueNotifier<List<SensorData>>([]);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child("reading/Uultra").onValue.listen((event) {
      double value;
      if (event.snapshot.value is int) {
        value = (event.snapshot.value as int).toDouble();
      } else {
        value = event.snapshot.value as double;
      }

      setState(() {
        temperature = value;
        temperatureChartData.add(SensorData(DateTime.now(), value));
        // Check if the length exceeds 5
        if (temperatureChartData.length > 5) {
          temperatureChartData.removeAt(0);  // Remove the first item
        }
        dataNotifier.value = temperatureChartData;
      });
    });

    reference.child("reading/flame").onValue.listen((event) {
      double value;
      if (event.snapshot.value is int) {
        value = (event.snapshot.value as int).toDouble();
      } else {
        value = event.snapshot.value as double;
      }

      setState(() {
        flameSensor = value;
        flameSensorChartData.add(SensorData(DateTime.now(), value));
        // Check if the length exceeds 5
        if (flameSensorChartData.length > 5) {
          flameSensorChartData.removeAt(0);  // Remove the first item
        }
        dataNotifier.value = flameSensorChartData;
      });
    });

    reference.child("reading/gasSensor").onValue.listen((event) {
      double value;
      if (event.snapshot.value is int) {
        value = (event.snapshot.value as int).toDouble();
      } else {
        value = event.snapshot.value as double;
      }

      setState(() {
        gasSensor = value;
        gasSensorChartData.add(SensorData(DateTime.now(), value));
        // Check if the length exceeds 5
        if (gasSensorChartData.length > 5) {
          gasSensorChartData.removeAt(0);  // Remove the first item
        }
        dataNotifier.value = gasSensorChartData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Readings'),
      ),
      body: ListView(
        children: <Widget>[
          SensorCard(
            title: 'Flame Sensor',
            value: flameSensor.toString(),
            fetchChartData: _generateFlameSensorChartData,
            dataNotifier: dataNotifier,
          ),
          SensorCard(
            title: 'MQ4 Gas Sensor',
            value: gasSensor.toString(),
            fetchChartData: _generateGasSensorChartData,
            dataNotifier: dataNotifier,
          ),
          SensorCard(
            title: 'Ultra Sonic',
            value: temperature.toString(),
            fetchChartData: _generateTemperatureChartData,
            dataNotifier: dataNotifier,
          ),
        ],
      ),
    );
  }

  List<charts.Series<SensorData, DateTime>> _generateTemperatureChartData() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Sensor',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData data, _) => data.time,
        measureFn: (SensorData data, _) => data.value,
        data: temperatureChartData,
      ),
    ];
  }

  List<charts.Series<SensorData, DateTime>> _generateFlameSensorChartData() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Sensor',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData data, _) => data.time,
        measureFn: (SensorData data, _) => data.value,
        data: flameSensorChartData,
      ),
    ];
  }

  List<charts.Series<SensorData, DateTime>> _generateGasSensorChartData() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Sensor',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData data, _) => data.time,
        measureFn: (SensorData data, _) => data.value,
        data: gasSensorChartData,
      ),
    ];
  }
}

class SensorCard extends StatefulWidget {
  final String title;
  final String value;
  final List<charts.Series<SensorData, DateTime>> Function() fetchChartData;
  final ValueNotifier<List<SensorData>> dataNotifier;

  SensorCard({
    required this.title,
    required this.value,
    required this.fetchChartData,
    required this.dataNotifier,
  });

  @override
  _SensorCardState createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.title),
            subtitle: Text('Value: ${widget.value}'),
          ),
          Container(
            height: 200,
            child: ValueListenableBuilder<List<SensorData>>(
              valueListenable: widget.dataNotifier,
              builder: (_, data, __) {
                return charts.TimeSeriesChart(
                  widget.fetchChartData(),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SensorData {
  final DateTime time;
  final double value;

  SensorData(this.time, this.value);
}

