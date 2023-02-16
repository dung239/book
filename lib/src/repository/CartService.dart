import 'package:store/src/model/book.dart';
import 'package:store/src/model/cart.dart';

class CartService{
  static List<CartModel> cartItems = [];

  static CartService _singleton= CartService._internal();

  factory CartService(){
    return _singleton;
  }

  CartService._internal();

  static void addToCart(BookModel item, String _quanlity){
    var itemCart = CartModel(
        name: item.name,
        author: item.author,
        category: item.category,
        content: item.content,
        image: item.image,
        amount: item.amount,
        total: item.total,
        createAt: item.createAt,
        id: item.id,
        importPrice:item.importPrice,
        quanlity: _quanlity,
        price: item.price);
    cartItems.add(itemCart);
  }
  static void removeFromCart(CartModel item){
    cartItems.remove(item);
  }
  static List<CartModel> getCart(){
    return cartItems;
  }

}