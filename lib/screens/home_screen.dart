import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:valley/utils/querysize_device.dart';
import 'package:valley/utils/routes.dart';
import 'package:valley/widgets/text_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatelessWidget {
  final box = GetStorage();

  HomeScreen({super.key});

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
            padding: EdgeInsets.only(left: kIsWeb ? 20 : 0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: kIsWeb ? 30 : deviceSize.height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    TextBold(
                      text: 'Welcome to CSS Faculty',
                      fontSize: kIsWeb ? 48 : 22,
                      color: Colors.white,
                    ),
                    const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('role', isEqualTo: 'Teacher')
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
                      return kIsWeb
                          ? Expanded(
                              child: SizedBox(
                                child: GridView.builder(
                                  itemCount: data.docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          box.write('id', data.docs[index].id);
                                          Navigator.pushReplacementNamed(
                                              context, Routes().facultyscreen);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/images/profile.png',
                                                  height:
                                                      deviceSize.width < 1300
                                                          ? 100
                                                          : 125),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextBold(
                                                text: data.docs[index]['name'],
                                                fontSize: 28,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: ListView.builder(
                                    itemCount: data.docs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 5, 5, 5.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            box.write(
                                                'id', data.docs[index].id);
                                            Navigator.pushReplacementNamed(
                                                context,
                                                Routes().facultyscreen);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'assets/images/profile.png',
                                                    height: 125),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextBold(
                                                  text: data.docs[index]
                                                      ['name'],
                                                  fontSize: 28,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
