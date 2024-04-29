import 'package:bcd/widgets/loading_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ImageCard extends StatelessWidget {
  final image_path;
  final ontap;
  const ImageCard({super.key, this.image_path, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.ontap,
      child: Center(
        child: image_path != null ? 
        Image.file(image_path) 
        : Text("Зураг олдсонгүй !"),
      ),
    );
  }
}