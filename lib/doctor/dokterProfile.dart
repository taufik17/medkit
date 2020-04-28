import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/doctor/dokterLogin.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:toast/toast.dart';

final controllerBio = TextEditingController();
final controllerPhone = TextEditingController();
final controllerSpec = TextEditingController();

class DokterProfile extends StatefulWidget {
  final DokterDetails dokterDetails;

  DokterProfile({this.dokterDetails});

  @override
  _DokterProfileState createState() => _DokterProfileState();
}

class _DokterProfileState extends State<DokterProfile> {
  bool aboutCheck = false;
  bool validInfo = true;

  validatePhone(String phone) {
    if(!(phone.length == 11) && phone.isNotEmpty) {
      return "Jumlah Nomor telfon invalid";
    }
    return null;
  }

  profileUpdate() {
    Firestore.instance
        .collection('TentangDokter')
        .document(
        widget.dokterDetails.userEmail)
        .setData(
        {'Tentang': controllerBio.text,
        'Handphone' : controllerPhone.text,
        'spesialis' : controllerSpec.text});
    Toast.show('Profile Updated!', context, backgroundColor: Colors.blue, backgroundRadius: 5,
        duration: 2);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final bio = TextField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      autofocus: false,
      maxLines: 6,
      maxLength: 200,
      controller: controllerBio,
      decoration: InputDecoration(
        hintText: 'Ceritakan lebih banyak tentang diri Anda.',
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );

    final phone = TextField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      maxLength: 11,
      controller: controllerPhone,
      decoration:  InputDecoration (
          hintText: 'Masukan No Telp',
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );

    final specialization = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerSpec,
        decoration:  InputDecoration (
          hintText: 'Anda Spesialis?',
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.red)),
        )
    );

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BackBtn(),
              Center(
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'docPic',
                      child: CircleAvatar(
                        radius: height * 0.05,
                        backgroundImage:
                            NetworkImage(widget.dokterDetails.photoUrl),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      'Dr. ' + widget.dokterDetails.userName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: height * 0.007),
                    Text(
                      "Email: " + widget.dokterDetails.userEmail,
                      style: TextStyle(
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.w300,
                          color: Colors.black54),
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Container(
                      width: width * 0.7,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Tentang:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.02),
                              ),
                              Container(
                                height: height * 0.032,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    !aboutCheck ? FloatingActionButton(
                                      shape: CircleBorder(),
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            aboutCheck = !aboutCheck;
                                          });
                                        },
                                        child: WidgetAnimator(
                                          Icon(
                                            Icons.edit,
                                            size: height * 0.02,
                                            color: Colors.black,
                                          ),
                                        )) : Container(),
                                    aboutCheck ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        FloatingActionButton(
                                          backgroundColor: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              controllerPhone.text.isEmpty ? validInfo = false : validInfo = true;
                                              if (validInfo == true) {
                                                aboutCheck = !aboutCheck;
                                              }
                                            });
                                            !aboutCheck ? profileUpdate() :
                                            Toast.show('Bilah kosong ditemukan!', context, backgroundColor: Colors.red, backgroundRadius: 5, duration: 3);
                                          },
                                          child: WidgetAnimator(
                                            Icon(
                                              Icons.done,
                                              size: height * 0.025,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        FloatingActionButton(
                                          backgroundColor: Colors.white,
                                          onPressed: (){
                                            setState(() {
                                              aboutCheck = !aboutCheck;
                                            });
                                          },
                                          child: WidgetAnimator(
                                            Icon(Icons.close, size: height * 0.025,
                                              color: Colors.red,),
                                          ),
                                        ),
                                      ],
                                    ) : Container()
                                  ],
                                )
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          !aboutCheck
                              ? StreamBuilder(
                                  stream: Firestore.instance.document('TentangDokter/${widget.dokterDetails.userEmail}').snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: height * 0.21,
                                        width: width * 0.7,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      );
                                    }
                                    var docAbout = snapshot.data;
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.01,
                                            vertical: height * 0.01),
                                        height: height * 0.21,
                                        width: width * 0.7,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: ListView(
                                          children: <Widget>[
                                            Text(
                                              docAbout['tentang'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500, fontSize: height * 0.019),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  )
                              : bio,
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    Container(
                      width: width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "No Handphone:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          !aboutCheck
                              ? StreamBuilder(
                              stream: Firestore.instance.document('TentangDokter/${widget.dokterDetails.userEmail}').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    height: height * 0.041,
                                    width: width * 0.7,
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Colors.black12),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  );
                                }
                                var docAbout = snapshot.data;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  height: height * 0.041,
                                  width: width * 0.7,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.black12),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  child: ListView(
                                    children: <Widget>[
                                      Text(
                                        docAbout['Handphone'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: height * 0.019),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          )
                              : phone,
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    Container(
                      width: width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Spesiaalis:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.02),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          !aboutCheck
                              ? StreamBuilder(
                              stream: Firestore.instance.document('TentangDokter/${widget.dokterDetails.userEmail}').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    height: height * 0.05,
                                    width: width * 0.7,
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Colors.black12),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  );
                                }
                                var docAbout = snapshot.data;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  height: height * 0.05,
                                  width: width * 0.7,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.black12),
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  child: ListView(
                                    children: <Widget>[
                                      Text(
                                        docAbout['spesialis'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: height * 0.019),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          )
                              : specialization,
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    RaisedButton.icon(
                        color: Colors.white,
                        onPressed: () {
                          _logOutAlertBox(context);
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                          size: height * 0.03,
                        ),
                        label: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.red),
                        )),
                    SizedBox(height: height * 0.02),
                    Text(
                      'Versi',
                      style: TextStyle(
                          fontSize: height * 0.017,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                    Text(
                      'v 0.7',
                      style: TextStyle(
                          fontSize: height * 0.016, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  final GoogleSignIn _gSignIn = GoogleSignIn();

  void _logOutAlertBox(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: new Text(
            "Anda yakin?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("anda telah log out!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Colors.white,
              child: Text(
                "tutup",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.white,
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _gSignIn.signOut();
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 3);
              },
            ),
          ],
        );
      },
    );
  }
}
