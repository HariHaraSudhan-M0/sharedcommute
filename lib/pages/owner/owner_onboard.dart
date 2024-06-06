import 'package:flutter/material.dart';
import 'package:sharedcommute/pages/owner/post/a-postingPage.dart';
import 'package:sharedcommute/pages/owner/view/request_list.dart';

class OwnerOnboard extends StatelessWidget {
  const OwnerOnboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnerPostPage(),
                    ),
                  );
                },
                child: Text("Post a Trip")),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestListPage(),
                    ),
                  );
                },
                child: Text("View My Trips"))
          ],
        ),
      ),
    );
  }
}
