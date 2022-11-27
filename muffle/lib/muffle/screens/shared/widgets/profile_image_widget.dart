// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'app_text.dart';
import 'circular_widget.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? userName;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    required this.size,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    Widget placeholderImage = CircleWidget(
      radius: size,
      backgroundColor: AppColors.getRandomAccentColor(),
      child: AppText(
        text: _getInitials(userName),
        appTextStyle: TextTypography.textBodyStrong,
        color: Theme.of(context).textTheme.button?.color,
      ),
    );
    return CircleWidget(
      radius: size,
      child: Material(
        shape: const CircleBorder(
          side: BorderSide(style: BorderStyle.none, width: 2.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: imageUrl == null
              ? placeholderImage
              : placeholderImage
              // CachedNetworkImage(
              //     imageUrl: imageUrl!,
              //     placeholder: (context, url) => placeholderImage,
              //     errorWidget: (context, url, error) => placeholderImage,
              //     fit: BoxFit.cover,
              //   ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name != null && name.isNotEmpty) {
      var nameParts = name.trim().split(' ');
      String initials = nameParts[0][0];
      if (nameParts.length >= 2 && nameParts[1].isNotEmpty) {
        initials += nameParts[1][0];
      }

      return initials.toUpperCase();
    }

    return '';
  }
}
