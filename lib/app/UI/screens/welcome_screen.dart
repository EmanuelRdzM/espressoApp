import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/navigation_drawer.dart'
    as widget_navigation_drawer;
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ConfettiController _confettiController;
  bool isConnected = false;

  @override
  void initState() {
    checkConnection();
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getCurrentUser();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  Future<void> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if ( connectivityResult.contains(ConnectivityResult.none) ) {
      setState(() {
        isConnected = false;
      });
    } else if( connectivityResult.contains(ConnectivityResult.wifi) ){
      setState(() {
        isConnected = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return Text(userProvider.currentUser.userStoreName ?? '');
            }),
          leading: IconButton(
            icon: const Icon(Icons.menu), // Icono de hamburguesa
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      
        /// Navigation Drawer
        drawer: const widget_navigation_drawer.NavigationDrawer(),
      
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
              
                    //Welcome messgae
                    const Text('WELCOME TO YOUR STORE!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    
                    /// Confetti effect
                    ConfettiWidget(
                      confettiController: _confettiController,
                      shouldLoop: false,
                      blastDirectionality: BlastDirectionality.explosive,
                      maxBlastForce: 20, 
                      minBlastForce: 4,
                      numberOfParticles: 20, 
                      emissionFrequency: 0.2, 
                      gravity: 1,
                    ),
              
                    // Image
                    Center(
                      child: Image(
                        //height: MediaQuery.of(context).size.height * 0.60,
                        width: MediaQuery.of(context).size.height * 0.60,
                        image: const AssetImage('assets/images/female-chef-2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              checkConnection();
                              if(isConnected){
                                Navigator.of(context).pushNamed(Routes.home);
                              }else{
                                showToast(message: 'Revisa la conexión a internet');
                              }
                              
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 0, 80, 4),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            child: const Text('Start Day'),
                          ),
                        ],
                      ),
                    ),
              
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
