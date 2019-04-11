class ApiOption {
  String url = '';
  String key = '';
  int type = 1;
  String token = '';
  ApiOption();

  ApiOption.generate({this.url, this.key, this.type});
  ApiOption.login({this.url, this.key, this.type, this.token});
}
