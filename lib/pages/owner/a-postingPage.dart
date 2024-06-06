import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharedcommute/models/ownerPostModel.dart';
import 'package:sharedcommute/pages/owner/b-posting_start_selector.dart';


class OwnerPostPage extends StatefulWidget {
  @override
  _OwnerPostPage createState() => _OwnerPostPage();
}

class _OwnerPostPage extends State<OwnerPostPage> with SingleTickerProviderStateMixin {
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _licenseController.dispose();
    _vehicleController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onNextButtonPressed() {
    // Handle the next button press
    print('License: ${_licenseController.text}');
    print('Vehicle: ${_vehicleController.text}');
    print('Phone: ${_phoneController.text}');
    final postData = OwnerPostModel();
    postData.licence_number = _licenseController.text;
    postData.vehicle_number = _vehicleController.text;
    postData.phone_number = _phoneController.text;
    postData.userName = FirebaseAuth.instance.currentUser?.displayName;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerStartSelector(
              postData: postData,
            ),
          ),
        );  }

  Widget _buildAnimatedTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedTextField('License Number', _licenseController),
            SizedBox(height: 16),
            _buildAnimatedTextField('Vehicle Number', _vehicleController),
            SizedBox(height: 16),
            _buildAnimatedTextField('Phone Number', _phoneController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onNextButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
