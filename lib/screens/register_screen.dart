import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resp/store_repository.dart';
import '../screens/login_screen.dart';
import '../widgets/text_formfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController storeAddressController = TextEditingController();
  final TextEditingController storeEmailController = TextEditingController();
  final TextEditingController storePhoneController = TextEditingController();
  final TextEditingController storePasswordController = TextEditingController();

  double storeLatitude = 0.0;
  double storeLongitude = 0.0;

  bool isLoading = false;
  final StoreRepository repository = StoreRepository();

void _handleRegister() async {
  if (storeNameController.text.trim().isEmpty ||
      storeAddressController.text.trim().isEmpty ||
      storeEmailController.text.trim().isEmpty ||
      storePhoneController.text.trim().isEmpty ||
      storePasswordController.text.trim().isEmpty) {
    Get.snackbar('Validation Error', 'All fields are required');
    return;
  }

  // Proceed with form submission
  setState(() {
    isLoading = true;
  });

  try {
    await repository.registerStore(
      storeName: storeNameController.text.trim(),
      storeAddress: storeAddressController.text.trim(),
      storeLatitude: storeLatitude,
      storeLongitude: storeLongitude,
      storeEmail: storeEmailController.text.trim(),
      storePhone: storePhoneController.text.trim(),
      storePassword: storePasswordController.text.trim(),
    );
    Get.to(() => const LoginScreen());
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Store'),
      ),
      body: Stack(
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormfieldWidget(
                            hintText: 'Store Name',
                            controller: storeNameController,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: 'Store Address',
                            controller: storeAddressController,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: 'Store Email',
                            controller: storeEmailController,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: 'Store Phone',
                            controller: storePhoneController,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormfieldWidget(
                            hintText: 'Password',
                            controller: storePasswordController,
                            isPassword: true,
                            onChanged: (_) {},
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _handleRegister, // Disable button when loading
                            child: const Text('Register', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
