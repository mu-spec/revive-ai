import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LegalScreen extends StatefulWidget {
  final String title;
  final String assetPath;

  const LegalScreen({super.key, required this.title, required this.assetPath});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  String _content = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final String text = await rootBundle.loadString(widget.assetPath);
      if (mounted) {
        setState(() {
          _content = text;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _content = 'Failed to load the document from the app bundle.\n\n'
              'For the most up-to-date version, please contact:\n'
              'saaddkhan99@gmail.com\n\n'
              'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _content,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }
}
