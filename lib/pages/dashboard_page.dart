import 'package:codecard/widgets/colorpicker.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/suchleiste.dart';
import 'package:codecard/widgets/left_sidebar.dart';

import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Folder> folders = [];
  String searchTerm = "";

  Future<void> _showCreateFolderDialog({Folder? existingFolder}) async {
    String folderName = existingFolder?.name ?? "";
    Color selectedColor = existingFolder?.color ?? Color(0xFFFfd4a4a);

    TextEditingController folderNameController =
        TextEditingController(text: folderName);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            existingFolder == null ? "Create a Folder" : "Edit Folder",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.5, // Adjust the width as needed
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: folderNameController,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                      folderName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You need to give the folder a name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Folder Name',
                      errorText: formKey.currentState?.validate() == false
                          ? 'You need to give the folder a name'
                          : null,
                      labelStyle:
                          TextStyle(color: Colors.white), // Set label color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Set focused border color
                      ),
                      // Set text color
                      // You can customize the text color further using TextStyle
                      // Example: TextStyle(color: Colors.white, fontSize: 16),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Choose Folder Color:",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  ColorPicker(
                    onColorSelected: (color) {
                      selectedColor = color;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  if (existingFolder == null) {
                    // Create a new folder
                    setState(() {
                      folders
                          .add(Folder(name: folderName, color: selectedColor));
                    });
                  } else {
                    // Update the existing folder
                    setState(() {
                      existingFolder.name = folderName;
                      existingFolder.color = selectedColor;
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                existingFolder == null ? 'Create' : 'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteFolderDialog(Folder folder) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(style: TextStyle(color: Colors.white), 'Delete Folder'),
          content: Text(
              style: TextStyle(color: Colors.white),
              'Are you sure you want to delete the folder?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  folders.remove(folder);
                });
                Navigator.of(context).pop();
              },
              child: Text(style: TextStyle(color: Colors.white), 'Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFolderTile(Folder folder) {
    return GestureDetector(
      onTap: () {
        _showCreateFolderDialog(existingFolder: folder);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: folder.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Edit"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Delete"),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showCreateFolderDialog(existingFolder: folder);
                  } else if (value == 2) {
                    _showDeleteFolderDialog(folder);
                  }
                },
              ),
            ),
            Center(
              child: Text(
                folder.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFolderMessage() {
    return Center(
      child: Text(
        'Click on the + to create a new folder',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

// UI der Seite
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            LeftSideBar(),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2c293a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Suchleiste(
                          onSearch: (term) {
                            setState(() {
                              searchTerm = term;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            _showCreateFolderDialog();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    folders.isEmpty
                        ? _buildEmptyFolderMessage()
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: folders
                                  .where((folder) => folder.name
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()))
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                Folder folder = folders
                                    .where((folder) => folder.name
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()))
                                    .toList()[index];
                                return _buildFolderTile(folder);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
