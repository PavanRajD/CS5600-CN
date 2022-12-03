import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muffle/muffle/core/core.dart';
import 'package:muffle/muffle/screens/pages/select_contact_page.dart';
import 'package:muffle/muffle/screens/pages/update_about_page.dart';
import 'package:muffle/muffle/screens/shared/models/typography.dart';
import 'package:provider/provider.dart';

import '../shared/shared.dart';
import 'full_photo_page.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  final List<UserChat> allUsers;

  const SettingsPage({super.key, required this.allUsers});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDNDActivated = false;
  late UserChat loggedInUser;
  late AuthProvider authProvider;
  late SettingProvider settingProvider;

  List<String> ovverideSelectedContacts = [];

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    settingProvider = context.read<SettingProvider>();
    readLocal();
  }

  void readLocal() {
    loggedInUser = UserChat(
      id: settingProvider.getPref(FirestoreConstants.id) ?? "",
      photoUrl: settingProvider.getPref(FirestoreConstants.photoUrl) ?? "",
      nickname: settingProvider.getPref(FirestoreConstants.nickname) ?? "",
      aboutMe: settingProvider.getPref(FirestoreConstants.aboutMe) ?? "",
      isDNDActivated: settingProvider.getPref(FirestoreConstants.isDNDActivated) ?? "",
    );

    var overrideContacts = settingProvider.getPref(FirestoreConstants.overrideContacts)?.split(",");

    ovverideSelectedContacts = overrideContacts?.where((element) => element.isNotEmpty).toList() ?? [];

    isDNDActivated = loggedInUser.isDNDActivated == "true";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.4,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(isDNDActivated);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 25, right: 16),
        child: ListView(
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhotoPage(url: loggedInUser.photoUrl)));
                },
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: Offset(0, 10))],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(loggedInUser.photoUrl),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: isDNDActivated ? Colors.red : Colors.green,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: loggedInUser.nickname,
                  appTextStyle: TextTypography.header2,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: .5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: 'Focus Mode',
                      appTextStyle: TextTypography.header3,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AppText(
                      text: isDNDActivated ? 'Deactivate DND' : 'Activate DND',
                      appTextStyle: TextTypography.textLabel,
                    ),
                  ],
                ),
                Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      value: isDNDActivated,
                      activeColor: Colors.red,
                      trackColor: Colors.black,
                      onChanged: (bool val) {
                        authProvider.updateDNDStatus(val);
                        settingProvider.setPref(FirestoreConstants.isDNDActivated, val.toString());
                        setState(() {
                          isDNDActivated = !isDNDActivated;
                        });
                      },
                    ))
              ],
            ),
            Divider(
              thickness: .5,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.center_focus_weak,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 4,
                ),
                AppText(
                  text: "Focus Settings",
                  upperCase: true,
                  color: ColorConstants.greyColor,
                  appTextStyle: TextTypography.textBody,
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: .5,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                var ovverideContacts = await Navigator.push<List<String>>(context, MaterialPageRoute(builder: (context) => SelectContact(allContacts: widget.allUsers, preSelectedContacts: ovverideSelectedContacts)));
                if (ovverideContacts != null) {
                  ovverideSelectedContacts = ovverideContacts;
                  authProvider.updateOvverideListMessage(ovverideSelectedContacts.join(","));
                  settingProvider.setPref(FirestoreConstants.overrideContacts, ovverideSelectedContacts.join(","));
                  setState(() {});
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Who can override focus mode",
                          appTextStyle: TextTypography.textBody,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppText(
                          text: "${ovverideSelectedContacts.length} contacts selected",
                          appTextStyle: TextTypography.textLabel,
                          color: ColorConstants.greyColor,
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                var value = await Navigator.push<String>(context, MaterialPageRoute(builder: (context) => UpdateAboutPage(autoReplyMessage: loggedInUser.aboutMe)));
                if (value != null) {
                  loggedInUser.aboutMe = value;
                  authProvider.updateReplyMessage(value);
                  settingProvider.setPref(FirestoreConstants.aboutMe, value);
                  setState(() {});
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Auto reply message",
                          appTextStyle: TextTypography.textBody,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        AppText(
                          text: loggedInUser.aboutMe,
                          appTextStyle: TextTypography.textLabel,
                          color: ColorConstants.greyColor,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  handleSignOut();
                },
                child: AppText(
                  text: "SIGN OUT",
                  upperCase: true,
                  appTextStyle: TextTypography.textBodyStrong,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleSignOut() async {
    authProvider.handleSignOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
