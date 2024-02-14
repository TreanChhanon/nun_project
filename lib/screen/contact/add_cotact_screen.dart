import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nun/screen/component/custom_button.dart';
import 'package:nun/screen/component/custom_textfield.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';

class ContactForm extends StatefulWidget {
  final VoidCallback onAddContactSuccess;
  const ContactForm({Key? key, required this.onAddContactSuccess})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String base64Image =
          _image != null ? base64Encode(_image!.readAsBytesSync()) : "NoImage";

      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/create_contact.php'),
        body: {
          'NewContactName': _nameController.text,
          'NewPhone': _phoneController.text,
          'NewEmail': _emailController.text,
          'NewImage': base64Image,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Contact added successfully');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact added successfully'),
          ),
        );
        setState(() {});
        widget.onAddContactSuccess(); // Trigger the callback function
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        if (kDebugMode) {
          print('Failed to add contact');
        }
      }
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
          'Add New Contact',
          style: textBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                              width: 150, height: 150, fit: BoxFit.fill),
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
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Enter Name',
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Enter Phone Number',
                controller: _phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Phone Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Enter Email',
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              SizedBox(
                child: CustomButton(
                  buttonText: 'Add New Contact',
                  textColor: Colors.white,
                  onTap: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
