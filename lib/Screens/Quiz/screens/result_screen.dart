import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/shared/color.dart';


class ResultScreen extends StatefulWidget {
  int score;
  ResultScreen(this.score, {Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(icon: Icon(Icons.home), color: Colors.white, onPressed: (){
          Get.offAllNamed('/HomeScreen');
        },),
        title: const Text("Quiz Result"),
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
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: AppColor.pripmaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Congratulations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 45.0,
              ),
              const Text(
                "You Score is",
                style: TextStyle(color: Colors.white, fontSize: 34.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "${widget.score}",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 85.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/HomeScreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondaryColor,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(18.0),

                ),

                child: const Text(
                  "Finish",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
