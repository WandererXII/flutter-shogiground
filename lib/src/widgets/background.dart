import 'package:dartshogi/dartshogi.dart' show Side;
import 'package:flutter/widgets.dart';
import 'package:shogiground/src/models.dart';

/// Base widget for the background of the chessboard.
///
/// See [SolidColorShogiboardBackground] and [ImageShogiboardBackground] for concrete implementations.
abstract class ShogiboardBackground extends StatelessWidget {
  const ShogiboardBackground({
    super.key,
    this.coordinates = false,
    this.orientation = Side.sente,
    required this.lightSquare,
    required this.darkSquare,
    required this.shogiType
  });

  final bool coordinates;
  final Side orientation;
  final Color lightSquare;
  final Color darkSquare;
  final ShogiType shogiType;
}

/// A chessboard background with solid color squares.
class SolidColorShogiboardBackground extends ShogiboardBackground {
  const SolidColorShogiboardBackground({
    super.key,
    super.coordinates,
    super.orientation,
    required super.lightSquare,
    required super.darkSquare,
    required super.shogiType
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _SolidColorShogiboardPainter(
        lightSquare: lightSquare,
        darkSquare: darkSquare,
        coordinates: coordinates,
        orientation: orientation,
        shogiType: shogiType
      ),
    );
  }
}

class _SolidColorShogiboardPainter extends CustomPainter {
  _SolidColorShogiboardPainter({
    required this.lightSquare,
    required this.darkSquare,
    required this.coordinates,
    required this.orientation,
    required this.shogiType
  });

  final Color lightSquare;
  final Color darkSquare;
  final bool coordinates;
  final Side orientation;
  final ShogiType shogiType;

  @override
  void paint(Canvas canvas, Size size) {

    // TODO we have to update here if the type is dobutsu
    final numberSquaresHorizontally = shogiType.width;

    final squareSize = size.shortestSide / numberSquaresHorizontally;
    for (var rank = 0; rank < numberSquaresHorizontally; rank++) {
      for (var file = 0; file < numberSquaresHorizontally; file++) {
        final square = Rect.fromLTWH(file * squareSize, rank * squareSize, squareSize, squareSize);
        final paint = Paint()..color = (rank + file).isEven ? lightSquare : darkSquare;
        canvas.drawRect(square, paint);
        if (coordinates && (file == numberSquaresHorizontally - 1 || rank == numberSquaresHorizontally - 1)) {
          final coordStyle = TextStyle(
            inherit: false,
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
            color: (rank + file).isEven ? darkSquare : lightSquare,
            fontFamily: 'Roboto',
            height: 1.0,
          );
          if (file == 7) {
            final coord = TextPainter(
              text: TextSpan(
                text: orientation == Side.sente ? '${numberSquaresHorizontally - 1 - rank}' : '${rank + 1}',
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + (squareSize - coord.width) - edgeOffset,
              rank * squareSize + edgeOffset,
            );
            coord.paint(canvas, offset);
          }
          if (rank == 7) {
            final coord = TextPainter(
              text: TextSpan(
                text:
                    orientation == Side.sente
                        ? String.fromCharCode(97 + file)
                        : String.fromCharCode(97 + 7 - file),
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + edgeOffset,
              rank * squareSize + (squareSize - coord.height) - edgeOffset,
            );
            coord.paint(canvas, offset);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// A chessboard background made of an image.
class ImageShogiboardBackground extends ShogiboardBackground {
  const ImageShogiboardBackground({
    super.key,
    super.coordinates,
    super.orientation,
    required super.lightSquare,
    required super.darkSquare,
    required this.image,
    required super.shogiType
  });

  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    if (coordinates) {
      return Stack(
        fit: StackFit.expand,
        alignment: Alignment.topLeft,
        clipBehavior: Clip.none,
        children: [
          Image(image: image, fit: BoxFit.cover),
          CustomPaint(
            size: Size.infinite,
            painter: _ImageBackgroundCoordinatePainter(
              lightSquare: lightSquare,
              darkSquare: darkSquare,
              orientation: orientation,
              shogiType: shogiType
            ),
          ),
        ],
      );
    } else {
      return Image(image: image, fit: BoxFit.cover);
    }
  }
}

class _ImageBackgroundCoordinatePainter extends CustomPainter {
  _ImageBackgroundCoordinatePainter({
    required this.lightSquare,
    required this.darkSquare,
    required this.orientation,
    required this.shogiType
  });

  final Side orientation;
  final Color lightSquare;
  final Color darkSquare;
  final ShogiType shogiType;

  @override
  void paint(Canvas canvas, Size size) {

    final numberSquaresHorizontally = shogiType.width;

    final squareSize = size.shortestSide / numberSquaresHorizontally;
    for (var rank = 0; rank < numberSquaresHorizontally; rank++) {
      for (var file = 0; file < numberSquaresHorizontally; file++) {
        if (file == numberSquaresHorizontally - 1 || rank == numberSquaresHorizontally - 1) {
          final coordStyle = TextStyle(
            inherit: false,
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
            color: (rank + file).isEven ? darkSquare : lightSquare,
            fontFamily: 'Roboto',
            height: 1.0,
          );
          final square = Rect.fromLTWH(
            file * squareSize,
            rank * squareSize,
            squareSize,
            squareSize,
          );
          final paint = Paint()..color = const Color(0x00000000);
          canvas.drawRect(square, paint);
          if (file == 7) {
            final coord = TextPainter(
              text: TextSpan(
                text: orientation == Side.sente ? '${numberSquaresHorizontally - 1 - rank}' : '${rank + 1}',
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + (squareSize - coord.width) - edgeOffset,
              rank * squareSize + edgeOffset,
            );
            coord.paint(canvas, offset);
          }
          if (rank == 7) {
            final coord = TextPainter(
              text: TextSpan(
                text:
                    orientation == Side.sente
                        ? String.fromCharCode(97 + file)
                        : String.fromCharCode(97 + 7 - file),
                style: coordStyle,
              ),
              textDirection: TextDirection.ltr,
            );
            coord.layout();
            const edgeOffset = 2.0;
            final offset = Offset(
              file * squareSize + edgeOffset,
              rank * squareSize + (squareSize - coord.height) - edgeOffset,
            );
            coord.paint(canvas, offset);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
