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