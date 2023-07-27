// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/login_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isLoading = false;
  File? _imageFile;
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmationPassword = '';
  String _accountType = 'Student';
  String _teacherID = '';
  String _school = '';
  DocumentSnapshot? teacherDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Sign Up'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: AppStyle.appPadding.copyWith(top: 0, bottom: 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? const Icon(Icons.account_circle_rounded, size: 80)
                    : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addAvatar,
                icon: const Icon(Icons.add),
                label: Text('Add an avatar', style: AppStyle.defaultText),
              ),
              const SizedBox(height: 10),

              //name
              TextField(
                decoration: LoginStyle.nameTextField,
                onChanged: (value) => _name = value,
              ),
              const SizedBox(height: 10),

              //email
              TextField(
                decoration: LoginStyle.emailTextField,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 10),

              //password
              TextField(
                decoration: LoginStyle.passwordTextField,
                obscureText: true,
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 10),

              TextField(
                decoration: LoginStyle.confirmPasswordTextField,
                obscureText: true,
                onChanged: (value) => _confirmationPassword = value,
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Account Type:',
                    style: AppStyle.defaultText,
                  ),
                  const SizedBox(width: 10),
                  DropdownButton(
                      value: _accountType,
                      items: [
                        DropdownMenuItem(
                          value: 'Student',
                          child: Text(
                            'Student',
                            style: AppStyle.defaultText,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Teacher',
                          child: Text(
                            'Teacher',
                            style: AppStyle.defaultText,
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });

                        if (_accountType == 'Student') {
                          _school = '';
                        } else if (_accountType == 'Teacher') {
                          _teacherID = '';
                        }
                      }),
                ],
              ),
              const SizedBox(height: 10),

              //teacher id
              if (_accountType == 'Student')
                TextField(
                  decoration: LoginStyle.teacherIdTextField,
                  autocorrect: false,
                  onChanged: (value) => _teacherID = value,
                ),
              if (_accountType == 'Student') const SizedBox(height: 10),

              //school
              if (_accountType == 'Teacher')
                TextField(
                  decoration: LoginStyle.schoolTextField,
                  autocorrect: false,
                  onChanged: (value) => _school = value,
                ),
              if (_accountType == 'Teacher') const SizedBox(height: 10),

              //login button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isLoading) const CircularProgressIndicator(),
                  if (_isLoading) const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _signup,
                    icon: const Icon(Icons.done),
                    label: Text('SIGN UP', style: AppStyle.defaultText),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addAvatar() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add an avatar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo),
                  label: Text(
                    'Select from Gallery',
                    style: AppStyle.defaultText,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(
                    'Take a Photo',
                    style: AppStyle.defaultText,
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path);
    img = await _cropImage(img);
    setState(() {
      _imageFile = img;
    });
  }

  Future<File?> _cropImage(File image) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressFormat: ImageCompressFormat.jpg,
      maxWidth: 1000,
      maxHeight: 1000,
      compressQuality: 50,
    );

    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future<String?> uploadFile(String uid) async {
    if (_imageFile != null) {
      UploadTask? uploadTask;

      final path = 'avatar/$uid.jpg';

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(_imageFile!);

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    }
    return null;
  }

  void _signup() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    bool isConfirmed = await confirmDetails();
    if (isConfirmed) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(_name);
      userId = FirebaseAuth.instance.currentUser!.uid;
      String? imageLink = await uploadFile(userId);
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageLink);

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'Name': _name,
        'Email': _email,
        'Account Type': _accountType,
        if (_accountType == 'Student') 'Teacher Id': _teacherID,
        if (_accountType == 'Teacher') 'School': _school,
        'Avatar': imageLink,
        if (teacherDocument != null) 'School': teacherDocument!['School'],
      });

      if (_accountType == 'Student') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_teacherID)
            .collection('students')
            .doc(userId)
            .set({});
      }

      Navigator.pop(context);
    }
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<bool> confirmDetails() async {
    if (_name == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
      return false;
    }
    if (_email == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
        ),
      );
      return false;
    }
    if (_password == '' || _password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please enter a valid password. Note it must be at least 8 characters long.'),
        ),
      );
      return false;
    }
    if (_confirmationPassword != _password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm your password'),
        ),
      );
      return false;
    }
    if (_accountType == 'Student' && _teacherID == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your teacher\'s ID'),
        ),
      );
      return false;
    }
    if (_accountType == 'Student') {
      try {
        teacherDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(_teacherID)
            .get();
        if (teacherDocument!.data() == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'The Teacher ID that you have entered is invalid. Please make sure it is correct',
              ),
            ),
          );
          return false;
        }
        if (teacherDocument!['Account Type'] == 'Teacher') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ListTile(
                leading: CircleAvatar(
                  backgroundImage: teacherDocument!['Avatar'] != null
                      ? NetworkImage(teacherDocument!['Avatar'])
                      : null,
                  child: teacherDocument!['Avatar'] == null
                      ? const Icon(Icons.account_circle_rounded)
                      : null,
                ),
                title: Text(
                  teacherDocument!['Name'],
                  style: AppStyle.defaultText.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  'School: ${teacherDocument!['School']}',
                  style: AppStyle.defaultText.copyWith(color: Colors.white),
                ),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
    if (_accountType == 'Teacher' && _school == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the name of your school'),
        ),
      );
      return false;
    }
    // temporary
    return true;
  }
}
