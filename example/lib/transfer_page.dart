import 'package:flutter/material.dart';
import 'package:monero_flutter/entities/sweep_unlocked_request.dart';
import 'package:monero_flutter/entities/txs_request.dart';
import 'package:monero_flutter/transaction_api.dart' as api;

class TransferPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  TransferPage({super.key});

  void _getUtxos() async {
    try {
      _resultController.text = "please wait...";

      final utxos = await api.getUtxos();

      String result = "";

      for (final u in utxos) {
        result += "==amount=${u.amount} subaddressIndex=${u.subaddressIndex}  keyImage=${u.keyImage} isFrozen=${u.isFrozen} \r\n";
      }

      _resultController.text = result;
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getOutputs() async {
    try {
      String q = _resultController.text;

      // if (q.isEmpty) {
      //   q = "{}";
      // }

      _resultController.text = "please wait...";
      _resultController.text = await api.getOutputsAsJson(q);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTxs() async {
    try {
      final hash = _resultController.text;
      _resultController.text = "please wait...";
      _resultController.text = "numConfirmations=${(await api.getTxs(TxsRequest(txs: [TxsRequestBody(hash: hash)]))).blocks[0].txs[0].numConfirmations}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _describeTxSet() async {
    try {
      //final request = DescribeUnsignedTxRequest(unsignedTxHex: _resultController.text);
      //_resultController.text = "please wait...";
      //_resultController.text = "outputSum=${(await api.describeTxSet(request)).txs[0].outputSum}";
      _resultController.text = api.describeTxSetAsJsonSync(_resultController.text);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _sweepUnlocked() async {
    try {
      final address = _resultController.text;
      _resultController.text = "please wait...";
      final request = SweepUnlockedRequest(destinations: [SweepUnlockedRequestDestination(address: address)]);
      _resultController.text = "hash=${(await api.sweepUnlocked(request)).txSets[0].txs[0].hash}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTransfersAsJson() async {
    try {
      _resultController.text = await api.getAllTransfersAsJson();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTransfers() async {
    try {
      _resultController.text = "please wait...";
      _resultController.text = "amount=${(await api.getAllTransactions())[0].amount}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _thaw() async {
    try {
      final keyImage = _resultController.text;
      _resultController.text = "please wait...";
      await api.thaw(keyImage);
      _resultController.text = "ok";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _freeze() async {
    try {
      final keyImage = _resultController.text;
      _resultController.text = "please wait...";
      await api.freeze(keyImage);
      _resultController.text = "ok";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _isFrozen() async {
    try {
      final keyImage = _resultController.text;
      _resultController.text = "please wait...";
      _resultController.text = (await api.isFrozen(keyImage)).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _createTransaction() async {
    try {
      String jsonRequest = _resultController.text;
      _resultController.text = "please wait...";
      _resultController.text = await api.createExtendedTransactionAsJson(jsonRequest);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _relayTransaction() async {
    try {
      String request = _resultController.text;
      _resultController.text = "please wait...";
      _resultController.text = await api.relayTransaction(request);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Transfers')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get Utxos",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getUtxos,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get Outputs",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getOutputs,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get Txs",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getTxs,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Describe TxSet",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _describeTxSet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Sweep unlocked",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _sweepUnlocked,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                          Text("Get transfers (JSON)", style: TextStyle(fontSize: 22)),
                      onPressed: _getTransfersAsJson,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Get transfers", style: TextStyle(fontSize: 22)),
                      onPressed: _getTransfers,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Thaw", style: TextStyle(fontSize: 22)),
                      onPressed: _thaw,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Freeze", style: TextStyle(fontSize: 22)),
                      onPressed: _freeze,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("IsFrozen", style: TextStyle(fontSize: 22)),
                      onPressed: _isFrozen,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Crate transaction", style: TextStyle(fontSize: 22)),
                      onPressed: _createTransaction,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Relay transaction", style: TextStyle(fontSize: 22)),
                      onPressed: _relayTransaction,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
