import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

import '../../public/public_variables.dart';
import '../classes/ClsSearch.dart';
import '../screens/qr_scanner.dart';

class SearchBox extends StatefulWidget {
  final bool readOnly;
  final bool atVoice;
  final Function(int? callTypeCode) onTap;
  final ValueChanged<String> onTextChange;
  final FocusNode focusNode;
  final String? text;

  const SearchBox(
      {Key? key,
      required this.readOnly,
      required this.onTextChange,
      required this.atVoice,
      required this.onTap,
      required this.focusNode,
      this.text})
      : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // late final Function onTap;
  _SearchBoxState();
  TextEditingController _controller = TextEditingController();

  // final SpeechToText _speechToText = SpeechToText();
  // bool _speechEnabled = false;
  // String _lastWords = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: widget.text?? '');
    return FutureBuilder<List<ClsSearch>>(
        future: Globals.futureSearch,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return JumpingDotsProgressIndicator(
              fontSize: 35.0,
              color: Colors.white54,
            );
            // searchBox('در حال آماده سازی', false);
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              if (!snapshot.hasData) {
                return searchBox('جستجو');
              }
            }
          }
          return searchBox('در حال آماده سازی');
        });
  }

  Widget searchBox(String txt) {
    return SizedBox(
      height: 40,
      child: CupertinoTextField(
          onChanged: (value) => widget.onTextChange(value),
          controller: _controller,
          textAlign: TextAlign.start,
          focusNode: widget.focusNode,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.words,
          // textDirection: TextDirection.rtl,
          obscureText: false,
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Yekan',
          ),
          textAlignVertical: TextAlignVertical.center,
          textDirection: TextDirection.rtl,
          cursorHeight: 27,
          keyboardType: TextInputType.text,
          readOnly: widget.readOnly,
          enabled: true,
          placeholder: 'جستجو..',
          placeholderStyle: const TextStyle(
            color: Color(0xffC4C6CC),
            fontSize: 16.0,
            fontFamily: 'Yekan',
          ),
          onTap: () {
            widget.onTap(0);
            // ToastNormal('2222222 ');
          },
          clearButtonMode: OverlayVisibilityMode.editing,

          // controller: _textController,
          prefix: const Padding(
            padding: EdgeInsets.fromLTRB(1.0, 6.0, 9.0, 6.0),
            child: Icon(
              Icons.search,
              size: 20,
              color: Color(0xffC4C6CC),
            ),
          ),
          suffix: Row(
            children: [
              !widget.atVoice
                  ? const SizedBox.shrink()
                  : IconButton(
                      padding: const EdgeInsets.fromLTRB(0.0, 6.0, 6.0, 6.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.mic_rounded),
                      iconSize: 20,
                      color: const Color(0xffbdbdc1),
                      onPressed: () {
                        // _speechToText.isNotListening ? _startListening : _stopListening;
                        widget.onTap(1);
                        // ToastNormal('Voice Search.. ',
                        //     context: context, type: 0);
                        // _onVoiceSearchButtonPressed();
                      },
                    ),
              !widget.atVoice
                  ? const SizedBox.shrink()
                  : IconButton(
                      padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.qr_code),
                      iconSize: 20,
                      color: const Color(0xffbdbdc1),
                      onPressed: () async {

                        // var res = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const SimpleBarcodeScannerPage(),
                        //     ));
                        // setState(() {
                        //   if (res is String) {
                        //     ToastNormal(res, context: context, type: 0);
                        //   }
                        // });

                        // showDialog(
                        //   context: context,
                        //   builder: (context) => CamCodeScanner(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: MediaQuery.of(context).size.height,
                        //     refreshDelayMillis: 200,
                        //     onBarcodeResult: (barcode) {
                        //       ToastNormal(barcode, context: context, type: 0);
                        //     },
                        //   ),
                        // );

                        // if (kIsWeb) {
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => const BarcodeScannerWithoutController(),
                        //     ),
                        //   );
                          // final perm = await html.window.navigator.permissions!
                          //     .query({"name": "camera"});
                          // if (perm.state == "denied") {
                          //   ToastNormal("Camera access denied!",
                          //       context: context, type: -1);
                          //   return;
                          // }
                          // final stream = await html.window.navigator
                          //     .getUserMedia(video: true)
                          //     .then((value) {
                          //   Navigator.of(context).push(_createRoute());
                          // });
                        // } else {
                          Navigator.of(context).push(_createRoute());
                        // }

                        // ToastNormal('Code Search.. ');

                        // _onQrCodeSearchButtonPressed();
                      },
                    ),
            ],
          )
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(4.0),
          //   color: Color(0xffF0F1F5),
          // ),
          ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const QRViewScanner(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

// _onVoiceSearchButtonPressed() {
//   Fluttertoast.showToast(
//       msg: "voice search ",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
