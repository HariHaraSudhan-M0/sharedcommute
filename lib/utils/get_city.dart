import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> fetchCity(double lat, double lon) async {
  final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final address = jsonResponse['address'];
    final city = address['city'] ?? address['town'] ?? address['village'];
    return city;
  } else {
    throw Exception('Failed to load data');
  }
}