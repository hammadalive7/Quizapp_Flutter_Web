import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/take_quiz_without_login.dart';
import '../../../constants.dart';
import '../../../core/controller/login_controller.dart';
import '../../Quiz/screens/quizz_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
    }

    return Form(
      child: Column(
        children: [
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
                child: Icon(Icons.person),
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
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              controller.login();
              clearTextFields();
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              clearTextFields();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return const SignUpScreen();
              //     },
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
