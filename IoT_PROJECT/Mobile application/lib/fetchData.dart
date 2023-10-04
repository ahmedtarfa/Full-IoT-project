class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  List<SensorData> chartData = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  _initializeData() {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child("reading/temperature").onValue.listen((event) {
      double value = event.snapshot.value as double;
      setState(() {
        chartData.add(SensorData(DateTime.now(), value));
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
            value: 'Detected',
            chartData: _generateChartData(),
          ),
          SensorCard(
            title: 'MQ4 Gas Sensor',
            value: '0.45 ppm',
            chartData: _generateChartData(),
          ),
          SensorCard(
            title: 'Temperature Sensor',
            value: '25°C',
            chartData: _generateChartData(),
          ),
        ],
      ),
    );
  }

  List<charts.Series<SensorData, DateTime>> _generateChartData() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Sensor',
        colorFn: (_0, _) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData data, _) => data.time,
        measureFn: (SensorData data, _) => data.value,
        data: chartData,
      )
    ];
  }
}