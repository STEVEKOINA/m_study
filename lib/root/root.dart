// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home/home.dart';
import '../login/login.dart';
import '../noGroup/nogroup.dart';
import '../splashScreen/splash.dart';
import '../states/current_group.dart';
import '../states/current_user.dart';

enum AuthStatus{
  unknown,
  notInGroup,
  notLoggedIn,
  inGroup

}

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus authStatus=AuthStatus.unknown;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on state
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    String returnString = await currenState.onStartUp();
    if(returnString=="success"){

      if(currenState.getCurrentUser.groupId!=""){
        setState((){
          authStatus=AuthStatus.inGroup;
        });

      }else{
        setState((){
          authStatus=AuthStatus.notInGroup;
        });
      }
    }else{
      setState((){
        authStatus=AuthStatus.notLoggedIn;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget retval=const OurLogin();

    switch(authStatus){
      case AuthStatus.unknown:
        retval=const OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retval=const OurLogin();
        break;
      case AuthStatus.notInGroup:
        retval=const OurnoGroup();
        break;
      case AuthStatus.inGroup:
        retval=ChangeNotifierProvider(create: (BuildContext context) =>CurrentGroup() ,
        child: const HomeScreen());
        break;
      default:

    }
    return retval;
  }
}
