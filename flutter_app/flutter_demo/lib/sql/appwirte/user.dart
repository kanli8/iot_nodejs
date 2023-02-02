


  import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/screens/login_screen.dart';
import 'package:smart_cook/sql/appwirte/client.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:uuid/uuid.dart';




void signIn2(
  String email , 
  String password,
  void Function() onLoading , 
  void Function() onSuccess ,
  void Function(String errMsg) onError
  ) async {

    onLoading();
  Account account = Account(client);
  
  Future<Session> result = account.createEmailSession(email: email, password: password) ;
  
  result
    .then((response) {
      userId = response.userId ;
     
        onSuccess();
    }).catchError((error) {
      onError(error.toString());
      
  });
}


void signup2({
  required String name,
  required String email,
  required String password,
  required void Function() onLoading , 
  required void Function() onSuccess ,
  required void Function(String errMsg) onError,
}){
    onLoading();
    Account account = Account(client);
    Uuid uuid = const Uuid();
    Future result  = account.create(
      userId:uuid.v4(),
      name:name,
      email: email,
      password: password,
    );

    result.then((response) {
      onSuccess();
     
    }).catchError((error) {
      onError(error.toString());
  });
}


Future<void> checkLogin2({
  required void Function() onLoading , 
  required void Function() onSuccess ,
  required void Function(String errMsg) onError})async {
    Account account = Account(client);
    onLoading();
    Future<SessionList> result = account.getSessions();
    Future<User> userResult = account.get();

    

    result
      .then((response) {
         bool isLogin = false ;
         for(Session session in response.sessions){
            if(session.current){
              sessionId = session.$id ;
              userId = session.userId ;
              
              isLogin = true ;
            }
         }
          if(isLogin){
            onSuccess();
          }else{
            onError('no login');
          }
        

      }).catchError((error) {
        onError(error.toString());
      }); 

    userResult.then(
      (response){
        username = response.name;
      }).catchError((error) {
      
    });
      
}


void logout2(context){
    Account account = Account(client);

    Future<SessionList> getSessionResult = account.getSessions();

    getSessionResult
      .then((sessionList) {
          for(int i=0;i<sessionList.total;i++){
            Session session = sessionList.sessions[i];
            if(session.current){
                 Future result = account.deleteSession(
                  sessionId: session.$id,
                );
                result
                  .then((response) {
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false) ;
                  }).catchError((error) {
                    context.showErrorSnackBar(message: error.message);
                  });
            }
          }
      }).catchError((error) {
        context.showErrorSnackBar(message: error.message);
    });
}


void setUserAtavar({
  required void Function(Image image) onChooseImage , 
  required void Function() onLoading , 
  required void Function(String uuid) onSuccess ,
  required void Function(String errMsg) onError
}) async {
    Account account = Account(client);
    uploadImg(
      imgBucketId: avatarsImgBucketId,
      onChooseImage:onChooseImage,
      onLoading:onLoading,
      onSuccess:(String uuid){

        Future result = account.updatePrefs(prefs: {
          'avatars' : uuid
        });

        result.then((response) {
          onSuccess(uuid) ;
          }).catchError((error) {
            onError(error.toString());
        });
        
      },
      onError:onError
      ) ;

}
