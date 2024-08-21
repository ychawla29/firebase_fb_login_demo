import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FacebookLoginScreen(),
    );
  }
}

class FacebookLoginScreen extends StatefulWidget {
  const FacebookLoginScreen({super.key});

  @override
  FacebookLoginScreenState createState() => FacebookLoginScreenState();
}

class FacebookLoginScreenState extends State<FacebookLoginScreen> {
  Map<String, dynamic>? _userData;

  Future<void> _loginWithFacebook() async {
    final LoginResult result =
        await FacebookAuth.instance.login(permissions: ['public_profile']);

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      setState(() {
        _userData = userData;
      });
    } else {
      debugPrint(result.status.name);
      debugPrint(result.message);
    }
  }

  Future<void> _logout() async {
    await FacebookAuth.instance.logOut();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Login Demo'),
      ),
      body: Center(
        child: _userData == null
            ? ElevatedButton(
                onPressed: _loginWithFacebook,
                child: const Text('Login with Facebook'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage(_userData!['picture']['data']['url']),
                  ),
                  const SizedBox(height: 10),
                  Text('Name: ${_userData!['name']}'),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }
}
