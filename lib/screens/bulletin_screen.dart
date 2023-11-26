import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:valley/widgets/button_widget.dart';
import 'package:valley/widgets/text_widget.dart';

import '../utils/routes.dart';

class FacultyBulletinScreen extends StatelessWidget {
  final box = GetStorage();

  FacultyBulletinScreen({super.key});

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
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBold(
                      text: 'CCS FACULTY BULLETIN OF SCHEDULE',
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextBold(
                          text: 'Calendar',
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: Card(
                            child: SizedBox(
                              width: 500,
                              height: 500,
                              child: CellCalendar(
                                onCellTapped: (date) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Reservations')
                                              .where('date',
                                                  isEqualTo:
                                                      '${date.year}-${date.month}-${date.day}')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              print('error');
                                              return const Center(
                                                  child: Text('Error'));
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 50),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.black,
                                                )),
                                              );
                                            }

                                            final data = snapshot.requireData;
                                            return Dialog(
                                              child: SizedBox(
                                                height: 500,
                                                width: 500,
                                                child: ListView.builder(
                                                  itemBuilder:
                                                      (context, index) {
                                                    return const ListTile();
                                                  },
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextBold(
                          text: 'Special Announcement',
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: SizedBox(
                            height: 500,
                            width: 400,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Announcements')
                                      .where('toshow', isEqualTo: true)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const Center(child: Text('Error'));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.black,
                                        )),
                                      );
                                    }

                                    final data = snapshot.requireData;
                                    return SizedBox(
                                      height: 300,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: data.docs.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: TextRegular(
                                                text:
                                                    'Title: ${data.docs[index]['description']}',
                                                fontSize: 14,
                                                color: Colors.black),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextBold(
                          text: 'Daily Reminders',
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: SizedBox(
                            height: 500,
                            width: 400,
                            child: ListView.separated(
                              itemCount: 20,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                return const ListTile();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonWidget(
                      color: Colors.black,
                      label: 'CCS Faculty Schedule',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes().homescreen);
                      },
                    ),
                    ButtonWidget(
                      color: Colors.black,
                      label: 'View Laboratory Schedule',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes().schedulescreen);
                      },
                    ),
                    ButtonWidget(
                      color: Colors.black,
                      label: 'View Attendance',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Routes().attendancescreen);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
