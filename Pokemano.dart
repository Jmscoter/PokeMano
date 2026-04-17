import 'dart:io';
import 'dart:math';

abstract class RegistravelNaPokedex {
  void marcarComoVisto();
  void marcarComoCapturado();
  void favoritar();
}

abstract class Habilidade {
  final String nome;
  final int custoPP;
  Habilidade(this.nome, this.custoPP);
  void usar(Pokemon usuario, Pokemon alvo);
}

class Thunderbolt extends Habilidade {
  Thunderbolt() : super("Thunderbolt", 15);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 5;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class Flamethrower extends Habilidade {
  Flamethrower() : super("Flamethrower", 15);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 7;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class WaterGun extends Habilidade {
  WaterGun() : super("Water Gun", 25);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 3;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class Pokemon implements RegistravelNaPokedex {
  final int _numero;
  String _nome;
  final String _tipo;
  int _nivel;
  int _hpAtual;
  int _hpMaximo;
  int _pp;
  String? _proximaEvolucao;
  int _nivelEvolucao;
  
  // ignore: unused_field
  bool _visto = false;
  bool _capturado = false;
  bool _favorito = false;

  Pokemon(this._numero, this._nome, this._tipo, this._nivel, this._hpMaximo, this._pp, this._proximaEvolucao, this._nivelEvolucao)
      : _hpAtual = _hpMaximo {
    _nivel = _nivel.clamp(1, 100);
  }

  // Getters
  int get numero => _numero;
  String get nome => _nome;
  String get tipo => _tipo;
  int get nivel => _nivel;
  int get hpAtual => _hpAtual;
  int get hpMaximo => _hpMaximo;
  int get pp => _pp;
  bool get capturado => _capturado;
  bool get favorito => _favorito;

  int calcularAtaqueBase() => _nivel * 2;
  void gastarPP(int qtd) => _pp -= qtd;
  void receberDano(int dano) => _hpAtual = (_hpAtual - dano).clamp(0, _hpMaximo);

  @override void marcarComoVisto() => _visto = true;
  @override void marcarComoCapturado() { _capturado = true; _visto = true; }
  @override void favoritar() => _capturado ? _favorito = true : print("❌ Erro: capture primeiro!");

  void evoluir() {
    if (_proximaEvolucao != null && _nivel >= _nivelEvolucao) {
      print("\n🌟 O quê? $_nome está evoluindo...");
      _nome = _proximaEvolucao!;
      _proximaEvolucao = null;
      _hpMaximo += 20; _hpAtual = _hpMaximo;
      print("✨ Evoluiu para $_nome!");
    }
  }

  void exibirFicha() {
    print("[#$_numero] $_nome | Tipo: $_tipo | Lvl: $_nivel | HP: $_hpAtual/$_hpMaximo | PP: $_pp ${_favorito ? '⭐' : ''}");
  }
  
  void subirNivel(int i) {}
}

class PokemonFogo extends Pokemon {
  PokemonFogo(int n, String nom, int niv, int hp, int pp, String? ev, int ne) : super(n, nom, "Fogo", niv, hp, pp, ev, ne);
  @override int calcularAtaqueBase() => nivel * 3;
}

class PokemonAgua extends Pokemon {
  PokemonAgua(int n, String nom, int niv, int hp, int pp, String? ev, int ne) : super(n, nom, "Água", niv, hp, pp, ev, ne);
  @override int calcularAtaqueBase() => (nivel * 2) + 10;
}


class Pokedex {
  final List<Pokemon> lista = [];

  void adicionar(Pokemon p) {
    if (!lista.any((x) => x.numero == p.numero)) lista.add(p);
  }

  void mostrarEstatisticas() {
    if (lista.isEmpty) { print("Pokédex vazia."); return; }
    print("\n--- 📊 ESTATÍSTICAS ---");
    print("Total: ${lista.length}");
    print("Média de Nível: ${(lista.fold(0, (s, p) => s + p.nivel) / lista.length).toStringAsFixed(1)}");
    print("Taxa de Captura: ${((lista.where((p) => p.capturado).length / lista.length) * 100).toStringAsFixed(1)}%");
    print("Por Tipo: ${lista.fold<Map<String, int>>({}, (m, p) { m[p.tipo] = (m[p.tipo] ?? 0) + 1; return m; })}");
  }
}


// 5. O MENU PRINCIPAL (SIMULADOR APP)
// ============================================================
void main() {
  var dex = Pokedex();
  var rand = Random();

  // Gerador de selvagens (6ª Geração)
  List<Pokemon> gerarSelvagens() => [
    PokemonAgua(658, "Greninja", 36, 120, 50, null, 0),
    PokemonFogo(653, "Fennekin", 15, 40, 30, "Braixen", 16),
    Pokemon(700, "Sylveon", "Fada", 32, 110, 40, null, 0),
    PokemonFogo(663, "Talonflame", 35, 90, 40, null, 0),
    PokemonAgua(656, "Froakie", 10, 35, 50, "Frogadier", 16),
  ];

  print("🏰 BEM-VINDO AO SIMULADOR KALOS 2026");

  while (true) {
    print("\n========= MENU PRINCIPAL =========");
    print("1. 🌿 Explorar Mato Alto (Encontrar)");
    print("2. 📖 Ver Minha Pokédex (Filtros)");
    print("3. ⚔️ Batalha de Treinador");
    print("4. 📊 Dashboard de Estatísticas");
    print("5. 🌟 Evoluir meus Pokémon");
    print("0. 🚪 Sair do App");
    stdout.write("Escolha uma opção: ");
    
    var op = stdin.readLineSync();

    if (op == '0') break;

    switch (op) {
      case '1': // Captura
        var selvagem = gerarSelvagens()[rand.nextInt(5)];
        print("\n🌿 Um ${selvagem.nome} selvagem apareceu!");
        stdout.write("Capturar? (s/n): ");
        if (stdin.readLineSync() == 's') {
          selvagem.marcarComoCapturado();
          dex.adicionar(selvagem);
          print("✅ Capturado! Deseja favoritar? (s/n): ");
          if (stdin.readLineSync() == 's') selvagem.favoritar();
        }
        break;

      case '2': // Filtros
        print("\n--- 📖 FILTROS DA POKÉDEX ---");
        print("A. Listar Todos | B. Somente Favoritos | C. HP Baixo (<30)");
        var f = stdin.readLineSync()?.toUpperCase();
        if (f == 'A') dex.lista.forEach((p) => p.exibirFicha());
        if (f == 'B') dex.lista.where((p) => p.favorito).forEach((p) => p.exibirFicha());
        if (f == 'C') dex.lista.where((p) => p.hpAtual < 30).forEach((p) => p.exibirFicha());
        break;

      case '3': // Batalha Polimórfica
        if (dex.lista.isEmpty) { print("❌ Capture um Pokémon primeiro!"); break; }
        var meu = dex.lista[0];
        var inimigo = gerarSelvagens()[rand.nextInt(5)];
        print("\n⚔️ BATALHA: ${meu.nome} vs ${inimigo.nome}");
        // Usando polimorfismo de habilidade
        WaterGun().usar(meu, inimigo);
        Flamethrower().usar(inimigo, meu);
        print("Status Final: ${meu.nome}(HP ${meu.hpAtual}) | ${inimigo.nome}(HP ${inimigo.hpAtual})");
        break;

      case '4':
        dex.mostrarEstatisticas();
        break;

      case '5':
        dex.lista.forEach((p) {
          if (p._proximaEvolucao != null) {
            stdout.write("Subir nível de ${p.nome} para evoluir? (s/n): ");
            if (stdin.readLineSync() == 's') {
              p.subirNivel(10);
              p.evoluir();
            }
          }
        });
        break;

      default:
        print("Opção inválida.");
    }
  }
}