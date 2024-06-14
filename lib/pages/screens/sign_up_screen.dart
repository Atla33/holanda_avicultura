import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holanda_avicultura/services/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _dobFormatter = MaskTextInputFormatter(mask: '##/##/####');
  final _phoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####');
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');

  bool _passwordsMatch = true;
  bool _emailsMatch = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 0;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _signUp() async {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
      _emailsMatch = _emailController.text == _confirmEmailController.text;
    });

    if (_formKey.currentState!.validate() && _passwordsMatch && _emailsMatch) {
      User? user = await _authService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso')),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao realizar o cadastro')),
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
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _signUp();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              steps: [
                Step(
                  title: const Text('Informações Pessoais'),
                  content: Column(
                    children: <Widget>[
                      _buildTextField(
                        controller: _firstNameController,
                        icon: Icons.person,
                        hintText: 'Nome',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        hintText: 'Sobrenome',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _dobController,
                        icon: Icons.cake,
                        hintText: 'Data de Nascimento',
                        inputFormatters: [_dobFormatter],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneController,
                        icon: Icons.phone,
                        hintText: 'Telefone',
                        inputFormatters: [_phoneFormatter],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _cpfController,
                        icon: Icons.badge,
                        hintText: 'CPF',
                        inputFormatters: [_cpfFormatter],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Endereço'),
                  content: Column(
                    children: <Widget>[
                      _buildTextField(
                        controller: _stateController,
                        icon: Icons.map,
                        hintText: 'Estado',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _cityController,
                        icon: Icons.location_city,
                        hintText: 'Cidade',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _neighborhoodController,
                        icon: Icons.home,
                        hintText: 'Bairro',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _streetController,
                        icon: Icons.streetview,
                        hintText: 'Rua',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _houseNumberController,
                        icon: Icons.confirmation_number,
                        hintText: 'Número',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _complementController,
                        icon: Icons.add,
                        hintText: 'Complemento',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _zipCodeController,
                        icon: Icons.mail,
                        hintText: 'CEP',
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Informações de Login'),
                  content: Column(
                    children: <Widget>[
                      _buildTextField(
                        controller: _emailController,
                        icon: Icons.email,
                        hintText: 'E-mail',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _confirmEmailController,
                        icon: Icons.email_outlined,
                        hintText: 'Confirme o E-mail',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, preencha este campo';
                          }
                          if (!_emailsMatch) {
                            return 'Os e-mails não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordTextField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        hintText: 'Senha',
                        obscureText: _obscurePassword,
                        toggleVisibility: _togglePasswordVisibility,
                        passwordsMatch: _passwordsMatch,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordTextField(
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline,
                        hintText: 'Confirme a Senha',
                        obscureText: _obscureConfirmPassword,
                        toggleVisibility: _toggleConfirmPasswordVisibility,
                        passwordsMatch: _passwordsMatch,
                      ),
                      if (!_passwordsMatch)
                        const Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Text(
                            'As senhas não coincidem',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                  state: _currentStep == 2
                      ? StepState.indexed
                      : StepState.complete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFECAD32)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFECAD32)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFECAD32)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFECAD32)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFECAD32)),
        ),
      ),
      style: const TextStyle(color: Color(0xFFECAD32)),
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            return null;
          },
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required bool passwordsMatch,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFECAD32)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFECAD32)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
              color: passwordsMatch ? const Color(0xFFECAD32) : Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
              color: passwordsMatch ? const Color(0xFFECAD32) : Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
              color: passwordsMatch ? const Color(0xFFECAD32) : Colors.red),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          color: const Color(0xFFECAD32),
          onPressed: toggleVisibility,
        ),
      ),
      style: const TextStyle(color: Color(0xFFECAD32)),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        if (!passwordsMatch) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SignInScreen(),
  ));
}
