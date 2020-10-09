import 'package:flutter/material.dart';

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
          _buildPlayerMode(),
          _buildResetButton(),
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
        child: Center(
          child: Text(
            _controller.tiles[index].symbol,
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  _onReset() {
    setState(_controller.reset);
  }

  _showWinnerDialog(winner) {
    final symbol =
        winner == WinnerType.player1 ? kPlayerOneSymbol : kPlayerTwoSymbol;
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
