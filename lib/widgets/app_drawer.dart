import 'package:app_disdel/screens/leave_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppDrawer extends StatelessWidget {
  // Parámetros para recibir la información del usuario
  final String? userName;
  final String? selectedRoleName;
  final String? userDocEntry;
  final VoidCallback onLogout; // Función para cerrar sesión

  const AppDrawer({
    super.key,
    required this.userName,
    required this.selectedRoleName,
    required this.userDocEntry,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color accentColor = theme.colorScheme.secondary;
    final staggerDelay = 70.ms;
    final Color drawerBackgroundColor = theme.canvasColor;
    final Color drawerHeaderColor = primaryColor.withOpacity(0.05);
    final Color itemTextColor = primaryColor.withOpacity(0.85);
    final Color selectedItemColor = accentColor;
    final Color iconColor = primaryColor.withOpacity(0.65);

    // Determina si la página actual es la primera en la pila de navegación (la HomePage)
    final bool isAtHomePage = ModalRoute.of(context)?.isFirst ?? false;

    return Drawer(
      backgroundColor: drawerBackgroundColor,
      elevation: 4.0,
      child: Column(
        children: [
          _buildDrawerHeaderContent(context, theme, drawerHeaderColor, primaryColor, accentColor),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              children: <Widget>[
                // --- ESTA ES LA SECCIÓN CON LA LÓGICA CORRECTA ---
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  text: 'Panel Principal',
                  onTap: () {
                    // Si ya estamos en la página principal, solo cerramos el drawer.
                    if (isAtHomePage) {
                      Navigator.pop(context);
                    } else {
                      // Si estamos en otra página, volvemos a la primera ruta (HomePage)
                      // eliminando las pantallas intermedias.
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  theme: theme,
                  itemTextColor: itemTextColor,
                  selectedItemColor: selectedItemColor,
                  iconColor: iconColor,
                  delay: staggerDelay * 1,
                  isSelected: isAtHomePage, // El item se marca como seleccionado solo si estamos en la HomePage.
                ),
                _buildDrawerItem(context, icon: Icons.inventory_2_outlined, text: 'Gestión de Inventario', onTap: () { Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 2),
                _buildDrawerItem(context, icon: Icons.groups_outlined, text: 'Administrar Clientes', onTap: () { Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 3),
                _buildDrawerItem(context, icon: Icons.bar_chart_outlined, text: 'Reportes y Análisis', onTap: () { Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 4),
                ExpansionTile(
                  leading: Icon(Icons.badge_outlined, color: iconColor, size: 22),
                  title: Text('RRHH', style: theme.textTheme.bodyLarge?.copyWith(color: itemTextColor, fontWeight: FontWeight.normal)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  childrenPadding: const EdgeInsets.only(left: 20.0),
                  iconColor: iconColor,
                  collapsedIconColor: iconColor,
                  children: <Widget>[
                    _buildDrawerItem(
                      context,
                      icon: Icons.event_busy_outlined,
                      text: 'Ausencia',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveRequestPage(
                          userName: userName,
                          selectedRoleName: selectedRoleName,
                          userDocEntry: userDocEntry,
                          onLogout: onLogout,
                        )));
                      },
                      theme: theme,
                      itemTextColor: itemTextColor,
                      selectedItemColor: selectedItemColor,
                      iconColor: iconColor,
                      delay: 0.ms,
                    ),
                  ],
                ).animate().fadeIn(delay: staggerDelay * 5).slideX(begin: -0.3, duration: 450.ms, curve: Curves.easeOut),
                Divider(color: primaryColor.withOpacity(0.1), indent: 16, endIndent: 16, height: 24).animate().fadeIn(delay: staggerDelay * 6),
                _buildDrawerItem(context, icon: Icons.settings_outlined, text: 'Configuración', onTap: () { Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 7),
                _buildDrawerItem(context, icon: Icons.help_outline, text: 'Ayuda y Soporte', onTap: () { Navigator.pop(context); }, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, delay: staggerDelay * 8),
                Divider(color: primaryColor.withOpacity(0.1), indent: 16, endIndent: 16, height: 24).animate().fadeIn(delay: staggerDelay * 9),
                _buildDrawerItem(context, icon: Icons.logout_outlined, text: 'Cerrar Sesión', onTap: onLogout, theme: theme, itemTextColor: itemTextColor, selectedItemColor: selectedItemColor, iconColor: iconColor, isLogout: true, delay: staggerDelay * 10),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top:10.0),
              child: Text('DISDEL S.A. © ${DateTime.now().year}', textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: primaryColor.withOpacity(0.5))),
            ).animate().fadeIn(delay: staggerDelay * 11),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderContent(BuildContext context, ThemeData theme, Color headerBackgroundColor, Color primaryColor, Color accentColor) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(color: headerBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30, backgroundColor: accentColor,
            child: Text(selectedRoleName?.isNotEmpty == true ? selectedRoleName![0].toUpperCase() : "D", style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          ).animate(delay: 150.ms).scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              children: [
                Text(userName ?? 'Usuario DISDEL', style: theme.textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis).animate().fadeIn(delay: 250.ms).slideX(begin: -0.2),
                if (userDocEntry != null) Text('ID Usuario: $userDocEntry', style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor.withOpacity(0.7))).animate().fadeIn(delay: 350.ms).slideX(begin: -0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon, required String text, required GestureTapCallback onTap, required ThemeData theme,
    required Color itemTextColor, required Color selectedItemColor, required Color iconColor,
    bool isLogout = false, bool isSelected = false, required Duration delay,
  }) {
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
}