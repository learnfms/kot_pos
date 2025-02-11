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
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset('assets/images/background.png', width: double.infinity, fit: BoxFit.cover,),
          Center(
            child: isLoading?Container(padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),

              ),
              child: Center(child: CircularProgressIndicator(),),
            ): Container(
              width: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormfieldWidget(hintText: 'Store Email', controller: storeEmail, onChanged: (text){}),
                    SizedBox(height: 10,),
                    TextFormfieldWidget(hintText: 'Store Password', controller: storePassword, onChanged: (s){}, isPassword: true,),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          isLoading = true;
                        });
                        repository.loginStore(email: storeEmail.text, password: storePassword.text).then((value){
                          if(value == null){
                            Get.snackbar('Login Error', 'Unable to Login');
                            setState(() {
                              isLoading = false;
                            });
                          }
                          else {
                            setState(() {
                              isLoading= false;
                            });
                            Get.to(HomeScreen());
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Log In!!',
                            style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
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
