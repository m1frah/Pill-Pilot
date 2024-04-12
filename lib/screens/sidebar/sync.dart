import 'package:flutter/material.dart';
import '../../database/sync_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SyncPage extends StatelessWidget {
  final SyncService syncService = SyncService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250, // Adjust the width as needed
              height: 200, // Adjust the height as needed
              child: ElevatedButton.icon(
                onPressed: () async {
                  await syncService.initializeFirebase();
                  await syncService.loadFirebaseDataToLocal();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data loaded from Firebase to local!'),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.cloudDownloadAlt,
                  size: 40, // Adjust the icon size as needed
                ),
                label: Text(
                  'Load Data from Firebase to Local',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 250, // Adjust the width as needed
              height: 200, // Adjust the height as needed
              child: ElevatedButton.icon(
                onPressed: () async {
                  await syncService.initializeFirebase();
                  await syncService.syncData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data synced successfully!'),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.cloudUploadAlt,
                  size: 40, // Adjust the icon size as needed
                ),
                label: Text(
                  'Sync Data to Firebase',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
