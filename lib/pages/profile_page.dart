import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 70,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.home_rounded, color: Colors.white),
                  onPressed: () {
                    // Aktion beim Klicken auf das Home-Icon
                  },
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // Aktion beim Klicken auf das Add-Icon
                  },
                ),
              ],
            ),
          ),
          SizedBox(
              width:
                  20), // Fügt einen Abstand zwischen dem Container und dem Rest der Seite hinzu
          Expanded(
            child: Container(
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabeledEditableTextField(
                        label: 'Name', initialValue: 'John Doe'),
                    SizedBox(height: 20),
                    LabeledEditableTextField(
                        label: 'Benutzername',
                        initialValue: 'john.doe@example.com'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledEditableTextField extends StatefulWidget {
  final String label;
  final String initialValue;

  LabeledEditableTextField({required this.label, required this.initialValue});

  @override
  _LabeledEditableTextFieldState createState() =>
      _LabeledEditableTextFieldState();
}

class _LabeledEditableTextFieldState extends State<LabeledEditableTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    : Text(
                        _controller.text,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.done : Icons.edit,
                    color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
