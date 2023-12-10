import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/Screens/DashBoard/home_screen.dart';
import 'package:quizapp/Screens/Login/login_screen.dart';
import 'package:quizapp/Screens/Quiz/model/question_model.dart';
import 'package:quizapp/Screens/Quiz/screens/result_screen.dart';
import '../../../core/controller/quiz_controller.dart';
import '../ui/shared/color.dart';

class QuizzScreen extends StatefulWidget {
  int code;

  QuizzScreen({Key? key, required this.code}) : super(key: key);

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int question_pos = 0;
  int score = 0;
  RxBool btnPressed = false.obs;
  PageController? _controller;
  RxString btnText = "Next Question".obs;
  RxBool answered = false.obs;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  final QuizController quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null) {
              Get.offAll(() => const HomeScreen());
            } else {
              Get.offAll(() => const LoginScreen());
            }
          },
        ),
        title: const Text("QUIZ QUESTIONS"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.6,
          decoration: BoxDecoration(
            color: AppColor.pripmaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FutureBuilder(
            future: quizController.getQuestionsFromFirestore(widget.code),
            builder: (context, AsyncSnapshot<List<QuestionModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          "No Quiz Found",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                          "Please Enter Valid Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      //button to go back
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purple,
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              Get.offAll(() => const HomeScreen());
                            } else {
                              Get.offAll(() => const LoginScreen());
                            }                          },
                          child: const Text("Back to Home Page",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              }
              List<QuestionModel> questions = snapshot.data!;
              return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: PageView.builder(
                    controller: _controller!,
                    onPageChanged: (page) {
                      if (page == questions.length - 1) {
                        btnText.value = "See Results";
                      }
                      answered.value = false;
                    },
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Question ${index + 1}/${questions.length}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 200.0,
                                child: Text(
                                  "${questions[index].question}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                              for (int i = 0;
                                  i < questions[index].answers!.length;
                                  i++)
                                Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  margin: const EdgeInsets.only(
                                      bottom: 20.0, left: 12.0, right: 12.0),
                                  child: RawMaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    fillColor: btnPressed.value
                                        ? questions[index]
                                                .answers!
                                                .values
                                                .toList()[i]
                                            ? Colors.green
                                            : Colors.red
                                        : AppColor.secondaryColor,
                                    onPressed: !answered.value
                                        ? () {
                                            if (questions[index]
                                                .answers!
                                                .values
                                                .toList()[i]) {
                                              score++;
                                              print("yes");
                                            } else {
                                              print("no");
                                            }
                                            btnPressed.value = true;
                                            answered.value = true;
                                          }
                                        : null,
                                    child: Text(
                                        questions[index]
                                            .answers!
                                            .keys
                                            .toList()[i],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                        )),
                                  ),
                                ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  if (_controller!.page?.toInt() ==
                                      questions.length - 1) {
                                    Get.offAll(ResultScreen(score));
                                  } else {
                                    _controller!.nextPage(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.easeInExpo);

                                    btnPressed.value = false;
                                  }
                                },
                                shape: const StadiumBorder(),
                                fillColor: Colors.purple,
                                padding: const EdgeInsets.all(18.0),
                                elevation: 0.0,
                                child: Text(
                                  btnText.value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ));
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }
}
