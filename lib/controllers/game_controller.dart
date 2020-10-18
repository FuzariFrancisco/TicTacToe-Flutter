import '../core/constants.dart';
import '../core/winner_rules.dart';
import '../enums/player_type.dart';
import '../enums/winner_type.dart';
import '../models/board_tile.dart';


class GameController {
  List<BoardTile> tiles = [];
  List<int> movesPlayer1 = [];
  List<int> movesPlayer2 = [];
  int winsPlayer1 = 0;
  int winsPlayer2 = 0;
  PlayerType currentPlayer;
  String currentPlayerName;
  bool isSinglePlayer = false;

  bool get isBotTurn => isSinglePlayer && currentPlayer == PlayerType.player2;

  bool get hasMoves =>
      (movesPlayer1.length + movesPlayer2.length) != kBoardSize;

  GameController() {
    _initialize();
  }

  void _initialize() {
    movesPlayer1.clear();
    movesPlayer2.clear();
    currentPlayer = PlayerType.player1;
    currentPlayerName = "Player 1";
    tiles =
        List<BoardTile>.generate(kBoardSize, (index) => BoardTile(index + 1));
  }

  void reset() {
    _initialize();
  }

  void _markBoardTileWithPlayer1(BoardTile tile) {
    tile.symbol = kPlayerOneSymbol;
    movesPlayer1.add(tile.id);
    currentPlayer = PlayerType.player2;
    currentPlayerName = "Player 2";
  }

  void _markBoardTileWithPlayer2(BoardTile tile) {
    tile.symbol = kPlayerTwoSymbol;
    movesPlayer2.add(tile.id);
    currentPlayer = PlayerType.player1;
    currentPlayerName = "Player 1";
  }

  void markBoardTileByIndex(int index) {
    final tile = tiles[index];
    if (currentPlayer == PlayerType.player1) {
      _markBoardTileWithPlayer1(tile);
    } else {
      _markBoardTileWithPlayer2(tile);
    }
    tile.enable = false;
  }

  bool _checkPlayerWinner(List<int> moves) {
    return kWinnerRules.any((rule) =>
        moves.contains(rule[0]) &&
        moves.contains(rule[1]) &&
        moves.contains(rule[2]));
  }

  WinnerType checkWinner() {
    if (_checkPlayerWinner(movesPlayer1)){
      winsPlayer1++;
      return WinnerType.player1;
    } 
    if (_checkPlayerWinner(movesPlayer2)){
      winsPlayer2++;
      return WinnerType.player2;
    } 
    return WinnerType.none;
  }

  int getBoardTileIdToAutomaticMove() {
    final candidates = List.generate(kBoardSize, (index) => index + 1);
    candidates.removeWhere((id) => movesPlayer1.contains(id));
    candidates.removeWhere((id) => movesPlayer2.contains(id));
    candidates.shuffle();
    return candidates[0];
  }
}
