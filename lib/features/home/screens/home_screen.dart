import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_top_screen.dart';
import 'home_footer_screen.dart';
import 'center_screen.dart';
import 'package:my_project/features/profile/admin_dashboard.dart';
import 'package:my_project/features/profile/user_dashboard.dart';
import 'package:equatable/equatable.dart';
import '../../../data/services/auth_service.dart';
import 'package:my_project/data/repositories/auth_repository.dart';
import '../widgets/search_sort.dart';
import '../data/menu_repository.dart';
import '../widgets/menu_item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? email;
  const HomeScreen({super.key, this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String formatRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  final ScrollController _scrollController = ScrollController();

  Future<void> _openSearchModal() async {
    final controller = SearchSortController();
  final scopeNotifier = ValueNotifier<String>('semua');
  final resultsNotifier = ValueNotifier<List<_SearchItem>>([]);
    final repo = MenuRepository();
  final all = await repo.getAll();
  final spesial = await repo.getSpecials();
    final makanan = all.where((e) => e.type == 'makanan').toList();
    final minuman = all.where((e) => e.type == 'minuman').toList();

  List<_SearchItem> mapItems(List<MenuItem> list) => list
    .map((e) => _SearchItem(type: e.type, name: e.name, price: e.price, item: e))
        .toList();

    void compute() {
      final scope = scopeNotifier.value;
      if (scope == 'spesial') {
        final filtered = filterAndSort<MenuItem>(
          all: spesial,
          query: controller.searchQuery.value,
          sortBy: controller.sortBy.value,
          nameOf: (e) => e.name,
          priceOf: (e) => e.price,
        );
        resultsNotifier.value = mapItems(filtered);
      } else if (scope == 'makanan') {
        final filtered = filterAndSort<MenuItem>(
          all: makanan,
          query: controller.searchQuery.value,
          sortBy: controller.sortBy.value,
          nameOf: (e) => e.name,
          priceOf: (e) => e.price,
        );
        resultsNotifier.value = mapItems(filtered);
      } else if (scope == 'minuman') {
        final filtered = filterAndSort<MenuItem>(
          all: minuman,
          query: controller.searchQuery.value,
          sortBy: controller.sortBy.value,
          nameOf: (e) => e.name,
          priceOf: (e) => e.price,
        );
        resultsNotifier.value = mapItems(filtered);
      } else {
        final allItems = [...makanan, ...minuman];
        final filtered = filterAndSort<MenuItem>(
          all: allItems,
          query: controller.searchQuery.value,
          sortBy: controller.sortBy.value,
          nameOf: (e) => e.name,
          priceOf: (e) => e.price,
        );
        resultsNotifier.value = mapItems(filtered);
      }
    }

    controller.searchQuery.addListener(compute);
    controller.sortBy.addListener(compute);
    scopeNotifier.addListener(compute);
    // initial compute
    compute();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.85,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Cari Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  // Search + Sort controls
                  SearchSortBar(controller: controller, hintText: 'Cari di semua menu...'),
                  // Scope chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ValueListenableBuilder<String>(
                      valueListenable: scopeNotifier,
                      builder: (context, scope, _) {
                        return Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('Semua'),
                              selected: scope == 'semua',
                              onSelected: (_) => scopeNotifier.value = 'semua',
                            ),
                            ChoiceChip(
                              label: const Text('Spesial'),
                              selected: scope == 'spesial',
                              onSelected: (_) => scopeNotifier.value = 'spesial',
                            ),
                            ChoiceChip(
                              label: const Text('Makanan'),
                              selected: scope == 'makanan',
                              onSelected: (_) => scopeNotifier.value = 'makanan',
                            ),
                            ChoiceChip(
                              label: const Text('Minuman'),
                              selected: scope == 'minuman',
                              onSelected: (_) => scopeNotifier.value = 'minuman',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Results
                  Expanded(
                    child: ValueListenableBuilder<List<_SearchItem>>(
                      valueListenable: resultsNotifier,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return const Center(child: Text('Tidak ada hasil.'));
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemBuilder: (context, i) {
                            final it = items[i];
                            return ListTile(
                              leading: Icon(
                                it.type == 'makanan' ? Icons.restaurant_menu : Icons.local_drink,
                                color: const Color(0xFFb71c1c),
                              ),
                              title: Text(it.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(formatRupiah(it.price.toInt())),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                if (it.item != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MenuItemDetailScreen(item: it.item!),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemCount: items.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      controller.dispose();
      scopeNotifier.dispose();
      resultsNotifier.dispose();
    });
  }

  // Unified search item holder
  // ignore: unused_element
  void _debugNoop() {}

  String? get username {
    final email = widget.email;
    if (email == null) return null;
    final idx = email.indexOf('@');
    return idx > 0 ? email.substring(0, idx) : email;
  }

  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeCubit.showOfferPopup();
    });
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>.value(
      value: _homeCubit,
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeShowOfferPopup) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_offer,
                            color: Color(0xFFb71c1c),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.offer,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFb71c1c),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54),
                        tooltip: 'Tutup',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is HomeShowOrderMessage) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFFb71c1c),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFb71c1c),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Home",
              style: TextStyle(
                color: Color(0xFFb71c1c),
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFFb71c1c)),
                  tooltip: 'Cari Menu',
                  onPressed: _openSearchModal,
                ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Color(0xFFb71c1c),
                ),
                tooltip: 'Profile',
                onPressed: () async {
                  final isAdmin = (widget.email != null &&
                      widget.email!.toLowerCase().trim() == 'farouq@gmail.com');
                  if (isAdmin) {
                    // Admin goes to AdminDashboard
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdminDashboard(
                          repository: AuthRepository(AuthService()),
                          adminEmail: widget.email ?? '-',
                        ),
                      ),
                    );
                    return;
                  }

                  // Regular user goes to UserDashboard, show verified badge if admin verified them
                  bool isVerified = false;
                  if (widget.email != null) {
                    try {
                      isVerified = await AuthService().isVerified(widget.email!);
                    } catch (_) {}
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserDashboard(
                        name: username ?? 'Guest',
                        email: widget.email ?? '-',
                        isVerified: isVerified,
                        saldo: 1573000000,
                        pendapatan: 6000000,
                        riwayatPesanan: [
                          {
                            'menu': 'Nasi Goreng',
                            'tanggal': '2025-09-16',
                            'total': 25000,
                          },
                          {
                            'menu': 'Ayam Bakar',
                            'tanggal': '2025-09-15',
                            'total': 35000,
                          },
                        ],
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFFb71c1c)),
                tooltip: 'Log Out',
                onPressed: () async {
                  // Clear token on logout
                  try {
                    final svc = AuthService();
                    await svc.logout();
                  } catch (_) {}
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              // menuList dan diskon sekarang dikelola di HomeMenuScreen
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 32,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth > 600
                                    ? 500
                                    : double.infinity,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    HomeTopScreen(username: username),
                                    // Tombol lihat daftar menu di tengah dan bisa diatur ukurannya
                                    const CenterScreen(),
                                    const SizedBox(height: 16),
                                    const SizedBox(height: 32),
                                    const HomeFooterScreen(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // FAB lain (promo)
                  Positioned(
                    bottom: 24,
                    left: 24,
                    child: FloatingActionButton(
                      heroTag: 'offer_fab',
                      backgroundColor: const Color(0xFFb71c1c),
                      foregroundColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.local_offer,
                                        color: Color(0xFFb71c1c),
                                        size: 48,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Promo Spesial Hari Ini! Diskon 30% untuk semua menu makanan.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFb71c1c),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black54,
                                    ),
                                    tooltip: 'Tutup',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      tooltip: 'Lihat Penawaran',
                      child: const Icon(Icons.local_offer),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchItem {
  final String type; // 'makanan' | 'minuman'
  final String name;
  final num price;
  final MenuItem? item;
  _SearchItem({required this.type, required this.name, required this.price, this.item});
}


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void showOfferPopup() {
    emit(const HomeShowOfferPopup('Promo Spesial Hari Ini! Diskon 30% untuk semua menu makanan.'));
  }

  void orderMenu(String menuName) {
    emit(HomeShowOrderMessage('Fitur pemesanan "$menuName" masih dalam pengembangan.'));
    emit(HomeInitial()); // Reset state agar bisa pesan lagi
  }
}


abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeShowOfferPopup extends HomeState {
  final String offer;
  const HomeShowOfferPopup(this.offer);
  @override
  List<Object?> get props => [offer];
}

class HomeShowOrderMessage extends HomeState {
  final String message;
  const HomeShowOrderMessage(this.message);
  @override
  List<Object?> get props => [message];
}

