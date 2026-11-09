import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const SupportFoundationApp());

class SupportFoundationApp extends StatelessWidget {
  const SupportFoundationApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'متره فونداسیون ساپورت‌ها',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF174A63)),
          useMaterial3: true,
        ),
        home: const SupportsHomePage(),
      );
}

class SupportsHomePage extends StatefulWidget {
  const SupportsHomePage({super.key});

  @override
  State<SupportsHomePage> createState() => _SupportsHomePageState();
}

class _SupportsHomePageState extends State<SupportsHomePage> {
  final _searchController = TextEditingController();
  late final Future<List<String>> _supportIdsFuture = _loadSupportIds();
  String _query = '';

  Future<List<String>> _loadSupportIds() async {
    final source = await rootBundle.loadString('data/supports.json');
    final document = jsonDecode(source) as Map<String, dynamic>;
    final supports = document['supports'] as List<dynamic>;
    return supports
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('متره فونداسیون ساپورت‌ها'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'پروژه خط لوله پروپان',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _SummaryValue(
                                  label: 'شناسه‌های مورد انتظار',
                                  value: '176',
                                ),
                              ),
                              Expanded(
                                child: _SummaryValue(
                                  label: 'داده‌های تأییدشده',
                                  value: '0',
                                ),
                              ),
                              Expanded(
                                child: _SummaryValue(
                                  label: 'حالت اجرا',
                                  value: 'آفلاین',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'ابعاد و مقادیر تا زمان کنترل با نقشه، داده قطعی محسوب نمی‌شوند.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'جستجوی شناسه ساپورت (مثلاً SU-034)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: _supportIdsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('خطا در خواندن فهرست آفلاین ساپورت‌ها'),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final query = _query.trim().toLowerCase();
                      final filteredIds = snapshot.data!
                          .where((id) => id.toLowerCase().contains(query))
                          .toList(growable: false);
                      if (filteredIds.isEmpty) {
                        return const Center(child: Text('ساپورتی پیدا نشد'));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredIds.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final id = filteredIds[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.foundation_outlined),
                            ),
                            title: Text(id, textDirection: TextDirection.ltr),
                            subtitle: const Text(
                              'در انتظار استخراج و کنترل نقشه',
                            ),
                            trailing: const Icon(Icons.chevron_left),
                            onTap: () => showModalBottomSheet<void>(
                              context: context,
                              builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        id,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        textDirection: TextDirection.ltr,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'جزئیات این ساپورت پس از کنترل ابعاد، '
                                        'تیپ فونداسیون و آرماتورگذاری ثبت خواهد شد.',
                                      ),
                                      const SizedBox(height: 16),
                                      const Chip(
                                        avatar: Icon(Icons.pending_outlined),
                                        label: Text(
                                          'داده هنوز تأیید نشده است',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      );
}
