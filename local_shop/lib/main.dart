import 'package:flutter/material.dart';

import 'login_page.dart';

void main() {
  runApp(const LocalShopApp());
}

class LocalShopApp extends StatelessWidget {
  const LocalShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Shop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A1F2B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color vinho = Color(0xFF7A1F2B);
  static const Color vinhoClaro = Color(0xFFF3E6E8);

  int paginaAtual = 0;

  String pesquisaOferta = '';
  String pesquisaProcura = '';

  final List<Map<String, dynamic>> carrinho = [];

  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Notebook Lenovo',
      'preco': 1850.0,
      'local': 'Santa Teresa - ES',
      'vendedor': 'Carlos',
      'icone': Icons.laptop,
    },
    {
      'nome': 'iPhone 13',
      'preco': 2900.0,
      'local': 'Vitória - ES',
      'vendedor': 'Mariana',
      'icone': Icons.smartphone,
    },
    {
      'nome': 'Cadeira Gamer',
      'preco': 450.0,
      'local': 'Serra - ES',
      'vendedor': 'Pedro',
      'icone': Icons.chair_alt,
    },
    {
      'nome': 'PlayStation 5',
      'preco': 3200.0,
      'local': 'Vila Velha - ES',
      'vendedor': 'João',
      'icone': Icons.sports_esports,
    },
  ];

  final List<Map<String, dynamic>> procuras = [
    {
      'produto': 'Placa de vídeo RTX 3060',
      'usuario': 'Lucas',
      'descricao': 'Procuro uma RTX 3060 usada em bom estado.',
      'valor': 'Até R\$ 1.500',
      'local': 'Vitória - ES',
      'icone': Icons.memory,
    },
    {
      'produto': 'Nintendo Switch',
      'usuario': 'Ana',
      'descricao': 'Pode ser modelo V2 ou OLED.',
      'valor': 'Até R\$ 1.800',
      'local': 'Serra - ES',
      'icone': Icons.sports_esports,
    },
    {
      'produto': 'Monitor 24 polegadas',
      'usuario': 'Mateus',
      'descricao': 'Procuro monitor Full HD, de preferência 75 Hz ou mais.',
      'valor': 'Até R\$ 600',
      'local': 'Santa Teresa - ES',
      'icone': Icons.monitor,
    },
    {
      'produto': 'Notebook para estudos',
      'usuario': 'Fernanda',
      'descricao': 'Procuro notebook simples para faculdade.',
      'valor': 'Até R\$ 2.000',
      'local': 'Colatina - ES',
      'icone': Icons.laptop,
    },
  ];

  void adicionarCarrinho(Map<String, dynamic> produto) {
    setState(() {
      carrinho.add(produto);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${produto['nome']} adicionado ao carrinho!',
        ),
        action: SnackBarAction(
          label: 'Ver carrinho',
          onPressed: () {
            setState(() {
              paginaAtual = 2;
            });
          },
        ),
      ),
    );
  }

  void removerCarrinho(int index) {
    setState(() {
      carrinho.removeAt(index);
    });
  }

  Future<void> fazerOferta(Map<String, dynamic> procura) async {
    final precoController = TextEditingController();
    final mensagemController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Oferta para ${procura['produto']}',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${procura['usuario']} está procurando este produto.',
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: precoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valor da sua oferta',
                    prefixText: 'R\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: mensagemController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Mensagem',
                    hintText: 'Ex: Tenho esse produto em ótimo estado.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: vinho,
              ),
              onPressed: () {
                if (precoController.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Oferta enviada para ${procura['usuario']}!',
                    ),
                  ),
                );
              },
              child: const Text('Enviar oferta'),
            ),
          ],
        );
      },
    );

    precoController.dispose();
    mensagemController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      paginaOfertas(),
      paginaProcura(),
      paginaCarrinho(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        title: const Row(
          children: [
            Icon(
              Icons.storefront,
              color: vinho,
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Local Shop',
              style: TextStyle(
                color: vinho,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Carrinho',
            onPressed: () {
              setState(() {
                paginaAtual = 2;
              });
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  color: vinho,
                ),

                if (carrinho.isNotEmpty)
                  Positioned(
                    right: -7,
                    top: -7,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: vinho,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        carrinho.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Entrar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.person_outline,
              color: vinho,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: IndexedStack(
        index: paginaAtual,
        children: paginas,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        indicatorColor: vinhoClaro,
        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(
              Icons.sell,
              color: vinho,
            ),
            label: 'Ofertas',
          ),

          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(
              Icons.search,
              color: vinho,
            ),
            label: 'Procura',
          ),

          NavigationDestination(
            icon: Badge(
              isLabelVisible: carrinho.isNotEmpty,
              label: Text(
                carrinho.length.toString(),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
            selectedIcon: Badge(
              isLabelVisible: carrinho.isNotEmpty,
              label: Text(
                carrinho.length.toString(),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: vinho,
              ),
            ),
            label: 'Carrinho',
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PÁGINA DE OFERTAS
  // ==========================================================

  Widget paginaOfertas() {
    final produtosFiltrados = produtos.where((produto) {
      return produto['nome']
          .toString()
          .toLowerCase()
          .contains(pesquisaOferta.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: vinho,
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ofertas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Encontre produtos que outros usuários estão vendendo.',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                onChanged: (valor) {
                  setState(() {
                    pesquisaOferta = valor;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar produto...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: produtosFiltrados.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto encontrado.',
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final colunas =
                        constraints.maxWidth >= 700 ? 3 : 2;

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: produtosFiltrados.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: colunas,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 310,
                      ),
                      itemBuilder: (context, index) {
                        return cardProduto(
                          produtosFiltrados[index],
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget cardProduto(Map<String, dynamic> produto) {
    final preco = produto['preco'] as double;

    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 125,
            width: double.infinity,
            color: const Color(0xFFE9E9E9),
            child: Icon(
              produto['icone'],
              size: 65,
              color: Colors.grey,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto['nome'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: vinho,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Vendedor: ${produto['vendedor']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          produto['local'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vinho,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        adicionarCarrinho(produto);
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                      ),
                      label: const Text(
                        'Adicionar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PÁGINA DE PROCURA
  // ==========================================================

  Widget paginaProcura() {
    final procurasFiltradas = procuras.where((procura) {
      return procura['produto']
          .toString()
          .toLowerCase()
          .contains(pesquisaProcura.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: vinho,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Procura',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Veja o que outros usuários estão procurando e faça uma oferta.',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                onChanged: (valor) {
                  setState(() {
                    pesquisaProcura = valor;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar pedidos...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: procurasFiltradas.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum pedido encontrado.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: procurasFiltradas.length,
                  itemBuilder: (context, index) {
                    return cardProcura(
                      procurasFiltradas[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget cardProcura(Map<String, dynamic> procura) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: vinhoClaro,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                procura['icone'],
                size: 38,
                color: vinho,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procura['produto'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Procurado por ${procura['usuario']}',
                    style: const TextStyle(
                      color: vinho,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    procura['descricao'],
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    procura['valor'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        procura['local'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: vinho,
                        side: const BorderSide(
                          color: vinho,
                        ),
                      ),
                      onPressed: () {
                        fazerOferta(procura);
                      },
                      icon: const Icon(
                        Icons.local_offer_outlined,
                      ),
                      label: const Text(
                        'Fazer oferta',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CARRINHO
  // ==========================================================

  Widget paginaCarrinho() {
    final total = carrinho.fold<double>(
      0,
      (soma, produto) {
        return soma + (produto['preco'] as double);
      },
    );

    if (carrinho.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Text(
              'Seu carrinho está vazio.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Adicione produtos na página de ofertas.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: vinho,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'Meu carrinho',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: carrinho.length,
            itemBuilder: (context, index) {
              final produto = carrinho[index];
              final preco = produto['preco'] as double;

              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: vinhoClaro,
                    child: Icon(
                      produto['icone'],
                      color: vinho,
                    ),
                  ),
                  title: Text(
                    produto['nome'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      removerCarrinho(index);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      color: vinho,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vinho,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Finalização da compra ainda será implementada.',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Continuar compra',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}