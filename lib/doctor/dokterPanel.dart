import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/doctor/addDisease.dart';
import 'package:medkit/doctor/dokterProfile.dart';
import 'package:medkit/otherWidgetsAndScreen/customListTiles.dart';
import '../animations/bottomAnimation.dart';
import 'dokterLogin.dart';

class DokterPanel extends StatefulWidget {
  final DokterDetails detailsUser;

  DokterPanel({Key key, @required this.detailsUser}) : super(key: key);

  @override
  _DokterPanelState createState() => _DokterPanelState();
}

class _DokterPanelState extends State<DokterPanel> {
  Future getDiseaseInfo() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Penyakit").getDocuments();
    return qn.documents;
  }

  final GoogleSignIn _gSignIn = GoogleSignIn();

  bool editPanel = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            title: new Text(
              "Apakah anda yakin?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: new Text("Anda telah Log Out!"),
            actions: <Widget>[
              new FlatButton(
                color: Colors.white,
                child: new Text(
                  "Tutup",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                color: Colors.white,
                child: new Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _gSignIn.signOut();
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, height * 0.05, 0, 0),
              child: Hero(
                tag: 'docPic',
                child: FlatButton(
                    shape: CircleBorder(),
                    onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => DokterProfile(
                                dokterDetails: widget.detailsUser))),
                    child: CircleAvatar(
                        maxRadius: height * 0.03,
                        backgroundColor: Colors.black.withOpacity(0.2),
                        backgroundImage:
                            NetworkImage(widget.detailsUser.photoUrl))),
              ),
            ),
            Container(
              width: width,
              height: height * 0.25,
              margin: EdgeInsets.fromLTRB(width * 0.03, height * 0.1, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: height * 0.05,
                        child: FloatingActionButton(
                          heroTag: 'editBtn',
                          tooltip: 'Edit Panel',
                          backgroundColor: editPanel ? Colors.green : Colors.white,
                          child: editPanel
                              ? WidgetAnimator(
                                  Icon(
                                    Icons.done,
                                    size: height * 0.03,
                                    color: Colors.white,
                                  ),
                                )
                              : WidgetAnimator(
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: height * 0.03,
                                  ),
                                ),
                          onPressed: () {
                            setState(() {
                              editPanel = !editPanel;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.01,),
                      editPanel
                          ? Container(
                        height: height * 0.045,
                        child: WidgetAnimator(
                          RawMaterialButton(
                            shape: StadiumBorder(),
                            fillColor: Colors.blue,
                            child: Text(
                              'Tambah lagi',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => AddDisease(
                                        doctorName:
                                        widget.detailsUser.userName,
                                        doctorEmail: widget.detailsUser.userEmail,
                                      )));
                            },
                          ),
                        ),
                      )
                          : SizedBox(width: width * 0.245),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Dokter",
                        style: GoogleFonts.abel(
                            fontSize: height * 0.042,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Panel',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: getDiseaseInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.fromLTRB(
                        0, height * 0.325, 0, 0),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12),
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.transparent,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return WidgetAnimator(CustomTile(
                          delBtn: editPanel,
                          snapshot: snapshot.data[index],
                        ));
                      },
                    ),
                  );
                }
              },
            ),
            Positioned(
                top: height * 0.05,
                left: width - 180,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(0.1),
                      ],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image(
                      height: height * 0.265,
                      image: AssetImage('assets/bigDoc.png')),
                )),
          ],
        ),
      )),
    );
  }
}
