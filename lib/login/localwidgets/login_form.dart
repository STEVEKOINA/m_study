
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:laban_m_study/root/root.dart';
import 'package:laban_m_study/signup/signup.dart';
import 'package:laban_m_study/states/current_user.dart';
import 'package:laban_m_study/widgets/our_container.dart';
import 'package:provider/provider.dart';

enum LoginType { email, google }

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  void loginUser(
      {required LoginType type,
      String? email,
      String? password,
      BuildContext? context}) async {
    CurrenState currenState = Provider.of<CurrenState>(context!, listen: false);
    String returnString = "";
    try {
      switch (type) {
        case LoginType.email:
          returnString = await currenState.loginUser(email!, password!);
          break;
        case LoginType.google:
          returnString = await currenState.loginUserWithGoogle();
          break;
        default:
      }

      if (returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OurRoot(),
            ),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(returnString),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget googleButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 0,
        ),
        onPressed: () {
          loginUser(type: LoginType.google, context: context);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const[
               Image(
                image: AssetImage("assets/google_icon.jpg"),
                height: 25,
              ),
               Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: (Text(
              "Log In",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: "Email"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Log In",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            onPressed: () {
              loginUser(
                  type: LoginType.email,
                  email: emailController.text,
                  password: passwordController.text,
                  context: context);
            },
          ),
          Row(
            children: [
              const Text('Don\'t have and account?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OurSignup()),
                  );
                },
                child: const Text(" Sign up"),
              ),
            ],
          ),
          googleButton()
        ],
      ),
    );
  }
}
