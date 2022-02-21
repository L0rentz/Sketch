import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sketch/colors/primary_swatch.dart';
import 'package:sketch/screens/home/profil_setup.dart';
import 'package:sketch/services/auth.dart';
import 'package:sketch/widgets/loading.dart';
import 'package:sketch/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? _data;
  bool _showSetup = false;
  bool _loading = true;
  int _selectedIndex = 0;

  void _toggleSetup() {
    setState(() => _showSetup = !_showSetup);
  }

  void _toggleLoading() {
    setState(() => _loading = !_loading);
  }

  void _turnOffLoading() {
    setState(() => _loading = false);
  }

  void _checkIfExist() async {
    setState(() {
      _loading = true;
    });
    bool exist = await _auth.checkUserSetup();
    await _getUserProfil();
    setState(() {
      _loading = false;
      if (!exist) {
        _showSetup = true;
      } else {
        _showSetup = false;
      }
    });
  }

  _getUserProfil() async {
    DocumentSnapshot<Object?> querySnapshot =
        await DatabaseService(uid: _auth.currentUserUid).getUserProfil();
    _data = querySnapshot.data() as Map<String, dynamic>?;
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      await _auth.signOut();
    }
  }

  @override
  void initState() {
    _checkIfExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return _loading
        ? const Loading()
        : _showSetup
            ? ProfilSetup(
                toggleSetup: _toggleSetup,
                checkExist: _checkIfExist,
                toggleLoading: _turnOffLoading,
              )
            : _data == null
                ? const Loading()
                : StreamProvider<QuerySnapshot?>.value(
                    initialData: null,
                    value: DatabaseService(uid: _auth.currentUserUid).profils,
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                                .homeWelcome +
                                            ", " +
                                            _data!['firstname'],
                                        style: TextStyle(
                                          color: primarySwatch.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.homeTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundImage: Image.memory(
                                          base64Decode(_data!['picture']))
                                      .image,
                                ),
                              ],
                            ),
                            Divider(
                              color: primarySwatch.shade200,
                            ),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                        elevation: 0.0,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home, size: 28.0),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.exit_to_app, size: 28.0),
                            label: "",
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                      ),
                    ),
                  );
  }
}
