import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents_app/widgets/proposal_card.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Top 5 de las propuestas más votadas',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
          maxLines: 2,
        ),
      ),
      body: StreamBuilder(
        stream: db
            .collection('proposals')
            .orderBy("likes", descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay propuestas disponibles.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((doc) {
                final user = doc['user'] as Map<String, dynamic>?;  
                if (user == null) {
                  return const Text('Usuario desconocido');
                }

                return Column(
                  children: [
                    SizedBox(height: 10),
                    ProposalCard(
                      title: doc['title'] ?? 'Sin título', 
                      description: doc['description'] ?? 'Sin descripción', 
                      name: user['name'] ?? 'Desconocido',  
                      lastName: user['lastName'] ?? '',  
                      likes: doc['likes'] ?? 0,  
                      showLike: false,  
                      onLike: () => {},  
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}


