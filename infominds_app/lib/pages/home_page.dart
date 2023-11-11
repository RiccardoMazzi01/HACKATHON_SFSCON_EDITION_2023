// ignore_for_file: sort_child_properties_last, prefer_final_fields, prefer_const_constructors

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
  @override
  void initState() {
    _getSectors();
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
  List<int> timestampsArray = [];

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
        timestampsArray = timestampsFromDateAndHours(picked, hoursArray);
        _get(timestampsArray);
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int currentTemp = 0;
  int currentElec = 0;

  Future<void> _get(List<int> timestamps) async {
    try {
      QuerySnapshot documentSnapshot = await firestore
          .collection('Sectors')
          .doc('Sec1')
          .collection('Watt')
          .get();

      documentSnapshot.docs.forEach((DocumentSnapshot wattDocument) {
        Map<String, dynamic>? data =
            wattDocument.data() as Map<String, dynamic>?;

        // Verifica se la conversione è avvenuta con successo
        if (data != null) {
          // Accedi ai singoli campi tramite le chiavi
          String nomeCampo1 = data[
              'timestamp']; // Sostituisci 'campo1' con il nome del tuo campo
          String nomeCampo2 =
              data['value']; // Sostituisci 'campo2' con il nome del tuo campo

          // Puoi ora utilizzare i dati come desiderato
          print('Campo1: $nomeCampo1');
          print('Campo2: $nomeCampo2');
        }
      });
    } catch (e) {
      print('Errore nella query a Firestore: $e');
    }
  }

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
                          fontSize: 22,
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
                            fontSize: 22,
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
                            fontSize: 22,
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
                                  const FlSpot(0, 3),
                                  const FlSpot(1, 1),
                                  const FlSpot(2, 4),
                                  const FlSpot(3, 2),
                                  const FlSpot(4, 5),
                                  const FlSpot(5, 1),
                                  const FlSpot(6, 4),
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
                      height: 20,
                    ),
                    Text(
                      "Current temperature: $currentTemp °C",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
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
                                  const FlSpot(0, 3),
                                  const FlSpot(1, 1),
                                  const FlSpot(2, 4),
                                  const FlSpot(3, 2),
                                  const FlSpot(4, 5),
                                  const FlSpot(5, 1),
                                  const FlSpot(6, 4),
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
                      height: 20,
                    ),
                    Text(
                      "Current consumption: $currentElec watt",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
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
