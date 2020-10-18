import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../controllers/game_controller.dart';
import '../core/constants.dart';
import '../enums/winner_type.dart';
import '../widgets/custom_dialog.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(kGameTitle),
      centerTitle: true,
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBoard(),
          _buildCurentPlayer(_controller.currentPlayerName),
          _buildVerticalSpace(height: 7.0),
          _buildCurentScore(_controller.winsPlayer1.toString(), _controller.winsPlayer2.toString()),
          _buildVerticalSpace(height: 15),
          _buildPlayerMode(),
          _buildVerticalSpace(height: 15),
          _buildResetButton(),
          _buildVerticalSpace(height: 7.0),
          _buildShareButton(),
        ],
      ),
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kBoardColumnCount,
          crossAxisSpacing: kBoardSpace,
          mainAxisSpacing: kBoardSpace,
        ),
        itemBuilder: _buildBoardTile,
        itemCount: kBoardSize,
        padding: const EdgeInsets.all(kBoardSpace),
      ),
    );
  }

  Widget _buildBoardTile(context, index) {
    return GestureDetector(
      onTap: () => _onMarkTile(index),
      child: Container(
        color: _controller.tiles[index].color,
        child: Image.asset(
            _controller.tiles[index].symbol,
          ),
        ),
    );
  }

  _onMarkTile(index) {
    if (!_controller.tiles[index].enable) return;

    setState(() {
      _controller.markBoardTileByIndex(index);
    });

    _checkWinner();
  }

  _checkWinner() {
    final winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isBotTurn) {
        _onMarkTileByBot();
      }
    } else {
      _showWinnerDialog(winner);
    }
  }

  _onMarkTileByBot() {
    final id = _controller.getBoardTileIdToAutomaticMove();
    final index = _controller.tiles.indexWhere((tile) => tile.id == id);
    _onMarkTile(index);
  }

  _buildCurentPlayer(String player) {
      return Container(
      color: Theme.of(context).accentColor.withOpacity(0.2),
      height: 40,
      child: Center(
        child: Text(
          'Playing now: $player',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildCurentScore(String scorePlayer1, String scorePlayer2) {
      return Container(
      color: Theme.of(context).accentColor.withOpacity(0.2),
      height: 40,
      child: Center(
        child: Text(
          'Player 1: $scorePlayer1   X   Player 2: $scorePlayer2',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(
        _controller.isSinglePlayer ? kSinglePlayerLabel : kMultiPlayerLabel,
      ),
      secondary: Icon(
        _controller.isSinglePlayer ? kSinglePlayerIcon : kMultiPlayerIcon,
      ),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }

  _buildResetButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(kResetButtonLabel),
      onPressed: _onReset,
    );
  }

  _buildShareButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(kShareButtonLabel),
      onPressed: _onShare,
    );
  }

_buildVerticalSpace({double height = 20.0}) {
    return SizedBox(height: height);
  }

  _onReset() {
    setState(_controller.reset);
  }

  _onShare() {
    Share.share('See my project on Github - https://github.com/FuzariFrancisco/TicTacToe-Flutter');
  }

  _showWinnerDialog(winner) {
    final symbol =
        winner == WinnerType.player1 ? 'Player 1' : 'Player 2';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: kDialogTitleWinner.replaceAll(kWinSymbol, symbol),
          message: kDialogMessage,
          onPressed: _onReset,
        );
      },
    );
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: kTiedDialogMessage,
          message: kDialogMessage,
          onPressed: _onReset,
        );
      },
    );
  }
}
