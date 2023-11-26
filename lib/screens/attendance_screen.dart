import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/routes.dart';
import '../widgets/text_widget.dart';

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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
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
