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

class UpdateProductForm extends StatefulWidget {
  final Map<String, dynamic> productData;

  const UpdateProductForm({Key? key, required this.productData})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProductFormState createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<UpdateProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryIDController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _expiredDateController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _unitPriceInController = TextEditingController();
  final TextEditingController _unitPriceOutController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productData['ProductName'];
    _descriptionController.text = widget.productData['Description'];
    _categoryIDController.text = widget.productData['CategoryID'];
    _barcodeController.text = widget.productData['Barcode'];
    _expiredDateController.text = widget.productData['ExpiredDate'];
    _qtyController.text = widget.productData['Qty'];
    _unitPriceInController.text = widget.productData['UnitPriceIn'];
    _unitPriceOutController.text = widget.productData['UnitPriceOut'];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String base64Image =
          _image != null ? base64Encode(_image!.readAsBytesSync()) : '';

      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/update_product.php'),
        body: {
          'ProductID': widget.productData['ProductID'],
          'ProductName': _nameController.text,
          'Description': _descriptionController.text,
          'CategoryID': _categoryIDController.text,
          'Barcode': _barcodeController.text,
          'ExpiredDate': _expiredDateController.text,
          'Qty': _qtyController.text,
          'UnitPriceIn': _unitPriceInController.text,
          'UnitPriceOut': _unitPriceOutController.text,
          'ProductImage': base64Image,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Product updated successfully');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true); // Navigate back with a result
      } else {
        if (kDebugMode) {
          print('Failed to update product');
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
          'Update Product',
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
          child: ListView(
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
                                    "http://127.0.0.1/assignmentapi/images/contacts/${widget.productData['ProductImage']}",
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
                hintText: 'Product Name',
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Product Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Description',
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Category ID',
                controller: _categoryIDController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Category ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Barcode',
                controller: _barcodeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Barcode';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Expired Date',
                controller: _expiredDateController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Expired Date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Quantity',
                controller: _qtyController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Unit Price In',
                controller: _unitPriceInController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Unit Price In';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextField(
                showLabelText: false,
                prefixIcon: Images.termCondition,
                hintText: 'Unit Price Out',
                controller: _unitPriceOutController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Unit Price Out';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              SizedBox(
                height: 50,
                child: CustomButton(
                  buttonText: 'Update Product',
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
