import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MediaUpload extends StatefulWidget {
  final Function(String?) onMediaUploaded;
  final int index;
  final String question;
  final String questionImage;
  final List<List<String>> selectedChoices;

  MediaUpload(
      {required this.question,
      required this.onMediaUploaded,
      required this.index,
      required this.questionImage,
      required this.selectedChoices});

  @override
  _UploadMediaState createState() => _UploadMediaState();
}

class _UploadMediaState extends State<MediaUpload> {
  XFile? _image;
  String? imageUrl;

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });

      final imageUrl = await uploadImageToFirebase(File(_image!.path));
      widget.onMediaUploaded(imageUrl);
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questionImage.length > 0) {
      return Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.index + 1}. ${widget.question}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    widget.questionImage,
                    height: null,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )),
              Center(
                  child: ElevatedButton(
                onPressed: _getImage,
                child: Text('Upload Media'),
              )),
              if (_image != null) Image.file(File(_image!.path)),
            ],
          ));
    }

    return Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${widget.index + 1}. ${widget.question}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Center(
                child: ElevatedButton(
              onPressed: _getImage,
              child: Text('Upload Media'),
            )),
            if (!widget.selectedChoices[widget.index].isEmpty)
              Image.network(widget.selectedChoices[widget.index][0]),
          ],
        ));
  }
}
