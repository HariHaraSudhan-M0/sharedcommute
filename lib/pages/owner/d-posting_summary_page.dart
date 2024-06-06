import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharedcommute/models/ownerPostModel.dart';

class PostSummary extends StatefulWidget {
  final OwnerPostModel postData;

  const PostSummary({super.key, required this.postData});

  @override
  State<PostSummary> createState() => _PostSummaryState();
}

class _PostSummaryState extends State<PostSummary> {
  @override
  late MapController mapController;
  String _toCity = "";
  String _fromCity = "";
  @override
  void initState() {
    super.initState();

    mapController = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Column(
        children: [
          // Text values displayed at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${widget.postData.userName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'License Number: ${widget.postData.licence_number}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Vehicle Number: ${widget.postData.vehicle_number}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Phone Number: ${widget.postData.phone_number}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Spacer(),
          ElevatedButton(onPressed: (){
            mapController.addMarker(
              widget.postData.start ?? GeoPoint(latitude: 0, longitude: 0),
              markerIcon: MarkerIcon(
                icon: Icon(
                  Icons.flag,
                  color: Colors.green,
                ),
              ));

          mapController.addMarker(
              widget.postData.end ?? GeoPoint(latitude: 0, longitude: 0),
              markerIcon: MarkerIcon(
                icon: Icon(
                  Icons.flag,
                  color: Colors.red,
                ),
              ));
          }, child: Text("Summarise")),
          Spacer(),
          // Container at the bottom covering half of the screen
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: OSMFlutter(
              mapIsLoading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        );
                      },
                    ),
                    Text("Loading your trip")
                  ]),
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 5,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
