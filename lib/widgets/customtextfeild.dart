import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  const CustomTextFeild(
      {super.key, required this.hinttext, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centers the widget
      child: Stack(
        children: [
          Image.asset(
            'assets/images/textfeild.png',
            width: MediaQuery.of(context).size.width / 1.6,
            fit: BoxFit.contain,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: controller,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color:  Colors.white, fontFamily: 'Bowl'),
                  decoration: InputDecoration(
                    hoverColor: Colors.white,
                    iconColor: Colors.white,
                    focusColor: Colors.white,
                    border: InputBorder.none,
                    hintText: hinttext,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                            color: Colors.white,
                            fontFamily: 'Bowl'),
                    contentPadding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 30),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}