import 'package:cafeteria_app/widgets/icon_button_message.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int counterContacts = 1;

  List contactList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('- - Contact Suppliers - -'),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),

      body:  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    /// Search contact 
                    const Expanded(
                      child: SizedBox(
                        width: 700,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search',
                            prefixIcon: Icon(Icons.search)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
          
                    /// Add contact
                    ElevatedButton(
                      onPressed: () {  
                        //showDialog(context: context, builder: (BuildContext context) => const CreateContact());

                        contactList.add( ButtonContact(fullName: 'Nombre $counterContacts') );
                        counterContacts++;
                        setState(() {
                          
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(Icons.add_circle),
                            SizedBox(width: 5),
                            Text('Add contact'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox( height: 30),
                
                ...contactList,
          
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonContact extends StatelessWidget {
  final String fullName;

  const ButtonContact({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {
      // Acción al hacer clic en el contacto
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clickeado')));
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
                Row(
                  children: [
                    const Icon(Icons.person, size: 40),
                    const SizedBox(width: 16),
                    Text(fullName, style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Acción al hacer clic en el ícono de editar
                      },
                    ),
                    IconButtonMessage(
                      onPressed: (){

                      }, 
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

class CreateContact extends StatefulWidget {
  const CreateContact({super.key});

  @override
  State<CreateContact> createState() => _CreateContactState();
}

class Contact {
  String name = "";
  String lastName = "";
  String phoneNumber = "";
}

class _CreateContactState extends State<CreateContact> {
  final _formKey = GlobalKey<FormState>();
  final Contact _contact = Contact();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const Icon(Icons.supervised_user_circle_rounded, color: Colors.black),
      title: const Text('Crear nuevo contacto'),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre de contacto'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre del contacto';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contact.name = value!;
                      },
                  ),
                  const SizedBox(height: 12),
          
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el apellido del contacto';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _contact.lastName = value!;
                    },
                  ),
                  const SizedBox(height: 12),
          
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Número de Teléfono'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el número de teléfono del contacto';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _contact.phoneNumber = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(context, 'OK');
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
