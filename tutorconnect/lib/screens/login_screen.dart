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

  /// Función para iniciar sesión con validación simple
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
            _buildHeader(context), // Header con animaciones optimizadas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitle(), // Título de la app
                  const SizedBox(height: 30),
                  _buildLoginForm(), // Formulario con TextFields optimizados
                  const SizedBox(height: 20),
                  _buildForgotPasswordButton(), // Botón "Olvidaste tu contraseña"
                  const SizedBox(height: 30),
                  _buildLoginButton(), // Botón de login con Consumer
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header con imágenes de fondo optimizadas usando Image.asset en lugar de BoxDecoration
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: <Widget>[
          // Imagen de fondo principal
          Positioned.fill(
            top: -40,
            child: FadeInUp(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                Images.background,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Imagen secundaria
          Positioned.fill(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Image.asset(
                Images.background2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Título con animación y const para evitar rebuilds
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

  /// Formulario de login optimizado usando widgets stateless para los TextFields
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
            LoginTextField(controller: _emailController, hintText: "Email"),
            LoginTextField(
              controller: _passwordController,
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Botón "Olvidaste tu contraseña" con animación
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

  /// Botón de login optimizado para reconstruir solo lo necesario usando Consumer
  Widget _buildLoginButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1900),
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialButton(
            onPressed: _isEmailLoginLoading ? null : _login,
            color: const Color.fromRGBO(49, 39, 79, 1),
