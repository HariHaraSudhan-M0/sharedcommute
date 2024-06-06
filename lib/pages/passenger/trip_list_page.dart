import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:sharedcommute/pages/passenger/trip_detail.dart';
import 'package:sharedcommute/utils/get_trip_list.dart';

class TripListPage extends StatefulWidget {
  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  late Future<List<Trip>> _tripFuture;
  late MapController mapController;

  @override
  void initState() {

    _tripFuture = fetchTrips();
  }

  Future<List<Trip>> fetchTrips() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('trips');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      print(snapshot.value);
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      return parseTrips(data);
    } else {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<Trip>>(
        future: _tripFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No trips found.'));
          } else {
            final trips = snapshot.data!;
            return ListView.builder(
                    shrinkWrap: true,
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:  ListTile(
                      title: Text(trip.userName),
                      subtitle: Text('${trip.fromCity} to ${trip.toCity}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailPage(trip: trip),
                          ),
                        );
                      },
                    ),
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
