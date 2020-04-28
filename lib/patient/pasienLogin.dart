import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/doctor/dokterLogin.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:medkit/patient/PanelPasien.dart';

class PasienLogin extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDetailDokter providerInfo =
        new ProviderDetailDokter(userDetails.providerId);

    List<ProviderDetailDokter> providerData =
        new List<ProviderDetailDokter>();
    providerData.add(providerInfo);

    DetailPasien details = new DetailPasien(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PanelPasien(
                  detailsUser: details,
                )));

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            BackBtn(),
            ImageAvatar(
              assetImage: 'assets/bigpas.png',
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.1, width * 0.05, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: GoogleFonts.abel(
                        fontSize: height * 0.045, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    'Fitur',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '1. Detail tentang berbagai Penyakit / Obat'
                    '\n2. Tambahkan Dokter favorit Anda'
                    '\n3. Permintaan menambah Penyakit / Kedokteran'
                    '\n4. Laporkan Penyakit / Obat yang salah'
                    '\n5. Cari Apotek Terdekat'
                    '\n6. Umpan balik/Keluhan',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        height: height * 0.002),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: height * 0.013),
                    color: Colors.white,
                    shape: StadiumBorder(),
                    onPressed: () {
                      _signIn(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        WidgetAnimator(
                          Image(
                            image: AssetImage('assets/google.png'),
                            height: height * 0.038,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          'Login menggunakan Gmail',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.021),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: height * 0.15),
                width: width,
                height: height * 0.07,
                child: WidgetAnimator(
                  Text(
                    '"Pekerjaan akan digantikan  \njika dalam waktu sat minggu anda meninggal dunia.'
                    '\nSelalu jaga kesehatan!"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: height * 0.018,
                        color: Colors.black.withOpacity(0.3),
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailPasien {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetailDokter> providerData;

  DetailPasien(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetailPasien {
  ProviderDetailPasien(this.Detailprovider);

  final String Detailprovider;
}
