import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../methods/auth_methods.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
  }) : super(key: key);

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();
  final AuthMethode _authMethode = AuthMethode();

  void selectImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void signUpUser() async {
    String result = await _authMethode.signUpUser(
      email: widget.email,
      username: widget.username,
      password: widget.password,
      file: _image,
    );

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // User icon/image
          Container(
            child: _image != null
                ? Image.memory(_image!)
                : const Icon(Icons.person),
          ),

          // Username display
          Text(widget.username),

          // Camera icon
          GestureDetector(
            onTap: selectImageFromCamera,
            child: const Icon(Icons.camera_alt),
          ),

          // Gallery icon
          GestureDetector(
            onTap: selectImageFromGallery,
            child: const Icon(Icons.photo_library),
          ),

          // Next button
          ElevatedButton(
            onPressed: signUpUser,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
