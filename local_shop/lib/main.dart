import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color roxo = Color(0xFF7A1F2B);
  static const Color laranja = Color(0xFFFF7A00);

  final List<Map<String, dynamic>> categorias = const [
    {
      'nome': 'Celulares',
      'icone': Icons.smartphone,
    },
    {
      'nome': 'Informática',
      'icone': Icons.computer,
    },
    {
      'nome': 'Veículos',
      'icone': Icons.directions_car,
    },
    {
      'nome': 'Casa',
      'icone': Icons.chair,
    },
    {
      'nome': 'Games',
      'icone': Icons.sports_esports,
    },
  ];

  final List<Map<String, dynamic>> produtos = const [
    {
      'nome': 'Notebook usado',
      'preco': 'R\$ 1.850',
      'local': 'Santa Teresa - ES',
      'icone': Icons.laptop,
    },
    {
      'nome': 'iPhone 13',
      'preco': 'R\$ 2.900',
      'local': 'Vitória - ES',
      'icone': Icons.smartphone,
    },
    {
      'nome': 'Cadeira Gamer',
      'preco': 'R\$ 450',
      'local': 'Serra - ES',
      'icone': Icons.chair_alt,
    },
    {
      'nome': 'PlayStation 5',
      'preco': 'R\$ 3.200',
      'local': 'Vila Velha - ES',
      'icone': Icons.sports_esports,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        title: const Row(
          children: [
            Icon(
              Icons.storefront,
              color: roxo,
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Local Shop',
              style: TextStyle(
                color: roxo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Entrar');
            },
            child: const Text(
              'Entrar',
              style: TextStyle(
                color: roxo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: roxo,
              ),
              onPressed: () {
                print('Cadastrar');
              },
              child: const Text('Cadastrar'),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ÁREA PRINCIPAL
            Container(
              width: double.infinity,
              color: roxo,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vindo ao Local Shop!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Compre e venda produtos perto de você.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // BARRA DE PESQUISA
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'O que você está procurando?',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
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

            // CATEGORIAS
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFE4F5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            categoria['icone'],
                            color: roxo,
                            size: 28,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          categoria['nome'],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // CABEÇALHO DOS ANÚNCIOS
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Anúncios recentes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Ver todos',
                      style: TextStyle(
                        color: roxo,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PRODUTOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: produtos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.76,
                ),
                itemBuilder: (context, index) {
                  final produto = produtos[index];

                  return ProdutoCard(
                    nome: produto['nome'],
                    preco: produto['preco'],
                    local: produto['local'],
                    icone: produto['icone'],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // BOTÃO DE VENDER
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: laranja,
        foregroundColor: Colors.white,
        onPressed: () {
          print('Criar anúncio');
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Vender',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class ProdutoCard extends StatelessWidget {
  final String nome;
  final String preco;
  final String local;
  final IconData icone;

  const ProdutoCard({
    super.key,
    required this.nome,
    required this.preco,
    required this.local,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFE9E9E9),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      icone,
                      size: 65,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 20,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preco,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

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
                        local,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}