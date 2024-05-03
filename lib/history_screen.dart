import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }


  void _loadHistory() async {
    QuerySnapshot historySnapshot =
    await FirebaseFirestore.instance.collection('history').get();
    List<String> historyList = [];
    historySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String? expression = data['expression'] as String?;
      Timestamp? timestamp = data['timestamp'] as Timestamp?;
      if (expression != null && timestamp != null) {
        // Format timestamp into a readable date and time
        String formattedTime =
            "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute}";
        historyList.add('$expression - $formattedTime');
      }
    });
    setState(() {
      _history = historyList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: _history.isEmpty
          ? Center(
        child: Text('No History'),
      )
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_history[index]),
          );
        },
      ),
    );
  }
}
