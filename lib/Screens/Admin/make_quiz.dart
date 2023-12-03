import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controller/quiz_controller.dart';
import '../Quiz/model/question_model.dart';

class QuizBuilderScreen extends StatefulWidget {
  int numberOfQuestions;
  String quizName;
  int quizCode;

  QuizBuilderScreen({Key? key, required this.numberOfQuestions, required this.quizName, required this.quizCode})
      : super(key: key);

  @override
  _QuizBuilderScreenState createState() => _QuizBuilderScreenState();
}

class _QuizBuilderScreenState extends State<QuizBuilderScreen> {
  final List<QuestionModel> questions = [];
  final PageController _pageController = PageController();
  bool quesCompleted = false;
  final _controller = Get.put(QuizController());

  TextEditingController questionController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Create Quiz', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Card(
            margin: EdgeInsets.all(16),
            elevation: 8,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.numberOfQuestions,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SingleChildScrollView(child: buildQuestionForm(index, _formkey));
              },
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.purple,
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.black12,
            width: 5,
          ),
        ),
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            saveQuestion();
          }
        },
        child: quesCompleted ? const Text("Submit") : const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget buildQuestionForm(int index, GlobalKey<FormState> _formkey) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            // Quiz image
            Image.asset(
              'assets/images/quiz_logo.png',
              height: 200,
              width: 200,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //some tag line or something
                const Text(
                  'Enter the Question and Options',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                  controller: questionController,
                  decoration:
                      InputDecoration(labelText: 'Question ${index + 1}'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                    controller: option1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 1',
                      // border color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                    controller: option2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                    controller: option3Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 3',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an option';
                      }
                      return null;
                    },
                    controller: option4Controller,
                    decoration: const InputDecoration(
                      labelText: 'Option 4',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number (1-4)';
                      }
                      int number = int.parse(value);
                      if (number < 1 || number > 4) {
                        return 'Please enter a number between 1 and 4';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Correct Option number (1-4)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveQuestion() async {
    int currentIndex = _pageController.page?.round() ?? 0;

    String question = questionController.text.toString();
    String option1 = option1Controller.text.toString();
    String option2 = option2Controller.text.toString();
    String option3 = option3Controller.text.toString();
    String option4 = option4Controller.text.toString();
    int correctOption = int.parse(numberController.text);

    // Create a QuestionModel instance and add it to the list
    QuestionModel newQuestion = QuestionModel(
      question,
      {
        option1: false,
        option2: false,
        option3: false,
        option4: false,
      },
    );

    // Set the correct option to true
    switch (correctOption) {
      case 1:
        newQuestion.answers![option1] = true;
        break;
      case 2:
        newQuestion.answers![option2] = true;
        break;
      case 3:
        newQuestion.answers![option3] = true;
        break;
      case 4:
        newQuestion.answers![option4] = true;
        break;
    }

    if ({option1, option2, option3, option4}.length < 4) {
      Get.snackbar("Error", "Please enter unique options");
      return;
    }

    setState(() {
      questions.add(newQuestion);
    });

    // Clear the text fields
    // You may want to customize this based on your needs


    // Move to the next page
    if (currentIndex < widget.numberOfQuestions - 1) {
      if(currentIndex == widget.numberOfQuestions - 2){
        setState(() {
          quesCompleted = true;
        });
      }
      questionController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      numberController.clear();
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Upload all questions to Firestore
      await _controller.uploadQuestionsToFirestore(questions, widget.quizName, widget.quizCode, questions.length);
      questionController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      numberController.clear();
      Get.offAllNamed('/HomeScreen', arguments: questions);
    }
  }
}
