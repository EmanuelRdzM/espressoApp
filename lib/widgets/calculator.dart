import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShowCalculator extends StatefulWidget {
  final VoidCallback onMenuPressed;
  final Function(double, double, double) onPayPressed;
  final double totalAmount;
  
  const ShowCalculator({
    super.key, 
    required this.onMenuPressed, 
    required this.onPayPressed,
    required this.totalAmount,
  });

  @override
  _ShowCalculatorState createState() => _ShowCalculatorState();
}

class _ShowCalculatorState extends State<ShowCalculator> {
  //String totalAmount = '200'; // Total amount
  String paidAmount = ''; // Amount paid
  String change = '----'; // Change
  Color changedColor = Colors.black;

  void _onKeyPress(String keyPressed) {
    if (keyPressed == 'C') {
      // Clear input
      setState(() {
        paidAmount = '';
        change = '----';
        changedColor = Colors.black;
      });
    } else if (keyPressed == '⟵') {
      // Backspace
      setState(() {
        if (paidAmount.isNotEmpty) {
          paidAmount = paidAmount.substring(0, paidAmount.length - 1);
        }
      });
      _updateChange();
    } else if(paidAmount.length <4){
      // Append pressed key to paid amount
      setState(() {
        paidAmount += keyPressed;
      });
      _updateChange();
    }
  }

  void _updateChange() {
    if (paidAmount.isNotEmpty){
      try {
        double paid = double.parse(paidAmount);
        if(paid >= widget.totalAmount){
          double changeAmount = paid - widget.totalAmount;
          setState(() {
            change = changeAmount.toStringAsFixed(2);
            changedColor = Color.fromARGB(255, 16, 200, 38);
          });
        }else{
          setState(() {
            change = '----';
            changedColor = Colors.black;
          });
        }
      } catch (e) {
        setState(() {
          change = '----';
          changedColor = Colors.black;
        });
      }

    }else{
      setState(() {
        change = '----';
        changedColor = Colors.black;
      });
    }
  }

  Future<void> _pay() async {
    if (paidAmount.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Monto de Pago Vacío'),
            content: const Text('Por favor, ingrese un monto pagado.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      double paid = double.parse(paidAmount);
      double changeAmount = paid - widget.totalAmount;

      if( paid < widget.totalAmount){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Monto Insuficiente'),
              content: const Text('El monto pagado es menor que el total.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }else{
        showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Confirmar Pago'),
            content: Text('Monto pagado: \$${paid.toStringAsFixed(2)}\nCambio: \$${changeAmount.toStringAsFixed(2)}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  widget.onPayPressed(widget.totalAmount, double.parse(paidAmount), double.parse(change));
                },
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = constraints.maxWidth * 0.035;
        double verticalSpacing = constraints.maxHeight * 0.02;
        double horizontalSpacing = constraints.maxHeight * 0.02;

        return Container(
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.all(horizontalSpacing),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Total: \$ ${widget.totalAmount}', 
                      style: TextStyle(
                        fontSize: fontSize, 
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Paid: \$ $paidAmount', 
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold, 
                        color: paidAmount.isEmpty || double.parse(paidAmount) < widget.totalAmount ? Colors.red : Colors.black
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Change: \$ $change', 
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: changedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: horizontalSpacing,
                      mainAxisSpacing: verticalSpacing,
                      childAspectRatio: 1.8,
                      children: [
                        _calcButton('1'),
                        _calcButton('2'),
                        _calcButton('3'),
                        _calcButton('4'),
                        _calcButton('5'),
                        _calcButton('6'),
                        _calcButton('7'),
                        _calcButton('8'),
                        _calcButton('9'),
                        _calcButton('⟵', backgroundColor: Colors.white),
                        _calcButton('0'),
                        _calcButton('C', backgroundColor: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.onMenuPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: APP_PRIMARY_COLOR_DARK,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Menu',style: TextStyle(fontSize: 15),),
                    ), 
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pay();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Pay \$ ${widget.totalAmount}', 
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _calcButton(
    String label, 
    {Color backgroundColor = APP_PRIMARY_COLOR_DARK}
  ){
    return LayoutBuilder(
      builder: (context, constraints) {
        return TextButton(
          onPressed: () => _onKeyPress(label),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.25),
            backgroundColor: backgroundColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: APP_PRIMARY_COLOR_DARK),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: constraints.maxHeight * 0.25), // Adjust the font size based on available height
          ),
        );
      }
    );
  }
}
