import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharedcommute/features/splash_screen/tripPostedScreen.dart';
import 'package:sharedcommute/utils/get_trip_list.dart';
import 'package:sharedcommute/widgets/textWidget.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;

  TripDetailPage({required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late MapController mapController;
  DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
  final TextEditingController _phoneController = TextEditingController();

  _onMapLoad(bool isReady) {
    mapController.addMarker(
        GeoPoint(latitude: widget.trip.fromLat, longitude: widget.trip.fromLon),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.flag,
            color: Colors.green,
          ),
        ));
    mapController.addMarker(
        GeoPoint(latitude: widget.trip.toLat, longitude: widget.trip.fromLon),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.flag,
            color: Colors.red,
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('User: ${widget.trip.userName}',
                style: TextStyle(fontSize: 18)),
            Text('Phone: ${widget.trip.phoneNumber}',
                style: TextStyle(fontSize: 18)),
            Text('Vehicle Name: ${widget.trip.vehicleName}',
                style: TextStyle(fontSize: 18)),
            Text('Licence Name: ${widget.trip.licenceName}',
                style: TextStyle(fontSize: 18)),
            Text('Seats: ${widget.trip.seats}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20.0),
            Text('From: ${widget.trip.fromCity}',
                style: TextStyle(fontSize: 18)),
            Text('To: ${widget.trip.toCity}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20.0),
            buildAnimatedTextField("Phone Number", _phoneController),
            Container(
              height: 300,
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
                    initZoom: 6,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                ),
                onMapIsReady: _onMapLoad,
              ),
            ),
            ElevatedButton(
              child: Text("Request"),
              onPressed: () {
                if (_phoneController.text.isEmpty) {
                  const snackBar = SnackBar(
                    content: Text('Phone number podra!!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                DatabaseReference ref =
                    FirebaseDatabase.instance.ref("requests");
                DatabaseReference reqRef = ref.push();
                final currentUser = FirebaseAuth.instance.currentUser;
                reqRef.set({
                  "UserName": currentUser!.displayName,
                  "TripId": widget.trip.tripId,
                  "email": currentUser.email,
                  "phone": _phoneController.text
                });
                 Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TripSplashScreen(splashText: "Your request has been sent !!"),
          ),
        );
              },
            )
          ],
        ),
      ),
    );
  }
}
