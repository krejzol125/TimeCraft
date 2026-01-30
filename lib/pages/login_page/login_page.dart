import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/auth/session_cubit.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _signin() async {
    setState(() => loading = true);
    try {
      await context.read<SessionCubit>().signIn(email.text.trim(), pass.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _signup() async {
    setState(() => loading = true);
    try {
      await context.read<SessionCubit>().signUp(email.text.trim(), pass.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TcTextField(controller: email, labelText: 'Email'),
                const SizedBox(height: 8),
                TcTextField(
                  controller: pass,
                  obscureText: true,
                  labelText: 'Password',
                ),
                const SizedBox(height: 16),
                if (loading)
                  const CircularProgressIndicator()
                else
                  Row(
                    children: [
                      Expanded(
                        child: TcButton(
                          primary: false,
                          onTap: _signup,
                          label: 'Sign up',
                          icon: Icons.person_add,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TcButton(
                          onTap: _signin,
                          label: 'Sign in',
                          icon: Icons.login,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
