import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/domain/models/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_app/others/extensions.dart';
import 'package:cafeteria_app/widgets/svg_icon.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaAutServices _aut = FirebaAutServices();
  late bool _hidePassword;

  bool _isSignIn = false;

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    /// ICON
                    Container(
                      width: 145.0,
                      height: 145.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(233, 102, 233, 0.905), Color.fromRGBO(240, 179, 125, 1)],
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: const Center(
                        child: SvgIcon(
                          'assets/icons/restaurant_logo.svg',
                          width: 100,
                          height: 100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
      
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      
                          /// Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              hintText: "name@example.com",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.email_outlined),
                              )
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return "please enter your email";
                              }
                              return ( value!.isValidEmail()) ? null : 'Ingresa una direccion de correo valida';
                            },
                          ),
                          const SizedBox(height: 20),
                      
                          /// password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "************",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: CupertinoButton(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ),
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
                          
                          /// Sign In button
                          _isSignIn 
                          ? const Center(
                            child: SizedBox(
                              
                                child: CircularProgressIndicator()
                              ),
                          ) 
                          : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signIn();
                              }
                            },
                            child: const Text('Sign In'),
                          ),
                          const SizedBox(height: 8.0),
      
                          TextButton(
                            onPressed: () {
                              // Add your forgot password logic here
                            },
                            child: const Text('Forgot your password?'),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              const SizedBox(width: 4.0),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.register);
                                },
                                child: const Text('Sign Up'),
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

  void _signIn() async{

    setState(() {
      _isSignIn = true;
    });

    String userEmail = _emailController.text;
    String userPassword = _passwordController.text;

    User? user = await _aut.signInpwithEmailAndPassword(userEmail, userPassword);

    setState(() {
      _isSignIn = false;
    });

    if(user!= null){
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, Routes.welcome);
    }
  }
}
