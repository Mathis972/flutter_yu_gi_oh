import 'dart:ffi';

class cardModel {
  final int id;
  final String name;
  final String type;
  final String desc;
  final String race;
  final String url;
  final Map<CardSeller, double> prices;
  final List<CardSet> sets;
  final int? level;
  final String? attribute;

  cardModel({
    required this.id,
    required this.name,
    required this.type,
    required this.desc,
    required this.race,
    required this.url,
    required this.prices,
    required this.sets,
    this.level,
    this.attribute,
  });

  factory cardModel.fromJson(Map<String, dynamic> json) {
    List<CardSet> cardSets = [];
    if (json['card_sets'] != null) {
      for (var cardSet in json['card_sets']) {
        cardSets.add(CardSet(
            name: cardSet['set_name'],
            code: cardSet['set_code'],
            price: cardSet['set_price'] != null
                ? double.parse(cardSet['set_price'])
                : 0));
      }
    }

    return cardModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        desc: json['desc'],
        race: json['race'],
        url: json['card_images'][0]['image_url'],
        sets: cardSets,
        prices: {
          CardSeller.amazonPrice:
              double.parse(json['card_prices'][0]['amazon_price']),
          CardSeller.cardmarketPrice:
              double.parse(json['card_prices'][0]['cardmarket_price']),
          CardSeller.coolstuffincPrice:
              double.parse(json['card_prices'][0]['coolstuffinc_price']),
          CardSeller.ebayPrice:
              double.parse(json['card_prices'][0]['ebay_price']),
          CardSeller.tcgplayerPrice:
              double.parse(json['card_prices'][0]['tcgplayer_price'])
        },
        attribute: json['attribute'],
        level: json['level']);
  }
}

enum CardSeller {
  cardmarketPrice,
  tcgplayerPrice,
  ebayPrice,
  amazonPrice,
  coolstuffincPrice
}

class CardSet {
  final String name;
  final String code;
  final double price;

  CardSet({
    required this.name,
    required this.code,
    required this.price,
  });
}
