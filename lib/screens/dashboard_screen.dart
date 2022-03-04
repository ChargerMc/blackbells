import 'package:animate_do/animate_do.dart';
import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/providers/push_notification_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:blackbells/screens/profile_screen.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:blackbells/widgets/dashboard/establishment_tile_widget.dart';
import 'package:blackbells/widgets/dashboard/custom_title_widget.dart';
import 'package:blackbells/widgets/dashboard/event_tile_widget.dart';
import 'package:blackbells/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/establishments_provider.dart';
import '../providers/socket_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final socket = ref.read(socketProvider);
    if (socket.serverStatus != ServerStatus.online) {
      await socket.connect();
    }
    await ref.read(pushNotificationProvider).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsProvider);
    final establishments = ref.watch(establishmentProvider);

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(eventsProvider);
            ref.refresh(establishmentProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                collapsedHeight: 100,
                flexibleSpace: FadeInLeft(
                  duration: const Duration(milliseconds: 800),
                  child: CustomTitle(
                    title: 'Rodadas.',
                    subtitle: 'Chequea nuestros siguientes eventos.',
                    padding: const EdgeInsets.all(14),
                    onPressed: () => NavigationService.navigateToSlideLeft(
                        const ProfileScreen()),
                    icon: const Icon(Icons.person),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: size.width * 0.6,
                  ),
                  child: Center(
                    child: events.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return FadeInRight(
                            child: Column(
                              children: [
                                LottieBuilder.asset(
                                  'assets/lotties/sad-skull.json',
                                  height: size.width * 0.4,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'No tenemos rodadas/eventos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (_, i) {
                            return FadeInRight(
                              child: EventTileWidget(
                                event: data[i],
                              ),
                            );
                          },
                        );
                      },
                      error: (_, e) {
                        return Text('$e');
                      },
                      loading: () {
                        return FadeInRight(
                          child: ShimmerEffect(
                            width: size.width * 0.8,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: PersistentHeader(
                  widget: FadeInLeft(
                    child: const CustomTitle(
                      title: 'Beneficios.',
                      subtitle: 'Hey Rider ¿listo para los beneficios?.',
                      padding: EdgeInsets.all(14),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      return establishments.when(
                        data: (data) {
                          if (data.isEmpty) {
                            return FadeInUp(
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Text(
                                    'No existen establecimientos registrados.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }
                          return FadeInRight(
                            child: EstablishmentTileWidget(
                              establishment: data[i],
                            ),
                          );
                        },
                        error: (_, __) {
                          return const SizedBox();
                        },
                        loading: () {
                          return FadeInRight(
                            child: ShimmerEffect(
                              height: size.width * 0.35,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 14,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          );
                        },
                      );
                    },
                    childCount: establishments.value != null
                        ? establishments.value!.isEmpty
                            ? 1
                            : establishments.value!.length
                        : 10,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: ref.read(userProvider).role == 'ADMIN_ROLE'
            ? FloatingActionButton.extended(
                icon: const Icon(Icons.dashboard),
                label: const Text('Admin'),
                onPressed: () =>
                    Navigator.pushNamed(context, BlackbellsRoutes.admin),
              )
            : null,
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: widget,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [blackbellsColor, blackbellsColor.withOpacity(0)],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 95.0;

  @override
  double get minExtent => 95.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
