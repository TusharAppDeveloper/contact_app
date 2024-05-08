
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/details_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFirst = true;
  int currentIndex = 0;


  @override
  void didChangeDependencies() {
    if(isFirst){
      context.read<ContactProvider>().getAllContacts();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact List',
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),

        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        child: const Icon(Icons.add),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 10,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          selectedFontSize: 15,
          selectedItemColor: Colors.brown,
          backgroundColor: Colors.cyan,
          currentIndex: currentIndex,
          onTap: (value){
            setState(() {
              currentIndex = value;
            });
            _loadData();

          },
          items:const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'All'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite'
            ),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => provider.contactList.isEmpty
            ? const Center(
                child: Text('No contact found'),
              )
            : ListView.builder(
                itemCount: provider.contactList.length,
                itemBuilder: (context, index) {
                  final contact = provider.contactList[index];
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: ValueKey(contact.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (_) {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Delete Contact?'),
                                content: Text(
                                    'Are you sure to delete contact ${contact.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('YES'),
                                  )
                                ],
                              ));
                    },
                    onDismissed: (_) {
                      context
                          .read<ContactProvider>()
                          .deleteContact(contact.id!);
                    },
                    child: ListTile(
                      onTap: () => Navigator.pushNamed(context, DetailsPage.routeName,arguments: contact.id),
                      title: Text(contact.name),
                      trailing: IconButton(
                        onPressed: () {
                          final value = contact.favorite ? 0 : 1;
                          provider.updateContactSingleColumn(
                              contact.id!, tblContactFavorite, value);
                        },
                        icon: Icon(contact.favorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _loadData() {
    if(currentIndex == 0){
      context.read<ContactProvider>().getAllContacts();
    } else{
      context.read<ContactProvider>().getAllFavoriteContacts();
    }
  }
}
