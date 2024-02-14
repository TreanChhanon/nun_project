import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nun/screen/component/custom_button.dart';
import 'package:nun/screen/component/custom_textfield.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:http/http.dart' as http;
import 'package:nun/screen/component/images.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onUpdateProfile;

  const ProfileScreen(
      {Key? key, required this.userId, required this.onUpdateProfile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userData;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/assignmentapi/get_user_info.php'),
      body: {'UserID': widget.userId.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _updateProfile() async {
    String base64Image =
        _image != null ? base64Encode(_image!.readAsBytesSync()) : '';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1/assignmentapi/update_profile.php'),
    );
    request.fields['UserID'] = widget.userId.toString();
    request.fields['UserName'] = userNameController.text;
    request.fields['UserType'] = userTypeController.text;
    request.fields['UserEmail'] = userEmailController.text;
    request.fields['FullName'] = fullNameController.text;
    request.fields['Image'] = base64Image;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == 1) {
        if (kDebugMode) {
          print("User updated successfully");
        }
        widget.onUpdateProfile();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update Profile Successfully'),
            duration: Duration(seconds: 1),
          ),
        );

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        if (kDebugMode) {
          print("User update failed");
        }
      }
    } else {
      throw Exception('Failed to update user information');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Screen',
          style: textBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            if (userData['success'] == 1) {
              final user = userData['user'];
              fullNameController.text = user['FullName'] ?? '';
              userNameController.text = user['UserName'] ?? '';
              userTypeController.text = user['UserType'] ?? '';
              userEmailController.text = user['UserEmail'] ?? '';
              return FormSignup(
                fullNameController: fullNameController,
                userNameController: userNameController,
                userTypeController: userTypeController,
                userEmailController: userEmailController,
                fullName: user['FullName'] ?? 'N/A',
                userName: user['UserName'] ?? 'N/A',
                userType: user['UserType'] ?? 'N/A',
                userEmail: user['UserEmail'] ?? 'N/A',
                userImage: user['UserImage'] ?? '',
                onUpdateProfile: _updateProfile,
                onImageSelect: _getImage,
                image: _image,
              );
            } else {
              return Center(child: Text(userData['msg_errors']));
            }
          }
        },
      ),
    );
  }
}

class FormSignup extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController userNameController;
  final TextEditingController userTypeController;
  final TextEditingController userEmailController;
  final String fullName;
  final String userName;
  final String userType;
  final String userEmail;
  final String userImage;
  final VoidCallback onUpdateProfile;
  final VoidCallback onImageSelect;
  final File? image;

  const FormSignup({
    Key? key,
    required this.fullNameController,
    required this.userNameController,
    required this.userTypeController,
    required this.userEmailController,
    required this.fullName,
    required this.userName,
    required this.userType,
    required this.userEmail,
    required this.userImage,
    required this.onUpdateProfile,
    required this.onImageSelect,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: onImageSelect,
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
                      child: image != null
                          ? Image.file(
                              image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              image:
                                  "http://127.0.0.1/assignmentapi/images/contacts/$userImage",
                              imageErrorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error");
                                return Image.asset(
                                  Images.placeholder,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                );
                              },
                            )),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).hintColor.withOpacity(0.2),
                      radius: 14,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          CustomTextField(
            showLabelText: false,
            prefixIcon: Images.user,
            hintText: 'Enter Full Name',
            controller: fullNameController,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          CustomTextField(
            showLabelText: false,
            prefixIcon: Images.user,
            hintText: 'Enter Username',
            controller: userNameController,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          CustomTextField(
            showLabelText: false,
            prefixIcon: Images.user,
            hintText: 'Enter User Type',
            controller: userTypeController,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          CustomTextField(
            showLabelText: false,
            prefixIcon: Images.user,
            hintText: 'Enter Email',
            controller: userEmailController,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          SizedBox(
            child: CustomButton(
              buttonText: 'Update Profile',
              textColor: Colors.white,
              onTap: onUpdateProfile,
            ),
          ),
        ],
      ),
    );
  }
}
