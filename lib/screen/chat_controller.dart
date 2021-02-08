import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatController {


  // realizando login pelo googlr
  final googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;

  Future<Null> ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) // ou seja não estamos logados
      user = await googleSignIn.signInSilently();
    // vamos tentar fazer um login silencioso sem exibir mensagem para o usuario

    if (user == null) user = await googleSignIn.signIn();
    //caso nao tenha conseguido ai sim vamos tentar novamente abrindo a opção de logar

    // ---------------- Primeiro autenticação no google ↑

    if (await auth.currentUser == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );
    }
    // ---------------- Primeiro autenticação no Firebase ↑
  }

  //Pegar o texto e enviar para o banco do firebase
  handleSubmitted({String text}) async {
    await ensureLoggedIn();
    sendMessage(message: text);
  }

  void sendMessage({String message, String imgUrl}) {
    FirebaseFirestore.instance.collection("messages").add({
      "message": message,
      "imgUrl": imgUrl,
      "senderName": googleSignIn.currentUser.displayName,
      //nome do usuario no google
      "senderPhotoUrl": googleSignIn.currentUser.photoUrl
      // foto de quem enviou a mensagem
    });
  }

  ChatController(){
    ensureLoggedIn();
  }
}
