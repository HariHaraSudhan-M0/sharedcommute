import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharedcommute/models/ownerPostModel.dart';
import 'package:sharedcommute/pages/LoginPage.dart';
import 'package:sharedcommute/pages/owner/post/d-posting_summary_page.dart';

class OwnerEndSelector extends StatefulWidget {
  final OwnerPostModel postData;
  const OwnerEndSelector({super.key, required this.postData});

  @override
  State<OwnerEndSelector> createState() => _OwnerStartSelectorState();
}

class _OwnerStartSelectorState extends State<OwnerEndSelector> {
  late MapController mapController;
  @override
  void initState() {
    super.initState();
    mapController = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    mapController.listenerMapLongTapping.addListener(() {
      if (mapController.listenerMapLongTapping.value != null) {
        /// put you logic here
        print(mapController.listenerMapLongTapping.value);
        final data = mapController.listenerMapLongTapping.value;
        widget.postData.end = data;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostSummary(
              postData: widget.postData,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text"),
      ),
      body: OSMFlutter(
         mapIsLoading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.red : Colors.green,
                ),
              );
            },
          ),
          Text("Select Your End point by long pressing the location")
          ]
        ),
        controller: mapController,
        osmOption: OSMOption(
          zoomOption: const ZoomOption(
            initZoom: 18,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await mapController.currentLocation();
          //  await mapController.startLocationUpdating();
        },
        child: Icon(Icons.abc),
      ),
    );
  }
}
