import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerfilPage extends StatelessWidget {
  static const Color vinho = Color(0xFF7A1F2B);
  static const Color vinhoClaro = Color(0xFFF3E6E8);

  final void Function(Map<String, dynamic>) onNovaOferta;
  final void Function(Map<String, dynamic>) onNovaProcura;

  final List<Map<String, String>> historicoCompras;
  final bool carregandoHistorico;
  final bool erroAoCarregarHistorico;
  final VoidCallback onRecarregarHistorico;

  const PerfilPage({
    super.key,
    required this.onNovaOferta,
    required this.onNovaProcura,
    required this.historicoCompras,
    required this.carregandoHistorico,
    required this.erroAoCarregarHistorico,
    required this.onRecarregarHistorico,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // =====================================================
          // INFORMAÇÕES DO PERFIL
          // =====================================================

          Card(
            color: Colors.white,
            elevation: 1,
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

          // =====================================================
          // ÁREA DE PUBLICAÇÃO
          // =====================================================

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

          // =====================================================
          // HISTÓRICO DE COMPRAS
          // =====================================================

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

          if (carregandoHistorico)
            const Padding(
              padding: EdgeInsets.all(25),
              child: CircularProgressIndicator(
                color: vinho,
              ),
            )
          else if (erroAoCarregarHistorico)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 45,
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Não foi possível carregar o histórico de compras.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 5),

                  TextButton.icon(
                    onPressed: onRecarregarHistorico,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      'Tentar novamente',
                    ),
                  ),
                ],
              ),
            )
          else if (historicoCompras.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 55,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Você ainda não realizou nenhuma compra.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ...historicoCompras.map(
              (compra) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: vinhoClaro,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: vinho,
                      ),
                    ),
                    title: Text(
                      compra['produto'] ?? 'Produto',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${compra['data'] ?? ''} • '
                      '${compra['status'] ?? ''}',
                    ),
                    trailing: Text(
                      compra['preco'] ?? '',
                      style: const TextStyle(
                        color: vinho,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTÃO DE PUBLICAÇÃO
  // ==========================================================

  Widget botaoPublicacao({
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
            color: const Color(0x337A1F2B),
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
  // ABRIR CADASTRO DE OFERTA
  // ==========================================================

  Future<void> abrirNovaOferta(BuildContext context) async {
    /*
      O BottomSheet retorna a oferta pronta.

      Importante:
      não alteramos a lista do main.dart enquanto
      o BottomSheet ainda está aberto.
    */

    final novaOferta =
        await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _NovaOfertaSheet();
      },
    );

    // Usuário fechou/cancelou.
    if (novaOferta == null) {
      return;
    }

    // Confere se a página ainda existe.
    if (!context.mounted) {
      return;
    }

    /*
      Somente AGORA chamamos o callback do main.dart.

      Nesse momento o BottomSheet já terminou de retornar
      os dados e não estamos usando o context dele.
    */
    onNovaOferta(novaOferta);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Oferta publicada com sucesso!',
          ),
        ),
      );
  }

  // ==========================================================
  // ABRIR CADASTRO DE PROCURA
  // ==========================================================

  Future<void> abrirNovaProcura(BuildContext context) async {
    final novaProcura =
        await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _NovaProcuraSheet();
      },
    );

    if (novaProcura == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    onNovaProcura(novaProcura);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Procura publicada com sucesso!',
          ),
        ),
      );
  }
}

// ============================================================
// FORMULÁRIO DE NOVA OFERTA
// ============================================================

class _NovaOfertaSheet extends StatefulWidget {
  const _NovaOfertaSheet();

  @override
  State<_NovaOfertaSheet> createState() =>
      _NovaOfertaSheetState();
}

class _NovaOfertaSheetState
    extends State<_NovaOfertaSheet> {
  static const Color vinho = Color(0xFF7A1F2B);

  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  final localController = TextEditingController();
  final descricaoController = TextEditingController();

  @override
  void dispose() {
    /*
      Agora os controllers pertencem ao próprio BottomSheet.

      Eles só serão destruídos quando o formulário realmente
      sair da tela, evitando problemas durante a animação
      de fechamento.
    */
    nomeController.dispose();
    precoController.dispose();
    localController.dispose();
    descricaoController.dispose();

    super.dispose();
  }

  double? converterValor(String texto) {
    String valor = texto.trim();

    if (valor.isEmpty) {
      return null;
    }

    /*
      Exemplos aceitos:

      1500
      1500,50
      1500.50
    */
    valor = valor.replaceAll(',', '.');

    return double.tryParse(valor);
  }

  void publicar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final preco = converterValor(
      precoController.text,
    );

    if (preco == null) {
      return;
    }

    final novaOferta = <String, dynamic>{
      'nome': nomeController.text.trim(),
      'preco': preco,
      'local': localController.text.trim(),
      'vendedor': 'Você',
      'descricao': descricaoController.text.trim(),

      // O main.dart atualmente utiliza IconData.
      'icone': Icons.shopping_bag,
    };

    /*
      Fecha o BottomSheet e devolve os dados.

      NÃO chamamos setState do main.dart aqui.
    */
    Navigator.of(context).pop(
      novaOferta,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,

          // Faz o formulário subir quando o teclado abre.
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              25,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra visual
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 25),

              // NOME
              TextFormField(
                controller: nomeController,
                textInputAction:
                    TextInputAction.next,
                decoration: decoracaoCampo(
                  'Nome do produto',
                  Icons.shopping_bag_outlined,
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe o nome do produto.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // PREÇO
              TextFormField(
                controller: precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction:
                    TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9,.]'),
                  ),
                ],
                decoration: decoracaoCampo(
                  'Preço',
                  Icons.attach_money,
                ).copyWith(
                  prefixText: 'R\$ ',
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe o preço.';
                  }

                  final preco =
                      converterValor(valor);

                  if (preco == null) {
                    return 'Informe um preço válido.';
                  }

                  if (preco <= 0) {
                    return 'O preço deve ser maior que zero.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // LOCALIZAÇÃO
              TextFormField(
                controller: localController,
                textInputAction:
                    TextInputAction.next,
                decoration: decoracaoCampo(
                  'Localização',
                  Icons.location_on_outlined,
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe a localização.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // DESCRIÇÃO
              TextFormField(
                controller: descricaoController,
                maxLines: 4,
                textInputAction:
                    TextInputAction.newline,
                decoration: decoracaoCampo(
                  'Descrição do produto',
                  Icons.description_outlined,
                ),
              ),

              const SizedBox(height: 25),

              // PUBLICAR
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: vinho,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: publicar,
                  icon: const Icon(
                    Icons.publish,
                  ),
                  label: const Text(
                    'Publicar oferta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // CANCELAR
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        borderRadius:
            BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: vinho,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}

// ============================================================
// FORMULÁRIO DE NOVA PROCURA
// ============================================================

class _NovaProcuraSheet extends StatefulWidget {
  const _NovaProcuraSheet();

  @override
  State<_NovaProcuraSheet> createState() =>
      _NovaProcuraSheetState();
}

class _NovaProcuraSheetState
    extends State<_NovaProcuraSheet> {
  static const Color vinho = Color(0xFF7A1F2B);

  final _formKey = GlobalKey<FormState>();

  final produtoController =
      TextEditingController();

  final valorController =
      TextEditingController();

  final localController =
      TextEditingController();

  final descricaoController =
      TextEditingController();

  @override
  void dispose() {
    produtoController.dispose();
    valorController.dispose();
    localController.dispose();
    descricaoController.dispose();

    super.dispose();
  }

  double? converterValor(String texto) {
    String valor = texto.trim();

    if (valor.isEmpty) {
      return null;
    }

    valor = valor.replaceAll(',', '.');

    return double.tryParse(valor);
  }

  String formatarDinheiro(double valor) {
    return valor
        .toStringAsFixed(2)
        .replaceAll('.', ',');
  }

  void publicar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final valor = converterValor(
      valorController.text,
    );

    if (valor == null) {
      return;
    }

    final novaProcura =
        <String, dynamic>{
      'produto':
          produtoController.text.trim(),
      'usuario': 'Você',
      'descricao':
          descricaoController.text.trim(),
      'valor':
          'Até R\$ ${formatarDinheiro(valor)}',
      'local':
          localController.text.trim(),
      'icone': Icons.search,
    };

    /*
      Fecha primeiro e retorna o objeto.
      O PerfilPage atualiza o main.dart depois.
    */
    Navigator.of(context).pop(
      novaProcura,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              25,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 25),

              // PRODUTO
              TextFormField(
                controller:
                    produtoController,
                textInputAction:
                    TextInputAction.next,
                decoration: decoracaoCampo(
                  'Produto procurado',
                  Icons.search,
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe o produto que está procurando.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // VALOR MÁXIMO
              TextFormField(
                controller: valorController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction:
                    TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9,.]'),
                  ),
                ],
                decoration: decoracaoCampo(
                  'Valor máximo',
                  Icons.attach_money,
                ).copyWith(
                  prefixText: 'R\$ ',
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe o valor máximo.';
                  }

                  final numero =
                      converterValor(valor);

                  if (numero == null) {
                    return 'Informe um valor válido.';
                  }

                  if (numero <= 0) {
                    return 'O valor deve ser maior que zero.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // LOCALIZAÇÃO
              TextFormField(
                controller:
                    localController,
                textInputAction:
                    TextInputAction.next,
                decoration: decoracaoCampo(
                  'Localização',
                  Icons.location_on_outlined,
                ),
                validator: (valor) {
                  if (valor == null ||
                      valor.trim().isEmpty) {
                    return 'Informe a localização.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // DESCRIÇÃO
              TextFormField(
                controller:
                    descricaoController,
                maxLines: 4,
                textInputAction:
                    TextInputAction.newline,
                decoration: decoracaoCampo(
                  'Descrição',
                  Icons.description_outlined,
                ),
              ),

              const SizedBox(height: 25),

              // PUBLICAR
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: vinho,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: publicar,
                  icon: const Icon(
                    Icons.publish,
                  ),
                  label: const Text(
                    'Publicar procura',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        borderRadius:
            BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: vinho,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}

// ============================================================
// COMPONENTE DE INFORMAÇÕES DO PERFIL
// ============================================================

class InformacaoPerfil
    extends StatelessWidget {
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
      padding:
          const EdgeInsets.symmetric(
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  valor,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w500,
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