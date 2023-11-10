// ignore_for_file: sort_child_properties_last, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
//__________________________________ APPBAR _______________________________________________________________________________________________________-

      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(
          child: Text(
            'COMPANY NAME',
            style: TextStyle(
              fontSize: 31,
            ),
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
                        onPressed: () {}, //_logout,
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
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(),
                Text(
                  "Electrical consumption",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const Divider(),
                Center(
                  child: Container(
                    width: 300.0, // Larghezza specifica
                    height: 300.0, // Altezza specifica
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 7,
                        minY: 0,
                        maxY: 6,
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
                            isCurved: true, // Abilita la curvatura della linea
                            color: Colors.blue,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(),
                Center(
                  child: Container(
                    width: 300.0, // Larghezza specifica
                    height: 300.0, // Altezza specifica
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 7,
                        minY: 0,
                        maxY: 6,
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
                            isCurved: true, // Abilita la curvatura della linea
                            color: Colors.blue,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
