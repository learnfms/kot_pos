import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:kot_pos/model/store.dart'; // Import the Store model
import 'package:kot_pos/resp/store_repository.dart';
import 'package:kot_pos/screens/login_screen.dart';
import 'package:kot_pos/widgets/text_formfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController storeName = TextEditingController();
  final TextEditingController storeAddress = TextEditingController();
  final TextEditingController storeEmail = TextEditingController();
  final TextEditingController storePhone = TextEditingController();
  final TextEditingController storePassword = TextEditingController();

  double storeLatitude = 0.0;
  double storeLongitude = 0.0;

  final StoreRepository repository = StoreRepository();
  bool isLoading = false;

  String address = '';
  List<String> listAddress = [];

  // Searches for addresses matching the query using geocoding
  void _searchAddress(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      List<String> matchingAddress = [];
      for (var location in locations) {
        List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
        if (placemarks.isNotEmpty) {
          for (var placemark in placemarks) {
            String addr =
                '${placemark.street ?? ''} ${placemark.subLocality ?? ''} ${placemark.locality ?? ''} ${placemark.country ?? ''}';
            matchingAddress.add(addr.trim());
          }
        }
      }
      setState(() {
        listAddress = matchingAddress;
      });
    } catch (e) {
      print('Error in _searchAddress: $e');
    }
  }

  // Gets latitude and longitude for the selected address and updates the text field
  void _getLatLng(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        setState(() {
          storeLatitude = locations.first.latitude;
          storeLongitude = locations.first.longitude;
          storeAddress.text = query;
          address = '';
          listAddress = []; // Clear suggestions after selection
        });
      }
    } catch (e) {
      print('Error in _getLatLng: $e');
    }
  }

  // Validates form inputs
  bool _validateInputs() {
    if (storeName.text.isEmpty ||
        storeAddress.text.isEmpty ||
        storeEmail.text.isEmpty ||
        storePhone.text.isEmpty ||
        storePassword.text.isEmpty ||
        storeLatitude == 0.0 ||
        storeLongitude == 0.0) {
      Get.snackbar('Validation Error', 'All fields are required');
      return false;
    }
    return true;
  }

  // Handles registration logic
  void _handleRegister() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      Store store = Store(
        storeName: storeName.text,
        storeAddress: storeAddress.text,
        storeLatitude: storeLatitude,
        storeLongitude: storeLongitude,
        storeEmail: storeEmail.text,
        storePhone: storePhone.text,
        storePassword: storePassword.text,
      );

      await repository.registerStore(store: store);
      Get.to(() => const LoginScreen());
    } catch (e) {
      Get.snackbar('Registration Error', 'Failed to register the store');
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
        title: const Text('SignUp Store'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: isLoading
                ? Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CircularProgressIndicator(),
            )
                : Container(
              padding: const EdgeInsets.all(10),
              width: 600,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormfieldWidget(
                    hintText: 'Store Name',
                    controller: storeName,
                    onChanged: (s) {},
                  ),
                  const SizedBox(height: 10),
                  TextFormfieldWidget(
                    hintText: 'Store Address',
                    controller: storeAddress,
                    onChanged: (query) => _searchAddress(query),
                  ),
                  const SizedBox(height: 10),
                  address == ''
                      ? const SizedBox()
                      : Container(
                    color: Colors.black,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAddress.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => _getLatLng(listAddress[index]),
                        child: Row(
                          children: [
                            const Icon(Icons.location_history, color: Colors.white),
                            const SizedBox(width: 15),
                            Text(
                              listAddress[index],
                              style:
                              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextFormfieldWidget(
                    hintText: 'Store Email',
                    controller: storeEmail,
                    onChanged: (s) {},
                  ),
                  const SizedBox(height: 10),
                  TextFormfieldWidget(
                    hintText: 'Store Phone',
                    controller: storePhone,
                    onChanged: (s) {},
                  ),
                  const SizedBox(height: 10),
                  TextFormfieldWidget(
                    hintText: 'Store Password',
                    controller: storePassword,
                    onChanged: (s) {},
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _handleRegister, // Use the registration handler
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration:
                      BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(10)),
                      child:
                      const Center(child: Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight:
                      FontWeight.bold))),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
