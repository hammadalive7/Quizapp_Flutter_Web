import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/Screens/Quiz/screens/quizz_screen.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/take_quiz_without_login.dart';
import '../../../constants.dart';
import '../../../core/controller/signup_controller.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _CodeController = TextEditingController();

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Enter Quiz Code"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter quiz code";
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Please enter valid quiz code";
                  }
                  return null;
                },
                controller: _CodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  icon: Icon(Icons.numbers),
                  hintText: "Quiz Code",
                ),
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Get.offAll(() => QuizzScreen(code: int.parse(_CodeController.text),));
                    }
                  },
                  child: const Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      );
    }


    void clearTextFields() {
      controller.email.clear();
      controller.password.clear();
      controller.name.clear();
    }

    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: controller.name,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          TextFormField(
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.mail),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: controller.password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              controller.registerUser(
                controller.email.text,
                controller.password.text,
                controller.name.text,
              );
              clearTextFields();
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              clearTextFields();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding),
          TakeQuizWithoutLogin(
            press: () {
              clearTextFields();
              _showDialog();
            },
          ),

        ],
      ),
    );
  }
}