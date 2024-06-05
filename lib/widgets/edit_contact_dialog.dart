import 'package:cafeteria_app/widgets/icon_text_button.dart';
import 'package:flutter/material.dart';

class CreateContactDialog extends StatefulWidget {
  const CreateContactDialog({super.key});

  @override
  State<CreateContactDialog> createState() => _CreateContactDialogState();
}

class _CreateContactDialogState extends State<CreateContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the phone number';
    }
    // Validar que el número de teléfono solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number can only contain numbers';
    }
    // Validar que el número de teléfono tenga 7 u 10 dígitos
    if (value.length != 7 && value.length != 10) {
      return 'Phone number should have 7 or 10 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.supervised_user_circle_rounded, color: Colors.black),
            SizedBox(width: 12),
            Text('Nuevo Contacto',)
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _providerController,
                        decoration: const InputDecoration(labelText: 'Provider Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the provider name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, {
                              'provider': _providerController.text,
                              'phone': _phoneController.text,
                              'address': _addressController.text,
                            });
                          }
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditContactDialog extends StatefulWidget {
  final String initialProvider;
  final String initialPhone;
  final String initialAddress;

  const EditContactDialog({
    super.key,
    required this.initialProvider,
    required this.initialPhone,
    required this.initialAddress,
  });

  @override
  State<EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _providerController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the phone number';
    }
    // Validar que el número de teléfono solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number can only contain numbers';
    }
    // Validar que el número de teléfono tenga 7 u 10 dígitos
    if (value.length != 7 && value.length != 10) {
      return 'Phone number should have 7 or 10 digits';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _providerController = TextEditingController(text: widget.initialProvider);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit),
            SizedBox(width: 12),
            Text('Editar Contacto',)
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _providerController,
                        decoration: const InputDecoration(labelText: 'Provider Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the provider name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, {
                              'provider': _providerController.text,
                              'phone': _phoneController.text,
                              'address': _addressController.text,
                            });
                          }
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
