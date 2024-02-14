// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:nun/screen/component/images.dart';

// class CustomImage extends StatelessWidget {
//   final String image;
//   final double? height;
//   final double? width;
//   final BoxFit? fit;
//   final String? placeholder;
//   final Color? color;
//   final Alignment alignment;
//   final File? file;
//   const CustomImage(
//       {Key? key,
//       required this.image,
//       this.height,
//       this.width,
//       this.fit = BoxFit.cover,
//       this.placeholder = Images.placeholder,
//       this.color,
//       this.alignment = Alignment.center,
//       this.file})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return file != null
//         ? Image.file(
//             file!,
//             color: color,
//             fit: fit,
//             alignment: alignment,
//             height: height,
//             width: width,
//             errorBuilder: (c, o, s) => Image.asset(
//               placeholder ?? Images.placeholder,
//               height: height,
//               width: width,
//               fit: BoxFit.cover,
//             ),
//           )
//         : image.contains('http')
//             ? CachedNetworkImage(
//                 placeholder: (context, url) => Image.asset(
//                     placeholder ?? Images.placeholder,
//                     height: height,
//                     width: width,
//                     fit: BoxFit.cover),
//                 imageUrl: image,
//                 alignment: alignment,
//                 fit: fit ?? BoxFit.cover,
//                 height: height,
//                 width: width,
//                 errorWidget: (c, o, s) => Image.asset(
//                     placeholder ?? Images.placeholder,
//                     height: height,
//                     width: width,
//                     fit: BoxFit.cover),
//               )
//             : Image.asset(
//                 image,
//                 color: color,
//                 fit: fit,
//                 alignment: alignment,
//                 height: height,
//                 width: width,
//                 errorBuilder: (c, o, s) => Image.asset(
//                   placeholder ?? Images.placeholder,
//                   height: height,
//                   width: width,
//                   fit: BoxFit.cover,
//                 ),
//               );
//   }
// }
