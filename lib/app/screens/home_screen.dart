import 'package:fiin_pocket/app/blocs/home_page/home_page_bloc.dart';
import 'package:fiin_pocket/app/core/widgets/common_svg_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utills/app_images.dart';
import '../core/widgets/exit_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final bloc = context.read<HomePageBloc>();
        int currentIndex = bloc.currentIndex;

        if (state is OnPageChangedState) {
          currentIndex = state.pageIndex;
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (result, data) async {
            // Prevent back navigation
            if (currentIndex > 0) {
              bloc.add(OnPageChanged(pageIndex: 0));
              return;
            } else {
              // Allow app to close if on the first page
              await showDialog<bool>(
                context: context,
                builder: (_) => const ExitDialog(),
              );
              return;
            }
            return;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: context.read<HomePageBloc>().pages[currentIndex],
            bottomNavigationBar: _buildBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                bloc.add(OnPageChanged(pageIndex: index));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar({
    required int currentIndex,
    void Function(int)? onTap,
  }) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,

      items: [
        BottomNavigationBarItem(
          icon: CommonSvgContainer(
            assetName: AppImages.expenseTracker,
            color: currentIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'Expense Tracker',
        ),
        BottomNavigationBarItem(
          icon: CommonSvgContainer(
            assetName: AppImages.calendarBlank,
            color: currentIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: CommonSvgContainer(
            assetName: AppImages.chartPie,
            color: currentIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'Reels',
        ),
      ],
    );
  }
}
