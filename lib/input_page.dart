import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

enum Cinsiyet {
  kadin,
  erkek,
  bos,
} //enum ile yeni bir tür yarattık ve 3 değeri var.

const okullar = ['İlkokul','Ortaokul','Lise','Üniversite'];

class _InputPageState extends State<InputPage> {
  bool? okuldaMisin = false;
  Cinsiyet? cinsiyet = Cinsiyet.bos;
  String? okul;
  double boy = 100;
  TextEditingController yorumController = TextEditingController();
  @override
  void dispose() {
    yorumController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Girdi Sayfası'),
      ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Checkbox(
              value: okuldaMisin,
              onChanged: (value) {
                setState(() {
                  okuldaMisin = value;
                });
              },
          ),
          Switch(
            value: okuldaMisin!,
            onChanged: (value) {
              setState(() {
                okuldaMisin = value;
              });
            },
          ),
          Text(
            okuldaMisin == true ? 'Okuldasın' : 'Okulda değilsin'
          ),
          Radio<Cinsiyet>(
              value: Cinsiyet.kadin,
              groupValue: cinsiyet,
              onChanged: (value) {
                setState(() {
                  cinsiyet = value;
                });
              },
          ),
          Text('kadın'),
          Radio<Cinsiyet>(
            value: Cinsiyet.erkek,
            groupValue: cinsiyet,
            onChanged: (value) {
              setState(() {
                cinsiyet = value;
              });
            },
          ),
          Text('Erkek'),
          DropdownButton<String>(
            value: okul,
              items: okullar.map(
                      (e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                      ),
              ).toList(),
            onChanged: (value) {
              setState(() {
                okul = value;
              });
            },
          ),
          Text(okul ?? ''), //null'sa boş dursun
          Slider(
              value: boy,
              min: 30,
              max: 300,

              onChanged: (value) {
                setState(() {
                  boy = value;
                });
              },
          ),
          Text(
            boy.toStringAsFixed(2)
          ),
          TextField(
            controller: yorumController,
            onChanged: (value) {
                setState(() {

                });
            },
          ),
          Text(yorumController.text),
          ElevatedButton(onPressed: () {
            setState(() {
            okuldaMisin = false;
            cinsiyet = Cinsiyet.bos;
            okul = null;
            boy = 100;
            yorumController.text = '';
            });
          }, child: Text('Temizle'))
        ],
      ),
    ),

    );
  }
}
