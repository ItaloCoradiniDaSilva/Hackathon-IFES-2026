import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'login_page.dart';


class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  static const Color vinho = Color(0xFF7A1F2B);

  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final nascimentoController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? fotoPerfil;

  bool ocultarSenha = true;
  bool ocultarConfirmacao = true;

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    nascimentoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();

    super.dispose();
  }

  // SELECIONAR FOTO DA GALERIA
  Future<void> selecionarFoto() async {
    final XFile? imagem = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagem != null) {
      final bytes = await imagem.readAsBytes();

      setState(() {
        fotoPerfil = bytes;
      });
    }
  }

  // REMOVER FOTO
  void removerFoto() {
    setState(() {
      fotoPerfil = null;
    });
  }

  // SELECIONAR DATA DE NASCIMENTO
  Future<void> selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (data != null) {
      nascimentoController.text =
          '${data.day.toString().padLeft(2, '0')}/'
          '${data.month.toString().padLeft(2, '0')}/'
          '${data.year}';
    }
  }

  // CADASTRAR USUÁRIO
  void cadastrar() {
    if (_formKey.currentState!.validate()) {
      // Se fotoPerfil == null, será usada a foto padrão.
      if (fotoPerfil == null) {
        print('Usuário cadastrado com foto padrão.');
      } else {
        print('Usuário cadastrado com foto personalizada.');
      }

      print('Nome: ${nomeController.text}');
      print('CPF: ${cpfController.text}');
      print('Nascimento: ${nascimentoController.text}');
      print('Email: ${emailController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
        ),
      );
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
          'Criar conta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO DE PERFIL
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFFE8E8E8),

                          // Caso tenha foto
                          backgroundImage: fotoPerfil != null
                              ? MemoryImage(fotoPerfil!)
                              : null,

                          // Caso NÃO tenha foto
                          child: fotoPerfil == null
                              ? const Icon(
                                  Icons.person,
                                  size: 65,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        // BOTÃO DE ADICIONAR FOTO
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: vinho,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: selecionarFoto,
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: selecionarFoto,
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        color: vinho,
                      ),
                      label: const Text(
                        'Adicionar foto de perfil',
                        style: TextStyle(
                          color: vinho,
                        ),
                      ),
                    ),

                    // APARECE SOMENTE SE TIVER FOTO
                    if (fotoPerfil != null)
                      TextButton(
                        onPressed: removerFoto,
                        child: const Text(
                          'Remover foto',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),

                    if (fotoPerfil == null)
                      const Text(
                        'Opcional - uma foto padrão será utilizada',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  'Cadastre-se no Local Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: vinho,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  'Crie sua conta para comprar e vender.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // NOME
              TextFormField(
                controller: nomeController,
                decoration: campoDecoration(
                  'Nome completo',
                  Icons.person_outline,
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe seu nome.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

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

              const SizedBox(height: 15),

              // DATA DE NASCIMENTO
              TextFormField(
                controller: nascimentoController,
                readOnly: true,
                onTap: selecionarData,
                decoration: campoDecoration(
                  'Data de nascimento',
                  Icons.calendar_month_outlined,
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Informe sua data de nascimento.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: campoDecoration(
                  'E-mail',
                  Icons.email_outlined,
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe seu e-mail.';
                  }

                  if (!valor.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

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
                    return 'Informe uma senha.';
                  }

                  if (valor.length < 6) {
                    return 'A senha deve possuir pelo menos 6 caracteres.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // CONFIRMAR SENHA
              TextFormField(
                controller: confirmarSenhaController,
                obscureText: ocultarConfirmacao,
                decoration: campoDecoration(
                  'Confirmar senha',
                  Icons.lock_reset,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        ocultarConfirmacao = !ocultarConfirmacao;
                      });
                    },
                    icon: Icon(
                      ocultarConfirmacao
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Confirme sua senha.';
                  }

                  if (valor != senhaController.text) {
                    return 'As senhas não são iguais.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // BOTÃO CADASTRAR
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
                  onPressed: cadastrar,
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já possui uma conta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Entrar',
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