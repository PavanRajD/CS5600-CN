import 'package:flutter/material.dart';
import 'package:muffle/muffle/core/core.dart';

import '../shared/models/models.dart';
import '../shared/shared.dart';
import '../shared/widgets/search_bar.dart';
import 'contact_card.dart';

class SelectContact extends StatefulWidget {
  final List<UserChat> allContacts;
  final List<String> preSelectedContacts;

  const SelectContact({Key? key, required this.allContacts, required this.preSelectedContacts}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<UserChat> searchedContacts = [];
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    searchedContacts = widget.allContacts;
    for (var contact in widget.preSelectedContacts) {
      searchedContacts.singleWhere((element) => element.id == contact).select = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.4,
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Select Contacts",
              appTextStyle: TextTypography.header1,
            ),
            AppText(
              text: "${widget.allContacts.length} contacts",
              appTextStyle: TextTypography.textBody,
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 26),
            onPressed: () {
              Navigator.pop(context, widget.allContacts.where((element) => element.select).map((e) => e.id).toList());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          showSearchBar
              ? SearchBar(
                  onSeachKeyUpdated: (value) {
                    searchedContacts = widget.allContacts.where((element) => element.nickname.contains(value)).toList();
                    setState(() {});
                  },
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: searchedContacts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    searchedContacts[index].select = !searchedContacts[index].select;
                    setState(() {});
                  },
                  child: ContactCard(contact: searchedContacts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
