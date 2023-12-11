import "package:flutter/material.dart";

import "package:webview_flutter/webview_flutter.dart";

class HomeScreen extends StatelessWidget {
  // const 생성자
  HomeScreen({Key? key}) : super(key: key);

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading Bar
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }))
    ..loadRequest(Uri.parse("https://blog.codefactory.ai/"));

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text(
              "Code Factory",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    controller.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    if (controller != null) {
                      controller!.loadRequest(
                          Uri.parse("https://blog.codefactory.ai/"));
                    }
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    controller.goForward();
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )),
            ]),
        body: WebViewWidget(controller: controller)));
  }
}
