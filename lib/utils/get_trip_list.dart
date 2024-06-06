class Trip {
  final String tripId;
  final String vehicleName;
  final String user;
  final String userName;
  final String phoneNumber;
  final String fromCity;
  final double fromLon;
  final double fromLat;
  final String toCity;
  final double toLon;
  final double toLat;
  final int seats;
  final String licenceName;

  Trip({
    required this.tripId,
    required this.vehicleName,
    required this.user,
    required this.userName,
    required this.phoneNumber,
    required this.fromCity,
    required this.fromLon,
    required this.fromLat,
    required this.toCity,
    required this.toLon,
    required this.toLat,
    required this.seats,
    required this.licenceName,
  });

  factory Trip.fromJson(String id, Map<String, dynamic> json) {
    return Trip(
      tripId: id,
      vehicleName: json['VehicleNmae'],
      user: json['User'],
      userName: json['UserName'],
      phoneNumber: json['phoneNumber'],
      fromCity: json['from']['city'],
      fromLon: json['from']['lon'],
      fromLat: json['from']['lat'],
      toCity: json['to']['city'],
      toLon: json['to']['lon'],
      toLat: json['to']['lat'],
      seats: json['seats'],
      licenceName: json['LicenceName'],
    );
  }
}

  List<Trip> parseTrips(Map<String, dynamic> data) {
    List<Trip> trips = [];
    data.forEach((key, value) {
      trips.add(Trip.fromJson(key,Map<String, dynamic>.from(value)));
    });
    return trips;
  }
