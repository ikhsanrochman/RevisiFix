import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBidangPage extends StatefulWidget {
  @override
  _AddBidangPageState createState() => _AddBidangPageState();
}

class _AddBidangPageState extends State<AddBidangPage> {
  final TextEditingController _bidangController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addBidang() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('bidang').add({
        'name': _bidangController.text.trim(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bidang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _bidangController,
                decoration: InputDecoration(
                  labelText: 'Bidang Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a bidang name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBidang,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
