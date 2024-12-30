import 'package:firebase_database/firebase_database.dart';

class DataRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("data");

  Stream<Map<String, dynamic>> fetchData() {
    try {
      return _databaseReference.onValue.map((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        } else {
          return {};
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
      return Stream.empty();
    }
  }
}
