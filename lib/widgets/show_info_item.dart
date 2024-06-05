import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowInfoItem extends StatelessWidget {
  const ShowInfoItem({
    super.key,
    required this.item,
  });

  final DocumentSnapshot<Object?> item;

  @override
  Widget build(BuildContext context) {
    final isHorizontal = MediaQuery.of(context).orientation == Orientation.landscape;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: SizedBox(
          width: isHorizontal
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.6, // Ancho del AlertDialog
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Bordes redondeados del Card
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.blueGrey[50],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nombre del producto
                    Text(
                      item['name_item'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isHorizontal)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              width: 300,
                              height: 170,
                              child: _buildImage(item),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildInfo(item),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 300,
                            height: 180,
                            child: _buildImage(item),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildInfo(item),
                          ),
                        ],
                      ),
                    const Divider(
                      color: Colors.pinkAccent,
                      thickness: 1.5,
                      height: 20,
                      indent: 15,
                      endIndent: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
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

  Widget _buildImage(DocumentSnapshot<Object?> item) {
    return item['img_item'].isEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10), // Redondear los bordes del contenedor
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Image.network(
            item['img_item'],
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.amber,
                ),
              );
            },
          );
  }

  Widget _buildInfo(DocumentSnapshot<Object?> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Descripción del producto
        Text(
          item['description_item'],
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8), // Espacio entre la descripción y el precio
        // Precio del producto
        Text(
          'Precio: \$${item['price_item']}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
