import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nun/screen/category/add_new_category_screen.dart';
import 'package:nun/screen/category/update_category_screen.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:http/http.dart' as http;
import 'package:nun/screen/component/images.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ApiProvider api =
      ApiProvider("http://127.0.0.1/assignmentapi/get_category.php");

  void _updateCategory(bool updated) {
    if (updated) {
      setState(() {});
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/delete_category.php'),
        body: {'CategoryID': categoryId},
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted successfully'),
          ),
        );
        setState(() {});
        // Handle success
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete Category'),
          ),
        );
        // Handle failure
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Category',
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
                  MaterialPageRoute(builder: (context) => const CategoryForm()),
                );
                if (result == true) {
                  setState(() {});
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
        future: api.getContact(),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.done) {
            if (data.hasData) {
              List<dynamic> categories = data.data?["categories"];
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> category = categories[index];
                  return Slidable(
                    key: Key(category['CategoryID'].toString()),
                    endActionPane: ActionPane(
                      extentRatio: .25,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (value) {
                            _showDeleteConfirmationDialog(
                                category['CategoryID']);
                          },
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(.05),
                          foregroundColor: Theme.of(context).colorScheme.error,
                          icon: CupertinoIcons.delete_solid,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusExtraLarge,
                          ),
                        ),
                        child: ListTile(
                          title: Text(category['CategoryName']),
                          subtitle: Text(category['Description']),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateCategory(
                                    categoryId: category['CategoryID'],
                                    categoryName: category['CategoryName'],
                                    description: category['Description'],
                                    onUpdate:
                                        _updateCategory, // Pass the callback function
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(
                              Images.edit,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(String categoryId) {
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
                  "Are you sure you want to Category?",
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
                            color: Theme.of(context).hintColor.withOpacity(0.3),
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
                        deleteCategory(categoryId);
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
}

class ApiProvider {
  final String url;
  ApiProvider(this.url);

  Future<Map<String, dynamic>> getContact() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to get contact');
    }
  }
}
