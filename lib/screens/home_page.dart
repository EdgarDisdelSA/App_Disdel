// lib/screens/home_page.dart
import 'package:app_disdel/widgets/app_drawer.dart'; // <-- 1. IMPORTAMOS NUESTRO NUEVO WIDGET
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
// ya no necesitamos importar leave_request_page.dart aquí

// Modelo simple para una nota
class Note {
  final String id;
  String title;
  String content;
  DateTime lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdited,
  });
}

// Modelo para una Acción Rápida
class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userDocEntry;
  String? _selectedRoleName;
  String? _userName;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentCarouselIndex = 0;

  final List<Note> _userNotes = [
    Note(id: '1', title: 'Recordatorio reunión', content: 'Preparar presentación para el cliente X mañana a las 10 AM.', lastEdited: DateTime.now().subtract(const Duration(hours: 2))),
    Note(id: '2', title: 'Ideas Proyecto Z', content: 'Investigar nuevas tecnologías de frontend. Considerar Flutter Web.', lastEdited: DateTime.now().subtract(const Duration(days: 1))),
    Note(id: '3', title: 'Lista de Pendientes', content: '- Enviar correos de seguimiento.\n- Actualizar reporte semanal.', lastEdited: DateTime.now()),
  ];

  List<QuickAction> _quickActions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final theme = Theme.of(context);
        _quickActions = [
          QuickAction(label: "Soporte Técnico", icon: Icons.headset_mic_outlined, onTap: () { print("Soporte Tapped"); }, backgroundColor: Colors.orange.withOpacity(0.1)),
          QuickAction(label: "Nuevo Pedido", icon: Icons.add_shopping_cart_outlined, onTap: () { print("Nuevo Pedido Tapped"); }, backgroundColor: theme.colorScheme.secondary.withOpacity(0.1)),
          QuickAction(label: "Ver Facturas", icon: Icons.receipt_long_outlined, onTap: () { print("Ver Facturas Tapped"); }, backgroundColor: theme.colorScheme.primary.withOpacity(0.1)),
          QuickAction(label: "Rutas de Entrega", icon: Icons.location_on_outlined, onTap: () { print("Rutas Tapped"); }, backgroundColor: Colors.teal.withOpacity(0.1)),
        ];
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map) {
      _userDocEntry = arguments['userDocEntry'] as String?;
      final dynamic selectedRoleArg = arguments['selectedRole'];
      _selectedRoleName = selectedRoleArg?.toString();
      _userName = arguments['nameuser'] as String?;
    }
  }

  void _logout() {
    print("Cerrando sesión...");
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _showNoteDialog({Note? existingNote}) {
    // ... (el código de este método no cambia)
    final bool isEditing = existingNote != null;
    TextEditingController titleController = TextEditingController(text: existingNote?.title);
    TextEditingController contentController = TextEditingController(text: existingNote?.content);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Nota' : 'Nueva Nota Rápida'),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder(), isDense: true),
                  validator: (value) => (value == null || value.isEmpty) ? 'Ingresa un título' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Contenido', border: OutlineInputBorder(), alignLabelWithHint: true),
                  maxLines: 4, minLines: 2,
                  validator: (value) => (value == null || value.isEmpty) ? 'Ingresa el contenido' : null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              child: Text(isEditing ? 'Guardar Cambios' : 'Guardar Nota'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    if (isEditing) {
                      existingNote.title = titleController.text;
                      existingNote.content = contentController.text;
                      existingNote.lastEdited = DateTime.now();
                      _userNotes.remove(existingNote);
                      _userNotes.insert(0, existingNote);
                    } else {
                      _userNotes.insert(0, Note(id: DateTime.now().millisecondsSinceEpoch.toString(), title: titleController.text, content: contentController.text, lastEdited: DateTime.now()));
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(Note noteToDelete) {
    // ... (el código de este método no cambia)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Nota'),
          content: Text('¿Seguro que quieres eliminar "${noteToDelete.title}"?'),
          actions: <Widget>[
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() => _userNotes.remove(noteToDelete));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nota "${noteToDelete.title}" eliminada.')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color accentColor = theme.colorScheme.secondary;
    final Color onAccentColor = theme.colorScheme.onSecondary;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: onAccentColor)),
        backgroundColor: accentColor,
        elevation: 2.0,
        iconTheme: IconThemeData(color: onAccentColor),
        actionsIconTheme: IconThemeData(color: onAccentColor),
        shape: Border(bottom: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_outlined, size: 26), tooltip: 'Notificaciones', onPressed: () {}).animate().fadeIn(delay: 400.ms).shake(hz: 2),
          IconButton(icon: const Icon(Icons.logout_outlined, size: 26), tooltip: 'Cerrar Sesión', onPressed: _logout).animate().fadeIn(delay: 500.ms).shake(hz: 2),
          const SizedBox(width: 8),
        ],
      ),
      // --- 2. USAMOS NUESTRO WIDGET REUTILIZABLE AQUÍ ---
      drawer: AppDrawer(
        userName: _userName,
        selectedRoleName: _selectedRoleName,
        userDocEntry: _userDocEntry,
        onLogout: _logout, // Pasamos la función de logout
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildWelcomeHeader(theme, primaryColor).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          const SizedBox(height: 28),
          _buildCarouselSliderSection(theme, primaryColor, accentColor).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          const SizedBox(height: 28),
          _buildNotesSection(theme, primaryColor, accentColor).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- YA NO NECESITAMOS LOS MÉTODOS DEL DRAWER AQUÍ ---
  // _buildAppDrawer, _buildDrawerHeaderContent, y _buildDrawerItem han sido eliminados.


  // --- WIDGETS DEL CUERPO DE LA PÁGINA (sin cambios) ---
  Widget _buildWelcomeHeader(ThemeData theme, Color primaryColor) {
    // ... (el código de este método no cambia)
    final String displayName = _userName ?? _selectedRoleName ?? 'Usuario';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hola, $displayName!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 26)),
        const SizedBox(height: 4),
        Text('Bienvenido al panel de control.', style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9))),
      ],
    );
  }

  Widget _buildCarouselSliderSection(ThemeData theme, Color primaryColor, Color accentColor) {
    // ... (el código de este método no cambia)
    if (_quickActions.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No hay acciones disponibles.")));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        carousel.CarouselSlider.builder(
          itemCount: _quickActions.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            final action = _quickActions[itemIndex];
            return _buildCarouselItem(theme, action.label, action.icon, action.backgroundColor ?? accentColor.withOpacity(0.1), action.onTap);
          },
          options: carousel.CarouselOptions(
            height: 150.0,
            autoPlay: _quickActions.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 16/7,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
        ),
        if (_quickActions.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _quickActions.asMap().entries.map((entry) {
              return Container(
                width: _currentCarouselIndex == entry.key ? 9.0 : 7.0,
                height: _currentCarouselIndex == entry.key ? 9.0 : 7.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (accentColor).withOpacity(_currentCarouselIndex == entry.key ? 0.9 : 0.4),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay:100.ms),
      ],
    );
  }

  Widget _buildCarouselItem(ThemeData theme, String label, IconData icon, Color backgroundColor, VoidCallback onTap) {
    // ... (el código de este método no cambia)
    const Color contentColor = Color(0xFF616969);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: contentColor.withOpacity(0.1),
      highlightColor: contentColor.withOpacity(0.05),
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF19ac8a),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 36, color: contentColor.withOpacity(0.85)),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: contentColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scaleXY(begin: 0.95, curve: Curves.easeOutBack);
  }

  Widget _buildNotesSection(ThemeData theme, Color primaryColor, Color accentColor) {
    // ... (el código de este método no cambia)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Mis Notas Rápidas", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
            TextButton.icon(
              icon: Icon(Icons.add_circle_outline_rounded, color: accentColor, size: 20),
              label: Text("Nueva", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
              onPressed: () => _showNoteDialog(),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_userNotes.isEmpty)
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: primaryColor.withOpacity(0.25), width: 1)),
            color: theme.cardColor.withOpacity(0.8),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.note_add_outlined, size: 40, color: primaryColor.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Text("No tienes notas aún.", style: theme.textTheme.titleMedium?.copyWith(color: primaryColor.withOpacity(0.7))),
                    const SizedBox(height: 4),
                    Text("Presiona 'Nueva' para empezar.", textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor.withOpacity(0.6))),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: _userNotes.length > 3 ? 3 : _userNotes.length,
            itemBuilder: (context, index) {
              final note = _userNotes[index];
              final animationDelay = (80 * (index + 1)).ms;
              return _buildNoteItem(theme, note, primaryColor, accentColor, animationDelay);
            },
          ),
        if (_userNotes.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () { print("TODO: Ver todas las notas"); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionalidad para ver todas las notas no implementada aún.'))); },
                child: Text("Ver todas (${_userNotes.length})", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoteItem(ThemeData theme, Note note, Color primaryColor, Color accentColor, Duration delay) {
    // ... (el código de este método no cambia)
    return Card(
      elevation: 1.5, margin: const EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: CircleAvatar(backgroundColor: accentColor.withOpacity(0.12), child: Icon(Icons.article_outlined, color: accentColor, size: 22)),
        title: Text(note.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(note.content, style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor.withOpacity(0.75)), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: primaryColor.withOpacity(0.6)),
          onSelected: (String value) {
            if (value == 'edit') _showNoteDialog(existingNote: note);
            else if (value == 'delete') _deleteNote(note);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Editar'))),
            const PopupMenuItem<String>(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text('Eliminar', style: TextStyle(color: Colors.red)))),
          ],
        ),
        onTap: () => _showNoteDialog(existingNote: note),
      ),
    ).animate(delay: delay).fadeIn(duration: 400.ms).slideX(begin: 0.2, curve: Curves.easeOutCubic);
  }
}