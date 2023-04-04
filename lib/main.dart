import 'package:flutter/material.dart';
import 'package:ornek/album.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Example App'),
      initialRoute: '/',
      //başlangıç route'ını initalRoute ile vermem gerekir.
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Example App'),
        //named route'ta bunu kullanmam gerekiyor.

        '/settings': (context) => SettingsPage(),

        //yukarıdan aşşağı doğru çalışır: 'settings'' -> ... -> '/''
      }, //bu bir map
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
      _counter++;
    });
  }

  var sinif = 5;
  var baslik = 'Ogrenciler';
  var ogrenciler = [
    'Ali',
    'Ayşe',
    'Can'
  ]; //final yapsak bile burada içi değiştirilebilir. Dikkat etmek gerekir.
  //Bu sorunu Sinif'i const değişken yapıp,
  // InheritedWidgetların mevcut şeyi değiştirmeden farklı nesnelere bakmasını sağlayarak yapıyoruz.
  //Hemen alt kod satırında bu işlem var.
  void yeniOgrenciEkle(String yeniOgrenci) {
    setState(() {
      ogrenciler = [
        ...ogrenciler,
        yeniOgrenci
      ]; //artık inheritedWidgetlarımız ogrenciler'e değil farklı nesnelere bakıyor olacak.
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq =
        MediaQuery.of(context); //mediaQuery'i alıyoruz MyApp->Details içinden
    final screenSize = mq.size; //screenSize'ı alıyoruz
    final desiredWidth = 300.0; //hangi boyuta göre tasarladıysak onu veriyoruz.
    final ratio = screenSize.width / desiredWidth; // oran buluyoruz
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              print('settings');
              Navigator.of(context).pushNamed('/settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SinifBilgisi(
        sinif: sinif,
        baslik: baslik,
        ogrenciler: ogrenciler,
        yeniOgrenciEkle: yeniOgrenciEkle,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ArkaPlan(),
            Positioned(
                top: 45,
                right: 10,
                left: 10,
                child: LayoutBuilder(builder: (context, constraints) {
                  print('constraints.maxWidth: ${constraints.maxWidth}');
                  if (constraints.maxWidth > 450) {
                    return Row(
                      children: [
                        Sinif(),
                        Expanded(
                            child: Text('Seçili olan öğrencinin detayları.')),
                      ],
                    );
                  } else {
                    return Sinif();
                  }
                })),
            Positioned(
              //yön belirtip yanında oradan ne kadar uzak olacağını seçiyoruz.
              bottom: 20,
              left: 10,
              right: 10,
              child: OgrenciEkleme(),
            ),
          ],
        ),
      ),
    );
  }
}

class SinifBilgisi extends InheritedWidget {
  const SinifBilgisi({
    Key? key,
    required Widget child,
    required this.sinif,
    required this.baslik,
    required this.ogrenciler,
    required this.yeniOgrenciEkle,
  }) : super(key: key, child: child);
  final int sinif;
  final String baslik;
  final List<String> ogrenciler;
  final Function(String yeniOgrenci) yeniOgrenciEkle;

  static SinifBilgisi of(BuildContext context) {
    final SinifBilgisi? result =
        context.dependOnInheritedWidgetOfExactType<SinifBilgisi>();
    assert(result != null, 'No SinifBilgisi found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SinifBilgisi old) {
    return sinif != old.sinif ||
        baslik != old.baslik ||
        ogrenciler != old.ogrenciler ||
        yeniOgrenciEkle != old.yeniOgrenciEkle;
  }
}

class Sinif extends StatelessWidget {
  const Sinif({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.red,
              ),
              Text(
                '${sinifBilgisi.sinif}. Sınıf',
                textScaleFactor: 2,
              ),
              Icon(
                Icons.star,
              ),
            ],
          ),
          Text(
            sinifBilgisi.baslik,
            textScaleFactor: 1.5,
          ),
          SinifListesi(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
                'Öğrencileri Yükle'
            ),
            onPressed: () async {
             final ogrenciler = SinifBilgisi.of(context).ogrenciler;
             
             await Future.forEach(ogrenciler,
                     (ogrenci) async {
                       print('$ogrenci yükleniyor.');
                       await Future.delayed(Duration(seconds: 1));
                       print('$ogrenci yüklendi');
                     }
                     );
             print('Tüm öğrenciler yüklendi.');
             
            },
          ),
          ElevatedButton(
            child: Text(
                'Yeni sayfaya git.'
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumPage(),
              ));
              //sor(context);
            },
          ),
        ]);
  }

  Future<void> sor(BuildContext context) async {
    try{
      bool? cevap =
          await Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (context) {
          return VideoEkrani('Videoyu beğendiniz mi?');
        },
      ));
      print('cevap geldi: ${cevap}');
      if (cevap == true) {
        print("beğendi!!!");
        // throw 'HATA OLSUN...';
      } else {
        cevap =
            await Navigator.of(context).push<bool>(MaterialPageRoute(
          builder: (context) {
            return VideoEkrani(
                'Keşke beğenseniz... Videoyu beğendiniz mi?');
          },
        ));
      }
      if (cevap == true) {
        print('BEGENDINIZ!!!');
      }
    }catch(e){
      print('hata');
    }finally{
      print('-------İş bitti---------');
    }
  }
}

class VideoEkrani extends StatelessWidget {
  final String mesaj;
  const VideoEkrani(this.mesaj, {
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print(('pop edecek.'));
        return true;
        },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              //Video(),
              Placeholder(),
              Text(
                  mesaj
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(true);
                },
                child: Text('Evet'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(false);
                },
                child: Text('Hayır'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        ElevatedButton(
          child: Text('Play/Pause'),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        ),
      ],
    );
  }
}

class SinifListesi extends StatelessWidget {
  const SinifListesi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final a in sinifBilgisi.ogrenciler) Text(a),
      ],
    );
  }
}

class OgrenciEkleme extends StatefulWidget {
  const OgrenciEkleme({
    super.key,
  });

  @override
  State<OgrenciEkleme> createState() => _OgrenciEklemeState();
}

class _OgrenciEklemeState extends State<OgrenciEkleme> {
  final controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: controller.text.isNotEmpty
                  ? () {
                      {
                        final yeniOgrenci = controller.text;
                        sinifBilgisi.yeniOgrenciEkle(yeniOgrenci);
                        controller.text = '';
                      }
                    }
                  : null,
              child: Text('Ekle')),
        ),
      ],
    );
  }
}

class ArkaPlan extends StatelessWidget {
  const ArkaPlan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Image.asset('images/homepage_img_8.png'),
      ),
    );
  }
}
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
        body: Container(
          child: Text('Settings Page'),

        )
    );
  }
}
