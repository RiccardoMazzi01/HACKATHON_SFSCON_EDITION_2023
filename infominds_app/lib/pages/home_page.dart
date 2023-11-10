// ignore_for_file: sort_child_properties_last, prefer_final_fields, prefer_const_constructors

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
    super.initState();
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
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int currentTemp = 0;
  int currentElec = 0;

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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Date:   ${_formatDate(selectedDate)}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          alignment: Alignment.centerLeft,
                          color: Colors.blue,
                          iconSize: 35,
                          icon: Icon(Icons.arrow_drop_down),
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
                        width: 400.0, // Larghezza specifica
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
                        width: 400.0, // Larghezza specifica
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
            const Scaffold(),
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
            icon: Icon(Icons.list_alt),
            label: 'General consumptions',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensors',
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
