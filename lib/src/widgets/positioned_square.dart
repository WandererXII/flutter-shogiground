import 'package:shogiground/shogiground.dart';
import 'package:shogiground/src/widgets/geometry.dart';
import 'package:dartshogi/dartshogi.dart';
import 'package:flutter/widgets.dart';
import './highlight.dart';
import './piece.dart';

/// Board aware [Positioned] widget.
///
/// Use to position things, such as a [PieceWidget] or [SquareHighlight] on the
/// board.
///
/// It must be a descendant of a [Stack] since it's a wrapper over [Positioned].
class PositionedSquare extends StatelessWidget with ShogiboardGeometry {
  const PositionedSquare({
    super.key,
    required this.shogiType,
    required this.child,
    required this.size,
    required this.orientation,
    required this.square,
  });

  final Widget child;

  @override
  final ShogiType shogiType;

  @override
  final double size;

  @override
  final Side orientation;

  final Square square;

  @override
  Widget build(BuildContext context) {
    final offset = squareOffset(square);
    return Positioned(
      width: squareSize,
      height: squareSize,
      left: offset.dx,
      top: offset.dy,
      child: child,
    );
  }
}
