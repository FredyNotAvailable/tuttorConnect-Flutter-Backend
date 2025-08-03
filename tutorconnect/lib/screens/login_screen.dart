import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/routes/app_routes.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await ref.read(signInProvider({'email': email, 'password': password}).future);

      if (user != null) {
        if (!mounted) return; // Para evitar errores si el widget fue desmontado
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar sesión')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Métodos para login rápido con credenciales predefinidas
  void _loginWithFreddyCredentials() {
    _emailController.text = 'frguamango@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithFrancoCredentials() {
    _emailController.text = 'frquezadaor@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }

  void _loginWithProgramacionMovilCredentials() {
    _emailController.text = 'riarmijosme@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithInteligenciaArtificalCredentials() {
    _emailController.text = 'mipalaciosmo@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithArquitecturaCredentials() {
    _emailController.text = 'locondezh@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithSoftwareCredentials() {
    _emailController.text = 'chcardenasto@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithOperacionesCredentials() {
    _emailController.text = 'maespinozati@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }
  void _loginWithRedesCredentials() {
    _emailController.text = 'jusanmartindi@uide.edu.ec';
    _passwordController.text = 'password';
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithFreddyCredentials,
              child: const Text('Login rápido con Freddy'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithFrancoCredentials,
              child: const Text('Login rápido con Franco'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithProgramacionMovilCredentials,
              child: const Text('Login rápido con Programacion Movil'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithInteligenciaArtificalCredentials,
              child: const Text('Login rápido con AI'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithArquitecturaCredentials,
              child: const Text('Login rápido con Arquitectura PC'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithRedesCredentials,
              child: const Text('Login rápido con Redes'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithSoftwareCredentials,
              child: const Text('Login rápido con Software'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _loginWithOperacionesCredentials,
              child: const Text('Login rápido con Operaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
