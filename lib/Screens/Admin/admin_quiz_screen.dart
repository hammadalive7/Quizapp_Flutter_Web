import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizapp/Screens/Admin/make_quiz.dart';

import '../../constants.dart';
import '../../core/controller/quiz_controller.dart';

class AdminQuizScreen extends StatefulWidget {
  const AdminQuizScreen({Key? key}) : super(key: key);

  @override
  State<AdminQuizScreen> createState() => _AdminQuizScreenState();
}

class _AdminQuizScreenState extends State<AdminQuizScreen> {
  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController quizCodeController = TextEditingController();
  final TextEditingController numberOfQuestionsController = TextEditingController();

  final _controller = Get.put(QuizController());

  //form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text(
            "Admin Screen",
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Get.toNamed('/ProfileScreen');
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Card(

            margin: EdgeInsets.all(16),
            elevation: 8,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Quiz',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        controller: quizNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter quiz name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Quiz Name',
                          hintText: 'Enter your quiz name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        controller: quizCodeController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter quiz code';
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter valid quiz code';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Quiz Code',
                          hintText: 'Enter your quiz code (numbers only)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        controller: numberOfQuestionsController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter number of questions';
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter valid number of questions';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Number of Questions',
                          hintText: 'Enter number of questions (numbers only)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool quizCodeExists = await _controller.checkIfQuizCodeExists(
                              int.tryParse(quizCodeController.text) ?? 0,
                            );

                            print(quizCodeExists);

                            if (quizCodeExists) {
                              Get.snackbar("Error", "Same Quiz Code Exists Already!");
                              return;
                            }else{
                              navigateToNextScreen();
                            }
                          }
                        },
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToNextScreen() async {
    // Get the entered data
    String quizName = quizNameController.text;
    int quizCode = int.tryParse(quizCodeController.text) ?? 0;
    int numberOfQuestions = int.tryParse(numberOfQuestionsController.text) ?? 0;


    Get.to(
      () => QuizBuilderScreen(
        numberOfQuestions: numberOfQuestions,
        quizCode: quizCode,
        quizName: quizName,
      ),
    );
  }
}
