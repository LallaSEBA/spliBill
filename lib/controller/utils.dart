
  import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

String formatPhoneNumber(String? phone){
    if(phone!=null) {
      return phone.replaceAllMapped(RegExp(r'^(\+)\D'), (Match m)=>m[0]=='+'?'+':'');
    } else {
      return "";
    }
  }


  PickedFile? _image;
  final picker = ImagePicker();

  /*time over next step test read bill from image snipped*/
/*
   Future scanText() async {
     String _text = '';
     if(_image!=null){
      final FirebaseVisionImage visionImage =    FirebaseVisionImage.fromFile(File(_image!.path));
      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      final VisionText visionText =  await textRecognizer.processImage(visionImage);

      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          _text += line.text! + '\n';
        }
      }
    }
    return _text;
  }

  Future<String> getImage() async {
    String _text = '';
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = pickedFile as PickedFile?;
      _text = await scanText();
    } else {
    }
    return _text;
}*/

  