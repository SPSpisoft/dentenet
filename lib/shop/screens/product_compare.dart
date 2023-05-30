import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_table/table_sticky_headers.dart';

import '../classes/ClsProductHead.dart';

class ProductCompare extends StatefulWidget {
  List<ClsProductHead> prDs;

  ProductCompare(this.prDs, {Key? key}) : super(key: key);

  @override
  _ProductCompareState createState() => _ProductCompareState();
}

class _ProductCompareState extends State<ProductCompare> {
  @override
  Widget build(BuildContext context) {
    List<String> titleColumn = [];
    List<String> titleRow = [];
    List<List<String>> data = [];

    for (int i = 0; i < widget.prDs.length; i++) {
      titleColumn.add(widget.prDs[i].title);
    }

    for (int i = 0; i < widget.prDs[0].spcRep.length; i++) {
      titleRow.add(widget.prDs[0].spcRep[i].spcTitle);
    }

    for (int i = 0; i < widget.prDs.length; i++) {
      List<String> spc = [];
      for (int j = 0; j < widget.prDs[i].spcRep.length; j++) {
        spc.add(widget.prDs[i].spcRep[j].valueList);
      }
      data.add(spc);
    }

    return SafeArea(
      child: Scaffold(
        body: StickyHeadersTable(
          cellDimensions: CellDimensions.uniform(width: 100, height: 50),
          columnsLength: titleColumn.length,
          rowsLength: titleRow.length,
          columnsTitleBuilder: (i) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(decoration: BoxDecoration(color: Colors.amberAccent),
                width: double.infinity, height: double.infinity,
                child: Text(titleColumn[i], textAlign: TextAlign.center,)),
          ),
          rowsTitleBuilder: (i) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(decoration: BoxDecoration(color: Colors.blueAccent),
                  width: double.infinity, height: double.infinity,
                  child: Center(child: Text(titleRow[i]))),
            ),
          ),
          contentCellBuilder: (i, j) => Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(decoration: BoxDecoration(color: Colors.grey),
                width: double.infinity, height: 200,
                child: Center(child: Text(data[i][j], textAlign: TextAlign.center, style: TextStyle(fontSize: 5),))),
          ),
          legendCell: Text('Sticky Legend'),
        ),
      ),
    );
  }
}
