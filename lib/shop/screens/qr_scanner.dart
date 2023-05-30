import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../classes/ClsSearch.dart';
import 'item_screen_2.dart';

class QRViewScanner extends StatefulWidget {
  const QRViewScanner({Key? key}) : super(key: key);

  @override
  _QRViewScannerState createState() => _QRViewScannerState();
}

class _QRViewScannerState extends State<QRViewScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  // QRViewController? controller;
  String? productId;

  Future<List<ClsSearch>> searchList = Globals.futureSearch;

  late List<ClsSearch> productList;

  late Iterable<ClsSearch> productList0;

  bool goToProductShowOnScan = false;
  bool onShowInfo = false;

  MobileScannerController cameraController = MobileScannerController();

  String mBarcode = '';
  final player = AudioPlayer();
  // String? reQrCode ;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // } else if (Platform.isIOS) {
    //   controller!.resumeCamera();
    // }
  }


  @override
  void initState() {
    productId = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClsSearch>>(
      future: Globals.futureSearch,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          Globals.productList = snapshot.data!
              .where((ClsSearch clsSearch) => clsSearch.typeCode == 3)
              .toList();
          // snapshot.data!.toList();
          return SafeArea(
            child: Scaffold(backgroundColor: Colors.black,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child:
                    // kIsWeb?
                    MobileScanner(
                        allowDuplicates: false,
                        controller: cameraController,
                        onDetect: (barcode, args) async {
                          if (barcode.rawValue == null) {
                            debugPrint('Failed to scan Barcode');
                          } else {
                            checkProductCode(barcode.rawValue!);
                            await player.setSource(AssetSource('sounds/beep.wav'));

                            // setState((){});
                            debugPrint('Barcode found! $barcode.rawValue');
                          }
                        })
                      // : QRView(
                      //   key: qrKey,
                      //   onQRViewCreated: _onQRViewCreated,
                      // ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(color: Colors.white70  ,
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: (productId != null)
                                    ? productId!.isNotEmpty
                                        ? Center(
                                            child: (Globals.productList
                                                    .where((element) =>
                                                        element.id == productId && element.typeCode == 3)
                                                    .isNotEmpty)
                                                ? Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                            '( کد : ${productId}' +
                                                                ' ) ' +
                                                                ReplacePersianChar(
                                                                Globals.productList
                                                                    .where((element) =>
                                                                        element.id ==
                                                                            productId)
                                                                    .first
                                                                    .text, withoutDigit: true),
                                                            textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Tahoma', fontSize: 14)),
                                                      ),
                                                      OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            elevation: 10,
                                                            primary: Colors.black,
                                                            backgroundColor: Colors.green
                                                                .withOpacity(0.4),
                                                            side: const BorderSide(
                                                                color: Colors.green),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                              Navigator.of(context)
                                                                  .push(PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation) =>
                                                                    ItemScreen2(
                                                                  mProductId: productId?? '',
                                                                  goToPage: null,
                                                                ),
                                                                transitionsBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  return child;
                                                                },
                                                              ));
                                                          },
                                                          child: const Text(' نمایش اطلاعات کالا ', style: TextStyle(fontSize: 13),)),
                                                    ],
                                                  )
                                                : Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'کد : ${productId}\n این کد موجود نیست',
                                                      textAlign: TextAlign.center),
                                                ))
                                        : Center(
                                            child: InkWell(
                                              onTap: (){
                                                Clipboard.setData(ClipboardData(text: mBarcode));
                                                // if(mBarcode.toLowerCase().substring(4) == "http")
                                                //   launchUrl(mBarcode);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(mBarcode,
                                                    textAlign: TextAlign.center),
                                              ),
                                            ))
                                    : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('.بارکد / کیو-آر کد محصول را اسکن کنید'),
                                    ),
                              ),
                              CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: const Text("نمایش مستقیم اطلاعات کالا پس از اسکن" , style: TextStyle(
                                      fontFamily: "Yekan",
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic)) ,
                                  activeColor: Colors.red,
                                  value: goToProductShowOnScan, onChanged: (v) =>
                                  setState((){goToProductShowOnScan = v?? false;}))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     if(scanData.code != null) {
  //       checkProductCode(scanData.code?? '');
  //     }
  //   });
  // }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  void checkProductCode(String barcode) {

    setState(() {
      mBarcode = barcode;
      onShowInfo = false;
      List<String> mCodeSplit = barcode.split("-");
      if (mCodeSplit.length > 1 && mCodeSplit[0] == Globals.appTitle) {
        productId = mCodeSplit[1];
        if (goToProductShowOnScan && !onShowInfo && Globals.productList
            .where((element) =>
        element.id == productId && element.typeCode == 3)
            .isNotEmpty) {
          onShowInfo = true;
          // Navigator.push(context, MaterialPageRoute(builder: (context) => p2()),).then((res) => refreshPage());
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ItemScreen2(
                  mProductId: productId?? '',
                  goToPage: null,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
        }
      } else {
        productId = '';
      }
    });
  }
}
