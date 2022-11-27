import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../models/models.dart';

class SearchBar extends StatefulWidget {
  final SearchFunc onSeachKeyUpdated;

  const SearchBar({super.key, required this.onSeachKeyUpdated});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return buildSearchBar();
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.greyColor2,
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: ColorConstants.greyColor,
            size: 20,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    widget.onSeachKeyUpdated(value);
                  } else {
                    btnClearController.add(false);
                      widget.onSeachKeyUpdated("");
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search name (you have to type exactly name)',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: ColorConstants.greyColor,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                            widget.onSeachKeyUpdated("");
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: ColorConstants.greyColor,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
