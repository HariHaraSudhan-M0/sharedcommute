import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharedcommute/features/splash_screen/tripPostedScreen.dart';
import 'package:sharedcommute/models/ownerPostModel.dart';
import 'package:sharedcommute/utils/get_city.dart';

class PostSummary extends StatefulWidget {
  final OwnerPostModel postData;

  const PostSummary({super.key, required this.postData});

  @override
  State<PostSummary> createState() => _PostSummaryState();
}

class _PostSummaryState extends State<PostSummary> {
  @override
  late MapController mapController;
  bool summarised = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref("trips");
  String _toCity = "";
  String _fromCity = "";
  _summarise() async {
    mapController.addMarker(
        widget.postData.start ?? GeoPoint(latitude: 0, longitude: 0),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.flag,
            color: Colors.green,
          ),
        ));

    mapController.addMarker(
        widget.postData.end ?? GeoPoint(latitude: 0, longitude: 0),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.flag,
            color: Colors.red,
          ),
        ));

    String? fromCity = await fetchCity(widget.postData.start!);
    String? toCity = await fetchCity(widget.postData.end!);
    print("FROM: $fromCity TO: $toCity");
    setState(() {
      _toCity = toCity!;
      _fromCity = fromCity!;
    });
    summarised = true;
  }

  _postTrip() {
    if (summarised) {
      print("Posting trip ");
      DatabaseReference tripListRef = ref.push();
      tripListRef.set({
        "User": FirebaseAuth.instance.currentUser!.uid ,
        "UserName": widget.postData.userName,
        "LicenceName": widget.postData.licence_number,
        "VehicleNmae": widget.postData.vehicle_number,
        "phoneNumber": widget.postData.phone_number,
        "seats": 6,
        "from":  {
          "city":_fromCity,
          "lat": widget.postData.start!.latitude,
          "lon": widget.postData.start!.longitude
        },
        "to":  {
          "city":_toCity,
          "lat": widget.postData.end!.latitude,
          "lon": widget.postData.end!.longitude
        }
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Summarise your trip first!!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripSplashScreen(splashText: "Your Trip has been posted !!"),
          ),
        );
  }

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
        title: const Text('User Information'),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'License Number: ${widget.postData.licence_number}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vehicle Number: ${widget.postData.vehicle_number}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Phone Number: ${widget.postData.phone_number}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(onPressed: _summarise, child: const Text("Summarise")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("FROM:  $_fromCity"), Text("TO:  $_toCity")],
          ),
          ElevatedButton(onPressed: _postTrip, child: const Text("Post trip")),

          const Spacer(),
          // Container at the bottom covering half of the screen
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: const BorderRadius.only(
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
                    const Text("Loading your trip")
                  ]),
              controller: mapController,
              osmOption: const OSMOption(
                zoomOption: ZoomOption(
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
