import 'package:flutter/material.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({Key? key}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: const Padding(padding: EdgeInsets.all(16), child: Text("data")),
    );
  }
}
