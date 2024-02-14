import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:http/http.dart' as http;
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/contact/add_cotact_screen.dart';
import 'package:nun/screen/contact/update_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final ApiProvider api =
      ApiProvider("http://127.0.0.1/assignmentapi/get_contact.php");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All Contact',
            style: textBold.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeExtraLarge),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactForm(
                        onAddContactSuccess: _handleAddContactSuccess,
                      ),
                    ),
                  );
                  if (result != null && result) {
                    _handleUpdate;
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
                List<dynamic> contacts = data.data?["contacts"];
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> contact = contacts[index];
                    return Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        extentRatio: .25,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (value) {
                              _showDeleteConfirmationDialog(
                                  contact['contactID']);
                            },
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(.05),
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                            icon: CupertinoIcons.delete_solid,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeSmall,
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 1)),
                              ],
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge)),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: const Offset(0, 1)),
                                  ],
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusExtraLarge)),
                              width: 60, // Adjust width as needed
                              height: 60,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "http://127.0.0.1/assignmentapi/images/contacts/${contact['contactImage']}",
                                ),
                              ),
                            ),
                            title: Text(contact['contactName']),
                            subtitle: Text(contact['contactNumber']),
                            trailing: InkWell(
                              onTap: () async {
                                bool result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateContactForm(
                                      contactID: contact['contactID'],
                                      contactName: contact['contactName'],
                                      contactPhone: contact['contactNumber'],
                                      contactEmail: contact['contactEmail'],
                                      contactImage: contact['contactImage'],
                                      onUpdate: _handleUpdate,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {
                                    // Update the state here if needed
                                  });
                                }
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
        ));
  }

  void _handleAddContactSuccess() {
    setState(() {
      // Trigger state update to refresh contact list
    });
  }

  void _handleUpdate(bool updated) {
    if (updated) {
      setState(() {});
    }
  }

  Future<void> _deleteContact(int contactID) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/assignmentapi/delete_contact.php'),
      body: {'ContactID': contactID.toString()},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == 1) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact deleted successfully'),
          ),
        );

        setState(() {});
      } else {
        // Failed to delete contact
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete contact'),
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

  void _showDeleteConfirmationDialog(String contactID) {
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
                  "Are you sure you want to Contact?",
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
                        _deleteContact(
                            int.parse(contactID)); // Parse string to int
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
