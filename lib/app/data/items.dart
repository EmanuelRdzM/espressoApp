
import 'package:cafeteria_app/app/constants/constants.dart';

class Item {
  String? itemId;
  String? categoryId;
  String? nameItem;
  String? descriptionItem;
  String? imgItem;
  double? priceItem;

  Item({
    required this.nameItem,
    required this.itemId, 
    required this.categoryId, 
    required this.descriptionItem, 
    required this.imgItem,
    required this.priceItem, 
  });

  Item.fromDocument(String selectedItemId, String catId, Map<String, dynamic> doc){
    itemId = selectedItemId;
    categoryId = catId;

    nameItem = doc[NAME_ITEM];
    descriptionItem = doc[DESCRIPTION_ITEM];
    priceItem = doc[PRICE_ITEM];

    imgItem = doc[IMG_ITEM];
  }

  get userId => null;

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = <String, dynamic>{};
    //data[CATEGORY_ID] = categoryId;
    data[NAME_ITEM] = nameItem;
    data[DESCRIPTION_ITEM] = descriptionItem;
    data[PRICE_ITEM] = priceItem;
    data[IMG_ITEM] = imgItem;

    return data;
  }


}

