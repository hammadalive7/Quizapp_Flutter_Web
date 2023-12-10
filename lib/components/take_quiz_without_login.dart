

import 'package:flutter/material.dart';
import 'package:quizapp/constants.dart';

class TakeQuizWithoutLogin extends StatelessWidget {
  final bool login;
  final Function? press;
  const TakeQuizWithoutLogin({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Want to take Quiz ? " : "Want to take Quiz ? ",
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Anonymously" : "Anonymously",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(Icons.hide_image_outlined, color: kPrimaryColor,)
      ],
    );
  }
}
