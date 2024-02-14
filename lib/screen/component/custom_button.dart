import 'package:flutter/material.dart';
import 'package:nun/screen/component/custom_themes.dart';
import 'package:nun/screen/component/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? buttonText;
  final bool isBuy;
  final bool isBorder;
  final Color? backgroundColor;
  final Color? textColor;
  final FontWeight? textWeight;
  final Color? borderColor;
  final double? radius;
  final double? fontSize;
  final String? leftIcon;
  final double? borderWidth;

  const CustomButton(
      {Key? key,
      this.onTap,
      required this.buttonText,
      this.isBuy = false,
      this.isBorder = false,
      this.backgroundColor = Colors.black,
      this.radius,
      this.textColor,
      this.fontSize,
      this.leftIcon,
      this.borderColor,
      this.borderWidth,
      this.textWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap as void Function()?,
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(radius != null
                ? radius!
                : isBorder
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                    width: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(leftIcon!),
                    )),
              ),
            Flexible(
              child: Text(buttonText ?? "",
                  style: titilliumSemiBold.copyWith(
                    fontSize: fontSize ?? 16,
                    fontWeight: textWeight,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
