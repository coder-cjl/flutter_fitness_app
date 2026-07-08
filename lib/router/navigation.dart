import 'package:go_router/go_router.dart';

class DLNavigation {
  final GoRouter _router;

  DLNavigation(this._router);

  String get currentLocation => _router.state.matchedLocation;

  void go(String location) {
    _router.go(location);
  }

  void goNamed(
    String routeName, {
    Map<String, String> params = const {},
    Map<String, dynamic> queryParams = const {},
  }) {
    _router.goNamed(
      routeName,
      pathParameters: params,
      queryParameters: queryParams,
    );
  }

  Future<T?> push<T>(String location) {
    return _router.push<T>(location);
  }

  Future<T?> replace<T>(String location) {
    return _router.replace<T>(location);
  }

  void pop<T>([T? result]) {
    if (!_router.canPop()) {
      return;
    }

    _router.pop<T>(result);
  }

  void pushNamed(
    String routeName, {
    Map<String, String> params = const {},
    Map<String, dynamic> queryParams = const {},
  }) {
    _router.pushNamed(
      routeName,
      pathParameters: params,
      queryParameters: queryParams,
    );
  }
}
