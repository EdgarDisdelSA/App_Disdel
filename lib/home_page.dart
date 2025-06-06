// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;

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
  String? _userName; // Variable para almacenar el nombre del usuario

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentCarouselIndex = 0;

  final List<Note> _userNotes = [
    Note(id: '1', title: 'Recordatorio reunión', content: 'Preparar presentación para el cliente X mañana a las 10 AM.', lastEdited: DateTime.now().subtract(const Duration(hours: 2))),
    Note(id: '2', title: 'Ideas Proyecto Z', content: 'Investigar nuevas tecnologías de frontend. Considerar Flutter Web.', lastEdited: DateTime.now().subtract(const Duration(days: 1))),
    Note(id: '3', title: 'Lista de Pendientes', content: '- Enviar correos de seguimiento.\n- Actualizar reporte semanal.', lastEdited: DateTime.now()),
  ];

  // Inicializar _quickActions como una lista vacía para evitar errores con 'late'
  List<QuickAction> _quickActions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final theme = Theme.of(context);
        // Ahora asignamos los valores a la lista ya existente
        _quickActions = [
          QuickAction(label: "Soporte Técnico", icon: Icons.headset_mic_outlined, onTap: () { print("Soporte Tapped"); }, backgroundColor: Colors.orange.withOpacity(0.1)),
          QuickAction(label: "Nuevo Pedido", icon: Icons.add_shopping_cart_outlined, onTap: () { print("Nuevo Pedido Tapped"); }, backgroundColor: theme.colorScheme.secondary.withOpacity(0.1)),
          QuickAction(label: "Ver Facturas", icon: Icons.receipt_long_outlined, onTap: () { print("Ver Facturas Tapped"); }, backgroundColor: theme.colorScheme.primary.withOpacity(0.1)),
          QuickAction(label: "Rutas de Entrega", icon: Icons.location_on_outlined, onTap: () { print("Rutas Tapped"); }, backgroundColor: Colors.teal.withOpacity(0.1)),
        ];
        setState(() {}); // Necesario para que el build sepa que _quickActions tiene datos
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
      // Leemos el nombre de usuario de los argumentos
      _userName = arguments['nameuser'] as String?;
    }
  }

  void _logout() { /* ... (sin cambios) ... */
    print("Cerrando sesión...");
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _showNoteDialog({Note? existingNote}) { /* ... (sin cambios) ... */
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

  void _deleteNote(Note noteToDelete) { /* ... (sin cambios) ... */
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
          IconButton(icon: const Icon(Icons.notifications_none_outlined, size: 26), tooltip: 'Notificaciones', onPressed: () { /* TODO */ }).animate().fadeIn(delay: 400.ms).shake(hz: 2),
          IconButton(icon: const Icon(Icons.logout_outlined, size: 26), tooltip: 'Cerrar Sesión', onPressed: _logout).animate().fadeIn(delay: 500.ms).shake(hz: 2),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildAppDrawer(context, theme, primaryColor, accentColor),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildWelcomeHeader(theme, primaryColor)
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutCubic),

          const SizedBox(height: 28),

          _buildCarouselSliderSection(theme, primaryColor, accentColor) // El chequeo de _quickActions.isEmpty ahora está dentro de este método
              .animate(delay: 200.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutCubic),

          const SizedBox(height: 28),

          _buildNotesSection(theme, primaryColor, accentColor)
              .animate(delay: 300.ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, curve: Curves.easeOutCubic),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- DRAWER ---
  Widget _buildAppDrawer(BuildContext context, ThemeData theme, Color primaryColor, Color accentColor) {
    // ... (código del Drawer sin cambios, omitido por brevedad)
    final staggerDelay = 70.ms;
    final Color drawerBackgroundColor = theme.canvasColor;
    final Color drawerHeaderColor = primaryColor.withOpacity(0.05);
    final Color itemTextColor = primaryColor.withOpacity(0.85);
    final Color selectedItemColor = accentColor;
    final Color iconColor = primaryColor.withOpacity(0.65);

    return Drawer(
      backgroundColor: drawerBackgroundColor,
      elevation: 4.0,
      child: Column(
        children: [
          _buildDrawerHeaderContent(theme, drawerHeaderColor, primaryColor, accentColor),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              children: <Widget>[
                _buildDrawerItem(icon: Icons.dashboard_outlined, text: 'Panel Principal', onTap: () => Navigator.pop(context), theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 1, isSelected: true),
                _buildDrawerItem(icon: Icons.inventory_2_outlined, text: 'Gestión de Inventario', onTap: () { /* TODO */ Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 2),
                _buildDrawerItem(icon: Icons.groups_outlined, text: 'Administrar Clientes', onTap: () { /* TODO */ Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 3),
                _buildDrawerItem(icon: Icons.bar_chart_outlined, text: 'Reportes y Análisis', onTap: () { /* TODO */ Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 4),
                Divider(color: primaryColor.withOpacity(0.1), indent: 16, endIndent: 16, height: 24).animate().fadeIn(delay: staggerDelay * 5),
                _buildDrawerItem(icon: Icons.settings_outlined, text: 'Configuración', onTap: () { /* TODO */ Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 6),
                _buildDrawerItem(icon: Icons.help_outline, text: 'Ayuda y Soporte', onTap: () { /* TODO */ Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 7),
                Divider(color: primaryColor.withOpacity(0.1), indent: 16, endIndent: 16, height: 24).animate().fadeIn(delay: staggerDelay * 8),
                _buildDrawerItem(icon: Icons.logout_outlined, text: 'Cerrar Sesión', onTap: _logout, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, isLogout: true, delay: staggerDelay * 9),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top:10.0),
              child: Text('DISDEL S.A. © ${DateTime.now().year}', textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: primaryColor.withOpacity(0.5))),
            ).animate().fadeIn(delay: staggerDelay * 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderContent(ThemeData theme, Color headerBackgroundColor, Color primaryColor, Color accentColor) {
    // ... (Código de _buildDrawerHeaderContent sin cambios)
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(color: headerBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30, backgroundColor: accentColor,
            child: Text(_selectedRoleName?.isNotEmpty == true ? _selectedRoleName![0].toUpperCase() : "D", style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          ).animate(delay: 150.ms).scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedRoleName ?? 'Usuario DISDEL', style: theme.textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis).animate().fadeIn(delay: 250.ms).slideX(begin: -0.2),
                if (_userDocEntry != null) Text('ID Usuario: $_userDocEntry', style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor.withOpacity(0.7))).animate().fadeIn(delay: 350.ms).slideX(begin: -0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon, required String text, required GestureTapCallback onTap, required ThemeData theme,
    required Color itemTextColor, required Color selectedItemColor, required Color iconColor,
    bool isLogout = false, bool isSelected = false, required Duration delay,
  }) {
    // ... (Código de _buildDrawerItem sin cambios)
    final Color effectiveIconColor = isSelected ? selectedItemColor : (isLogout ? Colors.red.shade400 : iconColor);
    final Color effectiveTextColor = isSelected ? selectedItemColor : (isLogout ? Colors.red.shade500 : itemTextColor);
    final FontWeight effectiveFontWeight = isSelected ? FontWeight.bold : FontWeight.normal;

    return Material(
      color: isSelected ? selectedItemColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(8),
        splashColor: selectedItemColor.withOpacity(0.15), highlightColor: selectedItemColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: <Widget>[
              Icon(icon, color: effectiveIconColor, size: 22),
              const SizedBox(width: 20),
              Expanded(child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: effectiveTextColor, fontWeight: effectiveFontWeight))),
              if (isSelected) Container(width: 4, height: 20, decoration: BoxDecoration(color: selectedItemColor, borderRadius: BorderRadius.circular(2))).animate().fadeIn(duration: 200.ms)
            ],
          ),
        ),
      ),
    ).animate(delay: delay).fadeIn(duration: 350.ms, curve: Curves.easeOut).slideX(begin: -0.3, duration: 450.ms, curve: Curves.easeOut);
  }

  // --- WIDGETS DEL CUERPO DE LA PÁGINA ---
  Widget _buildWelcomeHeader(ThemeData theme, Color primaryColor) {
    // Se prioriza el nombre de usuario, con fallback al rol o un texto genérico.
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
    // El chequeo de si _quickActions está vacío se hace aquí ahora.
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
            return _buildCarouselItem(
                theme,
                action.label,
                action.icon,
                action.backgroundColor ?? accentColor.withOpacity(0.1),
                action.onTap
            );
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
    // Color para el texto y el icono
    const Color contentColor = Color(0xFF616969);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: contentColor.withOpacity(0.1),
      highlightColor: contentColor.withOpacity(0.05),
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        // --- CAMBIO AQUÍ: Añadimos un borde a la tarjeta ---
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(      // Se añade la propiedad 'side'
            color: Color(0xFF19ac8a),  // Con el color que solicitaste
            width: 1.5,                // Y un grosor para que sea visible
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
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: contentColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scaleXY(begin: 0.95, curve: Curves.easeOutBack);
  }


  // --- NUEVA SECCIÓN DE NOTAS ---
  Widget _buildNotesSection(ThemeData theme, Color primaryColor, Color accentColor) {
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
                onPressed: () { /* TODO: Ver todas las notas */ print("TODO: Ver todas las notas"); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionalidad para ver todas las notas no implementada aún.'))); },
                child: Text("Ver todas (${_userNotes.length})", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoteItem(ThemeData theme, Note note, Color primaryColor, Color accentColor, Duration delay) {
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