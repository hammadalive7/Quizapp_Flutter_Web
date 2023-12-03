import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Screens/Quiz/model/question_model.dart';

class QuizController extends GetxController {
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection('question');

  Future<void> uploadQuestionsToFirestore(
      List<QuestionModel> questions, String name, int code, int num) async {
    // Upload all questions to Firestore
    List<Map<String, dynamic>> questionsData = questions.map((question) {
      return {
        'question': question.question,
        'answers': question.answers,
      };
    }).toList();

    try {
      await quizCollection.add({
        'questions': questionsData,
        'quizName': name,
        'quizCode': code,
        'quizQuestions': num,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkIfQuizCodeExists(int quizCode) async {
    final CollectionReference<Map<String, dynamic>> quizzes =
        FirebaseFirestore.instance.collection('question');

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await quizzes.where('quizCode', isEqualTo: quizCode).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<QuestionModel>> getQuestionsFromFirestore(int quizCode) async {
    try {
      // Reference to the Firestore collection
      final CollectionReference<Map<String, dynamic>> quizzesCollection =
      FirebaseFirestore.instance.collection('question');

      // Query Firestore to get documents with the specified quizCode
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await quizzesCollection
          .where('quizCode', isEqualTo: quizCode)
          .get();

      // Map the query results to a list of QuestionModel
      List<QuestionModel> questions = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        // Extract the 'questions' field from the document
        List<Map<String, dynamic>>? questionsData =
        doc.data()['questions']?.cast<Map<String, dynamic>>();

        if (questionsData != null) {
          List<QuestionModel> questionModels =
          questionsData.map((data) => QuestionModel.fromFirestore(data)).toList();

          questions.addAll(questionModels);
        }
        else {
          debugPrint('No questions found for quiz code: $quizCode');
        }
      }
      debugPrint('Questions: $questions');
      return questions;
    } catch (e) {
      // Handle any potential errors
      print('Error fetching questions from Firestore: $e');
      return [];
    }
  }
}