class URLNetwork {
  urlNetwork() {
    var url = '127.0.0.1:5000';
    return url;
  }
}


String uri = URLNetwork().urlNetwork();

var refreshTokenURI = Uri.http(uri, 'ayush/api/refreshToken');

var currentUserURI = Uri.http(uri, 'ayush/api/currentUser');

var loginURI = Uri.http(uri, 'ayush/api/login');

var registerURI = Uri.http(uri, 'ayush/api/register');

var getItemsCategory = Uri.http(uri, 'ayush/api/items');

var getAllCartItems = Uri.http(uri, 'ayush/api/cartItems');

var getCartLenItems = Uri.http(uri, 'ayush/api/cartItemsLen');

var addNoteInItemItems = Uri.http(uri, 'ayush/api/addNote');

deleteItemFromCartItems(String itemName) {
  var deleteItemFromCartItems = Uri.http(
      uri, 'ayush/api/deleteFromCart/$itemName');
  return deleteItemFromCartItems;
}

var addToCartURI = Uri.http(uri, 'ayush/api/addItemToCart');

editQtyURI(String item, String qty) {
  var editQtyURI = Uri.http(
      uri, 'ayush/api/editCartItemQty/$item/$qty');
  return editQtyURI;
}

