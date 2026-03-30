import 'package:dartshogi/dartshogi.dart';
import 'package:flutter/widgets.dart';
import 'package:shogiground/shogiground.dart';

/// A mixin that provides geometry information about the shogiboard.
mixin ShogiboardGeometry {
  /// Visual size of the board.
  double get size;

  /// Side by which the board is oriented.
  Side get orientation;

  //ShogiType to calculate board geometry
  ShogiType get shogiType;

  /// Size of a single square on the board.
  double get squareSize => size / shogiType.width;

  /// Converts a square to a board offset.
  Offset squareOffset(Square square) {
    int x, y;
    x = orientation == Side.gote ? shogiType.width - square.file : square.file;
    y = orientation == Side.gote ? square.rank : shogiType.height - square.rank;
    

    return Offset(x * squareSize, y * squareSize);
  }

  /// Converts a board offset to a square.
  ///
  /// Returns `null` if the offset is outside the board.
  Square? offsetSquare(Offset offset) {
    final x = (offset.dx / squareSize).floor();
    final y = (offset.dy / squareSize).floor();
    final orientX = orientation == Side.gote ? shogiType.width - 1 - x : x;
    final orientY = orientation == Side.gote ? y : shogiType.height - 1 - y;
    if (orientX >= 0 && orientX <= shogiType.width - 1 && orientY >= 0 && orientY <= shogiType.height - 1) {
      return Square.fromCoords(File(orientX), Rank(orientY));
    } else {
      return null;
    }
  }
}
