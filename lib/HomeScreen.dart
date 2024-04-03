
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String controller; // متغير لتخزين النص  المدخل من المستخدم
  bool pressed = false; // تحكم في إظهار النص المعدل
  late List<String> dividedText;
  int counter = 1; // قائمة لتخزين الأجزاء المقسمة من النص

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.indigo[300],
          title: const Center(
            child: Text(
              "Replace Number",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (data) {
                  setState(() {
                    controller = data;
                    dividedText =
                        _divideText(controller); // تقسيم النص عند التغيير
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pressed = true;
                  dividedText = _divideText(controller);
                  counter=1;
                  // تقسيم النص عند الضغط
                });
              },
              child: const Text('Change'),
            ),
            if (pressed)
              Column(
                children: dividedText
                    .map(
                      (text) => Stack(children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: text)); // نسخ النص عند الضغط
                            },
                            child: Text(
                              text,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: double.minPositive,
                          right: double.minPositive,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text('${counter++}'),
                          ),
                        ),
                      ]),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

// دالة لتقسيم النص إلى أجزاء
  List<String> _divideText(String text) {
    List<String> dividedText = [];
    RegExp regex = RegExp(r'[0-9]|[->:,\n]');

    // قم بحذف الأرقام والعلامات من النص
    String cleanedText = text.replaceAll(regex, '');

    // قم بتقسيم النص إلى كلمات
    List<String> words = cleanedText.split(' ');

    // عدد الكلمات في كل جزء
    int wordsPerChunk = 175;

    // تقسيم النص إلى مجموعات بحيث يحتوي كل جزء على عدد محدد من الكلمات
    for (int i = 0; i < words.length; i += wordsPerChunk) {
      dividedText.add(words
          .sublist(
              i,
              i + wordsPerChunk < words.length
                  ? i + wordsPerChunk
                  : words.length)
          .join(' '));
    }

    return dividedText;
  }
}
