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

class UpdateContactForm extends StatefulWidget {
  final String? contactID;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? contactImage;
  final Function(bool) onUpdate;

  const UpdateContactForm({
    Key? key,
    this.contactID,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.contactImage,
    required this.onUpdate,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateContactFormState createState() => _UpdateContactFormState();
}

class _UpdateContactFormState extends State<UpdateContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contactName ?? '';
    _phoneController.text = widget.contactPhone ?? '';
    _emailController.text = widget.contactEmail ?? '';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String base64Image =
          _image != null ? base64Encode(_image!.readAsBytesSync()) : '';

      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/update_contact.php'),
        body: {
          'ContactID': widget.contactID ?? '',
          'NewContactName': _nameController.text,
          'NewPhone': _phoneController.text,
          'NewEmail': _emailController.text,
          'NewImage': base64Image,
        },
      );

      if (response.statusCode == 200) {
        // Trigger the callback
        widget.onUpdate(true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact updated successfully'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update contact'),
          ),
        );
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
          'Edit Contact',
          style: textBold.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeExtraLarge,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                                image:
                                    "http://127.0.0.1/assignmentapi/images/contacts/${widget.contactImage}",
                                imageErrorBuilder: (c, o, s) => Image.asset(
                                  Images.placeholder,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.file(
                                _image!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                      ),
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
              SizedBox(
                height: 50,
                child: CustomButton(
                  buttonText: 'Save Changes',
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
