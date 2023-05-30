import 'dart:math';
import 'dart:ui';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:platform_info/platform_info.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sp_keyboard_shortcut_ns/sp_keyboard_shortcut_ns.dart';

// import 'package:avoid_keyboard/avoid_keyboard.dart';
// import 'package:keyboard_avoider/keyboard_avoider.dart';
import '../../../public/public_functions.dart';
import '../../../public/public_variables.dart';
import '../../data_fetch.dart';

class UserScreen extends StatefulWidget {
  final void Function(int, int, String?) goToPage;
  final Function()? refreshMainMaster;

  const UserScreen({Key? key, required this.goToPage, this.refreshMainMaster})
      : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with TickerProviderStateMixin, CodeAutoFill {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  UserStatus status = UserStatus.Unknown;
  PhoneNumber myPhone =
      PhoneNumber(countryISOCode: '', countryCode: '+98', number: '');
  String? appSignature;
  String? otpCode;
  String verifyCode = '';

  String setPass = "";
  String rePass = "";

  final _scrollController = ScrollController();

  FocusNode passFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusNode newRepPassFocusNode = FocusNode();

  bool hidePassword = true;

  int remToggleValue = 0;
  String initCountryCode = 'IR';
  String remMobile = '';
  String initPass = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    cancel();
  }

  @override
  void initState() {
    remToggleValue = Globals.prefs.getInt(Globals.prfRemember) ?? 0;
    if (remToggleValue > 0) {
      remMobile = Globals.prefs.getString(Globals.prfMobile) ?? '';
      initCountryCode = Globals.prefs.getString(Globals.prfCountryCode) ?? 'IR';
      if (initCountryCode.isEmpty) initCountryCode = 'IR';
      myPhone.number = remMobile;
      myPhone.countryISOCode = initCountryCode;
      if (remToggleValue > 1) {
        initPass = Globals.prefs.getString(Globals.prfPassword) ?? '';
      }
    }

    setPass = initPass;

    if (Globals.myMemberId.isNotEmpty && Globals.myMemberId.length > 0) {
      status = UserStatus.Login;
    } else {
      status = UserStatus.Unknown;
    }
    super.initState();
    setState(() {});
    // _controller.reverse();

    listenForCode();

    if(platform.isAndroid || platform.isIOS) {
      SmsAutoFill().getAppSignature.then((signature) {
        setState(() {
          appSignature = signature;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
      globalShortcuts: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(3.0),
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/user_default.jpg',
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: FadeTransition(
                  opacity: _animation.drive(CurveTween(curve: Curves.easeOut)),
                  child: Wrap(
                    children: [
                      Container(
                        width: 340,
                        // height: 400,
                        // duration: Duration(milliseconds: 2000), curve: Curves.easeIn,
                        // height: 0.5.sh,
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.white12.withOpacity(0.1),
                        ),
                        child: statusView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  statusView() {
    switch (status) {
      case UserStatus.Unknown:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "خوش آمدید",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Titraj',
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 10.0,
                        color: Colors.black,
                      ),
                      // Shadow(
                      //   offset: Offset(0.0, 15.0),
                      //   blurRadius: 1.0,
                      //   color: Colors.yellow,
                      // ),
                    ],
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "شما در حال حاضر بعنوان کاربر میهمان وارد شده اید",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Beirut',
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 10.0,
                        color: Colors.red,
                      ),
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "لطفا درصورتیکه قبلا ثبت نام کرده اید، با نام کاربری خود وارد شوید، در غیر اینصورت ابتدا ثبت نام کنید.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Yekan',
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 10.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        status = UserStatus.Login;
                        setState(() {
                          widget.refreshMainMaster!();
                        });
                        // Navigator.of(context).push(PageRouteBuilder(
                        //   pageBuilder: (context, animation, secondaryAnimation) =>
                        //       LoginScreen(),
                        //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        //     return child;
                        //   },
                        // ));
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.black,
                        backgroundColor: Colors.green.withOpacity(0.4),
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0.01.sh,
                            bottom: 0.015.sh,
                            right: 0.02.sw + 10,
                            left: 0.02.sw + 10),
                        child: const Text(
                          'ورود', // GO TO ENTER PAGE
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Yekan',
                            fontSize: 18,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        verifyCode = '';
                        status = UserStatus.Register;
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.black,
                        backgroundColor: Colors.blue.withOpacity(0.4),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0.01.sh,
                            bottom: 0.015.sh,
                            right: 0.02.sw,
                            left: 0.02.sw),
                        child: const Text(
                          'ثبت نام',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Yekan',
                            fontSize: 18,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      case UserStatus.Register:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 270, minWidth: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "لطفا شماره تلفن همراه خود را وارد کنید.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Focus(
                      onFocusChange: (isFocus) {
                        if (isFocus) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        } else {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: IntlPhoneField(
                        showDropdownIcon: true,
                        decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IR',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        invalidNumberMessage: '',
                        onChanged: (phone) async {
                          myPhone = phone;
                          if (phone.number.startsWith('0')) {
                            ToastNormal('شماره را بدون صفر اول وارد کنید',
                                context, type: 0);
                          } else if (phone.number.length == 10) {
                            if (phone.countryISOCode != 'IR') {
                              ToastNormal('شماره وارد شده پشتیبانی نمی شود!',
                                   context, type: -1);
                            } else {
                              appSignature ??= "";

                              var mFuture = fetchRegister(myPhone.number,
                                  myPhone.countryCode, appSignature!,
                                  myVerifyCode: verifyCode).then((v) => resetToken(v));

                              await showDialog(
                                context: context,
                                builder: (context) =>
                                    FutureProgressDialog(mFuture),
                              );
                              // await Future.delayed(const Duration(seconds: 2),
                              //     () async {
                              //       var mFuture = fetchRegister(myPhone.number,
                              //       myPhone.countryCode, appSignature!,
                              //       myVerifyCode: verifyCode);
                              //
                              //   await showDialog(
                              //       context: context,
                              //       builder: (context) =>
                              //       FutureProgressDialog(mFuture),
                              //       );
                              // });
                            }
                          }
                          print(phone.completeNumber);
                        },
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              child: Row(
                                children: const [
                                  Text("صفحه ورود",
                                      style:
                                          TextStyle(color: Colors.greenAccent)),
                                  Icon(Icons.account_box_outlined,
                                      color: Colors.greenAccent),
                                ],
                              ),
                              onTap: () {
                                status = UserStatus.Login;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case UserStatus.WaitSms:
        // listenForCode();
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "کد تایید (پیامک شده) را وارد و ارسال نمایید.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Yekan',
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 10.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 270, minWidth: 200),
                child: PinFieldAutoFill(
                  // decoration: PinDecoration(textStyle: TextStyle(color: Colors.black54)),
                  currentCode: otpCode,
                  enableInteractiveSelection: true,
                  // onCodeSubmitted:
                  onCodeChanged: (code) async {
                    if (code!.length == 6) {
                      verifyCode = code;
                      // await Future.delayed(const Duration(seconds: 2), () {
                      //   fetchRegister(
                      //       myPhone.number, myPhone.countryCode, appSignature!,
                      //       myVerifyCode: verifyCode);
                      // });

                      await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                            Future.delayed(const Duration(seconds: 2), () {
                          fetchRegister(myPhone.number, myPhone.countryCode,
                              appSignature!,
                              myVerifyCode: verifyCode).then((v) => resetToken(v));
                        })),
                      );
                    }
                  },
                  // codeLength: //code length, default 6
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: OutlinedButton(
                onPressed: () {
                  fetchRegister(
                      myPhone.number, myPhone.countryCode, appSignature!,
                      myVerifyCode: verifyCode).then((v) => resetToken(v));
                },
                style: OutlinedButton.styleFrom(
                  elevation: 10,
                  primary: Colors.black,
                  backgroundColor: Colors.blue.withOpacity(0.4),
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0.01.sh,
                      bottom: 0.015.sh,
                      right: 0.02.sw + 10,
                      left: 0.02.sw + 10),
                  child: const Text(
                    'تایید و ارسال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Yekan',
                      fontSize: 16,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(myPhone.countryCode + myPhone.number,
                        style: const TextStyle(color: Colors.white70)),
                    InkWell(
                        child: Row(
                          children: const [
                            Text("اصلاح شماره",
                                style: TextStyle(color: Colors.greenAccent)),
                            Icon(Icons.rate_review_outlined,
                                color: Colors.greenAccent),
                          ],
                        ),
                        onTap: () {
                          status = UserStatus.Register;
                          setState(() {});
                        }),
                  ],
                ),
              ),
            )
          ],
        );
      case UserStatus.SetPass:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 270, minWidth: 200),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "گذرواژه خود را تعیین کنید.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Focus(
                      onFocusChange: (isFocus) {
                        if (isFocus) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          // initialValue: initPass,
                          // controller: TextEditingController().. text = initPass.isEmpty ? setPass : initPass,
                          onChanged: (value) {
                            // if(initPass.isNotEmpty && setPass == initPass) {
                            //   value = '';
                            // }
                            // if(initPass.isNotEmpty) {
                            //   initPass = '';
                            // }
                            setPass = value;
                            setState(() {});
                          },
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          focusNode: newPassFocusNode,
                          autofocus: true,
                          obscureText: hidePassword,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(newRepPassFocusNode),
                          onSubmitted: (s) => FocusScope.of(context)
                              .requestFocus(newRepPassFocusNode),
                          //show/hide password
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password_outlined,
                                color: Color.fromARGB(255, 117, 248, 5)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                icon: hidePassword
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.white24,
                                      )
                                    : const Icon(Icons.visibility,
                                        color: Colors.white54),
                                onPressed: () {
                                  setState(() {
                                    if (hidePassword && initPass.isNotEmpty) {
                                      //   setPass = '';
                                      initPass = '';
                                    }
                                    // }else {
                                    hidePassword = !hidePassword;
                                    // }
                                  });
                                },
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), //circular border for TextField.
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Focus(
                      // focusNode: newRepPassFocusNode,
                      onFocusChange: (isFocus) {
                        if (isFocus) {
                          // ToastNormal(_scrollController.position.maxScrollExtent.toString());
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        } else {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          onTap: () => FocusScope.of(context)
                              .requestFocus(newRepPassFocusNode),
                          // initialValue: initPass,
                          // controller: TextEditingController().. text = initPass.isEmpty ? setPass : initPass,
                          onChanged: (value) {
                            // if(initPass.isNotEmpty && setPass == initPass) {
                            //   value = '';
                            // }
                            // if(initPass.isNotEmpty) {
                            //   initPass = '';
                            // }
                            rePass = value;
                            setState(() {});
                          },
                          onEditingComplete: () async => await setPassword().then((value) {
                            if (value == 205) {
                              widget.goToPage(0, 3, "");
                              widget.refreshMainMaster!();
                            }
                          }),
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          focusNode: newRepPassFocusNode,
                          autofocus: false,
                          obscureText: hidePassword,
                          //show/hide password
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password_sharp,
                                color: Color.fromARGB(255, 253, 200, 3)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                icon: hidePassword
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.white24,
                                      )
                                    : const Icon(Icons.visibility,
                                        color: Colors.white54),
                                onPressed: () {
                                  setState(() {
                                    if (hidePassword && initPass.isNotEmpty) {
                                      //   setPass = '';
                                      initPass = '';
                                    }
                                    // }else {
                                    hidePassword = !hidePassword;
                                    // }
                                  });
                                },
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), //circular border for TextField.
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: PasswordField(
                  //     color: Colors.blue,
                  //     onChanged: (s) {
                  //       rePass = s;
                  //       setState(() {});
                  //     },
                  //     // passwordConstraint: r'.*[@$#.*].*',
                  //     inputDecoration: PasswordDecoration(),
                  //     hintText: 'گذرواژه را تکرار کنید',
                  //     border: PasswordBorder(
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.blue.shade100,
                  //         ),
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.blue.shade100,
                  //         ),
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //         borderSide:
                  //             BorderSide(width: 2, color: Colors.red.shade200),
                  //       ),
                  //     ),
                  //     errorMessage: setPass != rePass
                  //         ? "عبارات وارد شده هماهنگ نیستند!"
                  //         : "",
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        await setPassword().then((value) {
                          if (value == 205) {
                            widget.goToPage(0, 3, "");
                            widget.refreshMainMaster!();
                          }
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.black,
                        backgroundColor: Colors.blue.withOpacity(0.4),
                        side: const BorderSide(color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0.01.sh,
                            bottom: 0.015.sh,
                            right: 0.02.sw + 10,
                            left: 0.02.sw + 10),
                        child: const Text(
                          'ثبت و ورود',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Yekan',
                            fontSize: 16,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      case UserStatus.Login:
        if (Globals.myMemberId.length > 0) {
          return Container(
            child: Column(
              children: [
                Text(Globals.myMemberId),
                OutlinedButton(
                  onPressed: () {
                    Globals.myMemberId = '';
                    fetchToken(
                      context,
                      true,
                      Globals.myTypeID,
                      Globals.myStoreId,
                      Globals.myMemberId.trim(),
                      Globals.myNetIP,
                      Globals.myDeviceId,
                      Globals.myAppVersion,
                      Globals.myPassword,
                    ).then((value) {
                      widget.refreshMainMaster!();
                      setState(() {});
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.black,
                    backgroundColor: Colors.blue.withOpacity(0.4),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.sh,
                        bottom: 0.015.sh,
                        right: 0.02.sw + 10,
                        left: 0.02.sw + 10),
                    child: const Text(
                      'خروج از حساب کاربری',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        fontSize: 16,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.black,
                    backgroundColor: Colors.blue.withOpacity(0.4),
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.sh,
                        bottom: 0.015.sh,
                        right: 0.02.sw + 10,
                        left: 0.02.sw + 10),
                    child: const Text(
                      'لیست سفارشات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        fontSize: 16,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.black,
                    backgroundColor: Colors.blue.withOpacity(0.4),
                    side: const BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.sh,
                        bottom: 0.015.sh,
                        right: 0.02.sw + 10,
                        left: 0.02.sw + 10),
                    child: const Text(
                      'لیست های منتخب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        fontSize: 16,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200, minWidth: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "شماره موبایل و رمز عبور را وارد کنید.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Yekan',
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Focus(
                        onFocusChange: (isFocus) {
                          if (isFocus) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                          // else {
                          //   _scrollController.animateTo(
                          //     0,
                          //     duration: Duration(seconds: 1),
                          //     curve: Curves.fastOutSlowIn,
                          //   );
                          // }
                        },
                        child: IntlPhoneField(
                          showDropdownIcon: true,
                          initialValue: remMobile,
                          decoration: const InputDecoration(
                            labelText: '',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: initCountryCode,
                          onSubmitted: (s) {
                            FocusScope.of(context).requestFocus(passFocusNode);
                          },
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          invalidNumberMessage: "",
                          onChanged: (phone) async {
                            myPhone = phone;
                            if (phone.number.startsWith('0')) {
                              ToastNormal('شماره را بدون صفر اول وارد کنید',
                                   context, type: 0);
                            } else if (phone.number.length == 10) {
                              if (phone.countryISOCode != 'IR') {
                                ToastNormal('شماره وارد شده پشتیبانی نمی شود!',
                                     context, type: -1);
                              } else {
                                appSignature ??= "";
                                FocusScope.of(context)
                                    .requestFocus(passFocusNode);
                              }
                            }
                            print(phone.completeNumber);
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Focus(
                      onFocusChange: (isFocus) {
                        if (isFocus) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        } else {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextField(
                          // initialValue: initPass,
                          controller: TextEditingController()
                            ..text = initPass.isEmpty ? setPass : initPass,
                          onChanged: (value) {
                            if (initPass.isNotEmpty && setPass == initPass) {
                              value = '';
                            }
                            if (initPass.isNotEmpty) {
                              initPass = '';
                            }
                            setPass = value;
                          },
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          focusNode: passFocusNode,
                          autofocus: false,
                          obscureText: hidePassword,
                          //show/hide password
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock,
                                color: Color.fromARGB(255, 139, 86, 22)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                icon: hidePassword
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.white24,
                                      )
                                    : const Icon(Icons.visibility,
                                        color: Colors.white54),
                                onPressed: () {
                                  setState(() {
                                    if (hidePassword && initPass.isNotEmpty) {
                                      setPass = '';
                                      initPass = '';
                                    } else {
                                      hidePassword = !hidePassword;
                                    }
                                  });
                                },
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), //circular border for TextField.
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, right: 10, left: 10),
                    child: OutlinedButton(
                      onPressed: () async {
                        var mFuture = fetchRegister(myPhone.number,
                                myPhone.countryCode, appSignature ?? "",
                                myPassword:
                                    setPass.isNotEmpty ? setPass : "SETPASS")
                            .then((value) {
                          resetToken(value);
                          if (value == 200 || value == 201) {
                            if (remToggleValue > 0) {
                              Globals.prefs
                                  .setInt(Globals.prfRemember, remToggleValue);
                              Globals.prefs
                                  .setString(Globals.prfMobile, myPhone.number);
                              Globals.prefs.setString(Globals.prfCountryCode,
                                  myPhone.countryISOCode);
                              if (remToggleValue == 2) {
                                Globals.prefs
                                    .setString(Globals.prfPassword, setPass);
                              }
                            }
                            widget.refreshMainMaster!();
                          } else if (value == 202) {
                            // ToastNormal("44444444444444_text");
                            status = UserStatus.WaitSms;
                            setState(() {});
                          }
                          // else{
                          //   ToastNormal("عملیات ناموفق "+ value.toString());
                          // }
                        });

                        // ToastNormal("منتظر بمانید");
                        // showDialog(
                        //   context: context,
                        //   builder: (context) =>
                        //       FutureProgressDialog(mFuture, message: Text('Loading...')),
                        // );

                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(mFuture),
                        );

                        // _scrollController.animateTo(
                        //   _scrollController.position.maxScrollExtent,
                        //   duration: Duration(seconds: 1),
                        //   curve: Curves.fastOutSlowIn,
                        // );

                        // Navigator.of(context).push(PageRouteBuilder(
                        //   pageBuilder:
                        //       (context, animation,
                        //       secondaryAnimation) =>
                        //       TestPage(title: "test"),
                        //   transitionsBuilder: (context, animation,
                        //       secondaryAnimation, child) {
                        //     return child;
                        //   },
                        // ));
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.black,
                        backgroundColor: Colors.blue.withOpacity(0.4),
                        side: const BorderSide(color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0.01.sh,
                            bottom: 0.015.sh,
                            right: 0.02.sw + 10,
                            left: 0.02.sw + 10),
                        child: const Text(
                          'ورود', // ENTER TO APP
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Yekan',
                            fontSize: 16,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Text("ذخیره",
                              //     style: TextStyle(color: Colors.greenAccent)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: SizedBox(
                                  width: 80,
                                  child:
                                      AnimatedToggleSwitch<int>.rollingByHeight(
                                    height: 25.0,
                                    borderRadius: BorderRadius.circular(7),
                                    borderWidth: 0,
                                    current: remToggleValue,
                                    indicatorBorderRadius:
                                        BorderRadius.circular(5),
                                    indicatorSize: const Size(5, 5),
                                    values: const [0, 1, 2],
                                    onChanged: (i) =>
                                        setState(() => remToggleValue = i),
                                    iconBuilder: rollingIconBuilder,
                                    innerColor: Colors.black45,
                                    // indicatorSize: const Size.fromWidth(2),
                                    foregroundBoxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1.5),
                                      )
                                    ],
                                    borderColor: Colors.orange,
                                    boxShadow: [
                                      BoxShadow(
                                        color: remToggleValue == 0
                                            ? Colors.greenAccent
                                            : remToggleValue == 1
                                                ? Colors.orange
                                                : Colors.redAccent,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1.5),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                              child: Row(
                                children: const [
                                  Text("ثبت نام",
                                      style:
                                          TextStyle(color: Colors.greenAccent)),
                                  Icon(Icons.app_registration,
                                      color: Colors.greenAccent),
                                ],
                              ),
                              onTap: () {
                                verifyCode = '';
                                status = UserStatus.Register;
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        break;
      case UserStatus.Stable:
        // TODO: Handle this case.
        break;
    }
  }

  // sendPhoneNumber() {
  Future<int> fetchRegister(
      String myNumber, String myCountryCode, String appSignature,
      {String myVerifyCode = '', String myPassword = ''}) async {
    int sRet = -1;

    var url = Uri.parse(
        '${Globals.baseApiAddressShop}MyStore=${Globals.myStoreId}&MyNumber=$myNumber&MyCountryCode=${myCountryCode.replaceAll('+', '')}&TypeID=${Globals.myTypeID}&NetIP=${Globals.myNetIP}&MyVerifyCode=$myVerifyCode&DeviceID=${Globals.myDeviceId}&AppVer=${Globals.myAppVersion}&TxtPlus=$appSignature&Pass=$myPassword');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': Globals.basicAuth
        },
      );

      sRet = response.statusCode;

      if (response.statusCode == 205 ||
          response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        Globals.myPassword = myPassword;
        if (response.statusCode == 205) {
          widget.goToPage(0, 3, "");
        } else if ((verifyCode.isNotEmpty && verifyCode.length > 0) ||
            (myPassword.isNotEmpty && myPassword.length > 0)) {
          Globals.myMemberId = response.body.replaceAll("\"", "");
          // Globals.prefs.setString(Globals.prfUserID, Globals.myMemberId);
          // Globals.myMemberId = Globals.prefs.getString(Globals.prfUserID)!;

          if (response.statusCode == 201) {
            widget.goToPage(0, 3, "");
          } else {
            status = UserStatus.SetPass;
          }
          setState(() {});
        } else {
          status = UserStatus.WaitSms;
          setState(() {});
        }
      } else {
        ToastNormal(response.body, context, type: 0);
        if (verifyCode.isNotEmpty && verifyCode.length > 0) {
          if (response.statusCode == 408) {
            verifyCode = "";
            status = UserStatus.Register;
            setState(() {});
          }
        }
      }

      // if (response.statusCode == 200) {
      //   response.body;
      //
      // } else {
      //   print(response.statusCode);
      //   print(response.body);
      //   return Future.error(response.statusCode);
      // }
    } catch (e) {
      print(e);
    }

    return sRet;
  }

  // final future = fetchRegister(myPhone.number, myPhone.countryCode, appSignature!, myVerifyCode : verifyCode);
  // future.then((response) {
  //   if(response.statusCode == 200 || response.statusCode == 202 || response.statusCode == 406) {
  //     // if(verifyCode.isEmpty || verifyCode.length == 0) {
  //       status = UserStatus.WaitSms;
  //       setState(() {});
  //     // }else{
  //     //   Globals.prefs.setString(Globals.prfUserID, response.body);
  //     //   Globals.myMemberId = Globals.prefs.getString(Globals.prfUserID)!;
  //     // }
  //   }else{
  //     ToastNormal(response.body);
  //   }
  // });
  // }

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
    switch (value) {
      case 0:
        return Icon(
          Icons.save_outlined,
          color: Colors.white,
          size: iconSize.shortestSide,
        );
      case 1:
        return Icon(
          Icons.account_circle_outlined,
          color: Colors.orange,
          size: iconSize.shortestSide,
        );
      case 2:
        return Icon(
          Icons.admin_panel_settings_outlined,
          color: Colors.redAccent,
          size: iconSize.shortestSide,
        );
    }
    IconData data = Icons.access_time_rounded;
    if (value.isEven) data = Icons.cancel;
    return Icon(
      data,
      size: iconSize.shortestSide,
    );
  }

  Future<int> setPassword() {
    if (setPass != rePass) {
      ToastNormal('گذرواژه های وارد شده هماهنگ نیست!',
          context, type: -1);
      FocusScope.of(context).requestFocus(newRepPassFocusNode);
      return Future.error(-1);
    } else if (setPass.length < 4) {
      ToastNormal('طول گذرواژه بایستی حذاقل 4 کاراکتر باشد!',
           context, type: 0);
      FocusScope.of(context).requestFocus(newPassFocusNode);
      return Future.error(-2);
    } else {
      return fetchRegister(myPhone.number, myPhone.countryCode, appSignature!,
          myVerifyCode: verifyCode, myPassword: setPass).then((v) => resetToken(v));
      // ClsUserSet myUser = ClsUserSet(UserID: Globals.myMemberId, newPassword: setPass, NikName: "AAA");
      // postUser(myUser);
      // fetchRegister(
      //     myPhone.number, myPhone.countryCode, appSignature!,
      //     myVerifyCode: verifyCode);
    }
  }

  resetToken(int vStatusCode) {
    if (vStatusCode == 200 || vStatusCode == 201) {
      // if (vStatusCode == 205 ||
      //     vStatusCode == 200 ||
      //     vStatusCode == 201 ||
      //     vStatusCode == 202) {
      fetchToken(
          context,
          true,
          Globals.myTypeID,
          Globals.myStoreId,
          Globals.myMemberId.trim(),
          Globals.myNetIP,
          Globals.myDeviceId,
          Globals.myAppVersion,
          Globals.myPassword)
          .then((value) {
        widget.refreshMainMaster!();
        // setState(() {});
      });
    }
  }
}
