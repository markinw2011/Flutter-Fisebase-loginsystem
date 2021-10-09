// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loginsystem/model/profile.dart';
import 'package:loginsystem/screen/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  title: const Text("สร้างบัญชีผู้ใช้"),
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
                                child: const Text("ลงทะเบียน",
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: profile.email,
                                              password: profile.password
                                              ).then((value){
                                                formKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg: "สร้างบัญชีผู้ใช้แล้ว",
                                          gravity: ToastGravity.TOP);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const HomeScreen();
                                      }));
                                        });
                                    } on FirebaseAuthException catch (e) {
                                      String message;
                                      if (e.code == 'email-already-in-use') {
                                        message =
                                            "มีอีเมลนี้ในระบบแล้วครับใช้อีเมลอื่นครับ";
                                      } else if (e.code == 'weak-password') {
                                        message =
                                            "รหัสผ่านต้องมีความยาว6ตัวอักษรขึ้นไป";
                                      } else {
                                        message = e.message.toString();
                                      }
                                      Fluttertoast.showToast(
                                          msg: message.toString(),
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
