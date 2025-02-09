import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  List<Map<String, dynamic>> tradeOffers = [];
  List<Map<String, dynamic>> myOffers = [];

  @override
  void initState() {
    super.initState();
    _loadTradeOffers();
  }

  Future<void> _loadTradeOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tradeOffers = List<Map<String, dynamic>>.from(
          (prefs.getStringList('trade_offers') ?? []).map((e) => Map<String, dynamic>.from(e as Map)));
      myOffers = List<Map<String, dynamic>>.from(
          (prefs.getStringList('my_offers') ?? []).map((e) => Map<String, dynamic>.from(e as Map)));
    });
  }

  void _makeOffer(String item) {
    setState(() {
      tradeOffers.add({'item': item, 'status': 'pending'});
    });
  }

  void _acceptOffer(int index) {
    setState(() {
      tradeOffers[index]['status'] = 'accepted';
    });
  }

  void _declineOffer(int index) {
    setState(() {
      tradeOffers[index]['status'] = 'declined';
    });
  }

  void _counterOffer(int index) {
    setState(() {
      tradeOffers[index]['status'] = 'counter';
    });
  }

  void _finalizeTrade(int index) {
    setState(() {
      tradeOffers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trade System')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tradeOffers.length,
              itemBuilder: (context, index) {
                final offer = tradeOffers[index];
                return Card(
                  child: ListTile(
                    title: Text('Trade Offer: ${offer['item']}'),
                    subtitle: Text('Status: ${offer['status']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _acceptOffer(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _declineOffer(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.compare_arrows),
                          onPressed: () => _counterOffer(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.done_all),
                          onPressed: () => _finalizeTrade(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _makeOffer('New Trade Item'),
              child: const Text('Make a Trade Offer'),
            ),
          ),
        ],
      ),
    );
  }
}
