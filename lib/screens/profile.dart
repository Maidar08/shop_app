import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/globalKeys.dart';
import 'package:shop_app/login_page.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final TextStyle valueStyle = TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );

    void changeLanguage(BuildContext context) {
      Locale currentLocale = context.locale!;
      Locale newLocale = currentLocale.languageCode == 'en'
          ? const Locale('mn', 'MN')
          : const Locale('en', 'US');
      context.setLocale(newLocale);
    }

    void logout(BuildContext context) async {
      final provider = Provider.of<GlobalProvider>(context, listen: false);
      provider.setCurrentUser(null);

      // Clear token from secure storage
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'token');

      // Navigate to login page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Consumer<GlobalProvider>(
        builder: (context, provider, child) {
          final currentUser = provider.currentUser;

          if (currentUser == null) {
            // Navigate to login page if current user is null
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Please log in to view your profile'),
              ),
            );
          }

          // Extract username from email
          final userName = currentUser.email.split('@').first;

          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                      radius: 40,
                    ),
                    SizedBox(width: 20),
                    Text(
                      userName, // Display the username
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildProfileInfo('email', currentUser.email, labelStyle, valueStyle),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Change the language
                    changeLanguage(context);
                  },
                  child: Text(
                    'changeLanguage'.tr(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logout the user
                    logout(context);
                  },
                  child: Text(
                    "logout".tr(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(
      String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label.tr(),
            style: labelStyle,
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
