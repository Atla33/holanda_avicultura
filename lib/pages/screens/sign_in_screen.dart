import 'package:flutter/material.dart';
import 'package:holanda_avicultura/pages/base/base_screen.dart';
import 'package:holanda_avicultura/services/auth_service.dart';
import 'initial_screen.dart';
import 'sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _loginFailed = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        setState(() {
          _loginFailed = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BaseScreen()),
        );
      } else {
        setState(() {
          _loginFailed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login ou senha incorretos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 60),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: const Color(0xFFECAD32),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFECAD32),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Seja bem-vindo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFECAD32),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFFECAD32)),
                    hintText: 'E-mail',
                    hintStyle: const TextStyle(color: Color(0xFFECAD32)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                  ),
                  style: TextStyle(
                      color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFFECAD32)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFFECAD32),
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    hintText: 'Senha',
                    hintStyle: const TextStyle(color: Color(0xFFECAD32)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                    ),
                  ),
                  style: TextStyle(
                      color: _loginFailed ? Colors.red : Color(0xFFECAD32)),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        color: Color(0xFFECAD32),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: _signIn,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: const BoxDecoration(
                        color: Color(0xFFECAD32),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      const Text(
                        'Novo Membro?',
                        style: TextStyle(
                          color: Color(0xFFECAD32),
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFFECAD32),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SignInScreen(),
  ));
}
