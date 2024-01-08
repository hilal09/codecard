import 'package:flutter/material.dart';
import 'dart:math';

class Suchleiste extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const Suchleiste({super.key, required this.onSearch});

  @override
  _SuchleisteState createState() => _SuchleisteState();
}

class _SuchleisteState extends State<Suchleiste> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarWidth =
        min(screenWidth * 0.8, 355); // Beispiel für maximale Breite

    return Center(
        // Zentrieren der Suchleiste
        child: Container(
      width: searchBarWidth,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 45, 31, 65),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (text) {
                if (text.length <= 22) {
                  widget.onSearch(text);
                }
              },
              focusNode: _focusNode,
              controller: _textEditingController,
              maxLength: 22,
              style: const TextStyle(fontSize: 17, color: Colors.white),
              decoration: InputDecoration(
                labelText: _hasFocus || _textEditingController.text.isNotEmpty
                    ? ''
                    : 'Suche',
                labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
                fillColor: const Color.fromARGB(255, 45, 31, 65),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_textEditingController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                setState(() {
                  _textEditingController.clear();
                  widget.onSearch('');
                });
              },
            ),
        ],
      ),
    ));
  }
}
