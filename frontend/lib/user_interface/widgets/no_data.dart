import 'package:flutter/material.dart';

Scaffold noData(BuildContext context, String title, String message) {
  return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Text(message,
              style: const TextStyle(
                fontSize: 23,
              ))));
}
