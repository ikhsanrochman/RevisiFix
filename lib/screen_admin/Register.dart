import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_management_page.dart'; // Pastikan path yang benar

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showProgress = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;

  var options = ['User', 'Verifikator', 'Admin'];
  var _currentItemSelected = "User";
  var role = "User";

  var bidangOptions = ['UMUM', 'SETDA', 'BAPPEDA', 'DISKOMINFO'];
  var _currentBidangSelected = "UMUM";
  var bidang = "UMUM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        automaticallyImplyLeading: false, // Menyembunyikan tombol back
        actions: [
          IconButton(
            icon: Icon(Icons.manage_accounts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountManagementPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  _buildTextFormField(
                    controller: usernameController,
                    hintText: 'Username',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: emailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  _buildPasswordFormField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: _isObscure,
                    onVisibilityPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    validator: (value) {
                      RegExp regex = RegExp(r'^(?=.[A-Z])(?=.[@$!%?&])[A-Za-z\d@$!%?&]{8,}$');
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return "Password must be at least 8 characters, include an uppercase letter and a special character";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  _buildPasswordFormField(
                    controller: confirmpassController,
                    hintText: 'Confirm Password',
                    obscureText: _isObscure2,
                    onVisibilityPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    },
                    validator: (value) {
                      if (confirmpassController.text != passwordController.text) {
                        return "Password did not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: phoneController,
                    hintText: 'Phone',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone number cannot be empty";
                      }
                      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                        return "Please enter a valid phone number";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 10),
                  _buildDropdownRow(
                    title: "Bidang",
                    items: bidangOptions,
                    currentItemSelected: _currentBidangSelected,
                    onChanged: (newValueSelected) {
                      setState(() {
                        _currentBidangSelected = newValueSelected!;
                        bidang = newValueSelected;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  _buildDropdownRow(
                    title: "Role",
                    items: options,
                    currentItemSelected: _currentItemSelected,
                    onChanged: (newValueSelected) {
                      setState(() {
                        _currentItemSelected = newValueSelected!;
                        role = newValueSelected;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    elevation: 5.0,
                    height: 40,
                    onPressed: () {
                      setState(() {
                        showProgress = true;
                      });
                      signUp(
                        emailController.text,
                        passwordController.text,
                        role,
                        bidang,
                        usernameController.text,
                        phoneController.text,
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], // Changed to gray
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onVisibilityPressed,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], // Changed to gray
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onVisibilityPressed,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownRow({
    required String title,
    required List<String> items,
    required String currentItemSelected,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], // Changed to gray
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentItemSelected,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void signUp(String email, String password, String role, String bidang, String username, String phone) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Simpan data pengguna ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
        'bidang': bidang,
        'username': username,
        'phone': phone,
      });

      // Tampilkan dialog pop-up
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Registration Successful"),
            content: Text("You have successfully registered."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Menutup dialog
                  Navigator.pushReplacementNamed(context, '/account_management'); // Navigasi ke halaman manajemen akun
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        showProgress = false;
      });
    }
  }
}
