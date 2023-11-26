import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:valley/utils/routes.dart';
import 'package:valley/widgets/text_widget.dart';

import '../widgets/event_dialog.dart';

class WorkloadScreen extends StatefulWidget {
  const WorkloadScreen({super.key});

  @override
  State<WorkloadScreen> createState() => _WorkloadScreenState();
}

class _WorkloadScreenState extends State<WorkloadScreen> {
  @override
  void initState() {
    super.initState();
    getEvents();
  }

  List<CalendarEvent> events = [];
  bool hasLoaded = false;

  getEvents() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .where('userId', isEqualTo: box.read('id'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        events.add(CalendarEvent(
            eventName: doc['name'],
            eventDate: doc['date'].toDate(),
            eventTextStyle: const TextStyle(fontFamily: 'Bold')));
      }

      setState(() {
        hasLoaded = true;
      });
    });
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 110,
              image: AssetImage(
                'assets/images/back.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes().facultyscreen);
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
                    SizedBox(height: 20,),
                Card(
                  child: SizedBox(
                    width: 500,
                    height: 500,
                    child: CellCalendar(
                      events: events,
                      onCellTapped: (date) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Events')
                                    .where('year', isEqualTo: date.year)
                                    .where('month', isEqualTo: date.month)
                                    .where('day', isEqualTo: date.day)
                                    .where('userId', isEqualTo: box.read('id'))
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    print('error');
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
                                  return EventDialog(
                                    events: [
                                      for (int i = 0; i < data.docs.length; i++)
                                        {
                                          'title': data.docs[i]['name'],
                                          'date': DateFormat.yMMMd()
                                              .add_jm()
                                              .format(
                                                  data.docs[i]['date'].toDate()),
                                          'id': data.docs[i].id,
                                          'details': data.docs[i]['details'],
                                        },
                                    ],
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}