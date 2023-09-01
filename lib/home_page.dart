import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'linear.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

// تحميل الترجمات راح فقط تاخذ دوال الفيديو تعدل اسمائهن وصيغ التحميل اي بمعنى (اس ار تي ) وتبرمج الزر

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final String recipientEmail = 'sajjad.salam.teama@gmail.com';
  Future<void> _sendEmail(recipientEmail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Subject here',
        'body': 'Type your message here',
      },
    );

    final String url = emailLaunchUri.toString();

    try {
      // ignore: deprecated_member_use
      await launch(url);
    } catch (e) {
      Get.snackbar("خطأ", "لايمكن فتح الرابط بسبب $e");
    }
  }

  String htmlContent = '';
  Future<void> fetchPageSource(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          htmlContent = response.body;
        });
        print(htmlContent);
        urlController.text = htmlContent;
      } else {
        setState(() {
          htmlContent = 'Failed to fetch page source';
        });
        Get.snackbar("خطأ", htmlContent);
      }
    } catch (e) {
      setState(() {
        htmlContent = 'Error: $e';
      });
      Get.snackbar("خطأ", htmlContent);
    }
  }

  // دالة تابعة الى دالة استخراج الروابط من النص
  List<String> extractUrlsFromText(String text) {
    final regex = RegExp(
      // r'https?://[^\s/$.?#].[^\s]*',
      caseSensitive: false,
      multiLine: true,
      // افتح الكومنت عن السطر الجوة اذا تريد تحمل بس ملفات ال فيديو
      r'(https?://(?:www\.|(?!www))[^\s.]+\.[^\s]{2,}-360\.mp4)',
      // caseSensitive: false,
      // multiLine: true,
    );

    final matches = regex.allMatches(text);

    final urls = matches.map((match) => match.group(0)!).toList();

    return urls;
  }

  // دالة تابعة الى دالة استخراج الروابط للترجمات من النص
  List<String> extractUrls_srt_FromText(String text) {
    final regex = RegExp(
      // r'https?://[^\s/$.?#].[^\s]*',
      caseSensitive: false,
      multiLine: true,
      // افتح الكومنت عن السطر الجوة اذا تريد تحمل بس ملفات ال فيديو
      r'(https?://(?:www\.|(?!www))[^\s.]+\.[^\s]{2,}.srt)',
      // caseSensitive: false,
      // multiLine: true,
    );

    final matches = regex.allMatches(text);

    final urls = matches.map((match) => match.group(0)!).toList();

    return urls;
  }

// دالة استخراج الروابط من االنص
  void _extractUrls() {
    final text = urlController.text;
    final urls = extractUrlsFromText(text);
    setState(() {
      _urls = urls;
    });
    for (final url in urls) {
      // ignore: avoid_print
      print(url);
    }
  }

  void _extract_srt_Urls() {
    final text = urlController.text;
    final urls = extractUrls_srt_FromText(text);
    setState(() {
      _urls = urls;
    });
    for (final url in urls) {
      // ignore: avoid_print
      print(url);
    }
  }

  void showNotice() {
    Get.snackbar(
      onTap: (snake) {
        _sendEmail('sajjad.salam.teama@gmail.com');
      },
      colorText: Colors.white,
      'المطور',
      'المهندس سجاد سلام\nاضغط لأرسال رسالة\nsajjad.salam.teama@gmail.com ',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  List<String> _urls = [];
  final urlController = TextEditingController();
  double? _progress;
  double progressbar = 0;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void dispose() {
    urlController.dispose();
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
              onFieldSubmitted: (value) {
                fetchPageSource(value);
                // هنا راح نستخرج من الرابط النصوص الموجودة بي
              },
              style: const TextStyle(
                  color: Colors.white, fontFamily: "myfont", fontSize: 14),
              decoration: InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'رابط المسلسل او الفلم',
                labelStyle: TextStyle(
                  fontFamily: "myfont",
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                // helperText: 'https://movie.vodu.me/index.php?do=view&type=post&id=30215',
                suffixIcon: IconButton(
                    onPressed: () {
                      urlController.text = "";
                    },
                    icon: Icon(Icons.clear)),

                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _progress != null
                ? Column(
                    children: [
                      ProgressIndicatorExample(progress: progressbar),
                      Text(
                        _progress!.toInt().toString(),
                        style: const TextStyle(
                          fontFamily: "myfont",
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : button_video(),
            const Padding(padding: EdgeInsets.only(top: 30)),
            button_subtitle(),
            const Padding(padding: EdgeInsets.only(top: 50)),
            youtube_button()
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

  // ignore: non_constant_identifier_names
  TextButton youtube_button() {
    return TextButton(
      onPressed: () {
        // تشغيل فيديو يوتيوب
      },
      child: const Text(
        "مشاهده الشرح عن البرنامج",
        style: TextStyle(
          // shadows: CupertinoContextMenu.kEndBoxShadow,
          fontFamily: "myfont",
          fontSize: 18,
          color: Colors.red,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ElevatedButton button_subtitle() {
    return ElevatedButton(
      onPressed: () {
        // print(urlController.text);
        _extract_srt_Urls();
        print(urlController.text);
        _progressList.clear(); // Clear previous progress values

        for (String url in _urls) {
          _progressList
              .add(null); // Initialize progress value for each download
          try {
            FileDownloader.downloadFile(
              url: url.trim(),
              onDownloadError: (errorMessage) {
                Get.snackbar("خطأ", errorMessage);
              },
              onProgress: (name, progress) {
                setState(() {
                  progressbar = progress;
                  _progress = progress;
                  _progressList[_urls.indexOf(url)] =
                      progress; // Update progress for each download
                });
              },
              onDownloadCompleted: (path) {
                // Handle download completion for each file
                // ignore: avoid_print
                print("Download completed for $path");
                // Update your UI or state as needed
                setState(() {
                  progressbar = 100;
                  _progress = null;
                  _progressList[_urls.indexOf(url)] =
                      null; // Reset progress when download completes
                });
              },
            );
          } catch (e) {
            Get.snackbar("خطأ", e.toString());
          }
        }

        // Get.snackbar(" ًعذرا", "هذه الخاصية غير متوفرة في  هذا الأصدار",
        //     snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
      },
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.amber),
        overlayColor: MaterialStateProperty.all(Colors.red),
      ),
      child: const Text(
        'تحميل الترجمات',
        style: TextStyle(fontFamily: "myfont", color: Colors.white),
      ),
    );
  }

  // ignore: prefer_final_fields
  List<double?> _progressList = []; // List to store progress values

  // ignore: non_constant_identifier_names
  ElevatedButton button_video() {
    return ElevatedButton(
      onPressed: () {
        _extractUrls();
        _progressList.clear(); // Clear previous progress values

        for (String url in _urls) {
          _progressList
              .add(null); // Initialize progress value for each download
          try {
            FileDownloader.downloadFile(
              url: url.trim(),
              onDownloadError: (errorMessage) {
                Get.snackbar("خطأ", errorMessage);
              },
              onProgress: (name, progress) {
                setState(() {
                  progressbar = progress;
                  _progress = progress;
                  _progressList[_urls.indexOf(url)] =
                      progress; // Update progress for each download
                });
              },
              onDownloadCompleted: (path) {
                // Handle download completion for each file
                // ignore: avoid_print
                print("Download completed for $path");
                // Update your UI or state as needed
                setState(() {
                  progressbar = 100;
                  _progress = null;
                  _progressList[_urls.indexOf(url)] =
                      null; // Reset progress when download completes
                });
              },
            );
          } catch (e) {
            Get.snackbar("خطأ", e.toString());
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        overlayColor: MaterialStateProperty.all(Colors.red),
      ),
      child: const Text(
        'تحميل الفيديوهات',
        style: TextStyle(fontFamily: "myfont", color: Colors.white),
      ),
    );
  }
}
