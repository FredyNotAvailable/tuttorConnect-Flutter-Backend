import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:tutorconnect/utils/images.dart';

import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailLoginLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() => _isEmailLoginLoading = true);

    try {
      final user = await ref.read(
        signInProvider({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }).future,
      );

      if (!mounted) return;

      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Credenciales incorrectas. Inténtalo de nuevo.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isEmailLoginLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitle(),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 30),
                  _buildCreateAccountButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 400,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -40,
            height: 400,
            width: width,
            child: FadeInUp(
              duration: const Duration(seconds: 1),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.background),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            height: 400,
            width: width + 20,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.background2),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1500),
      child: const Text(
        "TutorConnect",
        style: TextStyle(
          color: Color.fromRGBO(49, 39, 79, 1),
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1700),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: const Color.fromRGBO(196, 135, 198, .3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(196, 135, 198, .3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _buildTextField(controller: _emailController, hintText: "Email"),
            _buildTextField(
              controller: _passwordController,
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(196, 135, 198, .3),
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1700),
      child: Center(
        child: TextButton(
          onPressed: () {
            // TODO: Implementar la lógica de recuperación de contraseña
          },
          child: const Text(
            "¿Olvidaste tu contraseña?",
            style: TextStyle(
              color: Color.fromRGBO(196, 135, 198, 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1900),
      child: MaterialButton(
        onPressed: _isEmailLoginLoading ? null : _login,
        color: const Color.fromRGBO(49, 39, 79, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        height: 50,
        child: Center(
          child: _isEmailLoginLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.register);
          },
          child: const Text(
            "Crear Cuenta",
            style: TextStyle(
              color: Color.fromRGBO(49, 39, 79, .6),
            ),
          ),
        ),
      ),
    );
  }
}
