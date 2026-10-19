import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color vinho = Color(0xFF7A1F2B);

  final _formKey = GlobalKey<FormState>();

  final cpfController = TextEditingController();
  final senhaController = TextEditingController();

  bool ocultarSenha = true;

  @override
  void dispose() {
    cpfController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void entrar() {
    if (_formKey.currentState!.validate()) {
      print('CPF: ${cpfController.text}');
      print('Senha: ${senhaController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado!'),
        ),
      );

      // Futuramente:
      // Aqui você pode verificar o CPF e a senha
      // no banco de dados ou Firebase.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: vinho,
        foregroundColor: Colors.white,
        title: const Text(
          'Entrar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.storefront,
                  size: 80,
                  color: vinho,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Local Shop',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: vinho,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Entre na sua conta',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // CPF
                TextFormField(
                  controller: cpfController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: campoDecoration(
                    'CPF',
                    Icons.badge_outlined,
                  ).copyWith(
                    counterText: '',
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe seu CPF.';
                    }

                    if (valor.length != 11) {
                      return 'O CPF deve possuir 11 números.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // SENHA
                TextFormField(
                  controller: senhaController,
                  obscureText: ocultarSenha,
                  decoration: campoDecoration(
                    'Senha',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ocultarSenha = !ocultarSenha;
                        });
                      },
                      icon: Icon(
                        ocultarSenha
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Informe sua senha.';
                    }

                    if (valor.length < 6) {
                      return 'A senha deve possuir pelo menos 6 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      print('Esqueci minha senha');
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: vinho,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // BOTÃO ENTRAR
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vinho,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: entrar,
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ainda não possui uma conta?',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          color: vinho,
                          fontWeight: FontWeight.bold,
                        ),
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

  InputDecoration campoDecoration(
    String texto,
    IconData icone,
  ) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(
        icone,
        color: vinho,
      ),
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: vinho,
          width: 2,
        ),
      ),
    );
  }
}