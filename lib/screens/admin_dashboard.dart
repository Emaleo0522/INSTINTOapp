import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _selectedIndex = 0;
  String _selectedMenuTitle = 'Dashboard';
  bool _isDarkMode = false;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  // Helper para obtener colores del tema actual
  Color get _backgroundColor => _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
  Color get _cardColor => _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textColor => _isDarkMode ? const Color(0xFFE1E5E9) : const Color(0xFF1A202C);
  Color get _subtextColor => _isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);
  Color get _borderColor => _isDarkMode ? const Color(0xFF374151) : const Color(0xFFE2E8F0);

  // Colores del sidebar
  List<Color> get _sidebarGradient => _isDarkMode
    ? [const Color(0xFF1F2937), const Color(0xFF111827), const Color(0xFF0F172A)]
    : [Colors.orange.shade400, Colors.deepOrange.shade600, Colors.red.shade700];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            key: ValueKey(_isCollapsed),
            duration: const Duration(milliseconds: 250),
            width: _isCollapsed ? 80 : 280,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _sidebarGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header del sidebar
                Container(
                  padding: EdgeInsets.all(_isCollapsed ? 15 : 20),
                  child: _isCollapsed
                      ? Center(
                          child: IconButton(
                            onPressed: _toggleSidebar,
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'By Instinto',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Panel de Admin',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleSidebar,
                                  icon: const Icon(
                                    Icons.menu_open,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),

                // Menú de navegación
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 5 : 10),
                    children: [
                      _buildMenuItem(0, 'Dashboard', Icons.dashboard, 'Dashboard'),
                      _buildMenuItem(1, 'Gestión de Gimnasios', Icons.fitness_center, 'Gestión de Gimnasios'),
                      _buildMenuItem(2, 'Aprobar Solicitudes', Icons.approval, 'Aprobar Solicitudes'),
                      _buildMenuItem(3, 'Gestión de Usuarios', Icons.people, 'Gestión de Usuarios'),
                      _buildMenuItem(4, 'Reportes', Icons.assessment, 'Reportes'),
                      _buildMenuItem(5, 'Configuración', Icons.settings, 'Configuración'),
                      const SizedBox(height: 20),
                      if (!_isCollapsed) const Divider(color: Colors.white30),
                      _buildMenuItem(6, 'Soporte', Icons.help, 'Soporte'),
                    ],
                  ),
                ),

              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: Container(
              color: _backgroundColor,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Header del contenido
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        border: Border(
                          bottom: BorderSide(
                            color: _borderColor,
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedMenuTitle,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: _textColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Gestiona tu plataforma desde aquí',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _subtextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Menú consolidado del usuario
                          PopupMenuButton<String>(
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            color: _cardColor,
                            surfaceTintColor: _cardColor,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.shade400.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    child: Text(
                                      (_authService.currentUserEmail?.substring(0, 1).toUpperCase() ?? 'A'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Admin',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                enabled: false,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Administrador',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _authService.currentUserEmail ?? 'admin@instinto.com',
                                        style: TextStyle(
                                          color: _subtextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'theme',
                                child: Row(
                                  children: [
                                    Icon(
                                      _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                      color: _isDarkMode ? Colors.orange.shade400 : _textColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _isDarkMode ? 'Modo claro' : 'Modo oscuro',
                                      style: TextStyle(color: _textColor),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'notifications',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_outlined,
                                      color: _textColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Notificaciones',
                                      style: TextStyle(color: _textColor),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.settings_outlined,
                                      color: _textColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Configuración',
                                      style: TextStyle(color: _textColor),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Cerrar Sesión',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (String value) {
                              switch (value) {
                                case 'theme':
                                  _toggleTheme();
                                  break;
                                case 'notifications':
                                  // Implementar notificaciones
                                  break;
                                case 'settings':
                                  setState(() {
                                    _selectedIndex = 5;
                                    _selectedMenuTitle = 'Configuración';
                                  });
                                  break;
                                case 'logout':
                                  _handleLogout();
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Contenido dinámico
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: _buildMainContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
              ? Colors.black.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _textColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: _subtextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: _subtextColor,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, String title, IconData icon, String menuTitle) {
    final bool isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: _isCollapsed
          ? Tooltip(
              message: title,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    _selectedMenuTitle = menuTitle;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            )
          : ListTile(
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 20,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              selectedTileColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _selectedMenuTitle = menuTitle;
                });
              },
            ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildPlaceholderContent('Gestión de Gimnasios', 'Aquí podrás gestionar todos los gimnasios registrados');
      case 2:
        return _buildPlaceholderContent('Aprobar Solicitudes', 'Aquí podrás aprobar o rechazar solicitudes de nuevos gimnasios');
      case 3:
        return _buildPlaceholderContent('Gestión de Usuarios', 'Aquí podrás gestionar todos los usuarios del sistema');
      case 4:
        return _buildPlaceholderContent('Reportes', 'Aquí podrás generar y visualizar reportes');
      case 5:
        return _buildPlaceholderContent('Configuración', 'Aquí podrás configurar el sistema');
      case 6:
        return _buildPlaceholderContent('Soporte', 'Aquí podrás gestionar tickets de soporte');
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Gimnasios Activos',
                  '12',
                  Icons.fitness_center,
                  const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatCard(
                  'Usuarios Totales',
                  '348',
                  Icons.people,
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatCard(
                  'Solicitudes Pendientes',
                  '3',
                  Icons.pending_actions,
                  const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatCard(
                  'Ingresos del Mes',
                  '\$2,450',
                  Icons.monetization_on,
                  const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Quick Actions
          Row(
            children: [
              Text(
                'Acciones Rápidas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _borderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Ver todo',
                  style: TextStyle(
                    color: _subtextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Administra tu plataforma de manera eficiente',
            style: TextStyle(
              fontSize: 16,
              color: _subtextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.3,
            children: [
              _buildActionCard(
                'Gestionar Gimnasios',
                Icons.business_outlined,
                const Color(0xFF3B82F6),
                () => setState(() {
                  _selectedIndex = 1;
                  _selectedMenuTitle = 'Gestión de Gimnasios';
                }),
              ),
              _buildActionCard(
                'Aprobar Solicitudes',
                Icons.approval,
                const Color(0xFFF59E0B),
                () => setState(() {
                  _selectedIndex = 2;
                  _selectedMenuTitle = 'Aprobar Solicitudes';
                }),
              ),
              _buildActionCard(
                'Gestión de Usuarios',
                Icons.group_outlined,
                const Color(0xFF10B981),
                () => setState(() {
                  _selectedIndex = 3;
                  _selectedMenuTitle = 'Gestión de Usuarios';
                }),
              ),
              _buildActionCard(
                'Reportes y Analytics',
                Icons.analytics_outlined,
                const Color(0xFF8B5CF6),
                () => setState(() {
                  _selectedIndex = 4;
                  _selectedMenuTitle = 'Reportes';
                }),
              ),
              _buildActionCard(
                'Configuración',
                Icons.settings_outlined,
                const Color(0xFF6B7280),
                () => setState(() {
                  _selectedIndex = 5;
                  _selectedMenuTitle = 'Configuración';
                }),
              ),
              _buildActionCard(
                'Centro de Ayuda',
                Icons.help_outline,
                const Color(0xFF06B6D4),
                () => setState(() {
                  _selectedIndex = 6;
                  _selectedMenuTitle = 'Soporte';
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(String title, String description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: _isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: _subtextColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Esta función estará disponible próximamente',
            style: TextStyle(
              fontSize: 14,
              color: _subtextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('Esta función estará disponible próximamente.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}