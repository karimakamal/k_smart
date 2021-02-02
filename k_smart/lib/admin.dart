import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  Map user;
  final VoidCallback signOut;
  Admin({this.user, this.signOut});
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administration'),
        actions: [
          IconButton(icon: Icon(Icons.power), onPressed: widget.signOut)
        ],
        centerTitle: true,
      ),
      body: Center(child: Container(
        child: Text('Admin: '+widget.user['username']+", Users number: "+widget.user['usersno']),
      ),),
    );
  }
}
