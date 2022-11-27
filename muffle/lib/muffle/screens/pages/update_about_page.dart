import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../shared/models/models.dart';
import '../shared/shared.dart';

class UpdateAboutPage extends StatelessWidget {
  final String autoReplyMessage;

  final TextEditingController autoReplyMessageTextController = TextEditingController();

  UpdateAboutPage({super.key, required this.autoReplyMessage});

  @override
  Widget build(BuildContext context) {
    autoReplyMessageTextController.text = autoReplyMessage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.4,
        centerTitle: false,
        title: AppText(
          text: "Auto Reply Message",
          appTextStyle: TextTypography.header1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, size: 26),
            onPressed: () {
              Navigator.pop(context, autoReplyMessageTextController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 100,
          child: Center(
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: autoReplyMessageTextController,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Enter auto reply message',
                enabled: true,
                focusColor: Colors.black,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: ColorConstants.greyColor,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
