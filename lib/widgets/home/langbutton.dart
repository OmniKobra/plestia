// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class LangButton extends StatefulWidget {
  const LangButton();

  @override
  State<LangButton> createState() => _LangButtonState();
}

class _LangButtonState extends State<LangButton> {
  DropdownMenuItem<String> buildLangButtonItem({
    required String asseturl,
    required String value,
    required String description,
    required void Function(String) setLang,
    required bool widthQuery,
  }) =>
      DropdownMenuItem<String>(
        value: value,
        onTap: () => setLang(value),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40, width: 40, child: Image.network(asseturl)),
              if (widthQuery)
                Text(description,
                    style: const TextStyle(color: Colors.black, fontSize: 15))
            ]),
      );
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<ThemeModel>(context);
    final currentLang = lang.langCode;
    final setLang = Provider.of<ThemeModel>(context, listen: false).setLanguage;
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: widthQuery ? 50 : 40,
          width: widthQuery ? 117 : 58.5,
          padding:
              widthQuery ? const EdgeInsets.all(2.5) : const EdgeInsets.all(0),
          margin: lang.textDirection == TextDirection.rtl
              ? const EdgeInsets.all(0)
              : const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: MediaQuery.of(context).size.width <= 600
                  ? Border.all()
                  : null),
          child: DropdownButton(
              dropdownColor: Colors.white,
              key: UniqueKey(),
              borderRadius: BorderRadius.circular(25.0),
              onChanged: (_) => setState(() {}),
              underline: Container(color: Colors.transparent),
              icon: Icon(Icons.arrow_drop_down,
                  color: widthQuery ? Colors.transparent : Colors.black,
                  size: widthQuery ? 0.1 : 13),
              value: currentLang,
              items: [
                buildLangButtonItem(
                    asseturl:
                        'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fen_lang.png?alt=media&token=4e0a6d7e-df34-4731-b868-95d1be79e5ff&_gl=1*13d4f1a*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzYwMS4yNS4wLjA.',
                    value: 'en',
                    description: 'English',
                    widthQuery: widthQuery,
                    setLang: setLang),
                buildLangButtonItem(
                    asseturl:
                        'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Far_lang.png?alt=media&token=d1ec609b-604f-412d-85af-78bbb2baaaf6&_gl=1*1w37fiw*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzY2NC41NS4wLjA.',
                    value: 'ar',
                    description: 'العربية',
                    widthQuery: widthQuery,
                    setLang: setLang),
                buildLangButtonItem(
                    asseturl:
                        'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Ftr_lang.png?alt=media&token=92064812-0cef-45ce-8561-18334fde0f89&_gl=1*15yshau*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzcwNS4xNC4wLjA.',
                    value: 'tr',
                    description: 'Türkçe',
                    widthQuery: widthQuery,
                    setLang: setLang),
                buildLangButtonItem(
                    asseturl:
                        'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Ffr_lang.png?alt=media&token=d6effccf-c338-4273-9a04-f69bda60f6e5&_gl=1*x801nr*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzc1Ni41MS4wLjA.',
                    value: 'fr',
                    description: 'Français',
                    widthQuery: widthQuery,
                    setLang: setLang),
              ])),
    );
  }
}
