import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class BoletimFormScreen extends StatefulWidget {
  @override
  _BoletimFormScreenState createState() => _BoletimFormScreenState();
}

class _BoletimFormScreenState extends State<BoletimFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _classController = TextEditingController();
  final _dobController = TextEditingController();
  final _portugueseController = TextEditingController();
  final _mathController = TextEditingController();
  final _scienceController = TextEditingController();
  final _historyController = TextEditingController();
  final _geographyController = TextEditingController();
  final _frequencyController = TextEditingController();

  final cpfMaskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final dateMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletim do Aluno'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Cadastro de Alunos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      "Nome do Aluno",
                      _nameController,
                      filteringText: FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-ZÀ-ÿ\s]'),
                      ),
                    ),
                    _buildTextField(
                      "CPF",
                      _cpfController,
                      inputFormatters: [cpfMaskFormatter],
                    ),
                    _buildTextField(
                      "Turma",
                      _classController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _buildTextField(
                      "Data de Nascimento",
                      _dobController,
                      inputFormatters: [dateMaskFormatter],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Notas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildNumberField("Português", _portugueseController),
                    _buildNumberField("Matemática", _mathController),
                    _buildNumberField("Ciências", _scienceController),
                    _buildNumberField("História", _historyController),
                    _buildNumberField("Geografia", _geographyController),
                    _buildNumberField("Frequência (%)", _frequencyController),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _generatePDF,
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text("Gerar PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    TextInputFormatter? filteringText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            inputFormatters ?? (filteringText != null ? [filteringText] : []),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Preencha este campo';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return _buildTextField(
      label,
      controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  void _generatePDF() async {
    if (!_formKey.currentState!.validate()) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Boletim do Aluno",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text("Nome: ${_nameController.text}"),
                pw.Text("CPF: ${_cpfController.text}"),
                pw.Text("Turma: ${_classController.text}"),
                pw.Text("Data de Nascimento: ${_dobController.text}"),
                pw.SizedBox(height: 16),
                pw.Text(
                  "Notas",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("Português: ${_portugueseController.text}"),
                pw.Text("Matemática: ${_mathController.text}"),
                pw.Text("Ciências: ${_scienceController.text}"),
                pw.Text("História: ${_historyController.text}"),
                pw.Text("Geografia: ${_geographyController.text}"),
                pw.Text("Frequência: ${_frequencyController.text}%"),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
