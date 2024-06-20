import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Tasks'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String result = await fetchData();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(result),
                  ),
                );
                print(result);
              },
              child: const Text('Async/Await Task'),
            ),
            
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () {
                ref.read(counterProvider.notifier).state++;
                int result = ref.watch(counterProvider);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(result.toString()),
                  ),
                );
              },
              child: const Text('Provider Task'),
            ),
            
            const SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: () {
                ref.read(riverpodCounterProvider.notifier).increment();
                int result = ref.watch(riverpodCounterProvider);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(result.toString()),
                  ),
                );
              },
              child: const Text('Riverpod Task'),
            ),
            
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () async {
                String result = await fetchHttpData();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(result),
                  ),
                );
              },
              child: const Text('HTTP Task'),
            ),
            
            const SizedBox(height: 20,),
            
            ElevatedButton(
              onPressed: () async {
                String result = await fetchDioData();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(result),
                  ),
                );
              },
              child: const Text('Dio Task'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> fetchData() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  return response.statusCode == 200 ? response.body : throw Exception('Failed to load data');
}

Future<String> fetchHttpData() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  return response.statusCode == 200 ? response.body : throw Exception('Failed to load data');
}

Future<String> fetchDioData() async {
  try {
    var response = await Dio().get('https://jsonplaceholder.typicode.com/posts/1');
    return response.data.toString();
  } catch (e) {
    throw Exception('Failed to load data');
  }
}

final counterProvider = StateProvider<int>((ref) => 0);

final riverpodCounterProvider = StateNotifierProvider<RiverpodCounter, int>((ref) => RiverpodCounter());

class RiverpodCounter extends StateNotifier<int> {
  RiverpodCounter() : super(0);

  void increment() {
    state++;
  }
}
