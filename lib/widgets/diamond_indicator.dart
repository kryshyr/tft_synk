import 'package:flutter/material.dart';
import '../app_constants.dart';

class DiamondIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DiamondPainter(this, onChanged);
  }
}

class _DiamondPainter extends BoxPainter {
  final DiamondIndicator decoration;

  _DiamondPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double width = 16.0;
    final double height = 16.0;
    final double xCenter = configuration.size!.width / 2;
    final double yCenter =
        configuration.size!.height - height / 10; // Lower the diamond

    // Draw fill
    final Paint fillPaint = Paint()
      ..color = AppColors.tertiaryAccent; // Set the fill color to blue

    final Path fillPath = Path()
      ..moveTo(offset.dx + xCenter, offset.dy + yCenter - height / 2)
      ..lineTo(offset.dx + xCenter - width / 2, offset.dy + yCenter)
      ..lineTo(offset.dx + xCenter, offset.dy + yCenter + height / 2)
      ..lineTo(offset.dx + xCenter + width / 2, offset.dy + yCenter)
      ..close();

    canvas.drawPath(fillPath, fillPaint);

    // Draw outline
    final Paint outlinePaint = Paint()
      ..color = AppColors.secondary // Set the outline color to gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Adjust the outline thickness as needed

    canvas.drawPath(fillPath, outlinePaint);
  }
}
