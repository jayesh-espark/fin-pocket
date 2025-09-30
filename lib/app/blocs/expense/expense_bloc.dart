import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/models/category_model.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  bool isExpenseSelected = true;
  DateTime selectedDate = DateTime.now();
  int selectedCategory = 1;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final List<CategoryItem> expenditureCategory = [
    CategoryItem(
      icon: Icons.shopping_basket_outlined,
      label: 'Market',
      color: const Color(0xFFE53E3E),
      id: 1,
    ),
    CategoryItem(
      icon: Icons.restaurant_outlined,
      label: 'Eat and drink',
      color: const Color(0xFFF6AD55),
      id: 2,
    ),
    CategoryItem(
      icon: Icons.shopping_cart_outlined,
      label: 'Shopping',
      color: const Color(0xFF4299E1),
      id: 3,
    ),
    CategoryItem(
      icon: Icons.local_gas_station_outlined,
      label: 'Gasoline',
      color: const Color(0xFF38B2AC),
      id: 4,
    ),
    CategoryItem(
      icon: Icons.home_outlined,
      label: 'House',
      color: const Color(0xFFAD6AFF),
      id: 5,
    ),
    CategoryItem(
      icon: Icons.flash_on_outlined,
      label: 'Electricity',
      color: const Color(0xFFF6E05E),
      id: 6,
    ),
    CategoryItem(
      icon: Icons.phone_android_outlined,
      label: 'Load phone',
      color: const Color(0xFF48BB78),
      id: 7,
    ),
    CategoryItem(
      icon: Icons.school_outlined,
      label: 'School',
      color: const Color(0xFF9F7AEA),
      id: 8,
    ),
    CategoryItem(
      icon: Icons.credit_card_outlined,
      label: 'Credit card',
      color: const Color(0xFF4299E1),
      id: 9,
    ),
  ];
  final List<CategoryItem> revenueCategory = [
    CategoryItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Salary',
      color: const Color(0xFFE53E3E),
      id: 1,
    ),
    CategoryItem(
      icon: Icons.monetization_on_outlined,
      label: 'Allowance',
      color: const Color(0xFFF6AD55),
      id: 2,
    ),
    CategoryItem(
      icon: Icons.card_giftcard_outlined,
      label: 'Bonus',
      color: const Color(0xFF4299E1),
      id: 3,
    ),
    CategoryItem(
      icon: Icons.trending_up_outlined,
      label: 'External income',
      color: const Color(0xFF38B2AC),
      id: 4,
    ),
    CategoryItem(
      icon: Icons.show_chart_outlined,
      label: 'Invest',
      color: const Color(0xFF9F7AEA),
      id: 5,
    ),
  ];

  ExpenseBloc() : super(ExpenseInitial()) {
    on<OnSelectExpenseTypeEvent>(_onSelectExpenseType);
    on<OnDateChangedEvent>(_onExpenseDateChanged);
    on<OnCategoryChangedEvent>(_onCategoryChangedEvent);
    on<OnSaveExpenseEvent>(_onSaveExpenseEvent);
  }

  void _onSelectExpenseType(
    OnSelectExpenseTypeEvent event,
    Emitter<ExpenseState> emit,
  ) {
    isExpenseSelected = event.isExpenseSelected;
    selectedCategory = 1;
    emit(OnCategoryChangedState(selectedCategoryId: selectedCategory));
    emit(ExpenseSelectedState(isExpenseSelected: isExpenseSelected));
  }

  void _onExpenseDateChanged(
    OnDateChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    selectedDate = event.date;
    emit(ExpenseSelectedState(isExpenseSelected: isExpenseSelected));
  }

  void _onCategoryChangedEvent(
    OnCategoryChangedEvent event,
    Emitter<ExpenseState> emit,
  ) {
    selectedCategory = event.categoryId;
    emit(OnCategoryChangedState(selectedCategoryId: selectedCategory));
  }

  Future<void> _onSaveExpenseEvent(
    OnSaveExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoadingState());
    if (amountController.text.isEmpty || noteController.text.isEmpty) {
      emit(OnErrorState(message: "Please fill all fields"));
      return;
    }
    await Future.delayed(const Duration(seconds: 2), () {});
    emit(
      OnSaveExpenseState(
        amount: amountController.text.trim(),
        note: noteController.text.trim(),
        categoryId: selectedCategory,
        date: selectedDate,
        isExpense: isExpenseSelected,
      ),
    );
  }
}
