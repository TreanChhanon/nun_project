import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nun/screen/component/custom_button.dart';
import 'package:nun/screen/component/custom_textfield.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/create_category.php'),
        body: {
          'CategoryName': _nameController.text,
          'Description': _descriptionController.text,
          'CreatedBy': 'UserXYZ',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == 1) {
          if (kDebugMode) {
            print('Category added successfully');
          }
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category added successfully'),
            ),
          );
          setState(() {});
          // ignore: use_build_context_synchronously
          Navigator.pop(context, true);
        } else {
          if (kDebugMode) {
            print('Failed to add category: ${data['msg_errors']}');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to add category. Server returned ${response.statusCode}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Category',
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
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.user,
                hintText: 'Enter Category Name',
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Category Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Enter Description',
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              SizedBox(
                child: CustomButton(
                  buttonText: 'Add New Category',
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
