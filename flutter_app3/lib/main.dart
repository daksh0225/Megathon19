import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Faulty manholes',
    initialRoute: '/',
    routes: {
      '/': (context) => MyHomePage(),
      '/second': (context) => SecondPage(),
    },
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _MyHomePageState extends State<MyHomePage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Faulty Manholes')),
    body: Center(
      child: RaisedButton(
        child: _buildBody(context),
        onPressed:(){
         Navigator.pushNamed(context,'/second');
        },          
   ),
    ),
   );
 }

 Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
     stream: Firestore.instance.collection('bad').snapshots(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) return LinearProgressIndicator();

       return _buildList(context, snapshot.data.documents);
     },
   );
 }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.number),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.number),
         subtitle: Text(record.code),
        trailing: Icon(
          Icons.error,
          color: Colors.red),
       ),
     ),
   );
 }
}

class Record {
 final String number;
 final String code;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['number'] != null),
     assert(map['code']!=null),
     code=map['code'],
       number= map['number'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$number>";
}


class SecondPage extends StatefulWidget {
 @override
 _SecondState createState() {
   return _SecondState();
 }
}

class _SecondState extends State<SecondPage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Roads')),
    body: Center(
      child: RaisedButton(
        child: _buildBody(context),
        onPressed:(){
         Navigator.pop(context);
        },          
        ),
        )
   );
 }

 Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
     stream: Firestore.instance.collection('roads').snapshots(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) return LinearProgressIndicator();

       return _buildList(context, snapshot.data.documents);
     },
   );
 }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
   final record = Record1.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.road),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.road),
        trailing: Text(record.level),
       ),
     ),
   );
 }
}

class Record1 {
 final String road;
 final String level;
 final DocumentReference reference;

 Record1.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['road'] != null),
     assert(map['level']!=null),
     level=map['level'],
       road= map['road'];

 Record1.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$road>";
}