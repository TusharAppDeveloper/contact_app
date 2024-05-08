import 'package:contact_app/db/db_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier{
  List<ContactModel> contactList = [];
  final db = DbHelper();

  ContactModel getContactFromCache(int id) {
    return contactList.firstWhere((contact) => contact.id == id);

  }

  Future<int> addContact(ContactModel contactModel) async{
    final rowId = await db.addContact(contactModel);
    await getAllContacts();
    return rowId;

  }

  Future<void> getAllContacts() async {
    contactList =await db.getAllContacts();
    notifyListeners();
  }

  Future<void> getAllFavoriteContacts() async {
    contactList =await db.getAllFavoriteContacts();
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) async{
    return db.getContactById(id);
  }

  Future<int> updateContactSingleColumn(int rowId, String column , dynamic value) async {
     final id = db.updateContactSingleColumn(rowId, {column : value});
     await getAllContacts();
     return id;
  }

  Future<int> deleteContact(int rowId) async{
    final id = await db.deleteContact(rowId);
    getAllContacts();
    return id;
  }
}