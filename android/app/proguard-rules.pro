# Mantiene las clases utilizadas por Firebase
-keep class com.google.firebase.** { *; }

# Mantiene las clases de serialización y deserialización JSON usadas en Firestore
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Mantiene los modelos de datos usados por Firebase Firestore
-keep class com.google.firestore.v1.** { *; }
