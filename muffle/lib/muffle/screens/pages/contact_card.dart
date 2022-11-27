import 'package:flutter/material.dart';
import 'package:muffle/muffle/core/core.dart';
import 'package:muffle/muffle/screens/shared/models/typography.dart';
import 'package:muffle/muffle/screens/shared/shared.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, required this.contact, this.lastMessage, this.lastMessagedTimestamp, this.isChatPage = false}) : super(key: key);
  final UserChat contact;
  final String? lastMessage;
  final String? lastMessagedTimestamp;
  final bool isChatPage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.blueGrey[200],
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(contact.photoUrl),
                  ),
                ),
              ),
            ),
            contact.select
                ? const Positioned(
                    bottom: 4,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 11,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      title: Text(
        contact.nickname,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        isChatPage ? lastMessage! : contact.aboutMe,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: SizedBox(
        width: 50,
        height: 50,
        child: isChatPage
            ? AppText(
                text: lastMessagedTimestamp,
                appTextStyle: TextTypography.textLabel,
              )
            : Container(),
      ),
    );
  }
}
