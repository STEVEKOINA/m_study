import 'package:flutter/material.dart';
import 'package:laban_m_study/login/localwidgets/login_form.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image.asset("assets/book.jpg")
                  ),
                  const SizedBox(height: 20.0,),
                  const OurLoginForm(),
                ],
              )
          )
        ],
      ),
    );
  }
}
