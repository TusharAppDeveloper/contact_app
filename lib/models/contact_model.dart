const String tblContact = 'tbl_contact';
const String tblContactId = 'id';
const String tblContactName = 'name';
const String tblContactMobile = 'mobile';
const String tblContactEmail = 'email';
const String tblContactAddress = 'address';
const String tblContactWebsite = 'website';
const String tblContactImage = 'image';
const String tblContactFavorite = 'favorite';

class ContactModel {
  int? id;
  String name;
  String mobile;
  String? email;
  String? address;
  String? website;
  String? image;
  bool favorite;

  ContactModel(
      {this.id,
      required this.name,
      required this.mobile,
      this.email,
      this.address,
      this.website,
      this.image,
      this.favorite = false});

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id:  map[tblContactId],
        name: map[tblContactName],
        mobile:  map[tblContactMobile],
        email:  map[tblContactEmail],
        address:  map[tblContactAddress],
        website:  map[tblContactWebsite],
        image: map[tblContactImage],
        favorite:  map[tblContactFavorite] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactName: name,
      tblContactMobile: mobile,
      tblContactEmail: email,
      tblContactAddress: address,
      tblContactWebsite: website,
      tblContactImage: image,
      tblContactFavorite: favorite ? 1 : 0
    };
    if (id != null) {
      map[tblContactId] = id;
    }
    return map;
  }
}
