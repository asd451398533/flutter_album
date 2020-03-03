/*
 * @author lsy
 * @date   2019-10-13
 **/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

AppBar baseAppBar(
    {String title,
    List<Widget> action,
    bool centerTitle,
    VoidCallback backClick,
    Color backgroundColor,
    bool needBack = true}) {
  return baseAppBarChangeTitle(
      title: title == null
          ? Container()
          : baseText(title, 16, Color(0xff323232)),
      action: action,
      centerTitle: centerTitle,
      backClick: backClick,
      backgroundColor: backgroundColor,
      needBack: needBack);
}

AppBar baseAppBarChangeTitle(
    {Widget title,
    List<Widget> action,
    bool centerTitle,
    VoidCallback backClick,
    Color backgroundColor,
    bool needBack = true}) {
  return AppBar(
    brightness: Brightness.light,
    backgroundColor:
        backgroundColor == null ? Colors.white : backgroundColor,
    title: title,
    centerTitle: centerTitle,
    elevation: 0.0,
    leading:needBack? GestureDetector(
      onTap: backClick,
      child: Hero(
          tag: "left_arrow",
          child: Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 22),
              width: 30,
              height: double.maxFinite,
              child: SvgPicture.asset(
                "images/left_arrow.svg",
                color: Color(0xff323232),
              ))),
    ):Container(),
    actions: action == null ? List<Widget>() : action,
  );
}

Text baseText(String text, double fontSize, Color color) {
  return Text(
    text,
    textScaleFactor: 1.0,
    textDirection: TextDirection.ltr,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      decoration: TextDecoration.none,
    ),
  );
}

/**
 * 基础的liveView分割线
 */
Widget baseDivide(double height, double padding, Color color) {
  return Container(
      height: height,
      margin: EdgeInsets.only(
          right: padding,
          left: padding),
      child: Container(
        color: color,
      ));
}

Widget loadingItem() {
  return Center(child: CircularProgressIndicator());
}
