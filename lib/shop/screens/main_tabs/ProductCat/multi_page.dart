// import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import '../../../../public/public_functions.dart';
import '../../../../public/public_variables.dart';
import '../../../classes/ClsCategoryFull.dart';
import 'choices.dart' as choices;

class FeaturesMultiPage extends StatefulWidget {
  List<Spc> ispCs;
  List<List<String>?> selList = [];
  List<filterItem> filterList = [];
  bool reset;
  Function(List<List<String>?> list) callBack;
  Function(List<filterItem> list) callBack2;

  FeaturesMultiPage(
      {Key? key,
      required this.ispCs,
      required this.selList,
      required this.filterList,
      required this.reset,
      required this.callBack,
      required this.callBack2})
      : super(key: key);

  @override
  _FeaturesMultiPageState createState() => _FeaturesMultiPageState();
}

class filterItem {
  filterItem({
  required this.code,
  required this.id,
  required this.value,
  });

  int code;
  String id;
  var value;
}

class _FeaturesMultiPageState extends State<FeaturesMultiPage> {
  // late List<List<String>?> oldSelList = [];
  // bool reset = false;
  double _lowerValue = 0;
  double _upperValue = 0;
  List<FlutterSliderRangeStep> lstRangeSlider = [];
  List<FlutterSliderHatchMarkLabel> lstLabel = [];
  List<double> listPrice = [];
  List<int> listPercent = [];

  bool _showInv = false;
  bool _showOff = false;

  @override
  void initState() {
    // if(oldSelList.isEmpty) {
    //   oldSelList.addAll(widget.selList);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Spc> spCs = [];

    // spCs.add(Spc(spcCode: '101',spcTypeCode: 101, spcCatTitle: 'ترتیب نمایش',
    //     opTs: [],
    //     optIconCode: -1, storeCode: Globals.myStoreId, catGroup: '', optionCustomer: false,
    //     catTitle: '',catId: '', filter: true, ordLevel: -1, toHead: false));
    //
    // spCs.add(Spc(spcCode: '201',spcTypeCode: 201, spcCatTitle: 'قیمت',
    //     opTs: [],
    //     optIconCode: -1, storeCode: Globals.myStoreId, catGroup: '', optionCustomer: false,
    //     catTitle: '',catId: '', filter: true, ordLevel: -1, toHead: false));

    spCs.addAll(widget.ispCs);
    // reset = true;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: Container(color: Colors.blueAccent, child: Text("jgvjgf")),
          // ),
          Flexible(
            child: ListView.builder(
              itemCount: spCs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                Spc spC = spCs[i];
                List<S2Choice<String>> _choiceItems = [];
                for (int j = 0; j < spC.opTs.length; j++) {
                  _choiceItems.add(S2Choice(
                      value: spC.opTs[j].optCode,
                      title: ReplacePersianChar(spC.opTs[j].optTitle,
                          withoutDigit: true),
                      style: const S2ChoiceStyle(
                          titleStyle:
                              TextStyle(fontFamily: "Roboto", fontSize: 14))));
                }

                if (widget.selList.length <= i) {
                  widget.selList.add([]);
                }

                if (spCs[i].spcTypeCode == 101) {

                  if (lstRangeSlider.length == 0) {
                    double _from = -1;
                    double _first = 0;
                    for (Opt opt in spCs[i].opTs) {
                      if (!listPrice.contains(opt.doubleValue)) {
                        if (_from < 0) {
                          _from = opt.doubleValue!;
                          _first = opt.doubleValue!;
                        } else {
                          lstRangeSlider.add(FlutterSliderRangeStep(
                              from: _from, to: opt.doubleValue!, step: opt.doubleValue!-_first ));
                          _from = opt.doubleValue!;
                        }
                        listPrice.add(opt.doubleValue!);
                        var percent = (opt.doubleValue!-spCs[i].opTs[0].doubleValue!)*100/(spCs[i].opTs[spCs[i].opTs.length-1].doubleValue!-spCs[i].opTs[0].doubleValue!);
                        listPercent.add(percent.toInt());
                        lstLabel.add(FlutterSliderHatchMarkLabel(percent: percent,
                            label: const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('↓', style: TextStyle(fontSize: 10, color: Colors.black54),),
                            )));
                      }
                    }
                    // listPrice.sort();
                    lstLabel.add(FlutterSliderHatchMarkLabel(
                        percent: 0,
                        label: Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: spTextPrice(
                              context, spCs[i].opTs[0].doubleValue!,
                              format: Globals.storePriceFormat,
                              mStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11)),
                        )),
                    );
                    lstLabel.add(FlutterSliderHatchMarkLabel(
                        percent: 100,
                        label: Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: spTextPrice(
                              context, spCs[i].opTs[spCs[i].opTs.length-1].doubleValue!,
                              format: Globals.storePriceFormat,
                              mStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11)),
                        )),
                    );
                  }

                  if (_lowerValue == 0) {
                    _lowerValue = listPrice[0];
                  }
                  if (_upperValue == 0) {
                    _upperValue = listPrice[listPrice.length - 1];
                  }

                  var filterItemUp = widget.filterList.where((element) => element.code == 101 && element.id == 'up');
                  if(filterItemUp.isEmpty){
                    widget.filterList.add(filterItem(code: 101, id: 'up', value: _upperValue));
                  }else{
                    _upperValue = filterItemUp.first.value;
                  }

                  var filterItemLow = widget.filterList.where((element) => element.code == 101 && element.id == 'low');
                  if(filterItemLow.isEmpty){
                    widget.filterList.add(filterItem(code: 101, id: 'low', value: _lowerValue));
                  }else{
                    _lowerValue = filterItemLow.first.value;
                  }


                  // if (lstRangeSlider.length == 0) {
                  //   double _from = -1;
                  //   for (double prs in listPrice) {
                  //     if (_from < 0) {
                  //       _from = prs;
                  //     } else {
                  //       lstRangeSlider.add(FlutterSliderRangeStep(
                  //           from: _from, to: prs, step: prs - _from));
                  //       _from = prs;
                  //     }
                  //   }
                  //   // lstRangeSlider.add(FlutterSliderRangeStep(
                  //   //     from: spCs[i].opTs[0].doubleValue!,
                  //   //     to: spCs[i].opTs[1].doubleValue!,
                  //   //     step: spCs[i].opTs[1].doubleValue! -
                  //   //         spCs[i].opTs[0].doubleValue!));
                  //   // lstRangeSlider.add(FlutterSliderRangeStep(
                  //   //     from: spCs[i].opTs[1].doubleValue!,
                  //   //     to: spCs[i].opTs[2].doubleValue!,
                  //   //     step: spCs[i].opTs[2].doubleValue! -
                  //   //         spCs[i].opTs[1].doubleValue!));
                  //   // lstRangeSlider.add(FlutterSliderRangeStep(
                  //   //     from: spCs[i].opTs[2].doubleValue!,
                  //   //     to: spCs[i].opTs[spCs[i].opTs.length - 1].doubleValue!,
                  //   //     step: spCs[i].opTs[spCs[i].opTs.length - 1]
                  //   //         .doubleValue! - spCs[i].opTs[2].doubleValue!));
                  // }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 28, right: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.8,
                            //   child: Column(
                            //     children: [
                            //       Text(
                            //         listPrice.toString(),
                            //         style: TextStyle(fontSize: 9),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Text(spC.spcCatTitle),
                            Row(
                              children: [
                                spTextPrice(context, _upperValue,
                                    format: Globals.storePriceFormat,
                                    mStyle: const TextStyle(
                                        color: Colors.black, fontSize: 14)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Icon(
                                    Icons.label_important_outline,
                                    color: Colors.black26,
                                  ),
                                ),
                                spTextPrice(context, _lowerValue,
                                    format: Globals.storePriceFormat,
                                    mStyle: const TextStyle(
                                        color: Colors.black, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 0),
                        child: SizedBox(
                          height: 60,
                          child: FlutterSlider(
                            handlerWidth: 15,
                            rtl: false,
                            tooltip: FlutterSliderTooltip(
                                disabled: true,
                                alwaysShowTooltip: false,
                                textStyle: const TextStyle(fontSize: 17)),
                            hatchMark: FlutterSliderHatchMark(
                              linesDistanceFromTrackBar: 5,
                              displayLines: false,
                              // labelBox: FlutterSliderSizedBox(width: 1, height: 10),
                              density: .1,
                              labels: lstLabel,
                              // [
                              //   FlutterSliderHatchMarkLabel(
                              //       percent: 0,
                              //       label: Padding(
                              //         padding: const EdgeInsets.only(top: 35),
                              //         child: spTextPrice(
                              //             context, spCs[i].opTs[0].doubleValue!,
                              //             format: Globals.storePriceFormat,
                              //             mStyle: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 11)),
                              //       )),
                              //   FlutterSliderHatchMarkLabel(
                              //       percent: 100,
                              //       label: Padding(
                              //         padding: const EdgeInsets.only(top: 35),
                              //         child: spTextPrice(
                              //             context,
                              //             spCs[i]
                              //                 .opTs[spCs[i].opTs.length - 1]
                              //                 .doubleValue!,
                              //             format: Globals.storePriceFormat,
                              //             mStyle: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 11)),
                              //       )),
                              // ],
                            ),
                            jump: false,
                            trackBar: const FlutterSliderTrackBar(),
                            handler: FlutterSliderHandler(
                              decoration: const BoxDecoration(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            rightHandler: FlutterSliderHandler(
                              decoration: const BoxDecoration(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            values: [_lowerValue, _upperValue],
                            visibleTouchArea: false,
                            min: spCs[i].opTs[0].doubleValue!,
                            max: spCs[i]
                                .opTs[spCs[i].opTs.length - 1]
                                .doubleValue!,
                            touchSize: 15,
                            lockHandlers: false,
                            lockDistance: spCs[i]
                                .opTs[spCs[i].opTs.length - 1]
                                .doubleValue! - spCs[i].opTs[0].doubleValue!,
                            rangeSlider: true,
                            step: FlutterSliderStep(
                                rangeList: lstRangeSlider,
                                isPercentRange: false,
                                step: 1),
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                _lowerValue = lowerValue;
                                _upperValue = upperValue;
                                filterItemUp.first.value = _upperValue;
                                filterItemLow.first.value = _lowerValue;
                                widget.callBack2(widget.filterList);
                              });
                            },
                          ),
                        ),

                        // SfRangeSlider( enableIntervalSelection: true,
                        //   shouldAlwaysShowTooltip: true,
                        //   min: _lowerValue,
                        //   max: _upperValue,
                        //   values: _values,
                        //   interval: 500000,
                        //   showTicks: false,
                        //   showLabels: false,
                        //   enableTooltip: true,
                        //   minorTicksPerInterval: 1,
                        //   onChanged: (SfRangeValues values){
                        //     setState(() {
                        //       _values = values;
                        //     });
                        //   },
                        // ),
                        //*******************
                        // FlutterSlider(
                        //   jump: true,
                        //   handlerAnimation: const FlutterSliderHandlerAnimation(
                        //       curve: Curves.elasticOut,
                        //       reverseCurve: Curves.bounceIn,
                        //       duration: Duration(milliseconds: 100),
                        //       scale: 1.5
                        //   ),
                        //   hatchMark: FlutterSliderHatchMark(
                        //     density: 0.1,
                        //     labels: [
                        //       FlutterSliderHatchMarkLabel(percent: 0, label: Padding(
                        //         padding: const EdgeInsets.only(top: 40),
                        //         child: Text(spCs[i].opTs[0].doubleValue!.toInt().toString(), style: TextStyle(fontSize: 10),),
                        //       )),
                        //       FlutterSliderHatchMarkLabel(percent: 100, label: Padding(
                        //         padding: const EdgeInsets.only(top: 40),
                        //         child: Text(spCs[i].opTs[spCs[i].opTs.length - 1].doubleValue!.toInt().toString(), style: TextStyle(fontSize: 10),),
                        //       )),
                        //     ],
                        //   ),
                        //   trackBar: FlutterSliderTrackBar(
                        //     inactiveTrackBar: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       color: Colors.black12,
                        //       border: Border.all(width: 3, color: Colors.blue),
                        //     ),
                        //     activeTrackBar: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(4),
                        //         color: Colors.blue.withOpacity(0.5)
                        //     ),
                        //   ),
                        //
                        //   handler: FlutterSliderHandler(
                        //     decoration: BoxDecoration(shape: BoxShape.circle),
                        //     child: Material(
                        //       color: Colors.transparent,
                        //       child: Container(
                        //           padding: EdgeInsets.all(5),
                        //           child: Icon(
                        //             Icons.adjust_outlined, color: Colors.grey,
                        //             size: 24,)),
                        //     ),
                        //   ),
                        //   rightHandler: FlutterSliderHandler(
                        //     decoration: BoxDecoration(shape: BoxShape.circle),
                        //     child: Material(
                        //       color: Colors.transparent,
                        //       child: Container(
                        //           padding: EdgeInsets.all(5),
                        //           child: Icon(
                        //             Icons.adjust_outlined, color: Colors.grey,
                        //             size: 24,)),
                        //     ),),
                        //
                        //   // tooltip: FlutterSliderTooltip(
                        //   //     textStyle: TextStyle(fontSize: 17, color: Colors.white),
                        //   //     boxStyle: FlutterSliderTooltipBox(
                        //   //         decoration: BoxDecoration(
                        //   //             color: Colors.redAccent.withOpacity(0.7)
                        //   //         )
                        //   //     )
                        //   // ),
                        //
                        //   tooltip: FlutterSliderTooltip(
                        //     alwaysShowTooltip: true,
                        //     leftPrefix: Text("از "),
                        //     rightPrefix: Text("تا "),
                        //   ),
                        //   values: [_lowerValue, _upperValue],
                        //   // fixedValues: lstFix,
                        //   step: FlutterSliderStep(step: 1
                        //   ,rangeList: _rangeList
                        //   ),
                        //   rangeSlider: true,
                        //   max: spCs[i].opTs[spCs[i].opTs.length - 1].doubleValue,
                        //   min: spCs[i].opTs[0].doubleValue,
                        //   onDragging: (handlerIndex, lowerValue, upperValue) {
                        //     _lowerValue = lowerValue;
                        //     _upperValue = upperValue;
                        //     setState(() {});
                        //   },
                        //   // fixedValues: [
                        //   //   FlutterSliderFixedValue(
                        //   //       percent: 0, value: "1000"),
                        //   //   FlutterSliderFixedValue(
                        //   //       percent: 10, value: "10K"),
                        //   //   FlutterSliderFixedValue(
                        //   //       percent: 50, value: 50000),
                        //   //   FlutterSliderFixedValue(
                        //   //       percent: 80, value: "80M"),
                        //   //   FlutterSliderFixedValue(
                        //   //       percent: 100, value: "100B"),
                        //   // ],
                        // ),
                      ),
                    ],
                  );
                } else if (spCs[i].spcTypeCode == 201 || spCs[i].spcTypeCode == 202) {

                  var filterShowInv = widget.filterList.where((element) => element.code == 201);
                  if(filterShowInv.isEmpty){
                    widget.filterList.add(filterItem(code: 201, id: '', value: false));
                  }else{
                    _showInv = filterShowInv.first.value;
                  }

                  var filterShowOff = widget.filterList.where((element) => element.code == 202);
                  if(filterShowOff.isEmpty){
                    widget.filterList.add(filterItem(code: 202, id: '', value: false));
                  }else{
                    _showOff = filterShowOff.first.value;
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 16, right: 26),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(child: Text(spCs[i].spcCatTitle)),
                            Switch(value: spCs[i].spcTypeCode == 201 ? _showInv : _showOff, onChanged: (show) {
                              setState(() {
                                if(spCs[i].spcTypeCode == 201) {
                                  _showInv = show;
                                  filterShowInv.first.value = show;
                                }else{
                                  _showOff = show;
                                  filterShowOff.first.value = show;
                                }
                                widget.callBack2(widget.filterList);
                              });
                            })
                          ],
                        ),
                      ),
                      const Divider(indent: 2),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SmartSelect<String>.multiple(
                        modalConfig: S2ModalConfig(
                          title: ReplacePersianChar(spC.spcCatTitle),
                        ),
                        choiceActiveStyle: const S2ChoiceStyle(
                            titleStyle: TextStyle(color: Colors.red)),
                        modalHeaderStyle: const S2ModalHeaderStyle(
                            textStyle:
                                TextStyle(fontFamily: "Yekan2", fontSize: 17)),
                        placeholder: "",
                        selectedValue: widget.selList[i],
                        choiceItems: _choiceItems,
                        modalType: S2ModalType.bottomSheet,
                        onModalClose: (state, confirmed) {
                          setState(() {
                            widget.selList[i] = state.selection?.value ?? [];
                          });
                          widget.callBack(widget.selList);
                        },
                        choiceDivider: false,
                        tileBuilder: (context, state) {
                          if (widget.reset) {
                            state.refresh(widget.selList[i]);
                            if (i == spCs.length - 1) {
                              widget.reset = false;
                            }
                          }

                          return S2Tile.fromState(
                            state,
                            isTwoLine: false,
                            textStyle: const TextStyle(
                                fontFamily: "Yekan", fontSize: 16),
                            leading: CircleAvatar(
                              backgroundColor: widget.selList[i]!.isNotEmpty
                                  ? Colors.red
                                  : Colors.blueGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.selList[i]!.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Divider(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    spC.opTs.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              // backgroundImage: NetworkImage(
                              //   'https://source.unsplash.com/yeVtxxPxzbw/100x100',
                              // ),
                            ),
                          );
                        },
                        onChange: (selected) => setState(() {
                          widget.selList[i] = selected?.value ?? [];
                          // widget.selList[i] = selected?.value;
                        }),
                      ),
                      const Divider(indent: 2),
                    ],
                  );
                }
                // spCs[i].spcTypeCode == 101
                //     ? FlutterSlider(
                //   handlerAnimation: FlutterSliderHandlerAnimation(
                //       curve: Curves.elasticOut,
                //       reverseCurve: Curves.bounceIn,
                //       duration: Duration(milliseconds: 100),
                //       scale: 1.5
                //   ),
                //
                //   trackBar: FlutterSliderTrackBar(
                //     inactiveTrackBar: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Colors.black12,
                //       border: Border.all(width: 3, color: Colors.blue),
                //     ),
                //     activeTrackBar: BoxDecoration(
                //         borderRadius: BorderRadius.circular(4),
                //         color: Colors.blue.withOpacity(0.5)
                //     ),
                //   ),
                //
                //   handler: FlutterSliderHandler(
                //     decoration: BoxDecoration( shape: BoxShape.circle),
                //     child: Material(
                //       color: Colors.transparent,
                //       child: Container(
                //           padding: EdgeInsets.all(5),
                //           child: Icon(Icons.adjust_outlined, color: Colors.grey, size: 24,)),
                //     ),
                //   ),
                //   rightHandler: FlutterSliderHandler(
                //     decoration: BoxDecoration( shape: BoxShape.circle),
                //     child: Material(
                //       color: Colors.transparent,
                //       child: Container(
                //           padding: EdgeInsets.all(5),
                //           child: Icon(Icons.adjust_outlined, color: Colors.grey, size: 24,)),
                //     ),                      ),
                //
                //   // tooltip: FlutterSliderTooltip(
                //   //     textStyle: TextStyle(fontSize: 17, color: Colors.white),
                //   //     boxStyle: FlutterSliderTooltipBox(
                //   //         decoration: BoxDecoration(
                //   //             color: Colors.redAccent.withOpacity(0.7)
                //   //         )
                //   //     )
                //   // ),
                //
                //   tooltip: FlutterSliderTooltip(
                //     leftPrefix: Text("از "),
                //     rightPrefix: Text("تا "),
                //   ),
                //         values: [_lowerValue, _upperValue],
                //         rangeSlider: true,
                //         max: spCs[i].opTs[spCs[i].opTs.length-1].doubleValue,
                //         min: spCs[i].opTs[0].doubleValue,
                //   onDragging: (handlerIndex, lowerValue, upperValue) {
                //     _lowerValue = lowerValue;
                //     _upperValue = upperValue;
                //     setState(() {});
                //   },
                //         // fixedValues: [
                //         //   FlutterSliderFixedValue(
                //         //       percent: 0, value: "1000"),
                //         //   FlutterSliderFixedValue(
                //         //       percent: 10, value: "10K"),
                //         //   FlutterSliderFixedValue(
                //         //       percent: 50, value: 50000),
                //         //   FlutterSliderFixedValue(
                //         //       percent: 80, value: "80M"),
                //         //   FlutterSliderFixedValue(
                //         //       percent: 100, value: "100B"),
                //         // ],
                //       )
                //     : spCs[i].spcTypeCode == 201
                //         ? Column(
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 26),
                //               child: Row(
                //                 // crossAxisAlignment: CrossAxisAlignment.stretch,
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Container(child: Text(spCs[i].spcCatTitle)),
                //                   Switch(value: false, onChanged: (m){})
                //                 ],
                //               ),
                //             ),
                //             const Divider(indent: 2),
                //           ],
                //         )
                //         : Column(
                //             children: [
                //               SmartSelect<String>.multiple(
                //                 modalConfig: S2ModalConfig(
                //                   title:
                //                       ReplacePersianChar(spC.spcCatTitle),
                //                 ),
                //                 choiceActiveStyle: const S2ChoiceStyle(
                //                     titleStyle:
                //                         TextStyle(color: Colors.red)),
                //                 modalHeaderStyle: const S2ModalHeaderStyle(
                //                     textStyle: TextStyle(
                //                         fontFamily: "Yekan2",
                //                         fontSize: 17)),
                //                 placeholder: "",
                //                 selectedValue: widget.selList[i],
                //                 choiceItems: _choiceItems,
                //                 modalType: S2ModalType.bottomSheet,
                //                 onModalClose: (state, confirmed) {
                //                   setState(() {
                //                     widget.selList[i] =
                //                         state.selection?.value ?? [];
                //                   });
                //                   widget.callBack(widget.selList);
                //                 },
                //                 choiceDivider: false,
                //                 tileBuilder: (context, state) {
                //                   if (widget.reset) {
                //                     state.refresh(widget.selList[i]);
                //                     if (i == spCs.length - 1) {
                //                       widget.reset = false;
                //                     }
                //                   }
                //
                //                   return S2Tile.fromState(
                //                     state,
                //                     isTwoLine: false,
                //                     textStyle: const TextStyle(
                //                         fontFamily: "Yekan", fontSize: 16),
                //                     leading: CircleAvatar(
                //                       backgroundColor:
                //                           widget.selList[i]!.isNotEmpty
                //                               ? Colors.red
                //                               : Colors.blueGrey,
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           Text(
                //                             widget.selList[i]!.length
                //                                 .toString(),
                //                             style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 12),
                //                           ),
                //                           const Padding(
                //                             padding: EdgeInsets.all(2.0),
                //                             child: Divider(
                //                               height: 2,
                //                               color: Colors.white,
                //                             ),
                //                           ),
                //                           Text(
                //                             spC.opTs.length.toString(),
                //                             style: const TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 12),
                //                           ),
                //                         ],
                //                       ),
                //                       // backgroundImage: NetworkImage(
                //                       //   'https://source.unsplash.com/yeVtxxPxzbw/100x100',
                //                       // ),
                //                     ),
                //                   );
                //                 },
                //                 onChange: (selected) => setState(() {
                //                   widget.selList[i] = selected?.value ?? [];
                //                   // widget.selList[i] = selected?.value;
                //                 }),
                //               ),
                //               const Divider(indent: 2),
                //             ],
                //           );
              },
            ),
          ),
        ],
      ),
    );
  }
}
