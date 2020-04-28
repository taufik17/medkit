import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/fadeAnimation.dart';
import 'package:medkit/otherWidgetsAndScreen/medDetails.dart';
import 'package:medkit/otherWidgetsAndScreen/customListTiles.dart';
import 'package:medkit/patient/pasienLogin.dart';
import 'package:medkit/patient/ProfilPasien.dart';

import '../animations/bottomAnimation.dart';

class PanelPasien extends StatefulWidget {
  final DetailPasien detailsUser;

  PanelPasien({Key key, @required this.detailsUser}) : super(key: key);

  @override
  _PanelPasienState createState() => _PanelPasienState();
}

class _PanelPasienState extends State<PanelPasien> {

  Future getDiseaseInfo() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Diseases").getDocuments();
    return qn.documents;
  }

  final GoogleSignIn _gSignIn = GoogleSignIn();

  snapshotPassingToMedPage(DocumentSnapshot snapshot) {
    MedDetails(
      snapshot: snapshot,
    );
  }

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
        content: new Text("Anda akan Keluar!"),
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
                width: width,
                margin: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(onTap: () => Navigator.of(context).pop(true),
                        child: Icon(Icons.arrow_back, size: height * 0.04,)),
                    SizedBox(width: width * 0.02,),
                    Container(
                      width: width * 0.7,
                      height: height * 0.052,
                      child: WidgetAnimator(
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              labelText: 'Penyakit / obat',
                              prefixIcon: WidgetAnimator(Icon(
                                Icons.search,
                                size: height * 0.03,
                              )),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02,),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => ProfilPasien(
                                doctorDetails: widget.detailsUser,
                              ))),
                      child: Hero(
                        tag: 'patPic',
                        child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.2),
                            backgroundImage:
                            NetworkImage(widget.detailsUser.photoUrl)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.1,
                width: width * 0.35,
                  margin: EdgeInsets.fromLTRB(
                      width * 0.21, height * 0.15, 0, 0),
                  child: FadeAnimation(
                    0.3,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Pasien",
                          style: GoogleFonts.abel(
                              fontSize: height * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Panel',
                          style: TextStyle(
                              fontSize: height * 0.025),
                        )
                      ],
                    ),
                  )),
              FutureBuilder(
                future: getDiseaseInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: WidgetAnimator(
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(
                          0, height * 0.32, 0, 0),
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10),
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.transparent,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return WidgetAnimator(
                            CustomTile(
                              delBtn: false,
                              snapshot: snapshot.data[index],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Positioned(
                  top: height * 0.087,
                  left: width - 180,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(0.5),
                        ],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image(
                        height: height * 0.24,
                        image: AssetImage('assets/bigPat.png')),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
