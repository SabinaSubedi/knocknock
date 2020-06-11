import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FAQListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance.collection('faqs').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError) {
              final snackbar = SnackBar(
                content: Text( 'Something went wrong, please try again !')
              );
              Scaffold.of(context).showSnackBar(snackbar);
            }

            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator()
              );
            }

            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return ExpansionTile(
                    title: Text( document['question'] ?? ''),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0 ),
                        child: Html( data: document['answer'] ?? '')
                      )
                    ],
                  );
                }).toList(),
              );
            }
          },
        )
      ),
    );
  }
}