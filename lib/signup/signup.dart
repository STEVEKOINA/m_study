
import 'package:flutter/material.dart';
import 'package:laban_m_study/signup/localwidgets/sign_up_form.dart';

class OurSignup extends StatelessWidget {
  const OurSignup({Key? key}) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  BackButton(),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const OurSignUpForm()
            ],
          ))
        ],
      ),
    );
  }
}
