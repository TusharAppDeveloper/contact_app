import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:contact_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});

  static const String routeName = '/details_page';
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute
        .of(context)!
        .settings
        .arguments as int;
    final contact =
    Provider.of<ContactProvider>(context).getContactFromCache(id);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Details Page',
          ),
          centerTitle: true,
        ),
        body: Consumer<ContactProvider>(
            builder: (context, provider, child) =>
                ListView(
                  children: [
                    Stack(
                      children: [
                        contact.image == null || contact.image!.isEmpty
                            ? Image.asset(
                          'images/image_not_found.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          File(
                            contact.image!,
                          ),
                          width: double.infinity,
                          height: 150,
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: FloatingActionButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: const Text('Edit Image'),
                                      content: const Text(
                                          'want to edit image?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('CANCEL'),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            updateImage(
                                              context,
                                              id,
                                              ImageSource.camera,
                                            );
                                          },
                                          icon: const Icon(Icons.camera_alt),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            updateImage(
                                                context, id,
                                                ImageSource.gallery);
                                          },
                                          icon: const Icon(Icons.photo),
                                        )
                                      ],
                                    ),
                              );
                            },
                            child: const Icon(Icons.edit),
                          ),
                        )
                      ],
                    ),
                    ListTile(
                      title: Text(contact.mobile),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _callContact(context, contact.mobile);
                            },
                            icon: const Icon(Icons.call),
                          ),
                          IconButton(
                            onPressed: () {
                              _smsContact(context, contact.mobile);
                            },
                            icon: const Icon(Icons.sms),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          contact.email == null || contact.email!.isEmpty
                              ? 'Email not found'
                              : contact.email!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showSingleInputDialog(
                                context: context,
                                title: 'Edit email?',
                                hintText: 'Enter email address',
                                onSave: (value) {
                                  Provider.of<ContactProvider>(context , listen: false)
                                      .updateContactSingleColumn(
                                    id, tblContactEmail, value,);
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _emailContact(context, contact.email!);
                            },
                            icon: const Icon(Icons.email),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          contact.address == null || contact.address!.isEmpty
                              ? 'Address not found'
                              : contact.address!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showSingleInputDialog(
                                context: context,
                                title: 'Edit address?',
                                hintText: 'Enter address',
                                onSave: (value) {
                                  Provider.of<ContactProvider>(context , listen: false)
                                      .updateContactSingleColumn(
                                    id, tblContactAddress, value,);
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _openLocationOnMap(context, contact.address!);
                            },
                            icon: const Icon(Icons.map),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          contact.website == null || contact.website!.isEmpty
                              ? 'Website not found'
                              : contact.website!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showSingleInputDialog(
                                context: context,
                                title: 'Edit website?',
                                hintText: 'Enter website',
                                onSave: (value) {
                                  Provider.of<ContactProvider>(context , listen: false)
                                      .updateContactSingleColumn(
                                    id, tblContactWebsite, value,);
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _openWebsite(context, contact.website!);
                            },
                            icon: const Icon(Icons.web),
                          )
                        ],
                      ),
                    ),
                  ],
                )));
  }

  updateImage(BuildContext context, int id, ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      final path = xFile.path;
      context
          .read<ContactProvider>()
          .updateContactSingleColumn(id, tblContactImage, path);
      Navigator.pop(context);
    }
  }

  void _callContact(BuildContext context, String mobile) async {
    final urlString = 'tel:$mobile';
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMsg(context, 'Could not perform this action');
    }
  }

  void _smsContact(BuildContext context, String mobile) async {
    final urlString = 'sms:$mobile';
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMsg(context, 'Could not perform this action');
    }
  }

  void _emailContact(BuildContext context, String email) async {
    final urlString = 'mailto:$email';
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMsg(context, 'Could not perform this action');
    }
  }

  void _openLocationOnMap(BuildContext context, String address) async {
    String urlString;
    if (Platform.isAndroid) {
      urlString = 'geo:0,0?q=$address';
    } else {
      urlString = 'http://maps.apple.com/?q=$address';
    }

    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMsg(context, 'Could not perform this action');
    }
  }

  void _openWebsite(BuildContext context, String website) async {
    final urlString = 'https:$website';
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      showMsg(context, 'Could not perform this action');
    }
  }

// FutureBuilder<ContactModel> buildFutureBuilder(ContactProvider provider, int id) {
//   return FutureBuilder<ContactModel>(
//             future: provider.getContactById(id),
//             builder: (context, snapShot) {
//               if (snapShot.hasData) {
//                 final contact = snapShot.data!;
//                 return Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ListView(
//                     children: [
//                       Stack(
//                         children: [
//                           contact.image == null || contact.image!.isEmpty
//                               ? Image.asset(
//                             'images/image_not_found.png',
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           )
//                               : Image.file(
//                             File(
//                               contact.image!,
//                             ),
//                             width: double.infinity,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           ),
//                           Positioned(
//                             right: 10,
//                             bottom: 10,
//                             child: FloatingActionButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text('Edit Image'),
//                                     content: const Text('want to edit image?'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () => Navigator.pop(context),
//                                         child: const Text('CANCEL'),
//                                       ),
//                                       IconButton(
//                                         onPressed: (){},
//                                         icon: const Icon(Icons.camera_alt),
//                                       ),
//                                       IconButton(
//                                         onPressed: (){},
//                                         icon: const Icon(Icons.photo),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Icon(Icons.edit),
//                             ),
//                           )
//                         ],
//                       ),
//                       ListTile(
//                         title: Text(contact.mobile),
//                       )
//                     ],
//                   ),
//                 );
//               }
//               if (snapShot.hasError) {
//                 return const Center(
//                   child: Text('Cannot perform this action'),
//                 );
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },
//           );
// }
}
