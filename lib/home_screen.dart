import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'boletim_form_screen.dart';
import 'study_screen.dart';
import 'auth_screen.dart';
import 'student_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  HomeScreen({required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  void _openUserSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Abrir configurações do usuário (Futuro)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EduApp', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            color: Colors.blue[700],
            onSelected: (String choice) {
              if (choice == "Configurações") {
                _openUserSettings();
              } else if (choice == "Sair") {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Configurações",
                  child: Text(
                    "Configurações do Usuário",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem<String>(
                  value: "Sair",
                  child: Text("Sair", style: TextStyle(color: Colors.white)),
                ),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue[700],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue[700]),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              _buildMenuItem(
                Icons.library_books,
                "Biblioteca",
                LibraryScreen(),
              ),
              _buildMenuItem(
                Icons.assignment,
                "Notas e Frequência",
                BoletimFormScreen(),
              ),
              _buildMenuItem(Icons.book, "O que vamos estudar?", StudyScreen()),
              Divider(color: Colors.white),
              _buildMenuItem(Icons.settings, "Configurações", null),
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20), // Espaçamento maior entre cabeçalho e imagem
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset('assets/education.png', fit: BoxFit.contain),
            ),
            SizedBox(height: 10),
            Text(
              "Bem-vindo ao EduApp!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 0),
            Center(
              child: Text(
                "O melhor jeito de organizar seus estudos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Botões Estilizados
            Wrap(
              spacing: 15, // Espaçamento horizontal
              runSpacing: 15, // Espaçamento vertical
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureButton(
                  Icons.library_books,
                  "Biblioteca",
                  LibraryScreen(),
                ),
                _buildFeatureButton(
                  Icons.assignment,
                  "Notas e Frequência",
                  BoletimFormScreen(),
                ),
                _buildFeatureButton(Icons.book, "Estudos", StudyScreen()),
                _buildMenuItem(
                  Icons.person_add,
                  "Cadastro de Aluno",
                  StudentFormScreen(),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Rodapé
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Desenvolvido por Fágner Berto Cirio e Diego Amaral 2025",
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildMenuItem(IconData icon, String title, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Abrir $title (Futuro)")));
        }
      },
    );
  }

  Widget _buildFeatureButton(IconData icon, String label, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[700],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
