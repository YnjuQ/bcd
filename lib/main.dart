import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bcd/widgets/image_card.dart';
import 'package:bcd/widgets/loading_model.dart';
import 'package:bcd/widgets/upload_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context)=> LoadingModel(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _imageFile;
  final picker = ImagePicker();
  dynamic result;
  double malignant = 0;
  double benign = 0;
  
  Future<void> query(String imagePath) async{
    final file = File(imagePath);
    context.read<LoadingModel>().setIsLoading(true);
    final data = await file.readAsBytes();
    final response = await http.post(
       Uri.parse(
          'https://api-inference.huggingface.co/models/ALM-AHME/beit-large-patch16-224-finetuned-BreastCancer-Classification-BreakHis-AH-60-20-20'),
        headers: {
          'Authorization': 'Bearer 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'
        },
        body: data,
      );
      try{
        if(response.statusCode == 200){
        setState(() {
          result = jsonDecode(response.body);
          print(result[0]['score']);
          print(result[1]['score']);
          malignant = result[0]['score'];
          benign = result[1]['score'];
        });
        }else{
          setState(() {
            result = null;
          });
        }
      }catch(e){
        print(e);
        context.read<LoadingModel>().setIsLoading(false);        
      }finally{
        context.read<LoadingModel>().setIsLoading(false);
      }
    }


  Future getImage() async {
    context.read<LoadingModel>().setIsLoading(true);
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        query(pickedFile.path);
      } else {
        print('No image selected.');
        context.read<LoadingModel>().setIsLoading(false);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<LoadingModel>(builder: (context, value, child)=>
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pinkAccent,
            title: Text('Хөхний өвчлөл таамаглагч', style: TextStyle(color: Colors.white),),
          ),
          body: Stack(
            children: [Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: DottedBorder(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height/2 * 0.8,
                        child: _imageFile != null ? ImageCard(image_path: _imageFile, ontap: getImage,): UploadButton(onclick: getImage,)
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Магадлал"),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: LinearPercentIndicator(
                        animation: true,
                      leading:Text("Хавдар:"),
                      // width: MediaQuery.sizeOf(context).width * 0.7,
                      lineHeight: 14.0,
                      percent: malignant,
                      center: Text(
                        "${(malignant * 100).floor()}%",
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.red,
                                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:20),
                      child: LinearPercentIndicator(
                        animation: true,
                      leading:Text("Эрүүл:"),
                      // width: MediaQuery.sizeOf(context).width * 0.7,
                      lineHeight: 14.0,
                      percent: benign,
                      center: Text(
                        "${(benign*100).floor()}%",
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.green,
                                        ),
                    ),
                    ]
                ),
              ),
              ]
            ),value.isLoading ? Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
                child: LoadingAnimationWidget.beat(
                      color: Color.fromRGBO(0, 0, 0, 0.6), 
                      size: 50
                    ),
              )
                ) : SizedBox.shrink()
              ]
          ),
        ),
      ),
    );
  }
}
