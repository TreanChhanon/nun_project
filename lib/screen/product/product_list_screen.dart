import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/product/add_product_screen.dart';
import 'package:nun/screen/product/update_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiProvider api = ApiProvider(
      "http://127.0.0.1/assignmentapi/get_product.php"); // Change the URL here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Product',
          style: textBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductForm()),
                );
                if (result != null && result) {
                  _updateProductList();
                }
              },
              child: Image.asset(
                Images.add,
                height: 25,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future:
            api.getProduct(), // Call getProduct method instead of getContact
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> products = snapshot.data?["products"];
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              padding: const EdgeInsets.all(8),
              children: List.generate(
                products.length,
                (index) {
                  final product = products[index];
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 1)),
                        ],
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusExtraLarge)),
                    child: Stack(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 170,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "http://127.0.0.1/assignmentapi/images/contacts/${product['ProductImage']}",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.05),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Dimensions.radiusExtraLarge),
                                    topRight: Radius.circular(
                                        Dimensions.radiusExtraLarge)),
                              ),
                            ),

                            // Product Details
                            Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .paddingSizeExtraSmall,
                                            vertical: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: Text(
                                            product['ProductName'] ?? "",
                                            textAlign: TextAlign.start,
                                            style: textMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Row(
                                        children: [
                                          Text(product['Description'] ?? "",
                                              style: titilliumSemiBold.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                          const SizedBox(
                                            height: 2,
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Row(
                                        children: [
                                          Text(
                                              '\$${product['UnitPriceOut'] ?? ""}',
                                              style: titilliumSemiBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraExtraSmall,
                                          ),
                                          Text('\$',
                                              style: titilliumSemiBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      Positioned(
                        bottom: Dimensions.paddingSizeExtraSmall + 2,
                        right: Dimensions.paddingSizeExtraSmall + 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  Dimensions.paddingSizeExtraExtraSmall),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Image.asset(
                                      Images.cartImage,
                                      height: Dimensions.iconSizeDefault,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                      Positioned(
                        top: Dimensions.paddingSizeExtraSmall + 2,
                        right: Dimensions.paddingSizeExtraSmall + 2,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProductForm(productData: product),
                              ),
                            );
                            if (result != null && result) {
                              _update();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.paddingSizeExtraExtraSmall),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Image.asset(
                                        Images.edit,
                                        color: Theme.of(context).primaryColor,
                                        height: Dimensions.iconSizeDefault,
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: Dimensions.paddingSizeExtraSmall + 2,
                        child: InkWell(
                          onTap: () {
                            _showDeleteConfirmationDialog(product['ProductID']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.paddingSizeExtraExtraSmall),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Image.asset(
                                        Images.delete,
                                        color: const Color.fromARGB(
                                            255, 233, 28, 13),
                                        height: Dimensions.iconSizeDefault,
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      )
                    ]),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(String productId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Text(
                    "Delete",
                    style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).colorScheme.error),
                  ),
                ),
                Text(
                  "Are you sure you want to Product?",
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall)),
                        child: Text(
                          "Cancel",
                          style: textMedium.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    GestureDetector(
                      onTap: () async {
                        _deleteProduct(int.parse(productId));
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 100,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeSmall)),
                        child: Text(
                          "Yes",
                          style: textMedium.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  Future<void> _deleteProduct(int productId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/assignmentapi/delete_product.php'),
      body: {'ProductID': productId.toString()},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == 1) {
        // Product deleted successfully, update the product list
        _updateProductList(); // Call _updateProductList to trigger setState
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
          ),
        );
      } else {
        // Failed to delete product
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete product'),
          ),
        );
      }
    } else {
      // Server returned an error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server error'),
        ),
      );
    }
  }

  void _updateProductList() {
    setState(() {});
  }

  void _update() {
    setState(() {});
  }
}

class ApiProvider {
  final String url;
  ApiProvider(this.url);

  Future<Map<String, dynamic>> getProduct() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
