import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: ' ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(40, 40, 40, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> extractUrlsFromText(String text) {
    final regex = RegExp(
      r'(https?://(?:www\.|(?!www))[^\s.]+\.[^\s]{2,}-360\.mp4)',
      caseSensitive: false,
      multiLine: true,
    );

    final matches = regex.allMatches(text);

    final urls = matches.map((match) => match.group(0)!).toList();

    return urls;
  }

  void _extractUrls() {
    final text = urlController.text;
    final urls = extractUrlsFromText(text);
    setState(() {
      _urls = urls;
    });
    for (final url in urls) {
      print(url);
    }
  }

  List<String> _urls = [];

  void showNotice() {
    Get.snackbar(
      colorText: Colors.white,
      'المطور',
      'المهندس سجاد سلام ',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  final urlController = TextEditingController();
  final savePathController = TextEditingController();
  final List<String> mp4Links = [];

  String savePath = '';

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      setState(() {
        savePath = result;
        savePathController.text = result;
      });
    }
  }

  void downloadVideosFromUrls(List<String> urls, String savePath) async {
    for (final url in urls) {
      if (url.endsWith('.mp4')) {
        try {
          final response = await http.get(Uri.parse(url));
          final bytes = response.bodyBytes;
          final file = File('$savePath/${Uri.parse(url).pathSegments.last}');
          await file.writeAsBytes(bytes);
          print("download starting");
        } catch (e) {
          print('Error downloading video from URL: $url');
          print(e);
        }
      }
    }
  }

  Future<List<String?>> extractMp4Urls() async {
    const url = 'https://movie.vodu.me/index.php?do=view&type=post&id=73529.mp4';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {} catch (e) {}
      final document = parser.parse(response.body);
      final videoElements =
          document.querySelectorAll('video > source[src\$=".mp4"]');
      final mp4Urls =
          videoElements.map((element) => element.attributes['src']).toList();
      return mp4Urls;
    } else {
      throw Exception('Failed to fetch the web page');
    }
  }

  void printMp4Urls() async {
    try {
      final mp4Urls = await extractMp4Urls();
      mp4Urls.forEach(print);
      print(mp4Urls);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    savePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
      appBar: const CupertinoNavigationBar(
        middle: Text(
          'vodu downloader',
          style: TextStyle(
              fontFamily: "myfont", color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromRGBO(255, 128, 128, 10),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: urlController,
              style: const TextStyle(
                  color: Colors.white, fontFamily: "myfont", fontSize: 14),
              decoration: const InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'رابط المسلسل او الفلم',
                labelStyle: TextStyle(
                  fontFamily: "myfont",
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                // helperText: 'Helper text',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _openFilePicker,
              child: const Text(
                'اختار مسار حفض البيانات',
                style: TextStyle(fontFamily: "myfont"),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'سيتم حفض الملفات في : $savePath',
              style: const TextStyle(
                  fontSize: 12.0, fontFamily: "myfont", color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _urls.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_urls[index]),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _extractUrls,
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'تحميل الفيديوهات',
                style: TextStyle(fontFamily: "myfont", color: Colors.white),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            ElevatedButton(
              onPressed: () {
                downloadVideosFromUrls(_urls, savePath);
              },
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'تحميل الترجمات',
                style: TextStyle(fontFamily: "myfont", color: Colors.white),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 50)),
            TextButton(
              onPressed: () {},
              child: const Text(
                "مشاهده الشرح عن البرنامج",
                style: TextStyle(
                  // shadows: CupertinoContextMenu.kEndBoxShadow,
                  fontFamily: "myfont",
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotice,
        tooltip: 'Increment',
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
