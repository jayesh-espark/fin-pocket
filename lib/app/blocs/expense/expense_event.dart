part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

final class OnSelectExpenseTypeEvent extends ExpenseEvent {
  final bool isExpenseSelected;
  OnSelectExpenseTypeEvent({required this.isExpenseSelected});
}

final class OnDateChangedEvent extends ExpenseEvent {
  final DateTime date;
  OnDateChangedEvent({required this.date});
}

final class OnCategoryChangedEvent extends ExpenseEvent {
  final int categoryId;
  OnCategoryChangedEvent({required this.categoryId});
}

final class OnSaveExpenseEvent extends ExpenseEvent {
  OnSaveExpenseEvent();
}
