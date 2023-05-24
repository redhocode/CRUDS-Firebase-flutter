import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Member JKT48",
      home: const MyApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  late Query searchQuery;
  late Stream<QuerySnapshot> stream;

  void _runSearch() {
    setState(() {
      String searchText = searchController.text;
      searchQuery = FirebaseFirestore.instance
          .collection('members')
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: '${searchText}z');
      stream = searchQuery.snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    searchQuery = FirebaseFirestore.instance.collection('members');
    stream = searchQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Member JKT48"),
        ),
      ),
      body: Column(
        children: [
          // Textfield untuk melakukan pencarian
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _runSearch(),
            ),
          ),
          // Menampilkan hasil pencarian dalam ListView
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var alldata = snapshot.data!.docs;
                  return alldata.isNotEmpty
                      ? ListView.builder(
                          itemCount: alldata.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: const Image(
                                image: AssetImage('images/logojkt.png'),
                                width: 20,
                                height: 30,
                              ),
                              title: Text(
                                alldata[index]['name'],
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                'Generasi ke ${alldata[index]['generation']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  // Navigasi ke halaman FormPage dengan membawa ID data yang dipilih
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormPage(
                                        id: snapshot.data!.docs[index].id,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward_rounded),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No Data',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                } else {
                  // Tampilkan indikator loading ketika sedang memuat data
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      // Tombol untuk menambahkan data baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman FormPage untuk menambahkan data baru
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
