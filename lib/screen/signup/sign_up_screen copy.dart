import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      appBar: AppBar(
          title: Text(
        'Signup Screen',
        style: textBold.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeExtraLarge),
      )),
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

  Future<void> saveData(
      String fullName, String userName, String userPassword) async {
    var url = Uri.parse("http://127.0.0.1/assignmentapi/register_user.php");

    final response = await http.post(url, body: {
      'FullNameReg': fullName,
      'UserNameReg': userName,
      'PasswordReg': userPassword,
    });
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
      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Register. ${response.statusCode}'),
          duration: const Duration(seconds: 2),
        ),
      );
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
            Image.asset(
              Images.sign,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            const SizedBox(height: Dimensions.paddingSizeOverLarge),
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

                    saveData(fullName, userName, userPassword);
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
