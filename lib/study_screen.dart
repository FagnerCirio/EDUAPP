import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('O que vamos estudar?')),
      body: Center(
        child: Text('Aqui será a seção de estudos', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
