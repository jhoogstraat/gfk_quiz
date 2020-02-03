import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiken"),
      ),
      body: ListView.separated(
          itemBuilder: null, separatorBuilder: null, itemCount: null),
    );
  }
}
