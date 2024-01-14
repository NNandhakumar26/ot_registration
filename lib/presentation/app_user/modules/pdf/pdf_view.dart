// import 'package:flutter/material.dart';
// import 'package:internet_file/internet_file.dart';
// import 'package:pdfx/pdfx.dart';

// class PDFView extends StatelessWidget {
//   final String link;
//   const PDFView({
//     super.key,
//     required this.link  
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 4,
//         title: const Text('Certificate'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//               ),
//             ),
//           ),
//           PdfViewPinch(
//             controller: PdfControllerPinch(
//               document: PdfDocument.openData(
//                 InternetFile.get(link),
//               ),
//             ),
//           )
//         ],
//       )
//     );
//   }
// }