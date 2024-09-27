import 'package:flutter/material.dart';
import 'package:residents_app/widgets/promotion_card.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class AnnouncementView extends StatelessWidget {
  const AnnouncementView({super.key});


  Stream<QuerySnapshot> getPromotionsStream() {
    return FirebaseFirestore.instance.collection('promotions').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200], 
        title: const Text(
          'Promociones', 
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
          maxLines: 2,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    context.go('/create-announcement');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.purple[300], 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Añadir Promoción", 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                
                  stream: getPromotionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text("Error al cargar promociones");
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No hay promociones disponibles");
                    }

                    final promotions = snapshot.data!.docs;

                    return Column(
                      children: promotions.map((doc) {
                        final title = doc['title'] ?? 'Sin título';
                        final description =
                            doc['description'] ?? 'Sin descripción';
                        final imageUrl = doc['imageUrl'] as String?;

                        return AnnouncementCard(
                          title: title,
                          description: description,
                          imageUrl: imageUrl, 
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
