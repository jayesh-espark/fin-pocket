part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseLoadingState extends ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseSelectedState extends ExpenseState {
  final bool isExpenseSelected;
  ExpenseSelectedState({required this.isExpenseSelected});
}

final class ExpenseDateState extends ExpenseState {
  final DateTime selectedDate;
  ExpenseDateState({required this.selectedDate});
}

final class OnCategoryChangedState extends ExpenseState {
  final int selectedCategoryId;
  OnCategoryChangedState({required this.selectedCategoryId});
}

final class OnErrorState extends ExpenseState {
  final String message;
  OnErrorState({required this.message});
}

final class OnSaveExpenseState extends ExpenseState {
  final String amount;
  final String note;
  final int categoryId;
  final DateTime date;
  final bool isExpense;
  OnSaveExpenseState({
    required this.amount,
    required this.note,
    required this.categoryId,
    required this.date,
    required this.isExpense,
  });
}
