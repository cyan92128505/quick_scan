import 'package:http/http.dart';
import 'package:http_retry/http_retry.dart';

class HttpService {
  HttpService();

  Future<Response> exec(
    String path,
    dynamic data,
    int duration,
    int count,
  ) async {
    RetryClient client = new RetryClient(
      new Client(),
      retries: count,
      delay: (r) => new Duration(milliseconds: duration),
      when: (response) => response.statusCode != 200,
      whenError: (dynamic error, StackTrace stackTrace) {
        print(stackTrace);
        return true;
      },
      onRetry: (
        BaseRequest request,
        BaseResponse response,
        int retryCount,
      ) =>
          print('retry!'),
    );

    Response response = await client.post(path, body: data);
    print(response.body);
    client.close();

    return response;
  }
}
