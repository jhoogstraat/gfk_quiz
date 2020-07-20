import 'package:flutter/material.dart';

import '../locator.dart';
import '../repos/settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Settings settings = locator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView.separated(
          itemBuilder: (_, index) => CheckboxListTile(
              title: Text("Shuffle answers"),
              value: settings.shuffle,
              onChanged: (value) => setState(() => settings.shuffle = value)),
          separatorBuilder: (_, __) => Divider(height: 1),
          itemCount: 1),
    );
  }
}
