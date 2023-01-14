import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_yu_gi_oh/model/cart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CardDetailsWidget extends StatelessWidget {
  const CardDetailsWidget({
    super.key,
    required this.card,
  });
  final cardModel card;
  @override
  Widget build(BuildContext context) {
    List<double> princesList = card.prices.values.toList();
    princesList.sort((b, a) => a.compareTo(b));
    double max = princesList.first;
    List<_ChartData> data = [
      _ChartData('Amazon', card.prices[CardSeller.amazonPrice]),
      _ChartData('CardMarket', card.prices[CardSeller.cardmarketPrice]),
      _ChartData('CoolStuffInc', card.prices[CardSeller.coolstuffincPrice]),
      _ChartData('Ebay', card.prices[CardSeller.ebayPrice]),
      _ChartData('TCGPlayer', card.prices[CardSeller.tcgplayerPrice])
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: ListView(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Image.network(width: 300, card.url),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(textAlign: TextAlign.center, card.name),
              padding: EdgeInsets.all(8.0),
            ),
            Text(card.desc),
            const Text(textAlign: TextAlign.center, 'Prices'),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis:
                  NumericAxis(minimum: 0, maximum: max, interval: max / 4),
              series: [
                ColumnSeries(
                    dataLabelMapper: (datum, index) => '${datum.y}\$',
                    dataSource: data,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y)
              ],
            ),
            if (card.sets.isNotEmpty)
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Disponible dans ces sets :'),
                    for (var set in card.sets)
                      Container(
                        child: Text(set.name),
                        padding: EdgeInsets.all(8.0),
                      )
                  ])
          ],
        ),
      ]),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double? y;
}
