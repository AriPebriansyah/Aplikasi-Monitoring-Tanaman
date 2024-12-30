import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/config/palette.dart';

class StatsScreen extends StatelessWidget {
  final DatabaseReference readingsRef = FirebaseDatabase.instance.ref('readings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistik Data Sensor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Palette.primaryColor,
        elevation: 6,
        leading: Icon(Icons.bar_chart_rounded, color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _refreshData(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DatabaseEvent>(
          stream: readingsRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Palette.primaryColor),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorMessage('Terjadi kesalahan saat mengambil data.');
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.exists == false) {
              return _buildErrorMessage('Tidak ada data untuk ditampilkan.');
            }

            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final filteredData = _filterAndSortData(data);

            if (filteredData.isEmpty) {
              return _buildErrorMessage('Tidak ada data penyiraman untuk ditampilkan.');
            }

            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final reading = filteredData[index].value as Map<dynamic, dynamic>;
                return _buildStatCard(reading);
              },
            );
          },
        ),
      ),
    );
  }

  void _refreshData(BuildContext context) {
    readingsRef.onValue.first.then((event) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil diperbarui!'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  List<MapEntry<dynamic, dynamic>> _filterAndSortData(Map<dynamic, dynamic> data) {
    final filteredData = data.entries.where((entry) {
      final reading = entry.value as Map<dynamic, dynamic>;
      final wateringDuration = reading['wateringDuration'];
      return wateringDuration != null && wateringDuration > 0;
    }).toList();

    filteredData.sort((a, b) {
      final dateA = a.value['date'] ?? '';
      final dateB = b.value['date'] ?? '';
      return dateB.compareTo(dateA);
    });

    return filteredData;
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.redAccent),
      ),
    );
  }

  Widget _buildStatCard(Map<dynamic, dynamic> reading) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reading['date'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.primaryColor,
                  ),
                ),
                Text(
                  reading['time'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[400]),
            SizedBox(height: 8),
            _buildStatRow('Humidity', '${reading['humidity'] ?? '0'}%', Palette.primaryColor),
            _buildStatRow('Soil Moisture', '${reading['soilMoisture'] ?? '0'}%', Colors.green),
            _buildStatRow('Temperature', '${reading['temperature'] ?? '0'}°C', Colors.red),
            _buildStatRow('Durasi Penyiraman', '${reading['wateringDuration'] ?? '0'}s', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
