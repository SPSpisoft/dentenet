import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class SnackBarPage extends StatefulWidget {
  String text;

  SnackBarPage({Key? key, required this.text}) : super(key: key);

  @override
  State<SnackBarPage> createState() => _SnackBarPageState();
}

class _SnackBarPageState extends State<SnackBarPage> {
  @override
  Widget build(BuildContext context) {
    showTopSnackBar(
      context,
      const CustomSnackBar.info(
        message:
        "Good job, your release is successful. Have a nice day",
      ),
    );
    return Container();
  }
}
