import 'package:flutter/material.dart';
import '../../../domain/entities/component.dart';

class SystemOverview extends StatelessWidget {
  final VoidCallback? onComponentTap;
  // Standard design size - this should match your image's aspect ratio
  static const double _designWidth = 1920;
  static const double _designHeight = 1080;

  const SystemOverview({
    Key? key,
    this.onComponentTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF1A1A1A), // Dark background color
      child: AspectRatio(
        aspectRatio: _designWidth / _designHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Dark gradient background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF2D2D2D),
                        Color(0xFF1A1A1A),
                      ],
                    ),
                  ),
                ),

                // Background system diagram
                Positioned.fill(
                  child: Image.asset(
                    'assets/ald_system_diagram.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // Subtle grid overlay
                CustomPaint(
                  painter: GridPainter(
                    color: Colors.white.withOpacity(0.03),
                    gridSize: 20,
                  ),
                ),

                // Interactive component areas
                _buildInteractiveAreas(context, constraints),

                // Status overlay
                CustomPaint(
                  painter: SystemConnectionsPainter(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    constraints: constraints,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInteractiveAreas(BuildContext context, BoxConstraints constraints) {
    // Calculate the actual image size within the constraints
    final imageWidth = constraints.maxWidth;
    final imageHeight = constraints.maxHeight;

    // Helper function to convert percentage to actual position
    Offset getPosition(double xPercent, double yPercent) {
      return Offset(
        xPercent * imageWidth,
        yPercent * imageHeight,
      );
    }

    // Helper function to convert percentage to actual size
    Size getSize(double widthPercent, double heightPercent) {
      return Size(
        widthPercent * imageWidth,
        heightPercent * imageHeight,
      );
    }

    return Stack(
      children: [
        // Nitrogen Generator (leftmost)
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.05, 0.3), // 5% from left, 30% from top
          size: getSize(0.15, 0.4), // 15% width, 40% height
          label: 'Nitrogen Generator',
          type: ComponentType.nitrogenGenerator,
        ),

        // Mass Flow Controller
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.25, 0.25), // 25% from left, 25% from top
          size: getSize(0.1, 0.2), // 10% width, 20% height
          label: 'Mass Flow Controller',
          type: ComponentType.massFlowController,
        ),

        // Control Valve A
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.4, 0.2), // 40% from left, 20% from top
          size: getSize(0.08, 0.15), // 8% width, 15% height
          label: 'Control Valve A',
          type: ComponentType.valve,
        ),

        // Control Valve B
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.4, 0.65), // 40% from left, 65% from top
          size: getSize(0.08, 0.15), // 8% width, 15% height
          label: 'Control Valve B',
          type: ComponentType.valve,
        ),

        // Reaction Chamber (center)
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.45, 0.3), // 45% from left, 30% from top
          size: getSize(0.2, 0.4), // 20% width, 40% height
          label: 'Reaction Chamber',
          type: ComponentType.chamber,
        ),

        // Vacuum Pump (rightmost)
        _buildPositionedHotspot(
          context: context,
          position: getPosition(0.75, 0.3), // 75% from left, 30% from top
          size: getSize(0.15, 0.4), // 15% width, 40% height
          label: 'Vacuum Pump',
          type: ComponentType.vacuumPump,
        ),
      ],
    );
  }

  Widget _buildPositionedHotspot({
    required BuildContext context,
    required Offset position,
    required Size size,
    required String label,
    required ComponentType type,
  }) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size.width,
      height: size.height,
      child: _buildComponentHotspot(
        context: context,
        label: label,
        type: type,
      ),
    );
  }

  Widget _buildComponentHotspot({
    required BuildContext context,
    required String label,
    required ComponentType type,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onComponentTap?.call();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(label),
              content: Text('View details for $label?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onComponentTap?.call();
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          );
        },
        hoverColor: Colors.white.withOpacity(0.1),
        splashColor: Colors.white.withOpacity(0.2),
        child: Tooltip(
          message: label,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

// Add this new painter for the grid effect
class GridPainter extends CustomPainter {
  final Color color;
  final double gridSize;

  GridPainter({
    required this.color,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SystemConnectionsPainter extends CustomPainter {
  final Color color;
  final BoxConstraints constraints;

  SystemConnectionsPainter({
    required this.color,
    required this.constraints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002 // Make line width relative to size
      ..strokeCap = StrokeCap.round; // Add rounded ends to lines

    final path = Path();

    // Helper function to get relative position
    double x(double percent) => size.width * percent;
    double y(double percent) => size.height * percent;

    // Main horizontal line
    path
      // Nitrogen Generator to MFC
      ..moveTo(x(0.2), y(0.5))
      ..lineTo(x(0.25), y(0.5))
      // MFC to Chamber
      ..moveTo(x(0.35), y(0.5))
      ..lineTo(x(0.45), y(0.5))
      // Chamber to Vacuum Pump
      ..moveTo(x(0.65), y(0.5))
      ..lineTo(x(0.75), y(0.5));

    // Vertical connections to valves
    path
      // Upper valve
      ..moveTo(x(0.4), y(0.5))
      ..lineTo(x(0.4), y(0.3))
      // Lower valve
      ..moveTo(x(0.4), y(0.5))
      ..lineTo(x(0.4), y(0.7));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SystemConnectionsPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.constraints != constraints;
}