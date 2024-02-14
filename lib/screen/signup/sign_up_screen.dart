import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nun/screen/component/custom_button.dart';
import 'package:nun/screen/component/custom_textfield.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/login/login_screen.dart';

class SignUpUser extends StatelessWidget {
  const SignUpUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   'Signup Screen',
      //   style: textBold.copyWith(
      //       color: Theme.of(context).primaryColor,
      //       fontSize: Dimensions.fontSizeExtraLarge),
      // )),
      body: const FormSignup(),
    );
  }
}

class FormSignup extends StatefulWidget {
  const FormSignup({super.key});

  @override
  State<FormSignup> createState() => _FormSignupState();
}

class _FormSignupState extends State<FormSignup> {
  final _keyForm = GlobalKey<FormState>();
  final txt = FocusNode();
  bool ispassword = true;
  File? _image;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  Future<void> saveData(String fullName, String userName, String userPassword,
      File? imageFile) async {
    try {
      var url = Uri.parse("http://127.0.0.1/assignmentapi/register_user.php");

      // Encode the image file to base64 if available
      String base64Image =
          imageFile != null ? base64Encode(imageFile.readAsBytesSync()) : '';

      // Send the POST request with user details and image
      final response = await http.post(
        url,
        body: {
          'FullNameReg': fullName,
          'UserNameReg': userName,
          'PasswordReg': userPassword,
          'UserImage': base64Image,
        },
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register Successfully'),
            duration: Duration(seconds: 1),
          ),
        );
        fullNameController.clear();
        userNameController.clear();
        passwordController.clear();
        confirmPwdController.clear();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Register. ${response.statusCode}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during registration: $e'),
        ),
      );
    }
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _keyForm,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: Dimensions.paddingSizeOverLarge),
            Image.asset(
              Images.sig1,
              height: 60,
              width: 100,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            GestureDetector(
              onTap: _getImage,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Colors.white, width: 3),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: _image == null
                          ? FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              image: '',
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                  Images.placeholder,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover),
                            )
                          : Image.file(_image!,
                              width: 150, height: 150, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).hintColor.withOpacity(0.2),
                        radius: 14,
                        child: IconButton(
                          onPressed: _getImage,
                          padding: const EdgeInsets.all(0),
                          icon: Image.asset(
                            Images.photo,
                            color: Colors.black,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 125,
                      child: Image.asset(
                        Images.user2,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CustomTextField(
              showLabelText: false,
              prefixIcon: Images.user,
              hintText: 'Enter Full Name',
              controller: fullNameController,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CustomTextField(
              showLabelText: false,
              prefixIcon: Images.pass,
              hintText: 'Enter Username',
              controller: userNameController,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CustomTextField(
              showLabelText: false,
              prefixIcon: Images.pass,
              isPassword: true,
              hintText: 'Enter Password',
              controller: passwordController,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CustomTextField(
              showLabelText: false,
              prefixIcon: Images.pass,
              isPassword: true,
              hintText: 'Enter Confirm Password',
              controller: confirmPwdController,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            SizedBox(
              child: CustomButton(
                buttonText: 'Sign Up',
                textColor: Colors.white,
                onTap: () {
                  if (_keyForm.currentState!.validate()) {
                    String fullName = fullNameController.text;
                    String userName = userNameController.text;
                    String userPassword = passwordController.text;

                    saveData(fullName, userName, userPassword, _image);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registering...')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.left,
                  height: 50,
                  width: 100,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                ),
                Text(
                  "Social Media",
                  style:
                      textBold.copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                ),
                Image.asset(
                  Images.right,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.google,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeDefault,
                ),
                Image.asset(
                  Images.facebook,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeDefault,
                ),
                Image.asset(
                  Images.apple,
                  height: 50,
                  width: 50,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account",
                  style: textRegular,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: textBold.copyWith(
                          color: Theme.of(context).primaryColor),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
