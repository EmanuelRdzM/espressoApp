import 'package:cafeteria_app/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> iconTextButtons = [];
  int counterTicket = 1;
  
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 15,
              runSpacing: 15,
              children: [

                ...iconTextButtons,

                IconTextButton(labelText: 'Add', icon: Icons.add_circle,height: 220, width: 120,
                  onTap: (){
                    iconTextButtons.insert(
                      0, 
                      IconTextButton(
                        labelText: 'Ticket $counterTicket',
                        icon: Icons.receipt_sharp,
                        height: 220,
                        width: 120,
                        onTap: () {},
                      ),
                    );
                    counterTicket++;
                    setState(() {
                      
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}