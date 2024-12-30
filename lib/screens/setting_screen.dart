import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Pastikan ini adalah lokasi LoginScreen Anda
import 'package:flutter_application_1/config/palette.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Palette.primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildProfileSection(context),
            SizedBox(height: 20),
            _buildSettingsCard(
              context,
              title: 'Hapus Akun',
              icon: Icons.person_remove,
              color: Colors.redAccent,
              onTap: () => _deleteAccount(context),
            ),
            SizedBox(height: 20),
            _buildSettingsCard(
              context,
              title: 'Tentang Kami',
              icon: Icons.info,
              color: Palette.primaryColor,
              onTap: () => _showAboutDialog(context),
            ),
            SizedBox(height: 20),
            _buildSettingsCard(
              context,
              title: 'Logout',
              icon: Icons.logout,
              color: Colors.orange,
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final User? user = _auth.currentUser;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor.withOpacity(0.2),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Palette.primaryColor.withOpacity(0.8),
              child: Icon(Icons.person, size: 30, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.email ?? 'Pengguna Tidak Diketahui',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Profil Anda', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Palette.primaryColor),
              onPressed: () => _showProfileDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.8),
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
  final User? user = _auth.currentUser;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.primaryColor.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Judul Dialog
              Text(
                'Profil Anda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Palette.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // Divider untuk pemisah
              Divider(
                color: Colors.grey[300],
                thickness: 1.5,
              ),
              SizedBox(height: 16),
              // Menampilkan email pengguna
              Text(
                'Email: ${user?.email ?? "Tidak tersedia"}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Tombol Ganti Password
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _changePassword(context);  // Call to change password
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor, // Tombol warna sesuai tema
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Ganti Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Tombol Tutup
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Tutup',
                  style: TextStyle(
                    color: Palette.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _changePassword(BuildContext context) {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ganti Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Palette.primaryColor),
              ),
              Divider(color: Colors.grey),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_newPasswordController.text == _confirmPasswordController.text) {
                    try {
                      // Re-authenticate pengguna
                      final AuthCredential credential = EmailAuthProvider.credential(
                        email: _auth.currentUser?.email ?? '',
                        password: _oldPasswordController.text,
                      );

                      await _auth.currentUser?.reauthenticateWithCredential(credential);

                      // Update password setelah re-authenticate berhasil
                      await _auth.currentUser?.updatePassword(_newPasswordController.text);

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password berhasil diperbarui')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengganti password: $e')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password baru dan konfirmasi tidak cocok')));
                  }
                },
                child: Text('Ganti Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal'),
              ),
            ],
          ),
        ),
      );
    },
  );
}



  void _deleteAccount(BuildContext context) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Hapus Akun',
      content: 'Apakah Anda yakin ingin menghapus akun ini? Ini tidak dapat dibatalkan.',
    );

    if (confirmed == true) {
      try {
        await _auth.currentUser?.delete();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Akun berhasil dihapus.')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hapus akun membutuhkan login ulang.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus akun: $e')),
          );
        }
      }
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tentang Kami'),
          content: Text('Aplikasi ini dibuat untuk memonitor data sensor secara real-time dengan Firebase.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup', style: TextStyle(color: Palette.primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context,
      {required String title, required String content}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: TextStyle(color: Palette.primaryColor)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Ya', style: TextStyle(color: Palette.primaryColor)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
