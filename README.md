# chat_flutter_firebase

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Informações de uso do firebase

  #Escrever dados no projeto Firebase

  FirebaseFirestore.instance.collection("teste").doc("teste").set({"teste":"teste"}); adicionar itens no banco do firebase
  FirebaseFirestore.instance.collection("teste").doc().collection("lista de teste dentro do teste ").doc().set({"teste":"teste"}); aqui eu tenho uma lista dentro de outra lista

   #lendo os dados
  DocumentSnapshot conteudoDocuments = await FirebaseFirestore.instance.collection("users").doc("Kelry").get(); dados do documento
  QuerySnapshot documentsKey = await FirebaseFirestore.instance.collection("users").get();  toodos os "documentos"
  print(conteudoDocuments.data());
  for (DocumentSnapshot doc in documentsKey.docs) {
    print(doc.data());
  }

  # Notificação sempre que houver uma nova mensagem
  FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
    for (DocumentSnapshot doc in event.docs) {
      print(doc.data());
    }
  });

