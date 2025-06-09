// lib/screens/leave_request_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Paleta de Colores de tu App ---
const Color disdelBlue = Color(0xFF004A8F);
const Color disdelGreen = Color(0xFF8BC53F);
const Color lightGrey = Color(0xFFF2F2F2);

class LeaveRequestPage extends StatefulWidget {
  LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  String _selectedLeaveType = 'Vacaciones';
  DateTimeRange? _selectedDateRange;
  bool _isHalfDay = false;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: disdelGreen,
              onPrimary: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }

  void _submitRequest() async {
    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona un rango de fechas.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solicitud enviada con éxito'),
        backgroundColor: disdelGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      _selectedDateRange = null;
      _isHalfDay = false;
      _reasonController.clear();
    });
  }

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) {
      return 'Seleccionar fechas';
    }
    // Esta línea ahora funcionará porque el paquete 'intl' está instalado.
    final format = DateFormat('d MMM yyyy', 'es_ES');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Solicitud de Ausencia', style: TextStyle(color: disdelBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: disdelBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildUserInfoCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Tipo de Ausencia'),
          _buildLeaveTypeSelector(),
          const SizedBox(height: 24),
          _buildSectionTitle('Fechas Solicitadas'),
          _buildDateRangePicker(),
          const SizedBox(height: 10),
          _buildHalfDayToggle(),
          const SizedBox(height: 24),
          _buildSectionTitle('Motivo del Permiso'),
          _buildReasonField(),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildSubmitButton(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: disdelBlue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Empleado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.person_outline, 'Nombre', 'EDGAR LAUREANO SOC RAC'),
            _buildInfoRow(Icons.badge_outlined, 'ID Empleado', '463'),
            _buildInfoRow(Icons.calendar_today_outlined, 'Días disponibles', '0', highlight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Text('$label:', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlight ? disdelGreen : Colors.black87,
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedLeaveType,
      items: ['Vacaciones', 'Permiso por enfermedad', 'Asuntos personales']
          .map((type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedLeaveType = value);
        }
      },
      decoration: _inputDecoration(
          hintText: 'Selecciona un tipo',
          prefixIcon: Icons.work_off_outlined
      ),
      icon: const Icon(Icons.arrow_drop_down, color: disdelBlue),
    );
  }

  Widget _buildDateRangePicker() {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range_outlined, color: disdelGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatDateRange(_selectedDateRange),
                style: TextStyle(
                  color: _selectedDateRange == null ? Colors.grey[600] : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfDayToggle() {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: const Text('Solicitar solo medio día', style: TextStyle(color: Colors.black87)),
      value: _isHalfDay,
      onChanged: (value) => setState(() => _isHalfDay = value),
      activeColor: disdelGreen,
      dense: true,
    );
  }

  Widget _buildReasonField() {
    return TextFormField(
      controller: _reasonController,
      decoration: _inputDecoration(
        hintText: 'Escribe aquí...',
        prefixIcon: Icons.edit_note_outlined,
      ),
      maxLines: 4,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: disdelGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
        onPressed: _isLoading ? null : _submitRequest,
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        )
            : const Text(
          'ENVIAR SOLICITUD',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(prefixIcon, color: disdelGreen, size: 22),
      filled: true,
      fillColor: lightGrey,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: disdelGreen, width: 2),
      ),
    );
  }
}