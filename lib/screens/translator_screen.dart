import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  final List<String> _languages = ["English", "Hindi", "Bengali", "Russian"];
  final List<String> _outputLanguages = ["English", "Hindi"];
  final TextEditingController _inputText = TextEditingController();
  String result = "";

  // * Function to get language code
  String _getLanguageCode(String language) {
    Map<String, String> langMap = {
      "English": "en",
      "Hindi": "hi",
      "Bengali": "bn",
      "Russian": "ru"
    };
    return langMap[language] ?? "";
  }

  // * Translate Language Function
  void _translateLanguage() async {
    String fromLanguageCode = _getLanguageCode(_outputLanguages[0]);
    String toLanguageCode = _getLanguageCode(_outputLanguages[1]);

    var result = await translator.translate(_inputText.text,
        from: fromLanguageCode, to: toLanguageCode);

    setState(() {
      this.result = result.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Translate IT',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: [
        // * Text Input
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          margin: const EdgeInsets.only(top: 6, bottom: 16),
          child: TextField(
              controller: _inputText,
              decoration:
                  const InputDecoration(label: Text("Enter Text here"))),
        ),
        // * Translate Language Option Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // * create dropdown & for options use languages array
              DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 24,
                  ),
                  value: _outputLanguages[0],
                  items: _languages.map((String language) {
                    return DropdownMenuItem<String>(
                        value: language, child: Text(language));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _outputLanguages[0] = newValue.toString();
                    });
                  }),
              // * Right Arrow Icon
              const Icon(Icons.arrow_right_alt_outlined),
              // * create dropdown & for options use languages array
              DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 24,
                  ),
                  value: _outputLanguages[1],
                  items: _languages
                      .where(
                    (element) => element != _outputLanguages[0],
                  )
                      .map((String language) {
                    return DropdownMenuItem<String>(
                        value: language, child: Text(language));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _outputLanguages[1] = newValue.toString();
                    });
                  }),
            ],
          ),
        ),
        // * Translate Button
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                  onPressed: _translateLanguage,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text("Translate")),
            )),
          ],
        ),
        // * Translated Text comes here
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            result,
            style: const TextStyle(fontSize: 24),
          ),
        )
      ]),
    );
  }
}
