import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrueHomeScreen extends StatefulWidget {
  const TrueHomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<TrueHomeScreen> {
  final TextEditingController _folderNameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        title: const Text("My folders"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 150, 243, 1),
              ),
              child: Text(
                'Username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Profile stuff will go here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Settings stuff will go here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: (signUserOut),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getFolders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final folders = snapshot.data?.docs ?? [];

          return Stack(
            children: [
              ListView.builder(
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot folder = folders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: Text(folders[index]['name']),
                        subtitle: Text(
                            '${folders[index]['setsCount'] ?? 0} sets present'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String value) {
                            switch (value) {
                              case 'Edit':
                                //This calls on the edit folder name method to edit a folder name
                                _editFolderName(context, folder);
                                break;
                              case 'Delete':
                                //This calls on the delete folder method to delete and confirm deletion of folders
                                _deleteFolder(folder.id);
                                break;
                              default:
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: Code to call sets in folder for display go here
                        },
                      ),
                    ),
                  );
                },
              ),

              // Add folder button
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: ElevatedButton(
                  onPressed: () => _createFolderDialog(context),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createFolderDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Create a new folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: const InputDecoration(
              hintText: "Name of Folder",
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _folderNameController.clear();
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () async {
                if (_folderNameController.text.trim().isNotEmpty) {
                  await _firestoreService
                      .createFolder(_folderNameController.text.trim());
                  _folderNameController.clear();
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editFolderName(
      BuildContext context, DocumentSnapshot folder) async {
    final TextEditingController _editFolderNameController =
        TextEditingController(text: folder['name']);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Folder Name'),
          content: TextField(
            controller: _editFolderNameController,
            decoration: const InputDecoration(
              hintText: "Enter a new folder name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                String newFolderName = _editFolderNameController.text.trim();
                if (newFolderName.isNotEmpty &&
                    newFolderName != folder['name']) {
                  await _firestoreService.updateFolderName(
                      folder.id, newFolderName);
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFolder(String folderId) async {
    // Confirm with the user before deleting the folder
    bool confirmDelete = await _showConfirmDialog(
      context: context,
      title: "Delete Folder",
      content: "Are you sure you want to delete this folder?",
    );

    if (confirmDelete) {
      try {
        // Access the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Delete the folder from Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('folders')
              .doc(folderId)
              .delete();

          // Shows a snackbar, confirming the deletion of the folder
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Folder deleted successfully')),
          );
        }
      } catch (e) {
        // This is for error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting folder: $e')),
        );
      }
    }
  }

  Future<bool> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(false), // Dismiss and return false
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(true), // Dismiss and return true
                ),
              ],
            );
          },
        ) ??
        false; // In case the dialog is dismissed by tapping outside of it
  }
}

//This is the logic for creating and getting folders from firestore
//This is also for displaying data from firestore, that's why the DeleteFolder method is not present
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getFolders() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('folders')
          .snapshots();
    }
    return const Stream.empty();
  }

  Future<void> createFolder(String folderName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('folders')
          .add({
        'name': folderName,
        'setsCount': 0, // This initializes the folder with 0 sets
        'createdAt': Timestamp
            .now(), // This gets the timestamp of when the folder was created
      });
    }
  }

  Future<void> updateFolderName(String folderId, String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('folders')
          .doc(folderId)
          .update({
        'name': newName,
      });
    }
  }
}
