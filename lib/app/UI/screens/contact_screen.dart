import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/contact_details_dialog.dart';
import 'package:cafeteria_app/widgets/edit_contact_dialog.dart'; //It also includes the CreateContactDialog
import 'package:cafeteria_app/widgets/icon_button_message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  List<DocumentSnapshot> contactList = [];
  List<DocumentSnapshot> filteredContactList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    fetchContacts(userProvider.currentUser.userId!);
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void fetchContacts(String userStoreId) async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await contactsCollection
        .where('user_store_id', isEqualTo: userStoreId)
        .get();
    setState(() {
      contactList = snapshot.docs;
      filteredContactList = contactList;
      isLoading = false;
    });
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredContactList = contactList.where((contact) {
        final contactData = contact.data() as Map<String, dynamic>;
        final provider = contactData['provider'].toLowerCase();
        final phone = contactData['phone'].toLowerCase();
        final address = contactData['address'].toLowerCase();
        return provider.contains(query) ||
            phone.contains(query) ||
            address.contains(query);
      }).toList();
    });
  }

  void addContact(String userStoreId, String provider, String phone, String address) {
    contactsCollection.add({
      'user_store_id': userStoreId,
      'provider': provider,
      'phone': phone,
      'address': address,
    });
    fetchContacts(userStoreId);
  }

  void editContact(String userStoreId, String id, String provider, String phone, String address) {
    contactsCollection.doc(id).update({
      'provider': provider,
      'phone': phone,
      'address': address,
    });
    fetchContacts(userStoreId);
  }

  void deleteContact(String userStoreId, String id) {
    contactsCollection.doc(id).delete();
    fetchContacts(userStoreId);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Contact Suppliers'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // onChanged: (value) {
                      //   // mostrar los contactos con lo que se valla escribiendo, si se borra mostrar los contactos que pertenecen al usuario
                      // },
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const CreateContactDialog(),
                      );
                      if (result != null && result is Map<String, String>) {
                        addContact(
                          userProvider.currentUser.userId!, 
                          result['provider']!, 
                          result['phone']!, 
                          result['address']!
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(width: 5),
                        Text('Add contact'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...filteredContactList.map((contact) {
                        final contactData = contact.data() as Map<String, dynamic>;
                        return ButtonContact(
                          id: contact.id,
                          provider: contactData['provider'],
                          phone: contactData['phone'],
                          address: contactData['address'],
                          onEdit: (provider, phone, address) {
                            editContact(userProvider.currentUser.userId!, contact.id, provider, phone, address);
                          },
                          onDelete: () {
                            deleteContact(userProvider.currentUser.userId!, contact.id);
                          },
                        );
                      }).toList(),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonContact extends StatelessWidget {
  final String id;
  final String provider;
  final String phone;
  final String address;
  final void Function(String, String, String) onEdit;
  final VoidCallback onDelete;

  const ButtonContact({
    super.key,
    required this.id,
    required this.provider,
    required this.phone,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => 
            ContactDetailsDialog(idSupplier: id)
        );
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(207, 39, 92, 0.307),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 40),
                          const SizedBox(width: 16),
                          Text(provider, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) => EditContactDialog(
                              initialProvider: provider,
                              initialPhone: phone,
                              initialAddress: address,
                            ),
                          );
                          if (result != null && result is Map<String, String>) {
                            onEdit(result['provider']!, result['phone']!, result['address']!);
                          }
                        },
                      ),
                      IconButtonMessage(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete),
                        tittle: const Text('Seguro que deseas eliminar el contacto de tu agenda.'),
                        content: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'Tenga en consideración el contacto se eliminará dentro de la aplicación\n'),
                              TextSpan(
                                  text:
                                      'por lo que desaparecera su información, podra volver a agendarlo creando un nuevo contacto\n'),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}