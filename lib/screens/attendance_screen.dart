import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/routes.dart';
import '../widgets/text_widget.dart';
import 'package:acs_nfc/acs_nfc.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AcsNfc.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    AcsNfc.connectionStatusStream
        .receiveBroadcastStream()
        .listen(nfcConnectionStatus);

    await AcsNfc.openConnection(ip: '192.168.137.1', port: '8001');
    AcsNfc.nfcDataStream.receiveBroadcastStream().listen(nfcData);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  bool isMNVRConnected = false;
  void nfcConnectionStatus(dynamic isConnected) {
    setState(() {
      isMNVRConnected = isConnected as bool;
    });
  }

  List<String> nfcTags = [];
  void nfcData(dynamic nfcJsonData) {
    print('=========================================');
    print(nfcJsonData);
    setState(() {
      nfcTags.add(nfcJsonData as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Text(
                'MNVR connection status: $isMNVRConnected',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 28,
                ),
              ),
              Text(
                'ip: 192.168.137.1, port: 8001',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 28,
                ),
              ),
              Text(
                'Connect MNVR by sim card',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                'adb tcpip 5555 ',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                'adb connect 192.168.16.100:5555',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontSize: 20,
                ),
              ),
              Text(
                '\nConnect Wifi Router: 192.168.16.254\nClick HiLink Logo> Operation Mode>\nGateway for Simcard, Not AP Client(Wifi)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.green.shade900,
                  fontSize: 20,
                ),
              ),
              ...nfcTags.map((text) => Text('NFC Tag: $text')),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
            opacity: 110,
            image: AssetImage(
              'assets/images/back.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Attendance')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                        );
                      }

                      final data = snapshot.requireData;
                      return Container(
                        height: 500,
                        // width: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection:
                              !kIsWeb ? Axis.horizontal : Axis.vertical,
                          child: DataTable(columns: [
                            DataColumn(
                              label: TextBold(
                                  text: 'Date',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Name',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Course',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Section',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Laboratory',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Computer',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            DataColumn(
                              label: TextBold(
                                  text: 'Attendance Type',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ], rows: [
                            for (int i = 0; i < data.docs.length; i++)
                              DataRow(
                                cells: [
                                  DataCell(
                                    TextRegular(
                                      text: DateFormat.yMMMd().add_jm().format(
                                          data.docs[i]['dateTime'].toDate()),
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['name'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['course'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['section'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['labname'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['computername'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  DataCell(
                                    TextRegular(
                                      text: data.docs[i]['attendancetype'],
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ]),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(right: 50, top: 30),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes().landingscreen);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      label: TextBold(
                        text: 'Back',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
