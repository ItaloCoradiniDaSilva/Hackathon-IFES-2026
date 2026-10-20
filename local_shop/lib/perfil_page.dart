import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerfilPage extends StatelessWidget {
  static const Color vinho = Color(0xFF7A1F2B);
  static const Color vinhoClaro = Color(0xFFF3E6E8);

  final void Function(Map<String, dynamic>) onNovaOferta;
  final void Function(Map<String, dynamic>) onNovaProcura;

  const PerfilPage({
    super.key,
    required this.onNovaOferta,
    required this.onNovaProcura,
  });

  final List<Map<String, String>> historicoCompras = const [
    {
      'produto': 'Mouse Logitech',
      'preco': 'R\$ 120,00',
      'data': '10/10/2026',
      'status': 'Concluída',
    },
    {
      'produto': 'Teclado Mecânico',
      'preco': 'R\$ 250,00',
      'data': '02/10/2026',
      'status': 'Concluída',
    },
    {
      'produto': 'Headset Gamer',
      'preco': 'R\$ 180,00',
      'data': '25/09/2026',
      'status': 'Concluída',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // PERFIL
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: vinhoClaro,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: vinho,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Usuário Local Shop',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'usuario@email.com',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 10),

                  const InformacaoPerfil(
                    icone: Icons.badge_outlined,
                    titulo: 'CPF',
                    valor: '123.456.789-00',
                  ),

                  const InformacaoPerfil(
                    icone: Icons.calendar_month_outlined,
                    titulo: 'Data de nascimento',
                    valor: '15/05/2000',
                  ),

                  const InformacaoPerfil(
                    icone: Icons.email_outlined,
                    titulo: 'E-mail',
                    valor: 'usuario@email.com',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ÁREA DE PUBLICAÇÃO
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Publicar',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: botaoPublicacao(
                  context: context,
                  icone: Icons.sell_outlined,
                  titulo: 'Nova oferta',
                  descricao: 'Venda um produto',
                  onPressed: () {
                    abrirNovaOferta(context);
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: botaoPublicacao(
                  context: context,
                  icone: Icons.search,
                  titulo: 'Nova procura',
                  descricao: 'Procure um produto',
                  onPressed: () {
                    abrirNovaProcura(context);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // HISTÓRICO
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Histórico de compras',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          ...historicoCompras.map(
            (compra) => Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: vinhoClaro,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: vinho,
                  ),
                ),
                title: Text(
                  compra['produto']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${compra['data']} • ${compra['status']}',
                ),
                trailing: Text(
                  compra['preco']!,
                  style: const TextStyle(
                    color: vinho,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTÃO PUBLICAÇÃO
  // ==========================================================

  Widget botaoPublicacao({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: vinhoClaro,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: vinho.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icone,
              color: vinho,
              size: 35,
            ),

            const SizedBox(height: 8),

            Text(
              titulo,
              style: const TextStyle(
                color: vinho,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // NOVA OFERTA
  // ==========================================================

  Future<void> abrirNovaOferta(BuildContext context) async {
    final nomeController = TextEditingController();
    final precoController = TextEditingController();
    final localController = TextEditingController();
    final descricaoController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cadastrar nova oferta',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: vinho,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Informe os dados do produto que deseja vender.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                campo(
                  controller: nomeController,
                  texto: 'Nome do produto',
                  icone: Icons.shopping_bag_outlined,
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: precoController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9,.]'),
                    ),
                  ],
                  decoration: decoracaoCampo(
                    'Preço',
                    Icons.attach_money,
                  ),
                ),

                const SizedBox(height: 15),

                campo(
                  controller: localController,
                  texto: 'Localização',
                  icone: Icons.location_on_outlined,
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descricaoController,
                  maxLines: 3,
                  decoration: decoracaoCampo(
                    'Descrição do produto',
                    Icons.description_outlined,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vinho,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final preco = double.tryParse(
                        precoController.text.replaceAll(',', '.'),
                      );

                      if (nomeController.text.trim().isEmpty ||
                          localController.text.trim().isEmpty ||
                          preco == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha os campos corretamente.',
                            ),
                          ),
                        );

                        return;
                      }

                      onNovaOferta({
                        'nome': nomeController.text.trim(),
                        'preco': preco,
                        'local': localController.text.trim(),
                        'vendedor': 'Você',
                        'descricao': descricaoController.text.trim(),
                        'icone': Icons.shopping_bag,
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Oferta publicada com sucesso!',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Publicar oferta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    nomeController.dispose();
    precoController.dispose();
    localController.dispose();
    descricaoController.dispose();
  }

  // ==========================================================
  // NOVA PROCURA
  // ==========================================================

  Future<void> abrirNovaProcura(BuildContext context) async {
    final produtoController = TextEditingController();
    final valorController = TextEditingController();
    final localController = TextEditingController();
    final descricaoController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cadastrar nova procura',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: vinho,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Informe qual produto você está procurando.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                campo(
                  controller: produtoController,
                  texto: 'Produto procurado',
                  icone: Icons.search,
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9,.]'),
                    ),
                  ],
                  decoration: decoracaoCampo(
                    'Valor máximo',
                    Icons.attach_money,
                  ),
                ),

                const SizedBox(height: 15),

                campo(
                  controller: localController,
                  texto: 'Localização',
                  icone: Icons.location_on_outlined,
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descricaoController,
                  maxLines: 3,
                  decoration: decoracaoCampo(
                    'Descrição',
                    Icons.description_outlined,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vinho,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final valor = double.tryParse(
                        valorController.text.replaceAll(',', '.'),
                      );

                      if (produtoController.text.trim().isEmpty ||
                          localController.text.trim().isEmpty ||
                          valor == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha os campos corretamente.',
                            ),
                          ),
                        );

                        return;
                      }

                      onNovaProcura({
                        'produto': produtoController.text.trim(),
                        'usuario': 'Você',
                        'descricao': descricaoController.text.trim(),
                        'valor':
                            'Até R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}',
                        'local': localController.text.trim(),
                        'icone': Icons.search,
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Procura publicada com sucesso!',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Publicar procura',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    produtoController.dispose();
    valorController.dispose();
    localController.dispose();
    descricaoController.dispose();
  }

  Widget campo({
    required TextEditingController controller,
    required String texto,
    required IconData icone,
  }) {
    return TextField(
      controller: controller,
      decoration: decoracaoCampo(
        texto,
        icone,
      ),
    );
  }

  InputDecoration decoracaoCampo(
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

class InformacaoPerfil extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const InformacaoPerfil({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),

          Icon(
            icone,
            color: PerfilPage.vinho,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}