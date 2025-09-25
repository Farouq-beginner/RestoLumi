import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_top_screen.dart';
import 'home_footer_screen.dart';
import 'center_screen.dart';
import 'package:my_project/features/profile/dashboard.dart';
import 'package:equatable/equatable.dart';

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
                icon: const Icon(
                  Icons.account_circle,
                  color: Color(0xFFb71c1c),
                ),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileDashboard(
                        name: username ?? 'Guest',
                        email: widget.email ?? '-',
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
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
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
                      child: const Icon(Icons.local_offer),
                      tooltip: 'Lihat Penawaran',
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

