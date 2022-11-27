import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../../pages/chat_page.dart';
import '../../pages/contact_card.dart';

class ChatHeadListItem extends StatefulWidget {
  final String currentUserId;
  final UserChat userChat;

  const ChatHeadListItem({required this.currentUserId, required this.userChat, super.key});

  @override
  State<ChatHeadListItem> createState() => _ChatHeadListItemState();
}

class _ChatHeadListItemState extends State<ChatHeadListItem> {
  late ChatProvider chatProvider;
  String groupChatId = "";

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    if (widget.currentUserId.compareTo(widget.userChat.id) > 0) {
      groupChatId = '${widget.currentUserId}-${widget.userChat.id}';
    } else {
      groupChatId = '${widget.userChat.id}-${widget.currentUserId}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (Utilities.isKeyboardShowing()) {
          Utilities.closeKeyboard(context);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              arguments: ChatPageArguments(
                peerId: widget.userChat.id,
                peerAvatar: widget.userChat.photoUrl,
                peerNickname: widget.userChat.nickname,
              ),
            ),
          ),
        );
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: chatProvider.getChatStream(groupChatId, 1),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var listMessage = snapshot.data!.docs;
            if (listMessage.isNotEmpty) {
              MessageChat messageChat = MessageChat.fromDocument(listMessage[0]);
              return ContactCard(
                contact: widget.userChat,
                isChatPage: true,
                lastMessage: messageChat.content,
                lastMessagedTimestamp: DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp))),
              );
            }
          }

          return ContactCard(contact: widget.userChat);
        },
      ),
    );
  }
}
