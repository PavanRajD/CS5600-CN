import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subTitle;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  final double height;
  final double paddingLeft;
  final double paddingInBetween;
  final MainAxisAlignment titleAlignment;
  final Color? color;

  const ListItemWidget({
    Key? key,
    this.onTap,
    this.leading,
    required this.title,
    this.subTitle,
    this.trailing,
    this.height = 70.0,
    this.paddingLeft = 16,
    this.paddingInBetween = 20,
    this.titleAlignment = MainAxisAlignment.center,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color ?? Theme.of(context).primaryColorLight,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            _buildLeading(),
            SizedBox(
              width: paddingInBetween,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(),
                _bulidTrailing(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (leading == null) {
      return const SizedBox(height: 0, width: 0);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: paddingLeft,
          ),
          leading!,
        ],
      );
    }
  }

  Widget _buildTitle() {
    var titleWidget = title;
    if (subTitle != null) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: titleAlignment,
        children: <Widget>[
          title,
          subTitle!,
        ],
      );
    }

    return Expanded(
      child: titleWidget,
    );
  }

  Widget _bulidTrailing() {
    if (trailing == null) {
      return const SizedBox(height: 0, width: 0);
    } else {
      return Container(
        margin: EdgeInsets.only(
          right: 8.0,
          left: paddingInBetween,
        ),
        child: trailing,
      );
    }
  }
}
