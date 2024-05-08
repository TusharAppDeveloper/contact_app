import 'package:contact_app/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  final String _createTableContact = '''create table $tblContact(
  $tblContactId integer primary key,
  $tblContactName text,
  $tblContactMobile text,
  $tblContactEmail text,
  $tblContactAddress text,
  $tblContactWebsite text,
  $tblContactFavorite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = path.join(root, 'contact.db');
    return openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) {
        db.execute(_createTableContact);
      },
      onUpgrade: ( db , int oldVersion , int newVersion){
        if(newVersion == 2){
          db.execute('alter table $tblContact add column $tblContactImage text default ""');
        }

      }
    );
  }

  Future<int> addContact(ContactModel contactModel) async {
    final db =await _open();
    return db.insert(tblContact, contactModel.toMap());
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db =await _open();
     final List<Map<String , dynamic>> mapList = await db.query(tblContact);
     return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<List<ContactModel>> getAllFavoriteContacts() async {
    final db =await _open();
    final List<Map<String , dynamic>> mapList = await db.query(tblContact,where: '$tblContactFavorite = ?',whereArgs: [1]);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<ContactModel> getContactById(int id) async {
    final db =await _open();
    final List<Map<String , dynamic>> mapList = await db.query(tblContact,where: '$tblContactId = ?',whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  Future<int> updateContactSingleColumn(int rowId , Map<String , dynamic> map) async{
    final db =await _open();
    return db.update(tblContact, map,where: '$tblContactId = ?',whereArgs: [rowId]);
  }

  Future<int> deleteContact(int rowId) async {
    final db =await _open();
    return db.delete(tblContact,where: '$tblContactId = ?',whereArgs: [rowId]);
  }

}
