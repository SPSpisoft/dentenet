import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../classes/ClsSearch.dart';
import '../data_fetch.dart';
import '../views/search_box.dart';
import 'item_screen_2.dart';
import 'main_tabs/ProductCat/product_cat_view.dart';

import 'package:speech_to_text/speech_to_text.dart' as speechToText;

class SearchPage extends StatefulWidget {
  // final Function(List<String>?) goToSearch;
  final Function(int, int, String?)? goToPage;
  final ScrollController mScrollController;
  final int lastPage;
  final int? typeCall;
  final List<String>? inCat;

  const SearchPage({
    Key? key,
    // required this.goToSearch,
    required this.mScrollController,
    required this.lastPage,
    this.goToPage,
    this.inCat,
    this.typeCall // 0:normal 1:asVoice
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();

  num iLength = 2;
  bool _init = true;
  FocusNode mFocusNode = FocusNode();

  late speechToText.SpeechToText speech;
  bool isListen = false;
  double confidence = 1.0;
  String? textString;

  void listen() async {
    print("SPS - listen");
    if (!isListen) {
      bool avail = await speech.initialize(
          onStatus: statusListener,
          finalTimeout: Duration(seconds: 5)
      );
      if (avail) {
        print("SPS - SSS" );
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          print("SPS - " +value.toString());
          setState(() {
            textString = value.recognizedWords;
            if (value.hasConfidenceRating && value.confidence > 0) {
              print("SPS - IIIIIN");
              confidence = value.confidence;
            }else{
              print("SPS - OOOOOOOOOOOOOO");
              setState(() {
                isListen = false;
              });
            }
          });
        }, localeId: 'Fa', cancelOnError: true);
      }
    } else {
      setState(() {
        isListen = false;
      });
      speech.stop();
    }
  }

  void statusListener(String status) {
    print(
        'SPS - Received listener status: $status, listening: ${speech.isListening}');
    // setState(() {
    //   lastStatus = '$status';
    // });
  }

  // void errorListener(SpeechRecognitionError error) {
  //   print(
  //       'SPS - Received error status: $error, listening: ${speech.isListening}');
  //   // setState(() {
  //   //   lastError = '${error.errorMsg} - ${error.permanent}';
  //   // });
  //   setState(() {
  //     isListen = false;
  //   });
  // }

  @override
  void initState() {
    Globals.futureSearch = fetchSearch('', widget.inCat, 0);
    super.initState();
    // _init = true;
    mFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.goToPage!(widget.lastPage, 4, null),
      child: FutureBuilder<List<ClsSearch>>(
        future: Globals.futureSearch,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: JumpingDotsProgressIndicator(
                fontSize: 55.0,
                color: Colors.white,
              ),
            );
          }
          else if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            _searchList = snapshot.data!.toList();
            if (_init) {
              _searchResult.clear();
              // _searchResult.addAll(_searchList);
              _init = false;
            }
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                // appBar: AppBar(
                //   title: const Text('Home'),
                //   elevation: 0.0,
                // ),
                body: Column(
                  children: <Widget>[
                    Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 70, 8),
                          child: SearchBox(
                            readOnly: false,
                            atVoice: true,
                            focusNode: mFocusNode,
                            text: textString,
                            onTap: (v) {
                              if(v == 1){
                                listen();
                              }else {
                                mFocusNode.requestFocus();
                              }
                            },
                            onTextChange: (value) => onSearchTextChanged(value),
                          ),
                        )),
                    // Container(
                    //   color: Theme
                    //       .of(context)
                    //       .primaryColor,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Card(
                    //       child: ListTile(
                    //         leading: const Icon(Icons.search),
                    //         title: TextField(
                    //           controller: controller,
                    //           decoration: const InputDecoration(
                    //               hintText: 'Search', border: InputBorder.none),
                    //           onChanged: onSearchTextChanged,
                    //         ),
                    //         trailing: IconButton(
                    //           icon: const Icon(Icons.cancel),
                    //           onPressed: () {
                    //             controller.clear();
                    //             onSearchTextChanged('');
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _searchResult.isNotEmpty || controller.text.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onLongPress: (){
                                    ToastNormal(_searchResult[i].id, context);
                                  },
                                  onTap: () {
                                    // ToastNormal(_searchResult[i].id);
                                    showItem(
                                        context,
                                        _searchResult[i].id,
                                        _searchResult[i].typeCode,
                                        widget.mScrollController,
                                        widget.goToPage);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      leading: _searchResult[i].typeCode == 3
                                          ? const CircleAvatar(
                                              child: Icon(
                                              FontAwesomeIcons.shoppingBag,
                                              size: 18,
                                              color: Colors.white,
                                            ))
                                          : _searchResult[i].typeCode == 1
                                              ? const CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  child: Icon(
                                                    FontAwesomeIcons.layerGroup,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  child: Icon(
                                                    FontAwesomeIcons.tag,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ReplacePersianChar(
                                                _searchResult[i].text),
                                            style: const TextStyle(
                                                fontFamily: 'Yekan',
                                                color: Colors.black87,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            ReplacePersianChar(_searchResult[i].typeCode == 3
                                                ? 'در دسته ${_searchResult[i].iinCat}'
                                                : _searchResult[i].typeCode == 1
                                                    ? 'همه کالاهای این دسته '
                                                    : 'در ویژگی ${_searchResult[i].iinCat}'),
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  onSearchTextChanged(String textSearch) async {
    _searchResult.clear();

    if (textSearch.trim().isNotEmpty) {
      textSearch = ReplaceArabicChar(textSearch);

      textSearch.split(' ').forEach((s) {
        _searchResult.isEmpty
            ? _searchResult.addAll(
                _searchList.where((element) => element.searchText.contains(s)))
            : _searchResult
                .removeWhere((element) => !element.searchText.contains(s));
      });
      // setState(() {});

      // var st = textSearch.split(' ').map((String text) => Text(text)).toList();
      // if(st.length == 2) {
      //   _searchResult.addAll(
      //       _searchList.where((element) =>
      //       element.searchText.contains(st[0].data.toString()) &&
      //           element.searchText.contains(st[1].data.toString())));
      // }

      // List<String> bb ;
      //
      // _searchResult.addAll(
      //     _searchList.retainWhere((element) => element.searchText.contains('other'))

    } else {
      // setState(() {
      // _searchResult.addAll(_searchList);
      _searchResult.clear();
      // });
      // return;
    }

    setState(() {});
  }

// callBack(v) {
//   ToastNormal("_text");
// }
}

List<ClsSearch> _searchResult = [];

List<ClsSearch> _searchList = [];

showItem(BuildContext context, String mId, int mType,
    ScrollController mScrollController, [Function(int page, int last, String? id)? goToPage]) {
  // test2nItem mItem = fetchProduct(mId) as test2nItem;
  // if (kIsWeb) {
  //   animationController?.reverse().then<dynamic>((data) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {
  //       inHome = false;
  //       tabBody = ItemScreen();
  //     });
  //   });
  // } else
  //   {
  if (mType == 1) {
    goToPage!(5, 4, mId);
    // Navigator.of(context).push(PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => ProductCatView(
    //     catId: mId,
    //     goToSearch: goToSearch,
    //     mScrollController: mScrollController,
    //   ),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     return child;
    //   },
    // ));
  } else if (mType == 3) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ItemScreen2(mProductId: mId, goToPage: goToPage,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  } else {
    ToastNormal("other..  $mType", context, type: 0);
  }
  // }
}

// final String url = 'https://jsonplaceholder.typicode.com/users';
//
// class UserDetails {
//   final int id;
//   final String firstName, lastName, profileUrl;
//
//   UserDetails(
//       {this.id,
//       this.firstName,
//       this.lastName,
//       this.profileUrl =
//           'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       id: json['id'],
//       firstName: json['name'],
//       lastName: json['username'],
//     );
//   }
// }
