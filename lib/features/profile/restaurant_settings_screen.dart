import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RestaurantSettingsScreen extends StatefulWidget {
  const RestaurantSettingsScreen({super.key});

  @override
  State<RestaurantSettingsScreen> createState() => _RestaurantSettingsScreenState();
}

class _RestaurantSettingsScreenState extends State<RestaurantSettingsScreen> {
  final ValueNotifier<DateTime> selectedDateVN = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<String> selectedLocaleVN = ValueNotifier<String>('id'); // Default locale

  final Map<String, String> localeOptions = {
    'id': 'Indonesia',
    'en': 'English',
    'ja': '日本語 (Japanese)',
    'fr': 'Français (French)',
    'de': 'Deutsch (German)',
  };

  @override
  void initState() {
    super.initState();
    _initializeLocale(selectedLocaleVN.value);
  }

  Future<void> _initializeLocale(String locale) async {
    await initializeDateFormatting(locale, null);
    Intl.defaultLocale = locale;
    selectedLocaleVN.value = locale;
  }

  String getFormattedDate(String locale, DateTime date) {
    try {
      return DateFormat.yMMMMEEEEd(locale).format(date);
    } catch (e) {
      return DateFormat('EEEE, dd MMMM yyyy').format(date);
    }
  }

  String getFormattedTime(String locale, DateTime date) {
    try {
      return DateFormat.Hms(locale).format(date);
    } catch (e) {
      return DateFormat('HH:mm:ss').format(date);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateVN.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      locale: Locale(selectedLocaleVN.value),
    );
    if (picked != null && picked != selectedDateVN.value) {
      selectedDateVN.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Restoran'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.orange, size: 32),
                title: Text(
                  'RestoLumi Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                ),
                subtitle: const Text('Atur tanggal, waktu, dan format internasional'),
              ),
            ),
            const SizedBox(height: 24),

            // Tanggal & Waktu
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Pengaturan Tanggal & Waktu',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<String>(
                      valueListenable: selectedLocaleVN,
                      builder: (context, selectedLocale, _) {
                        return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                          child: ValueListenableBuilder<DateTime>(
                            valueListenable: selectedDateVN,
                            builder: (context, selectedDate, __) {
                              return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal Terpilih:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                          const SizedBox(height: 4),
                          Text(
                            getFormattedDate(selectedLocale, selectedDate),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text('Waktu Saat Ini:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                          const SizedBox(height: 4),
                          Text(
                            getFormattedTime(selectedLocale, DateTime.now()),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.date_range),
                        label: const Text('Pilih Tanggal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Locale Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Format Internasional',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Pilih Bahasa/Lokasi:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ValueListenableBuilder<String>(
                          valueListenable: selectedLocaleVN,
                          builder: (context, selectedLocale, ___) {
                            return DropdownButton<String>(
                              value: selectedLocale,
                          isExpanded: true,
                          items: localeOptions.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              await _initializeLocale(newValue);
                              // _initializeLocale already updates the notifier
                            }
                          },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengaturan disimpan!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Pengaturan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
