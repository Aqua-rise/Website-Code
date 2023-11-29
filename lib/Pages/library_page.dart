import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:questure/Pages/card_list_screen.dart';
import 'package:questure/Pages/create_page.dart';
import 'package:questure/Pages/add_cards_screen.dart';

class TrueHomeScreen extends StatefulWidget {
  const TrueHomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<TrueHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 224, 224),
      appBar: AppBar(
        title: const Text("My folders",
            style: TextStyle(
              color: Color.fromRGBO(14, 60, 83, 1),
              fontSize: 24,
            )),
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(148, 204, 202, 1),
              ),
              child: Text(
                'Username',
                style: TextStyle(
                  color: Color.fromRGBO(14, 60, 83, 1),
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

          return Center(
            child: SizedBox(
              width: 1000,
              child: Stack(
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
                            title: Text(folders[index]['name'],
                                style: const TextStyle(
                                  color: Color.fromRGBO(14, 60, 83, 1),
                                  fontSize: 20,
                                )),
                            subtitle: Text(folders[index]['description'],
                                style: const TextStyle(
                                  color: Color.fromRGBO(14, 60, 83, 1),
                                  fontSize: 15,
                                )),
                            trailing: PopupMenuButton<String>(
                              onSelected: (String value) {
                                switch (value) {
                                  case 'Edit Name':
                                    //This calls on the edit folder name method to edit a folder name
                                    editFolderName(context, folder);
                                    break;
                                  case 'Edit Description':
                                    //This calls on the edit folder name method to edit a folder name
                                    editDescription(context, folder);
                                    break;
                                  case 'Delete':
                                    //This calls on the delete folder method to delete and confirm deletion of folders
                                    deleteFolder(folder.id);
                                    break;
                                  default:
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Edit Name',
                                  child: Text('Edit Name'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Edit Description',
                                  child: Text('Edit Description'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                            onTap: () {
                              //functionality of folders to navagate the card list screen on click or tap
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CardListScreen(
                                    folderId: folder.id,
                                    folderName: folder['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Functionality for the add folder button (now shows create options)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateOptions(context);
        },
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            const SizedBox(
              height: 20,
              width: 20,
            ),
            Center(
              child: SizedBox(
                width: 650,
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('Create Folder',
                        style: TextStyle(
                          color: Color.fromRGBO(14, 60, 83, 1),
                          fontSize: 17,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      //functinality to go to the Create page on tap
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreatePage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              width: 20,
            ),
            Center(
              child: SizedBox(
                width: 650,
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.note_add),
                    title: const Text('Create Card Set',
                        style: TextStyle(
                          color: Color.fromRGBO(14, 60, 83, 1),
                          fontSize: 17,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      // Asynchronously create the default folder and get its ID
                      createDefaultFolder().then((defaultFolderId) {
                        // Navigate to the AddCardsScreen with the default folder ID
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AddCardsScreen(folderId: defaultFolderId),
                        ));
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              width: 20,
            ),
          ],
        );
      },
      backgroundColor: const Color.fromARGB(255, 195, 201, 201),
    );
  }

  Future<void> editFolderName(
      BuildContext context, DocumentSnapshot folder) async {
    final TextEditingController editFolderNameController =
        TextEditingController(text: folder['name']);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Folder Name'),
          content: TextField(
            controller: editFolderNameController,
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
                String newFolderName = editFolderNameController.text.trim();
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

  Future<void> editDescription(
      BuildContext context, DocumentSnapshot folder) async {
    final TextEditingController editFolderDescriptionController =
        TextEditingController(text: folder['description']);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Folder Description'),
          content: TextField(
            controller: editFolderDescriptionController,
            decoration: const InputDecoration(
              hintText: "Enter a new descrption",
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
                String newFolderName =
                    editFolderDescriptionController.text.trim();
                if (newFolderName.isNotEmpty &&
                    newFolderName != folder['description']) {
                  await _firestoreService.updateFolderDescription(
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

  Future<void> deleteFolder(String folderId) async {
    // Confirm with the user before deleting the folder
    bool confirmDelete = await showConfirmDialog(
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

  //Delete conformation
  Future<bool> showConfirmDialog({
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

Future<String> createDefaultFolder() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentReference folderRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('folders')
        .add({
      'name': 'New folder', // Temporary empty name
      'description': '' //Empty description
    });
    return folderRef.id; // Return the document ID of the new folder
  } else {
    throw Exception('An error occured');
  }
}

//This is the logic for creating and getting folders from firestore
//This is also for displaying data from firestore
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

  Future<void> updateFolderDescription(
      String folderId, String newDescription) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('folders')
          .doc(folderId)
          .update({
        'description': newDescription,
      });
    }
  }
}
