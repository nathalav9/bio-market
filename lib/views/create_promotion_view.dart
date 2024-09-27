import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:residents_app/widgets/form_container_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:residents_app/widgets/toast.dart';

class CreateProposalView extends StatefulWidget {
  const CreateProposalView({super.key});

  @override
  State<CreateProposalView> createState() => _CreateProposalViewState();
}

class _CreateProposalViewState extends State<CreateProposalView> {
  bool _isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _createProposal() async {
   
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      showToast(message: "Todos los campos son obligatorios");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

     
      final docRef = db.collection("users").doc(user.uid);
      final userInfo = await docRef.get();

      if (!userInfo.exists) {
        throw Exception("Documento del usuario no encontrado");
      }

      
      final userData = userInfo.data();
      if (userData == null) {
        throw Exception("Datos del usuario no disponibles");
      }

      // Crear objeto con la propuesta
      final usersProposal = <String, dynamic>{
        "title": _titleController.text,
        "description": _descriptionController.text,
        "likes": 0,
        "likedBy": [],
        "user": {
          "name": userData['name'] ?? 'Nombre no disponible',
          "lastName": userData['lastName'] ?? 'Apellido no disponible',
          "department": userData['department'] ?? 'Departamento no disponible',
          "municipality": userData['municipality'] ?? 'Municipio no disponible',
          "email": userData['email'] ?? 'Email no disponible',
        },
      };

      // Guardar propuesta en Firestore
      await db.collection("proposals").add(usersProposal);

      // Limpiar los campos del formulario
      _descriptionController.text = "";
      _titleController.text = "";

      showToast(message: "La propuesta se agregó correctamente");
      context.go('/proposals');
    } catch (e) {
      showToast(message: "Error al crear la propuesta: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Crear Propuesta",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormContainerWidget(
                controller: _titleController,
                hintText: "Título",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un título';
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _createProposal, 
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen, 
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

