import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siruangflutter/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: emailC,
                decoration: InputDecoration(labelText: "Email")),
            TextField(
                controller: passC,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true),
            SizedBox(height: 20),
            Obx(() => auth.isLoggedIn.value
                ? Text("Sudah login")
                : ElevatedButton(
                    onPressed: () async {
                      bool ok = await auth.login(emailC.text, passC.text);
                      if (ok) {
                        Get.offAllNamed('/home');
                      } else {
                        Get.snackbar("Error", "Login gagal");
                      }
                    },
                    child: Text("Login"),
                  )),
          ],
        ),
      ),
    );
  }
}
