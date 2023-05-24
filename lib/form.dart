// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:member_jkt48/main.dart';

class FormPage extends StatefulWidget {
  // Konstruktor memiliki satu parameter, parameter opsional
  // Jika memiliki id, kita akan menampilkan data dan menjalankan metode update
  // Jika tidak, jalankan penambahan data
  const FormPage({this.id});

  final String? id;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Mengatur kunci formulir
  final _formKey = GlobalKey<FormState>();

  // Mengatur variabel text editing controller
  var nameController = TextEditingController();
  var generationController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();

  // Menginisialisasi instance firebase
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  CollectionReference? members;

  void getData() async {
    // Mendapatkan koleksi 'members' dari Firebase
    // Koleksi ini adalah tabel di firebase
    members = firebase.collection('members');

    // Jika memiliki id
    if (widget.id != null) {
      // Mendapatkan data pengguna berdasarkan id dokumen
      var data = await members!.doc(widget.id).get();

      // Kita mendapatkan data.data()
      // Agar dapat diakses, kita membuatnya sebagai map
      var item = data.data() as Map<String, dynamic>;

      // Mengatur state untuk mengisi kontroler data dari firebase
      setState(() {
        nameController = TextEditingController(text: item['name']);
        generationController =
            TextEditingController(text: item['generation']);
        emailController = TextEditingController(text: item['email']);
        addressController = TextEditingController(text: item['address']);
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Member JKT48"),
        actions: [
          // Jika memiliki data, tampilkan tombol hapus
          widget.id != null
              ? IconButton(
                  onPressed: () {
                    // Metode untuk menghapus data berdasarkan id
                    members!.doc(widget.id).delete();

                    // Kembali ke halaman utama
                    // '/' adalah halaman utama
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(Icons.delete),
                )
              : SizedBox()
        ],
      ),
      // Formulir ini untuk menambahkan dan mengedit data
      // Jika memiliki id yang dilewatkan dari main, bidang akan menampilkan data
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            SizedBox(height: 10),
            Image(
              // Menggunakan gambar dari resource lokal
             image: AssetImage('images/logojkt.png'),
                  width: 50, // Menentukan lebar gambar
              height: 60, // Menentukan tinggi gambar
            ),
            Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Name is Required!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Generation',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: generationController,
              decoration: InputDecoration(
                hintText: "Generation",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Generation is Required!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email is Required!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
              'Address',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: addressController,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Address is Required!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Jika id tidak null, jalankan penambahan data untuk menyimpan data ke firebase
                  // Jika tidak, perbarui data berdasarkan id
                  if (widget.id == null) {
                    members!.add({
                      'name': nameController.text,
                      'generation': generationController.text,
                      'email': emailController.text,
                      'address': addressController.text,
                    });
                  } else {
                    members!.doc(widget.id).update({
                      'name': nameController.text,
                      'generation': generationController.text,
                      'email': emailController.text,
                      'address': addressController.text,
                    });
                  }
                  // Notifikasi snackbar
                  final snackBar =
                      SnackBar(content: Text('Data saved successfully!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  // Kembali ke halaman utama
                  // Halaman utama => '/'
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (Route<dynamic> route) => false,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
