import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/expense/expense_bloc.dart';
import '../../core/models/category_model.dart';
import '../../core/utills/snackbar.dart';
import '../../core/widgets/catergory_card.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/common_loader.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  bool isExpenseSelected = true;
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Shopping';

  Widget _buildToggleButton(
    BuildContext context,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        final bloc = context.read<ExpenseBloc>();
        if (state is OnErrorState) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is OnSaveExpenseState) {
          log("state => ${state.categoryId}");
          log("state => ${state.date}");
          log("state => ${state.isExpense}");
          log("state => ${state.note}");
          log("state => ${state.amount}");
          showAppSnackBar(
            context,
            message: "Expense saved successfully",
            type: SnackType.success,
          );
        }
        bloc.noteController.clear();
        bloc.amountController.clear();
      },
      builder: (context, state) {
        final bloc = context.read<ExpenseBloc>();
        if (state is ExpenseLoadingState) {
          return CommonLoaderScreen();
        }
        var categoryList = bloc.isExpenseSelected
            ? bloc.expenditureCategory
            : bloc.revenueCategory;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Toggle Buttons
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonTheme.colorScheme?.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          context,
                          'Expenditure',
                          bloc.isExpenseSelected,
                          () => bloc.add(
                            OnSelectExpenseTypeEvent(isExpenseSelected: true),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildToggleButton(
                          context,
                          'Revenue',
                          !bloc.isExpenseSelected,
                          () => bloc.add(
                            OnSelectExpenseTypeEvent(isExpenseSelected: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Date Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time', style: Theme.of(context).textTheme.bodyLarge),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => bloc.add(
                            OnDateChangedEvent(
                              date: bloc.selectedDate.subtract(
                                const Duration(days: 1),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _formatDate(bloc.selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => bloc.add(
                            OnDateChangedEvent(
                              date: bloc.selectedDate.add(
                                const Duration(days: 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Amount Input
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Amount',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: bloc.amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter the amount',
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 16, top: 12),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Note Input
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Note',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: bloc.noteController,
                        decoration: const InputDecoration(
                          hintText: 'Enter notes',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Category Section
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categoryList[index];
                        final isSelected = bloc.selectedCategory == category.id;

                        return CategoryCard(
                          category: category,
                          isSelected: isSelected,
                          onTap: () => bloc.add(
                            OnCategoryChangedEvent(categoryId: category.id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.add(OnSaveExpenseEvent());
                    },
                    child: const Text('Save expenses'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
