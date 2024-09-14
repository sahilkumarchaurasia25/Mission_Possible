import 'package:cloud_firestore/cloud_firestore.dart';

class TodayRide {
  final String pickup_location;
  final String vehicle_number;
  final Timestamp date;
  TodayRide({
    required this.date,
    required this.pickup_location,
    required this.vehicle_number,
  });

  factory TodayRide.fromJson(Map<String, dynamic> json) {
    return TodayRide(
        date: json["date"],
        pickup_location: json["pickup_location"],
        vehicle_number: json["vehicle_number"]);
  }
}
