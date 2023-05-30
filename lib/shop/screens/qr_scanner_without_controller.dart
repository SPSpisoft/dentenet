import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../public/public_variables.dart';
import 'item_screen_2.dart';

class BarcodeScannerWithoutController extends StatefulWidget {
  const BarcodeScannerWithoutController({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithoutControllerState createState() =>
      _BarcodeScannerWithoutControllerState();
}

class _BarcodeScannerWithoutControllerState
    extends State<BarcodeScannerWithoutController>
    with SingleTickerProviderStateMixin {
  String? barcode;
  String productId = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                MobileScanner(
                  fit: BoxFit.contain,
                  // allowDuplicates: false,
                  onDetect: (barcode, args) {
                    setState(() {
                      this.barcode = barcode.rawValue;

                      List<String> mCodeSplit = this.barcode!.split("-");
                      if (mCodeSplit.length > 1 &&
                          mCodeSplit[0] == Globals.appTitle) {
                        productId = mCodeSplit[1];
                      }
                    });
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: (this.barcode != null)
                        ? productId.isNotEmpty
                            ? Center(
                                child: (Globals.productList
                                        .where((element) =>
                                            element.id == productId &&
                                            element.typeCode == 3)
                                        .isNotEmpty)
                                    ? Column(
                                  verticalDirection: VerticalDirection.down,
                                        children: [
                                          Text(
                                              'کد کالا : ${productId}' +
                                                  '\n' +
                                                  Globals.productList
                                                      .where((element) =>
                                                          element.id ==
                                                              productId &&
                                                              element.typeCode == 3)
                                                      .first
                                                      .text,
                                              textAlign: TextAlign.center),
                                          OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                elevation: 10,
                                                primary: Colors.black,
                                                backgroundColor:
                                                    Colors.green.withOpacity(0.4),
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
                                                    mProductId: productId,
                                                    goToPage: null,
                                                  ),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    return child;
                                                  },
                                                ));
                                              },
                                              child: const Text(
                                                'اطلاعات کالا',
                                                style: TextStyle(fontSize: 12),
                                              ))
                                        ],
                                      )
                                    : Text(
                                        'Code : ${this.barcode}\n کد کالا یافت نشد',
                                        textAlign: TextAlign.center))
                            : Center(
                                child: Text('Code : ${this.barcode}',
                                    textAlign: TextAlign.center))
                        : const Text('بارکد یا کیو-آر کد محصول را اسکن کنید'),
                  ),
                )
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     alignment: Alignment.bottomCenter,
                //     height: 100,
                //     color: Colors.black.withOpacity(0.4),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Center(
                //           child: SizedBox(
                //             width: MediaQuery.of(context).size.width - 120,
                //             height: 50,
                //             child: FittedBox(
                //               child: Text(
                //                 barcode ?? 'Scan something!',
                //                 overflow: TextOverflow.fade,
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .headline4!
                //                     .copyWith(color: Colors.white),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

// String getProductIdInQrCode(String? mQrCode){
//   String productId = '';
//
//   return productId;
// }
}
