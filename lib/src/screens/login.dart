import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/src/bloc/login_bloc.dart';
import 'package:store/src/screens/admin/adminNabar.dart';
import 'package:store/src/screens/homeNabar.dart';
import 'package:store/src/screens/register.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc bloc = LoginBloc();

  bool _showPass = false;
  @override
  dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/book_login.png',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 32,
            ),
            StreamBuilder(
                stream: bloc.email,
                builder: (context, snapshot) {
                  return TextField(
                    // controller: _userController,
                    decoration: InputDecoration(
                        labelText: "Tên đăng nhập",
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40))),
                            onChanged: (value) => bloc.valueEmail(value),
                  );
                }),
            SizedBox(
              height: 16,
            ),
            Stack(alignment: AlignmentDirectional.centerEnd, children: [
              StreamBuilder(
                  stream: bloc.pass,
                  builder: (context, snapshot) {
                    return TextField(
                      obscureText: !_showPass,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                                
                      ),
                      onChanged: (value) => bloc.valuePass(value),
                    );
                  }),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    _showPass = !_showPass;
                  });
                }),
                child: Text(
                  !_showPass ? 'Show' : 'Hide',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              )
            ]),
            SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:() =>  bloc.login(context),
                  
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)))),
                )),
            SizedBox(
              height: 16,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Register())));
                },
                child: Text('Bạn chưa có tài khoản? Tạo tài khoản'))
          ],
        ),
      ),
    );
  }
}
