import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/calculator.dart';
import 'package:cafeteria_app/widgets/dialog_message.dart';
import 'package:cafeteria_app/widgets/show_info_item.dart';
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ViewType {
  menuViewer,
  editItem,
  calculator,
}

class OrderAvaible extends StatefulWidget{
  final DocumentSnapshot<Object?> currentOrder;

  const OrderAvaible({
    super.key,
    required this.currentOrder,
  });

  @override
  // ignore: no_logic_in_create_state
  State<OrderAvaible> createState() => _OrderAvaibleState(currentOrderTicket: currentOrder);
}

class _OrderAvaibleState extends State<OrderAvaible> {
  String? selectedMenu;
  String? selectedCategory;
  ViewType viewType = ViewType.menuViewer;
  DocumentSnapshot currentOrderTicket;

  _OrderAvaibleState({
    required this.currentOrderTicket
  });

  Map<String, dynamic>? selectedProductToEdit;
  bool isPayButtonEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    double totalAmount = _calculateTotalAmount(); // Calcula el total del ticket
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('--- Order Avaible ----'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {

          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // Determinamos cómo dividir la pantalla en secciones según las dimensiones.
          if (screenWidth > screenHeight) {
            return Row(
              children: [
                ticketViewer(),
                Expanded(
                  child: viewType == ViewType.menuViewer 
                  ? menuViewer(userProvider.currentUser.userId!, screenWidth/2, screenHeight)
                  :  viewType == ViewType.editItem
                    ? editItem(selectedProductToEdit!,userProvider.currentUser.userId!)
                    : viewType == ViewType.calculator
                      ? ShowCalculator(
                        totalAmount: totalAmount,
                        onMenuPressed: (){
                          setState(() {
                            viewType = ViewType.menuViewer;
                            isPayButtonEnabled = true;
                          });
                        },
                        onPayPressed: (totalBill, paidAmount, change) {
                          _updateTicketStatus(totalBill, paidAmount,change);
                          Navigator.of(context).pop();
                        },
                      )
                      : const SizedBox()
                ),
                //menuViewer(userProvider.currentUser.userId!, screenWidth/2, screenHeight),
              ],
            );
          } else { // Si el ancho es menor que el alto, dividir verticalmente
            return Column(
              children: [
                ticketViewer(),
                Expanded(
                  child: viewType == ViewType.menuViewer 
                  ? menuViewer(userProvider.currentUser.userId!, screenWidth, screenHeight/2)
                  :  viewType == ViewType.editItem
                    ? editItem(selectedProductToEdit!, userProvider.currentUser.userId!)
                    : viewType == ViewType.calculator
                      ? ShowCalculator(
                        totalAmount: totalAmount,
                        onMenuPressed: (){
                          setState(() {
                            viewType = ViewType.menuViewer;
                            isPayButtonEnabled = true;
                          });
                        },
                        onPayPressed: (totalBill, paidAmount, change) {
                          _updateTicketStatus(totalBill, paidAmount,change);
                          Navigator.of(context).pop();
                        },
                      )
                      : const SizedBox()
                ),
                //menuViewer(userProvider.currentUser.userId!, screenWidth, screenHeight),
              ],
            );
          }
        },
      ),
    );
  }

  double _calculateTotalAmount() {
    List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(currentOrderTicket['products']);
    return products.fold(0.0, (sum, item) => sum + item['price']);
  }

  Widget editItem(Map<String, dynamic> product, String userId) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: (){
                            setState(() {
                              viewType = ViewType.menuViewer;
                            });
                          }, 
                          icon: const Icon(Icons.menu_book_outlined), 
                          label: const Text('View Menu')
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () async{
                            try {
                              DocumentSnapshot<Object?> item = await fetchProduct(product, userId);
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowInfoItem(item: item);
                                },
                              );
                            } catch (e) {
                              // ignore: use_build_context_synchronously
                              _showSnackbar(context, 'Error al obtener la información del producto');
                            }
                          },
                          icon: const Icon(Icons.info),
                          label: const Text('Info'),
                        ),
                      ],
                    )
                  ]
                )
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
          const Spacer(),
          Center(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (product['quantity'] > 1) {
                      setState(() {
                        product['quantity']--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove, color: Colors.pinkAccent)
                ),
                SizedBox(
                  width: 50, // Ajusta el ancho según sea necesario
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: product['quantity'].toString()),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      product['quantity']++;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.pinkAccent)
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          const Spacer(),
          //const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async{

                  DocumentReference orderRefEdit = FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(widget.currentOrder.id);
                  
                  DocumentSnapshot orderEditSnapshot = await orderRefEdit.get();
                  List<dynamic> currentProducts = orderEditSnapshot['products'];

                  int productIndex = currentProducts.indexWhere((p) => p['item_id'] == product['item_id']);
                  if (productIndex != -1) {
                    currentProducts[productIndex]['quantity'] = product['quantity'];
                    currentProducts[productIndex]['price'] = product['quantity'] * currentProducts[productIndex]['unit_price'];
                    await orderRefEdit.update({'products': currentProducts});
                  }

                  DocumentSnapshot updatedOrderSnapshot = await orderRefEdit.get();
                  // Actualizar el estado del widget con la nueva orden
                  setState(() {
                    currentOrderTicket = updatedOrderSnapshot;
                    viewType = ViewType.menuViewer;
                  });
                  
                },
                icon: const Icon(Icons.done),
                label: const Text('Done'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  showDialogMessage(
                    context, 
                    const Text('¿Seguro que deseas eliminar el prodcuto del del ticket', 
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
                            const TextSpan(text:'Se elimnaran todos los productos que ha seleccionado',
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
                        DocumentReference orderRefDelete = FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(widget.currentOrder.id);
                        
                        DocumentSnapshot orderRefSnapshot = await orderRefDelete.get();
                        List<dynamic> currentProducts = List.from(orderRefSnapshot['products']);
                        int productToDelete = currentProducts.indexWhere((p) => p['item_id'] == product['item_id']);

                        if(productToDelete != -1){
                          //Se elimina el producto de la lista de productos
                          currentProducts.removeAt(productToDelete);
                          //Se actualiza el documento
                          await orderRefDelete.update({'products': currentProducts});
                          // Obtener una nueva instantánea del documento de la orden actual
                          DocumentSnapshot updatedOrderSnapshot = await orderRefDelete.get();
                          // Actualizar el estado del widget con la nueva orden
                          setState(() {
                            currentOrderTicket = updatedOrderSnapshot;
                            viewType = ViewType.menuViewer;
                          });
                        }
                      } catch (error) {
                        // Manejo de errores
                        showToast(message: 'Error al eliminar el produco: $error');
                      }
                      setState(() {
                        
                      });
                    } 
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('Remove'),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
  
  Widget ticketViewer() {
  List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(currentOrderTicket['products']);
  
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Ticket #${currentOrderTicket['number_of_ticket']}',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const Divider(
              color: Colors.pinkAccent,
              thickness: 2,
              height: 30,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        "Empty Ticket",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: isPayButtonEnabled
                                ? () {
                                    setState(() {
                                      selectedProductToEdit = products[index];
                                      viewType = ViewType.editItem;
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '${products[index]["quantity"]}',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${products[index]["name"]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${products[index]["price"]}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(
              color: Colors.pinkAccent,
              thickness: 2,
              height: 30,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      _deleteTicket(widget.currentOrder.id, () {
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 8,
                    ),
                    child: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: (isPayButtonEnabled && products.isNotEmpty)
                        ? () {
                            setState(() {
                              viewType = ViewType.calculator;
                              isPayButtonEnabled = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                closeIconColor: Colors.black,
                                showCloseIcon: true,
                                backgroundColor: Colors.amber,
                                content: Text(
                                  'Ingresa el monto pagado por el cliente',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Pay Ticket', 
                      style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget menuViewer(String userId, double width, double height) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 243, 247),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'MENÚS',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .collection('menus')
                      .snapshots(),
                      
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          List<Map<String, dynamic>> menus = snapshot.data!.docs.map((doc) => {'id': doc.id, 'name_menu': doc['name_menu']}).toList();
                          return Wrap(
                            spacing: 15.0,
                            runSpacing: 10.0,
                            children: List.generate(
                              menus.length,
                              (index) => ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedMenu = menus[index]['id'];
                                    selectedCategory = null;
                                  });
                                },
                                style:  ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 6,
                                ),
                                child: Text(menus[index]['name_menu'], style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 25.0),
                
                    if (selectedMenu != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CATEGORIAS',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent
                            ),
                          ),
                          const SizedBox(height: 15.0),
                
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(userId)
                            .collection('menus')
                            .doc(selectedMenu)
                            .collection('categories')
                            .snapshots(),
                
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Text('No hay categorías disponibles para este menú.');
                              } else {
                                List<Map<String, dynamic>> categories = snapshot.data!.docs.map((doc) => {'id': doc.id, 'name_category': doc['name_category']}).toList();
                                return Wrap(
                                  spacing: 15.0,
                                  children: List.generate(
                                    categories.length,
                                    (index) => ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = categories[index]['id'];
                                        });
                                      },
                                      style:  ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pinkAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        elevation: 1,
                                      ),
                                      child: Text(categories[index]['name_category'], style: const TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 25.0),
                
                          if (selectedCategory != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PRODUCTOS',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userId)
                                  .collection('menus')
                                  .doc(selectedMenu)
                                  .collection('categories')
                                  .doc(selectedCategory)
                                  .collection('items')
                                  .snapshots(),
                                  
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                      return const Text('No hay productos disponibles para esta categoría.');
                                    } else {
                                      List<Map<String, dynamic>> items = snapshot.data!.docs.map((doc) => {
                                        'id_item': doc.id, 
                                        'name_item': doc['name_item'],
                                        'price_item': doc['price_item']
                                      }).toList();
                                      return Wrap(
                                        spacing: 15.0,
                                        runSpacing: 16.0,
                                        children: List.generate(
                                          items.length,
                                          (index) => ElevatedButton(
                                            onPressed: () async {
                                              await addItemTicket(items, index, context);
                    
                                            }, 
                                            style:  ElevatedButton.styleFrom(
                                              backgroundColor: Colors.pinkAccent,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              elevation: 1,
                                            ),
                                            child: Text(items[index]['name_item'], style: const TextStyle(fontSize: 18)),
                                          )
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addItemTicket(List<Map<String, dynamic>> items, int index, BuildContext context) async {
    Map<String, dynamic> selectedProduct = items[index];
    String productId = selectedProduct['id_item'];
    String productName = selectedProduct['name_item'];
    double productPrice = selectedProduct['price_item'];
    
    // Obtener la referencia de la orden actual
    DocumentReference orderRef = FirebaseFirestore.instance
      .collection('Orders')
      .doc(currentOrderTicket.id);
    
    // Obtener la orden actual para verificar si el producto ya está añadido
    DocumentSnapshot orderSnapshot = await orderRef.get();
    List<dynamic> products = orderSnapshot['products'];
    
    bool productExists = products.any((product) => product['item_id'] == productId);
    
    if(productExists){
      // ignore: use_build_context_synchronously
      _showSnackbar(
        context, 
        'El producto ya está añadido. Selecciona el producto dentro del ticket para editar la cantidad.'
      );
    }else{
      // Crear el nuevo producto a añadir
      Map<String, dynamic> newProduct = {
        'item_id': productId,
        'name': productName,
        'quantity': 1,
        'unit_price': productPrice,
        'price': productPrice,
        'menu_id': selectedMenu,
        'category_id': selectedCategory,
      };
    
      // Añadir el nuevo producto al array de productos
      products.add(newProduct);
    
      // Actualizar la orden en Firebase
      await orderRef.update({'products': products});

      // Obtener el documento actualizado de Firebase
      DocumentSnapshot updatedOrderSnapshot = await orderRef.get();
      // Actualizar el estado del widget con la nueva orden
      setState(() {
        currentOrderTicket = updatedOrderSnapshot;
      });
    
      // Mostrar un mensaje de confirmación
      // ignore: use_build_context_synchronously
      _showSnackbar(context, 'Producto añadido al ticket.');
    }
  }

  Future<void> _updateTicketStatus(double totalAmount, double paidAmount, double change) async {
    DocumentReference orderRef = FirebaseFirestore.instance
        .collection('Orders')
        .doc(currentOrderTicket.id);
    
    await orderRef.update({
      'ticket_status': 'paid',
      'is_open': false,
      'total': totalAmount,
      'paidAmount': paidAmount,
      'change': change,
    });
  }
  
  void _deleteTicket(String ticketId, Function() buttonAccpet){
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
        final ordersCollection = FirebaseFirestore.instance.collection('Orders');

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Eliminar el documento principal del menú
          final docRefToDelete = ordersCollection.doc(ticketId);
          transaction.delete(docRefToDelete);
          
        });

        setState(() {
          buttonAccpet();
        });
      } catch (error) {
        // Manejo de errores
        showToast(message: 'Error al eliminar el ticket: $error');
      }
      setState(() {
        
      });
    } 
  );
  }
}



void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold),),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<DocumentSnapshot<Object?>> fetchProduct(Map<String, dynamic> product, String userId) async { 
  String menuId = product['menu_id']; 
  String categoryId = product['category_id'];
  String productId = product['item_id'];

  DocumentSnapshot<Object?> docProductSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('menus')
      .doc(menuId)
      .collection('categories')
      .doc(categoryId)
      .collection('items')
      .doc(productId)
      .get();

  if (docProductSnapshot.exists) {
    return docProductSnapshot;
  } else {
    throw Exception("Product not found");
  }
}