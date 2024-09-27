import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:residents_app/widgets/form_container_widget.dart';
import 'package:residents_app/widgets/toast.dart';
import 'package:go_router/go_router.dart';

class CreateAnnouncementView extends StatefulWidget {
  const CreateAnnouncementView({super.key});

  @override
  State<CreateAnnouncementView> createState() => _CreateAnnouncementViewState();
}

class _CreateAnnouncementViewState extends State<CreateAnnouncementView> {
  bool _isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  File? _imageFile;
  final picker = ImagePicker();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = storage
          .ref()
          .child('promotions/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }

  void _createAnnouncement() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      showToast(message: "Todos los campos son obligatorios");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    final docRef = db.collection("users").doc(user?.uid);
    final userInfo = await docRef.get();

    if (!userInfo.exists) {
      setState(() {
        _isLoading = false;
      });
      throw Exception("Documento de usuario no encontrado");
    }

    String? imageUrl;
    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!);
    }

    final usersAnnouncement = <String, dynamic>{
      "title": _titleController.text,
      "description": _descriptionController.text,
      "user": userInfo.data(),
      "imageUrl": imageUrl,
    };

    await db.collection("promotions").add(usersAnnouncement);
    _descriptionController.clear();
    _titleController.clear();
    setState(() {
      _isLoading = false;
      _imageFile = null;
    });

    showToast(message: "Promoción creada con éxito");
    context.go('/announcement');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Crear Promoción",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _titleController,
                  hintText: "Título",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _descriptionController,
                  hintText: "Descripción",
                  isTextArea: true,
                ),
                const SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!, height: 150)
                    : const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.purple[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Abrir Cámara",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _createAnnouncement,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.green[300], 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Crear",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
