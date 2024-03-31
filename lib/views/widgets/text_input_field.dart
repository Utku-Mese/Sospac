import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController _controller;
  final String _labelText;
  final IconData _icon;
  const TextInputField(
      {super.key,
      required TextEditingController controller,
      required String labelText,
      required IconData icon})
      : _controller = controller,
        _labelText = labelText,
        _icon = icon,
        super();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      controller: _controller,
      decoration: InputDecoration(
        label: Text(
          _labelText,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0XFF767676),
          ),
        ),
        //labelText: _labelText,
        prefixIcon: Icon(
          _icon,
          color: primaryColor,
          size: 33,
        ),
        labelStyle: const TextStyle(
          fontSize: 15,
          color: Color(0XFF767676),
        ),
        border: InputBorder.none,
      ),
      obscureText: _labelText == "Password" ? true : false,
    );
  }
}
