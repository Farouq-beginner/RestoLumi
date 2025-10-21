import 'package:flutter/material.dart';

class Material3TestScreen extends StatelessWidget {
  const Material3TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Material 3 Test Page"),
        backgroundColor: scheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "🎨 Material 3 Active Test",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "Jika tampilan tombol, AppBar, dan NavigationBar terlihat modern dengan warna lembut, "
              "sudut besar, dan efek transparan halus — berarti Material 3 aktif!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // BUTTONS
            Text("🟢 Buttons", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text("FilledButton (M3)"),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text("FilledButton.tonal"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("ElevatedButton"),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("OutlinedButton"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("TextButton"),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // CARD
            Text("🟣 Card", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Ini adalah contoh Card dengan desain Material 3.\n"
                  "Perhatikan sudutnya yang lebih besar dan bayangan yang lembut.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // CHIPS
            Text("🟡 Filter Chips", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: const [
                FilterChip(label: Text("Pizza"), selected: true, onSelected: null),
                FilterChip(label: Text("Burger"), selected: false, onSelected: null),
                FilterChip(label: Text("Dessert"), selected: false, onSelected: null),
              ],
            ),

            const SizedBox(height: 32),

            // COLOR SCHEME PREVIEW
            Text("🎨 Color Scheme", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ColorBox(label: 'Primary', color: scheme.primary),
                _ColorBox(label: 'Secondary', color: scheme.secondary),
                _ColorBox(label: 'Tertiary', color: scheme.tertiary),
                _ColorBox(label: 'Error', color: scheme.error),
                _ColorBox(label: 'Surface', color: scheme.surface),
                _ColorBox(label: 'Background', color: scheme.background),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorBox({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

