import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pillapp/model/model.dart';
import 'medcine/medicinepage.dart';
import 'appointments/appointments.dart';
import 'community/community.dart';
import '../widgets/calender.dart';
import 'signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sidebar/editprofile.dart';
import 'sidebar/friends/friends.dart';
import 'sidebar/sync.dart';
import 'sidebar/Journal/journal.dart';
import '../database/sql_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../database/firebaseoperations.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  

}

class _HomePageState extends State<HomePage> {
    FirebaseOperations _firebaseOperations = FirebaseOperations(); 
  int _selectedIndex = 0;
String? _userProfilePicture;
  final List<Widget> _pages = [
    CalendarWidget(),
    MedicationPage(),
    AppointmentPage(),
    CommunityPage()
  ];

  String _username = '';

  @override
  void initState() {
    super.initState();
     _loadUsernameAndProfilePicture();
  }

  Future<void> _loadUsernameAndProfilePicture() async {
  if (FirebaseAuth.instance.currentUser != null) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      setState(() {
        _username = userSnapshot.data()!['username'] ?? '';
      });
   Users userProfilePicture = await _firebaseOperations.getUserData();
        setState(() {
          _userProfilePicture = userProfilePicture.pfp;
        });
    }
  } else {
    setState(() {
      _username = 'Guest';
    });
  }
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
static Future<void> deleteNonFbMEDS() async {
  try {
    await SQLHelper.deleteNonLocalMeds();
  } catch (err) {
    debugPrint("Something went wrong: $err");
  }
}
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); 
      deleteNonFbMEDS();
  Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
 Widget _buildUserProfileIcon(String? userProfilePicture) {
  if (userProfilePicture != null && userProfilePicture.isNotEmpty) {
    String fullUrl = "assets/$userProfilePicture";
    return CircleAvatar(
      radius: 28,
      backgroundImage: AssetImage(fullUrl),
    );
  } else {
    return Icon(
      Icons.account_circle,
      size: 32,
      color: Color.fromARGB(255, 48, 47, 69),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255), 
         
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent, 
              elevation: 0, 
              title: Row(
                children: [
                 
               InkWell(
  onTap: () {
    Scaffold.of(context).openDrawer();
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal:0.0),
    child: _buildUserProfileIcon(_userProfilePicture),
  ),
),
                  SizedBox(width: 10), 
              
                  Text(
                    _username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 71, 61, 110)), // Change the color of the text
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 109, 111, 224),
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
      child: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 163, 123, 255), Color.fromARGB(255, 42, 24, 182)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Icon(
  FontAwesomeIcons.capsules,
  color: Colors.white,
  size: 40,
),
                  SizedBox(width: 10),
                  Text(
                    'Pill Pilot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Your Health Co-Pilot ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()), 
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.sync),
        title: Text(
          'Sync Data',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SyncPage()), 
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.book),
        title: Text(
          'Journal',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JournalPage()), 
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text(
          'Friends',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendsPage()), 
          );
        },
      ),
      ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Text(
          'Log Out',
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
          ), 
        ),
        onTap: _signOut,
      ),
    ],
  ),
),
      )
    );
  }
}
