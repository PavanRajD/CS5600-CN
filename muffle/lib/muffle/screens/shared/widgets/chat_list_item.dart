import 'package:flutter/material.dart';

import '../../../core/models/user.dart';
import '../models/models.dart';
import 'app_text.dart';
import 'list_item_widget.dart';
import 'profile_image_widget.dart';

class ChatListItem extends StatelessWidget {
  final User user;
  final String lastMessage;
  final DateTime lastRepondedOn;
  final bool isRead;

  const ChatListItem({
    super.key,
    required this.user,
    required this.lastMessage,
    required this.lastRepondedOn,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return ListItemWidget(
      paddingLeft: 0,
      paddingInBetween: 10,
      height: 60,
      leading: ProfileImageWidget(
          size: ProfileImageSize.large,
          imageUrl: user.profileImageUrl,
          userName: user.name),
      trailing: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        child: AppText(
          text: '0',
          appTextStyle: TextTypography.textXSmallStrong,
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
      ),
      title: AppText(
        text: 'Pavan Raj',
        appTextStyle: TextTypography.textBody,
      ),
      onTap: null,
    );
  }
}
