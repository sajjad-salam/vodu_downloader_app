import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(40, 40, 40, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'vodu downloader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 1000;
    });
  }

  void showNotice() {
    Get.snackbar(
      colorText: Colors.white,
      'developer',
      'Eng. sajjad salam',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  void _openvideo() async {
    const url =
        'https://youtu.be/YxNpMl5_OsA?list=PLDVWo4Hzejmp5wVVlOMqt6fkHoomPKFegA';
    try {
      // ignore: deprecated_member_use
      await launch(url);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(40, 40, 40, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 128, 128, 10),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "myfont", color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                  color: Colors.white, fontFamily: "myfont", fontSize: 14),
              onChanged: (value) {},
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
            Padding(padding: EdgeInsets.only(top: 120)),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'تحميل الفيديوهات',
                style: TextStyle(fontFamily: "myfont", color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            ElevatedButton(
              onPressed: _openvideo,
              child: const Text(
                'تحميل الترجمات',
                style: TextStyle(fontFamily: "myfont", color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            TextButton(
              onPressed: () => _openvideo(),
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
