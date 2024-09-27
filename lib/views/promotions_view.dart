import 'package:flutter/material.dart';
import 'package:residents_app/widgets/proposal_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:residents_app/widgets/toast.dart';
import 'package:go_router/go_router.dart';

class ProposalsView extends StatelessWidget {
  ProposalsView({super.key});

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser; 

  void _toggleLike(DocumentSnapshot doc) async {
    if (user == null) return; 

    final String userId = user!.uid;
    final List<dynamic> likedBy = doc['likedBy'] ?? [];

    if (likedBy.contains(userId)) {
      
      final int currentLikes = doc['likes'] ?? 0;
      await db.collection('proposals').doc(doc.id).update({
        'likes': currentLikes - 1,
        'likedBy':
            FieldValue.arrayRemove([userId]), 
      });
    } else {
      
      final int currentLikes = doc['likes'] ?? 0;
      await db.collection('proposals').doc(doc.id).update({
        'likes': currentLikes + 1,
        'likedBy':
            FieldValue.arrayUnion([userId]), 
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: const Text(
          'Listado De Propuestas',
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db.collection('proposals').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No proposals found.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((doc) {
                final userInfo = doc['user'] as Map<String, dynamic>?;

                return Column(
                  children: [
                    SizedBox(height: 10),
                    ProposalCard(
                      title: doc['title'] ?? 'Sin título',
                      description: doc['description'] ?? 'Sin descripción',
                      name: userInfo != null ? userInfo['name'] ?? 'Sin nombre' : 'Sin nombre',
                      lastName: userInfo != null ? userInfo['lastName'] ?? 'Sin apellido' : 'Sin apellido',
                      likes: doc['likes'] ?? 0,
                      onLike: () => _toggleLike(doc),
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

