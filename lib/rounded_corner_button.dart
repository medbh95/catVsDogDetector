import 'package:flutter/material.dart';

// on a crée notre bouton avec des bordure circulaire comme composant pour minimiser les lignes de code
class RoundedCornersButton extends StatelessWidget {
  const RoundedCornersButton(
      {required this.child,
      required this.fillColor,
      required this.borderColor,
      required this.height,
      required this.width,
      required this.borderRadius,
      required this.onpressed,
      required this.textColor});
  final Widget child;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double width;
  final void Function()? onpressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(10),
      height: height,
      width: width,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: borderColor, width: 2)),
        onPressed: onpressed,
        padding: EdgeInsets.all(10.0),
        color: fillColor,
        textColor: textColor,
        child: child,
      ),
    );
  }
}
