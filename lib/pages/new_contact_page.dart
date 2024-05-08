import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  static const String routeName = '/new_contact';

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New contact',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveContact,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (value.length > 20) {
                    return 'Name must be less than 20 characters';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: mobileController,

                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    filled: true,
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (value.length < 11) {
                    return 'Mobile number must be bigger than 10 characters';
                  }
                  if (value.length > 14) {
                    return 'Mobile number must be less than 14 characters';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email Address',
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller:  addressController,
                decoration: const InputDecoration(
                    labelText: 'Street Address',
                    filled: true,
                    prefixIcon: Icon(Icons.add_road),
                    border: OutlineInputBorder()),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: websiteController,
                decoration: const InputDecoration(
                    labelText: 'Website',
                    filled: true,
                    prefixIcon: Icon(Icons.web_asset),
                    border: OutlineInputBorder()),
                validator: (value) {
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if (formKey.currentState!.validate()) {
      final name = nameController.text;
      final mobile = mobileController.text;
      final email = emailController.text;
      final address = addressController.text;
      final website = websiteController.text;
      final contact = ContactModel(
        name: name,
        mobile: mobile,
        email: email,
        address: address,
        website: website
      );

      context.read<ContactProvider>().addContact(contact).then((rowId) =>Navigator.pop(context));


    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.dispose();
  }
}
