import 'package:flutter/material.dart';
import 'package:nun/screen/category/add_new_category_screen.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';
import 'package:nun/screen/component/images.dart';
import 'package:nun/screen/contact/add_cotact_screen.dart';
import 'package:nun/screen/login/login_screen.dart';
import 'package:nun/screen/product/add_product_screen.dart';
import 'package:nun/screen/profile/profile_screen.dart';

class MoreScreen extends StatefulWidget {
  final int userId;
  const MoreScreen({super.key, required this.userId});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  void updateUserInformation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: textBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  0),
              child: Text('Account',
                  style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                  )),
            ),
            TitleButton(
              image: Images.shoppingImage,
              title: 'My Profile',
              navigateTo: ProfileScreen(
                userId: widget.userId,
                onUpdateProfile: updateUserInformation,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  0),
              child: Text('Management',
                  style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                  )),
            ),
            const TitleButton(
                image: Images.shoppingImage,
                title: 'Category',
                navigateTo: CategoryForm()),
            const TitleButton(
                image: Images.shoppingImage,
                title: 'Product',
                navigateTo: ProductForm()),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                  0),
              child: Text('Settings',
                  style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                  )),
            ),
            TitleButton(
                image: Images.faq1,
                title: 'Contact',
                navigateTo: ContactForm(
                  onAddContactSuccess: _handleAddContactSuccess,
                )),
            ListTile(
              leading: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset(
                  Images.exit,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'Sign Out',
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
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
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            Text(
                              "Are you sure you want to sign out?",
                              style: textMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
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
                                const SizedBox(
                                    width: Dimensions.paddingSizeDefault),
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
                                        color:
                                            Theme.of(context).colorScheme.error,
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
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddContactSuccess() {
    setState(() {});
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;

  final bool isProfile;

  const TitleButton({
    Key? key,
    required this.image,
    required this.title,
    required this.navigateTo,
    this.isProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
      leading: Image.asset(
        image,
        width: 25,
        height: 25,
        fit: BoxFit.fill,
        color: Colors.black,
      ),
      title: Text(
        title!,
        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => navigateTo),
      ),
    );
  }
}
