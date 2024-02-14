import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nun/screen/component/custom_button.dart';
import 'package:nun/screen/component/custom_textfield.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/home/home_screen.dart';
import 'package:nun/screen/signup/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  int? userId;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  void loginUser() async {
    var url = Uri.parse("http://127.0.0.1/assignmentapi/login_user.php");
    final response = await http.post(url, body: {
      'UserNameLogin': controllerName.text.toString().trim(),
      'PasswordLogin': controllerPassword.text.toString().trim(),
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('$data');
      }
      if (data['success'] == 1) {
        int? userId = int.tryParse(data['UserIDLogin'] ?? '');
        if (userId != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                userId: userId,
                userName: data['UserNameLogin'],
                userType: data['UserType'],
              ),
            ),
            (route) => false,
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid UserIDLogin format'),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data['msg_errors']}'),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Login'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeOverLarge),
              Image.asset(
                Images.login1,
                height: 350,
                width: 350,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.user,
                hintText: 'Enter Username',
                controller: controllerName,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.pass,
                isPassword: true,
                hintText: 'Enter Password',
                controller: controllerPassword,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: isChecked
                        ? Icon(
                            Icons.check_box,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            color: Theme.of(context).hintColor.withOpacity(0.3),
                          ),
                  ),
                  const SizedBox(
                    width: Dimensions.paddingSizeExtraSmall,
                  ),
                  const Text(
                    "Remember",
                    style: textRegular,
                  ),
                  const Spacer(),
                  Text(
                    "Forgot password",
                    style: textRegular.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              SizedBox(
                child: CustomButton(
                  buttonText: 'Login',
                  textColor: Colors.white,
                  onTap: loginUser,
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
                    style: textBold.copyWith(
                        color: Theme.of(context).primaryColor),
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
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account",
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
                          builder: (context) => const SignUpUser(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: textBold.copyWith(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
