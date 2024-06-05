import 'package:cafeteria_app/app/UI/screens/order_avaible.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/dialog_message.dart';
import 'package:cafeteria_app/widgets/icon_progres_indicator.dart';
import 'package:cafeteria_app/widgets/icon_text_button.dart';
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: true);

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
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersCollection
            .where('id_user', isEqualTo: userProvider.currentUser.userId)
            .where('is_open', isEqualTo: true)
            .snapshots(),
          //future: ordersCollection.where('id_user', isEqualTo: userProvider.currentUser.userId).get(),
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
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 20,
                      runSpacing: 30,
                      children: [

                        ...orders.map((order) => 
                          IconTextButton(
                            labelText: 'Order \n ${order['number_of_ticket']}',
                            //labelText: 'Order \n 5',
                            icon: Icons.receipt_sharp,
                            height: 220,
                            width: 120,
                            onTap: () {
                              //Navigator.pushNamed(context, Routes.orderManagment);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderAvaible(currentOrder: order),
                                ),
                              );
                            },
                            deleteButton: () {
                              _deleteTicket(order.id);
                            },
                            canDeleted: true,
                          ) 
                        ),

                        IconTextButton(
                          labelText: 'Add', 
                          icon: Icons.add_circle,
                          height: 220,
                          width: 110,

                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Scaffold(
                                    body: Center(
                                      child: IconProgressInidcator(),
                                    ),
                                  ), // Pantalla de carga mientras se agregan los datos
                              ),
                            );
                            _addTicket(userProvider.currentUser.userId!);
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
  Future<void> _addTicket(String userId) async {
    DateTime now = DateTime.now();

    // Formato para id del ticket
    String day = now.day.toString().padLeft(2, '0'); 
    String month = now.month.toString().padLeft(2, '0'); 
    String hour = now.hour.toString().padLeft(2, '0'); 
    String minute = now.minute.toString().padLeft(2, '0');
    String seconds = now.second.toString().padLeft(2, '0');


    //String number_of_ticket = hour + minute + '/' + day + month;
    String idTicket = "$hour$minute-$seconds/${day}_$month";

    try {
      DocumentReference newTicketRef = await ordersCollection.add({
        'id_user': userId,
        'is_open': true,
        'ticket_status': 'open',
        'ticket_creation_date': FieldValue.serverTimestamp(),
        'number_of_ticket': idTicket,
        'products': [], 
      });

      // Actualizar el documento con el ID del mismo
      await newTicketRef.update({
        'id_ticket': newTicketRef.id,
      });
      
      DocumentSnapshot<Object?> newTicketSnapshot = await newTicketRef.get();
      // Navegar a la pantalla de OrderAvaible con el nuevo ticket
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderAvaible(currentOrder: newTicketSnapshot),
        ),
      );

    } catch (e) {
      if (kDebugMode) {
        print('Error al agregar el ticket: $e');
      }
    }
  }

  // Función para agregar un nuevo ticket
  void _deleteTicket(String ticketId){
    showDialogMessage(
    context, 
    const Text('¿Seguro que deseas eliminar este Ticket?', 
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 25
      ),
    ), 
    Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: 
            const TextSpan(text:'Tenga en consideración que toda la información que contenga el ticket sera eliminado de forma permanente',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    () async {
      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Eliminar el documento principal del menú
          final docRef = ordersCollection.doc(ticketId);
          transaction.delete(docRef);
          
        });
      } catch (error) {
        // Manejo de errores
        showToast(message: 'Error al eliminar el menú: $error');
      }
      setState(() {
        
      });
    } 
  );
  }
}
