// ignore_for_file: sort_child_properties_last, prefer_final_fields, prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:infominds_app/pages/login_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<int> minMaxTimestampsArray = [];

  int _seconds = 0;
  late Timer _timer;

  @override
  void initState() {
    _getSectors();
    minMaxTimestampsArray =
        timestampsFromDateAndHours(DateTime.now(), hoursArray);
    _getCorrectTimestamps(minMaxTimestampsArray);
    _timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) {
        setState(
          () {
            _seconds++;
            _getRealTimeSensors();
          },
        );
      },
    );
    super.initState();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

//______________________________________ FUNCTIONS __________________________________________________________________

  String SECTOR = "Sec1";

  List<int> timestampsFromDateAndHours(DateTime date, List<double> hours) {
    List<int> timestamps = [];

    for (double hour in hours) {
      int millisecondsInHour =
          (hour * 60 * 60 * 1000).round(); // Converti ore in millisecondi
      DateTime dateTimeWithHour = DateTime(date.year, date.month, date.day)
          .add(Duration(milliseconds: millisecondsInHour));
      timestamps.add(dateTimeWithHour.millisecondsSinceEpoch);
    }

    return timestamps;
  }

  double convertTimestampInHours(double timestamp) {
    // Creare un oggetto DateTime dal timestamp in millisecondi
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((timestamp).round());

    // Ottenere le ore come double
    double ore = dateTime.hour.toDouble();

    return ore;
  }

  List<FlSpot> TempGraphData = []; // {x=hour, y=value}
  List<FlSpot> TempGraphDataWatt = [];

  Future _getCorrectTimestamps(List<int> minAndMaxT) async {
    try {
      QuerySnapshot documentSnapshot = await firestore
          .collection('Sectors')
          .doc('Sec1')
          .collection('Temperature')
          .get();

      documentSnapshot.docs.forEach(
        (DocumentSnapshot document) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

          if (data != null) {
            int timestamp = data['timestamp'];

            if ((timestamp * 1000) >= minAndMaxT[0] &&
                (timestamp * 1000) <= minAndMaxT[1]) {
              double timestampD = timestamp.toDouble();

              double x = convertTimestampInHours(timestampD);

              int y = data['value'];

              double yd = y.toDouble();

              FlSpot coordinates = FlSpot(x, yd);

              TempGraphData.add(coordinates);
            } else {
              print("NON COMPRESO");
            }
          }

          // if uguale per l'anomalia
        },
      );
    } catch (e) {
      print('Errore durante l\'ottenimento dei documenti: $e');
    }
  }

  int _selectedPage = 0;

  void _onPageChange(int index) {
    setState(() {
      _selectedPage = index;
      //_getReports();
    });
  }

  void _logout() {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  DateTime selectedDate = DateTime.now();
  List<double> hoursArray = [0.01, 23.59];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        minMaxTimestampsArray = timestampsFromDateAndHours(picked, hoursArray);
        print(minMaxTimestampsArray[0]);
        print(minMaxTimestampsArray[1]);
        _getCorrectTimestamps(minMaxTimestampsArray);
        //_get(timestampsArray);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int currentTemp = 0;
  double currentElec = 0;

  List<String> sectors = [];

  Future<void> _getSectors() async {
    try {
      CollectionReference sectorsCollection =
          FirebaseFirestore.instance.collection('Sectors');

      QuerySnapshot querySnapshot = await sectorsCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        sectors.add(documentSnapshot.id);
      }
    } catch (e) {
      print('Errore nella query a Firestore: $e');
    }
  }

  Future _getRealTimeSensors() async {
    try {
      QuerySnapshot documentSnapshot = await firestore
          .collection('Sectors')
          .doc('Sec1')
          .collection('Temperature')
          .get();

      int max_timestamp = 0;
      int y = 0;

      documentSnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          int timestamp = data['timestamp'];
          if (timestamp > max_timestamp) {
            setState(() {
              max_timestamp = timestamp;
              y = data['value'];
            });
          }
        }
      });

      int hour = DateTime.now().hour;

      double x = hour.toDouble();
      double yd = y.toDouble();

      FlSpot coordinates = FlSpot(x, yd);

      TempGraphData.add(coordinates);
      setState(
        () {
          currentTemp = y;
        },
      );
    } catch (e) {
      print('Errore durante l\'ottenimento dei documenti temperatura: $e');
    }

    try {
      QuerySnapshot documentSnapshot = await firestore
          .collection('Sectors')
          .doc('Sec1')
          .collection('Watt')
          .get();

      int max_timestamp = 0;
      double ywatt = 0;

      documentSnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          int timestamp = data['timestamp'];

          if (timestamp > max_timestamp) {
            setState(() {
              max_timestamp = timestamp;
              ywatt = data['value'];
            });
          }
        }
      });

      int hour = DateTime.now().hour;

      double x = hour.toDouble();

      FlSpot coordinates = FlSpot(x, ywatt);

      TempGraphDataWatt.add(coordinates);
      setState(
        () {
          currentElec = ywatt;
        },
      );
    } catch (e) {
      print('Errore durante l\'ottenimento dei documenti elettricità: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
//__________________________________ APPBAR _______________________________________________________________________________________________________-

      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'COMPANY NAME',
          style: TextStyle(
            fontSize: 31,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
            tooltip: 'Logout',
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Do you want to logout?',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 112, 126, 136),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 60, 154, 222),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

//_____________________________________________ PAGEVIEW _____________________________________________________________________________________

      body: RefreshIndicator(
        onRefresh: () async {
          //_getGeneral();
        },
        child: PageView(
          controller: controller,
          children: <Widget>[
            Scaffold(
              body: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sector:    $SECTOR",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        color: Colors.blue,
                        iconSize: 35,
                        onSelected: (String value) {
                          setState(() {
                            SECTOR = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return sectors.map(
                            (String opzione) {
                              return PopupMenuItem<String>(
                                value: opzione,
                                child: Text(
                                  opzione,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ).toList();
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Live sensors",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Current temperature: $currentTemp",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Current electricity consumption: $currentElec",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Date: ${_formatDate(selectedDate)}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          alignment: Alignment.centerLeft,
                          color: Colors.blue,
                          iconSize: 35,
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sector:    $SECTOR",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                          color: Colors.blue,
                          iconSize: 35,
                          onSelected: (String value) {
                            setState(() {
                              SECTOR = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return sectors.map(
                              (String opzione) {
                                return PopupMenuItem<String>(
                                  value: opzione,
                                  child: Text(
                                    opzione,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ).toList();
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    Text(
                      "Temperature trend",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: 380.0, // Larghezza specifica
                        height: 300.0, // Altezza specifica
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                    axisNameWidget: Text("Temprature (°C)")),
                                topTitles: AxisTitles(
                                    axisNameWidget: Text("Time (hours)")),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true, interval: 2))),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            minX: 0,
                            maxX: 24,
                            minY: 0,
                            maxY: 40,
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 18), //demonstrative values
                                  FlSpot(1, 18.5),
                                  FlSpot(2, 18.7),
                                  FlSpot(3, 18.7),
                                  FlSpot(4, 18.7),
                                  FlSpot(5, 19),
                                  FlSpot(6, 19.3),
                                  FlSpot(7, 19.6),
                                  FlSpot(8, 19.7),
                                  FlSpot(9, 20),
                                  FlSpot(10, 20.8),
                                  FlSpot(11, 20.8),
                                  FlSpot(12, 21),
                                  FlSpot(13, 21),
                                  FlSpot(14, 21.2),
                                  FlSpot(15, 21.3),
                                  FlSpot(16, 21),
                                  FlSpot(17, 20.8),
                                  FlSpot(18, 20.8),
                                  FlSpot(19, 20.5),
                                  FlSpot(20, 20),
                                  FlSpot(21, 19.8),
                                  FlSpot(22, 19.3),
                                  FlSpot(23, 18.9),
                                  FlSpot(24, 18.3),
                                ], //TempGraphData,
                                isCurved:
                                    true, // Abilita la curvatura della linea
                                color: Colors.blue,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      thickness: 3,
                    ),
                    Text(
                      "Electrical consumption",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: 380.0, // Larghezza specifica
                        height: 300.0, // Altezza specifica
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                    axisNameWidget: Text("Consumption (watt)")),
                                topTitles: AxisTitles(
                                    axisNameWidget: Text("Time (hours)")),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true, interval: 2))),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            minX: 0,
                            maxX: 24,
                            minY: 0,
                            maxY: 50,
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, 2), //demonstrative values
                                  FlSpot(1, 2),
                                  FlSpot(2, 2),
                                  FlSpot(3, 2),
                                  FlSpot(4, 2),
                                  FlSpot(5, 2),
                                  FlSpot(6, 3),
                                  FlSpot(7, 5),
                                  FlSpot(8, 20),
                                  FlSpot(9, 40),
                                  FlSpot(10, 45),
                                  FlSpot(11, 48),
                                  FlSpot(12, 48),
                                  FlSpot(13, 30),
                                  FlSpot(14, 45),
                                  FlSpot(15, 48),
                                  FlSpot(16, 48),
                                  FlSpot(17, 48),
                                  FlSpot(18, 35),
                                  FlSpot(19, 22),
                                  FlSpot(20, 20),
                                  FlSpot(21, 5),
                                  FlSpot(22, 2),
                                  FlSpot(23, 2),
                                  FlSpot(24, 2),
                                ],
                                isCurved:
                                    true, // Abilita la curvatura della linea
                                color: Colors.blue,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
          onPageChanged: (index) {
            _onPageChange(index);
          },
        ),
      ),

//_________________________________BOTTOM NAVIGATION BAR___________________________________________________________________________

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Real-Time Statistics',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Data History',
            backgroundColor: Colors.lightBlue,
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.lightBlue,
        onTap: (int index) {
          controller.animateToPage(index,
              duration: const Duration(microseconds: 1000),
              curve: Curves.easeIn);
        },
      ),
    );
  }
}
