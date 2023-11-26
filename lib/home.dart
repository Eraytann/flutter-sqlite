// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/local_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  runApp(const ThorForm());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ThorForm(),
    );
  }
}

class ThorForm extends StatefulWidget {
  const ThorForm({super.key});

  @override
  _ThorFormState createState() => _ThorFormState();
}

class _ThorFormState extends State<ThorForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void clearTextField() {
    nameController.clear();
    surnameController.clear();
    ageController.clear();
    emailController.clear();
  }

  void getUsers() async {
    await LocalDatabase().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Sqlite'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: _textFormFieldWidgets,
              ),
              const SizedBox(height: 20),
              _submitButtonWidget(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    getUsers();
                  });
                },
                child: const Text('Retrieve User'),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text("Name: ${dataList[index]['name']}"),
                        subtitle:
                            Text("Surname: ${dataList[index]['surname']}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> get _textFormFieldWidgets {
    return <Widget>[
      _TextFormFieldWidget(
        controller: nameController,
        labelText: 'Name',
      ),
      _TextFormFieldWidget(
        controller: surnameController,
        labelText: 'Surname',
      ),
      _TextFormFieldWidget(
        controller: ageController,
        labelText: 'Age',
      ),
      _TextFormFieldWidget(
        controller: emailController,
        labelText: 'Email',
      ),
    ];
  }

  ElevatedButton _submitButtonWidget() {
    return ElevatedButton(
      onPressed: () async {
        await LocalDatabase().addDataLocally(
          name: nameController.text,
          surname: surnameController.text,
          age: ageController.text,
          email: emailController.text,
        );

        clearTextField();
      },
      child: const Text('Submit'),
    );
  }
}

class _TextFormFieldWidget extends StatelessWidget {
  const _TextFormFieldWidget(
      {required this.controller, required this.labelText});

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
