import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nun/screen/category/category_list_screen.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/contact/contact_list_screen.dart';
import 'package:nun/screen/login/login_screen.dart';
import 'package:nun/screen/more/more_screen.dart';
import 'package:nun/screen/product/product_list_screen.dart';
import 'package:nun/screen/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String userName; // Add userName parameter
  final String userType;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userType,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void updateUserInformation() {
    setState(() {});
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/assignmentapi/get_user_info.php'),
        body: {
          'UserID': widget.userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('UserName')) {
          setState(() {});
        }
        if (responseData.containsKey('UserType')) {
          setState(() {});
        }
      } else {
        // Handle HTTP error
        throw Exception(
            'Failed to fetch user information: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user information: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: Image.asset(
                    Images.bac,
                  ).image,
                )),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userId: widget.userId,
                                onUpdateProfile: updateUserInformation,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3.2,
                          child: ClipOval(
                            child: Image.asset(
                              Images.p1,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                "Welcome, ",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),
                              Image.asset(
                                Images.checked,
                                height: 20,
                              ),
                            ],
                          ),
                          Text(
                            widget.userType,
                            style: textBold.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.contact,
                                  width: 120,
                                  height: 120,
                                ),
                                Text(
                                  'All Contact',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.product,
                                  width: 120,
                                  height: 120,
                                ),
                                Text(
                                  'All Product',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CategoryListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.list,
                                  width: 120,
                                  height: 120,
                                ),
                                Text(
                                  'All Categories',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoreScreen(
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.set,
                                  width: 120,
                                  height: 120,
                                ),
                                Text(
                                  'Settings',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //xxx
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.re,
                                  width: 120,
                                  height: 120,
                                ),
                                Text(
                                  'Report Record',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeDefault),
                                          child: Text(
                                            "Sign out",
                                            style: textBold.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraLarge,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          ),
                                        ),
                                        Text(
                                          "Are you sure you want to sign out?",
                                          style: textMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                            .paddingSizeSmall)),
                                                child: Text(
                                                  "Cancel",
                                                  style: textMedium.copyWith(
                                                    color: Colors.white,
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeDefault),
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                  (route) => false,
                                                );
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                            .paddingSizeSmall)),
                                                child: Text(
                                                  "Yes",
                                                  style: textMedium.copyWith(
                                                    color: Colors.white,
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
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
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Images.ex,
                                  height: 120,
                                ),
                                Text(
                                  'Logout',
                                  style: textBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: Dimensions.paddingSizeLarge,
                // ),
                // CarouselSlider(
                //   items: child,
                //   carouselController: buttonCarouselController,
                //   options: CarouselOptions(
                //     autoPlay: true,
                //     enlargeCenterPage: true,
                //     viewportFraction: 0.9,
                //     aspectRatio: 2.0,
                //     initialPage: 2,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
