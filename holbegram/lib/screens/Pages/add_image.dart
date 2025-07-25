import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'package:holbegram/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool showIcons = false;

  void toggleIcons() {
    setState(() {
      showIcons = !showIcons;
    });
  }

  final TextEditingController captionController = TextEditingController();

  Uint8List? _image;

  void selectImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();

      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();

      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Image",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  final String res = await PostStorage().uploadPost(
                      captionController.text,
                      userProvider.getUser!.uid,
                      userProvider.getUser!.username,
                      userProvider.getUser!.photoUrl,
                      _image!);
                  if (res == "Ok") {
                    userProvider.refreshUser();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      ((route) => false),
                    );
                  }
                },
                child: Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[200],
                    fontFamily: 'Billabong',
                  ),
                ),
              ),
            ), //
            //
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const Text(
                  'Add Image',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Choose an image from your gallery or take one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: captionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      toggleIcons();
                    },
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            width: 300,
                            height: 200,
                          )
                        : Image.network(
                            'https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png',
                            width: 150,
                            height: 150,
                          ),
                  ),
                ),
              ],
            ),
            if (showIcons)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.photo_outlined,
                              size: 48, color: Colors.red),
                          onPressed: (() => selectImageFromGallery())),
                      const Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      IconButton(
                          icon: const Icon(Icons.camera_alt_outlined,
                              size: 48, color: Colors.red),
                          onPressed: (() => selectImageFromCamera())),
                      const Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ));
  }
}
