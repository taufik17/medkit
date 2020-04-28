import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'backBtnAndImage.dart';

class Tentang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackBtn(),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'App',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: height * 0.07),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/medkita.png',
                        height: height * 0.15,
                      ),
                      Text(
                        'Salam Hormat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: height * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02,),
                      Text('Dikembangkan oleh: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Muhammad Wahyudi'
                          '\n14116013', textAlign: TextAlign.center,),
                      SizedBox(height: height * 0.05,),
                      Text('Tugas Besar: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Pengembangan Aplikasi Mobile'),
                      SizedBox(height: height * 0.12,),
                      Image.asset(
                        'assets/itera.png',
                        height: height * 0.1,
                      ),
                      Text('Institut Teknologi Sumatera',
                          style: TextStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold)),
                      Text('@Copyrights All Rights Reserved, 2020',
                          style: TextStyle(fontSize: height * 0.02))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
