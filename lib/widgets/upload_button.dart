import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  final onclick;
  const UploadButton({super.key, required this.onclick});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: widget.onclick, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
              Icons.add_a_photo,
              size: 120,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
            Text('Зураг хуулах',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 24),),
        ],
      ),
    );
  }
}