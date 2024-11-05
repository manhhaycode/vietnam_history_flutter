import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLoginPage extends StatefulWidget {
  final String loginUrl;
  final String callbackUrl;

  const WebViewLoginPage(
      {super.key, required this.loginUrl, required this.callbackUrl});

  @override
  State<WebViewLoginPage> createState() => _WebViewLoginPageState();
}

class _WebViewLoginPageState extends State<WebViewLoginPage> {
  WebViewController? _controller;

  @override
  void initState() {
    print('initState');
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print('onPageStarted: $url');
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            print('onWebResourceError: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://github.com/bahrie127'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: WebViewWidget(controller: _controller!));
  }
}
