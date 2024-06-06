import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sharedcommute/utils/get_request.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  late Future<List<Request>> _requestFuture;

  @override
  void initState() {
    super.initState();
    _requestFuture = fetchRequests();
  }

  Future<List<Request>> fetchRequests() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('requests');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      return parseRequests(data);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request List'),
      ),
      body: FutureBuilder<List<Request>>(
        future: _requestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found.'));
          } else {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(request.user),
                      subtitle: Text('${request.phoneNumber}, ${request.email}'),
                      onTap: () async{
                        var url = Uri.parse("tel:${request.phoneNumber}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
