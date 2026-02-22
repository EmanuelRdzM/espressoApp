import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cafeteria_app/app/domain/models/firebase_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_app/others/extensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaAutServices _aut = FirebaAutServices();
  late bool _hidePassword;
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    const Text("Create Account",
                      style: TextStyle(
                        fontSize: 30, 
                        fontWeight: FontWeight.bold,
                        color: APP_PRIMARY_COLOR,
                      ),
                    ),
                    const SizedBox(height: 40),
                
                    /// Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                
                          /// Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Email *",
                              hintText: "name@example.com",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.email_outlined),
                              )
                            ),
                            validator: (value) {
                              // Basic validation
                              if (value?.isEmpty ?? false) {
                                return "please enter your email";
                              }
                              return ( value!.isValidEmail()) ? null : 'Ingresa una direccion de correo valida';
                            },
                          ),
                          const SizedBox(height: 20),
                
                          /// Store name field
                          TextFormField(
                            controller: _storeNameController,
                            decoration: const InputDecoration(
                              labelText: "Store Name",
                              hintText: "enter your name store",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.store_outlined),
                              )
                            ),
                            validator: (name) {
                              // Basic validation
                              if (name?.isEmpty ?? false) {
                                return "please enter your store name";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                
                          /// password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            decoration:  InputDecoration(
                              labelText: "Password",
                              hintText: "************",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: CupertinoButton(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: (){
                                  _hidePassword = !_hidePassword;
                                  setState(() {
                                  });
                                },
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.lock_person_outlined),
                              )
                            ),
                            validator: (name) {
                              // Basic validation
                              if (name?.isEmpty ?? false) {
                                return "please enter a password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                
                          /// Sign Up button
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              child: _isSignUp ? const CircularProgressIndicator() : const Text('Sign Up'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signUp();
                                }
                              },
                              
                            ),
                          ),
                          const SizedBox(height: 20),
      
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              const SizedBox(width: 2.0),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.login);
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ],
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

  void _signUp() async{

    setState(() {
      _isSignUp = true;
    });

    String userEmail = _emailController.text;
    String userStoreName = _storeNameController.text;
    String userPassword = _passwordController.text;

    User? user = await _aut.signUpwithEmailAndPassword(userEmail, userPassword);

    if(user!= null){
      _aut.signUpFireStore(user: user, userStoreName: userStoreName);
      showToast(message: 'User is succesfully created');
    }

    setState(() {
      _isSignUp = false;
    });

  }

}