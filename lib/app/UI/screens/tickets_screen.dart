import 'package:cafeteria_app/widgets/icon_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('Orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('-- Orders Avaible --'),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),

      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: ordersCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }else{
                final List<QueryDocumentSnapshot> orders = snapshot.data!.docs;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 25,
                      runSpacing: 20,
                      children: [

                        ...orders.map((order) => 
                          IconTextButton(
                            labelText: 'Ticket ${order.id}',
                            icon: Icons.receipt_sharp,
                            height: 220,
                            width: 140,
                            onTap: () {},
                            canDeleted: true,
                          ) 
                        ),

                        IconTextButton(
                          labelText: 'Add', 
                          icon: Icons.add_circle,
                          height: 220,
                          width: 120,

                          onTap: (){
                            _addTicket();
                          },
                        ),
                
                      ],
                    ),
                  ),
                );

              }
            }

            
          }
        ),
      ),
    );
  }

  // Función para agregar un nuevo ticket
  Future<void> _addTicket() async {
    try {
      await ordersCollection.add({
        'content': 'Nuevo ticket',
        // Puedes agregar más campos aquí si los necesitas
      });
      setState(() {
        // Actualiza la interfaz de usuario después de agregar el ticket
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al agregar el ticket: $e');
      }
    }
  }
}
