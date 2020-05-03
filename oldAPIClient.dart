// _handle_button() async {
//     setState((){
//       _state = "loading";
//     });

//     print("creating request");
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
//     HttpClientRequest request;
//     if (_toggle == 0){
//       String url = covidNewsURL;
//       request = await client.getUrl(Uri.parse(url));
//       }else {
//        String url = nonCovidNewsURL;
//        request = await client.postUrl(Uri.parse(url));
//     }
//     HttpClientResponse response = await request.close();
//     String data = await response.transform(utf8.decoder).join();
//     print("request sent");
//     print(data);
    
//     //setState((){_resp_userId = decoded_data['userId'].toString();_resp_id = decoded_data['id'].toString(); _resp_title = decoded_data['title'].toString();});
//     setState(() {
//       var _decoded_data = json.decode(data);
//       _article_data = _decoded_data['news'];
//     });
//   }