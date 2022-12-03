// import 'package:flutter/material.dart';

// class AnimatedToggle extends StatefulWidget {
//   final ValueChanged onToggleCallback;
//   final bool selectedValue;
//   final Color backgroundColor;
//   final Color buttonColor;
//   final Color textColor;

//   const AnimatedToggle({
//     super.key,
//     required this.selectedValue,
//     required this.onToggleCallback,
//     this.backgroundColor = const Color(0xFFe7e7e8),
//     this.buttonColor = const Color(0xFFFFFFFF),
//     this.textColor = const Color(0xFF000000),
//   });
  
//   @override
//   _AnimatedToggleState createState() => _AnimatedToggleState();
// }

// class _AnimatedToggleState extends State<AnimatedToggle> {

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       margin: EdgeInsets.all(20),
//       child: Stack(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               initialPosition = !initialPosition;
//               var index = 0;
//               if (!initialPosition) {
//                 index = 1;
//               }
//               widget.onToggleCallback(index);
//               setState(() {});
//             },
//             child: Container(
//               width: 50,
//               height: 50,
//               decoration: ShapeDecoration(
//                 color: widget.backgroundColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(
//                   widget.values.length,
//                   (index) => Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       widget.values[index],
//                       style: TextStyle(
//                         fontFamily: 'Rubik',
//                         fontSize: 4,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xAA000000),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           AnimatedAlign(
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.decelerate,
//             alignment: widget.selectedValue ? Alignment.centerRight : Alignment.centerLeft,
//             child: Container(
//               width: 20,
//               height: 20,
//               decoration: ShapeDecoration(
//                 color: widget.buttonColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 widget.selectedValue ? "On" : "Off",
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: widget.textColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
