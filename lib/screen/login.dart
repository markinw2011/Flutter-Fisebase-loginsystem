import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';

// import 'home.dart';
import 'welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("เข้าสู่ระบบ"),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "อีเมล",
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              validator: MultiValidator([
                                EmailValidator(errorText: "ใส่อีเมลไม่ถูกต้อง"),
                                RequiredValidator(errorText: "ป้อนอีเมล"),
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (email) {
                                profile.email = email!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "รหัสผ่าน",
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              validator:
                                  RequiredValidator(errorText: "ป้อนรหัสผ่าน"),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              onSaved: (password) {
                                profile.password = password!;
                              },
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text("ลงชื่อเข้าใช้",
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    try {
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: profile.email, 
                                        password: profile.password).then((value){
                                          formKey.currentState!.reset();
                                          Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return  WelcomeScreen();
                                      }));
                                        });
                                    } on FirebaseAuthException catch (e) {
                                      Fluttertoast.showToast(
                                          msg: e.message.toString(),
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
