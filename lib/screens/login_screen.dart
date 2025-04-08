import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kot_pos/resp/store_repository.dart';
import 'package:kot_pos/screens/home_screen.dart';
import '../widgets/text_formfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storeEmail = TextEditingController();
  final storePassword = TextEditingController();
  StoreRepository repository = StoreRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // Use NetworkImage for testing or AssetImage for local assets
                image: NetworkImage('https://images.pexels.com/photos/235990/pexels-photo-235990.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: isLoading
                ? Container(
                    padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8), // Add transparency to loading container
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    width: 600,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8), // Add transparency to login container
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormfieldWidget(
                            hintText: 'Store Email',
                            controller: storeEmail,
                            onChanged: (text) {},
                          ),
                          SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: 'Store Password',
                            controller: storePassword,
                            onChanged: (s) {},
                            isPassword: true,
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              final store = await repository.loginStore(email: storeEmail.text, password: storePassword.text);
                              if (store == null) {
                                Get.snackbar('Login Error', 'Unable to login');
                              } else {
                                Get.to(() => const HomeScreen());
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Log In!!',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
