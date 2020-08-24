import 'package:breezy_admin_app/screens/indiv_request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Requests"), actions: [
        FlatButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Logout'))
      ],),

      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('requests').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RequestStatus(document.documentID,document['track'])));
                    },
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(document['url'])
                    ),
                    title: Text(document['token']),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
