import 'package:flutter/material.dart';
import '../components/input_widget.dart';
import '../components/styles.dart';
import '../components/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  String? email;
  String? password;

  void login() async {
    setState(() {
      debugPrint("set state login 1");
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', ModalRoute.withName('/dashboard'));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        debugPrint("setstate login 2");
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Halaman Login di rebuild");
    debugPrint("Hello Bro");
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text('Login', style: headerStyle(level: 2)),
                    Container(
                      child: const Text(
                        'Login to your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputLayout(
                                  'Email',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            debugPrint(
                                                "set state email form field");
                                            email = value;
                                          }),
                                      validator: notEmptyValidator,
                                      decoration: customInputDecoration(
                                          "email@email.com"))),
                              InputLayout(
                                  'Password',
                                  TextFormField(
                                      onChanged: (String value) => setState(() {
                                            debugPrint(
                                                "set state password field");
                                            password = value;
                                          }),
                                      validator: notEmptyValidator,
                                      obscureText: true,
                                      decoration: customInputDecoration(""))),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: FilledButton(
                                    style: buttonStyle,
                                    child: Text('Login',
                                        style:
                                            headerStyle(level: 3, dark: false)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        login();
                                      }
                                    }),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? '),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text('Daftar di sini',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
