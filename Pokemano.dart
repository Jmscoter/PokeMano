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
    int dano = usuario.calcularAtaqueBase() + 10;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class Flamethrower extends Habilidade {
  Flamethrower() : super("Flamethrower", 15);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 12;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class WaterGun extends Habilidade {
  WaterGun() : super("Water Gun", 25);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 8;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class LeafBlade extends Habilidade {
  LeafBlade() : super("Leaf Blade", 15);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 11;
    usuario.gastarPP(custoPP);
    alvo.receberDano(dano);
  }
}

class Moonblast extends Habilidade {
  Moonblast() : super("Moonblast", 10);
  @override
  void usar(Pokemon usuario, Pokemon alvo) {
    int dano = usuario.calcularAtaqueBase() + 15;
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

  bool _visto = false;
  bool _capturado = false;
  bool _favorite = false;

  Pokemon(
    this._numero,
    this._nome,
    this._tipo,
    this._nivel,
    this._hpMaximo,
    this._pp,
    this._proximaEvolucao,
    this._nivelEvolucao,
  ) : _hpAtual = _hpMaximo {
    _nivel = _nivel.clamp(1, 100);
  }

  int get numero => _numero;
  String get nome => _nome;
  String get tipo => _tipo;
  int get nivel => _nivel;
  int get hpAtual => _hpAtual;
  int get hpMaximo => _hpMaximo;
  int get pp => _pp;
  bool get capturado => _capturado;
  bool get favorite => _favorite;
  String? get proximaEvolucao => _proximaEvolucao;
  int get nivelEvolucao => _nivelEvolucao;

  int calcularAtaqueBase() => _nivel * 2;
  void gastarPP(int qtd) => _pp -= qtd;
  void receberDano(int dano) =>
      _hpAtual = (_hpAtual - dano).clamp(0, _hpMaximo);
  void subirNivel(int qtd) => _nivel = (_nivel + qtd).clamp(1, 100);

  @override
  void marcarComoVisto() => _visto = true;
  @override
  void marcarComoCapturado() {
    _capturado = true;
    _visto = true;
  }

  @override
  void favoritar() =>
      _capturado ? _favorite = true : print("❌ Capture primeiro!");

  void evoluir() {
    if (_proximaEvolucao != null && _nivel >= _nivelEvolucao) {
      print("\n🌟 O quê? $_nome está evoluindo...");
      _nome = _proximaEvolucao!;
      _proximaEvolucao = null;
      _hpMaximo += 30;
      _hpAtual = _hpMaximo;
      print("✨ Parabéns! Evoluiu para $_nome!");
    }
  }

  void exibirFicha() {
    print(
      "[#$_numero] $_nome | Tipo: $_tipo | Lvl: $_nivel | HP: $_hpAtual/$_hpMaximo | PP: $_pp ${_favorite ? '⭐' : ''}",
    );
  }
}

class PokemonFogo extends Pokemon {
  PokemonFogo(n, nom, niv, hp, pp, ev, ne)
    : super(n, nom, "Fogo", niv, hp, pp, ev, ne);
  @override
  int calcularAtaqueBase() => nivel * 3;
}

class PokemonAgua extends Pokemon {
  PokemonAgua(n, nom, niv, hp, pp, ev, ne)
    : super(n, nom, "Água", niv, hp, pp, ev, ne);
  @override
  int calcularAtaqueBase() => (nivel * 2) + 10;
}

class PokemonEletrico extends Pokemon {
  PokemonEletrico(n, nom, niv, hp, pp, ev, ne)
    : super(n, nom, "Elétrico", niv, hp, pp, ev, ne);
  @override
  int calcularAtaqueBase() => (nivel * 2) + 15;
}

class PokemonPlanta extends Pokemon {
  PokemonPlanta(n, nom, niv, hp, pp, ev, ne)
    : super(n, nom, "Planta", niv, hp, pp, ev, ne);
  @override
  int calcularAtaqueBase() => (nivel * 2) + 5;
}

class PokemonFada extends Pokemon {
  PokemonFada(n, nom, niv, hp, pp, ev, ne)
    : super(n, nom, "Fada", niv, hp, pp, ev, ne);
  @override
  int calcularAtaqueBase() => (nivel * 2) + 12;
}

class Pokedex {
  final List<Pokemon> lista = [];

  void adicionar(Pokemon p) {
    if (!lista.any((x) => x.numero == p.numero)) lista.add(p);
  }

  void mostrarEstatisticas() {
    if (lista.isEmpty) {
      print("Pokédex vazia.");
      return;
    }
    print("\n--- 📊 ESTATÍSTICAS ---");
    print("Total: ${lista.length}");
    print(
      "Média de Nível: ${(lista.fold(0, (s, p) => s + p.nivel) / lista.length).toStringAsFixed(1)}",
    );
    print(
      "Taxa de Captura: ${((lista.where((p) => p.capturado).length / lista.length) * 100).toStringAsFixed(1)}%",
    );
    print(
      "Tipos Diferentes: ${lista.fold<Map<String, int>>({}, (m, p) {
        m[p.tipo] = (m[p.tipo] ?? 0) + 1;
        return m;
      })}",
    );
  }
}

void main() {
  var dex = Pokedex();
  var rand = Random();

  List<Pokemon> gerarBancoDeDados() => [
    PokemonPlanta(650, "Chespin", 10, 50, 40, "Quilladin", 16),
    PokemonPlanta(651, "Quilladin", 18, 80, 40, "Chesnaught", 36),
    PokemonFogo(653, "Fennekin", 10, 45, 45, "Braixen", 16),
    PokemonFogo(654, "Braixen", 18, 75, 45, "Delphox", 36),
    PokemonAgua(656, "Froakie", 10, 45, 50, "Frogadier", 16),
    PokemonAgua(657, "Frogadier", 18, 75, 50, "Greninja", 36),
    PokemonAgua(658, "Greninja", 36, 120, 60, null, 0),
    PokemonFogo(663, "Talonflame", 35, 100, 40, null, 0),
    PokemonFogo(667, "Litleo", 15, 55, 30, "Pyroar", 35),
    PokemonPlanta(672, "Skiddo", 12, 60, 30, "Gogoat", 32),
    PokemonPlanta(673, "Gogoat", 32, 110, 40, null, 0),
    PokemonFada(682, "Spritzee", 20, 70, 40, "Aromatisse", 30),
    PokemonFada(684, "Swirlix", 20, 70, 40, "Slurpuff", 30),
    PokemonAgua(691, "Dragalge", 48, 115, 40, null, 0),
    PokemonAgua(693, "Clawitzer", 37, 105, 40, null, 0),
    PokemonEletrico(695, "Heliolisk", 30, 85, 50, null, 0),
    PokemonFada(700, "Sylveon", 32, 115, 50, null, 0),
    Pokemon(704, "Goomy", "Dragão", 20, 50, 30, "Sliggoo", 40),
    Pokemon(705, "Sliggoo", "Dragão", 40, 90, 40, "Goodra", 50),
    Pokemon(714, "Noibat", "Voador", 25, 60, 40, "Noivern", 48),
  ];

  print("\n==========================================");
  print("🏰 BEM-VINDO AO MUNDO DE KALOS");
  print("==========================================");

  while (true) {
    print("\n--- MENU PRINCIPAL ---");
    print("1. 🌿 Explorar Mato Alto");
    print("2. 📖 Pokédex");
    print("3. ⚔️ Batalha de Treinador");
    print("4. 📊 Estatísticas");
    print("5. 🌟 Evoluir Pokémon");
    print("0. 🚪 Sair do Jogo");
    stdout.write("Comando: ");

    var op = stdin.readLineSync();
    if (op == '0') break;

    switch (op) {
      case '1':
        var banco = gerarBancoDeDados();
        var selvagem = banco[rand.nextInt(banco.length)];
        print("\n🔍 Procurando...");
        print(
          "❗ Um ${selvagem.nome} selvagem apareceu! (Lvl: ${selvagem.nivel})",
        );
        stdout.write("Capturar? (s/n): ");
        if (stdin.readLineSync()?.toLowerCase() == 's') {
          if (rand.nextInt(10) > 2) {
            selvagem.marcarComoCapturado();
            dex.adicionar(selvagem);
            print("🎯 ✅ ${selvagem.nome} foi capturado!");
            stdout.write("Favoritar? (s/n): ");
            if (stdin.readLineSync()?.toLowerCase() == 's')
              selvagem.favoritar();
          } else {
            print("💨 O Pokémon fugiu!");
          }
        }
        break;

      case '2':
        if (dex.lista.isEmpty) {
          print("Sua Pokédex está vazia.");
          break;
        }
        print("\n--- 📖 CONSULTA POKÉDEX ---");
        print(
          "1. Listar Tudo | 2. Favoritos | 3. Por Nível (Desc) | 4. Por Nome (A-Z)",
        );
        var subOp = stdin.readLineSync();
        var temp = List<Pokemon>.from(dex.lista);

        if (subOp == '3') temp.sort((a, b) => b.nivel.compareTo(a.nivel));
        if (subOp == '4') temp.sort((a, b) => a.nome.compareTo(b.nome));
        if (subOp == '2') temp = temp.where((p) => p.favorite).toList();

        temp.forEach((p) => p.exibirFicha());
        break;

      case '3':
        if (dex.lista.isEmpty) {
          print("Você não tem Pokémon para batalhar!");
          break;
        }
        var meu = dex.lista[rand.nextInt(dex.lista.length)];
        var inimigo = gerarBancoDeDados()[rand.nextInt(20)];
        print("\n⚔️ BATALHA: ${meu.nome} VS ${inimigo.nome}");

        Habilidade hab;
        if (meu.tipo == "Fogo")
          hab = Flamethrower();
        else if (meu.tipo == "Água")
          hab = WaterGun();
        else if (meu.tipo == "Elétrico")
          hab = Thunderbolt();
        else if (meu.tipo == "Planta")
          hab = LeafBlade();
        else
          hab = Moonblast();

        hab.usar(meu, inimigo);
        print(
          "💥 Resultado: ${inimigo.nome} restou com ${inimigo.hpAtual} HP.",
        );
        break;

      case '4':
        dex.mostrarEstatisticas();
        break;

      case '5':
        if (dex.lista.isEmpty) {
          print("Ninguém para evoluir.");
          break;
        }
        for (var p in dex.lista) {
          if (p.proximaEvolucao != null) {
            print(
              "\nPokémon: ${p.nome} | Lvl Atual: ${p.nivel} | Necessário: ${p.nivelEvolucao}",
            );
            stdout.write("Treinar para evoluir agora? (s/n): ");
            if (stdin.readLineSync()?.toLowerCase() == 's') {
              p.subirNivel(20);
              p.evoluir();
            }
          }
        }
        break;

      default:
        print("Escolha 0-5.");
    }
  }
  print("👋 Até a próxima, Treinador!");
}
