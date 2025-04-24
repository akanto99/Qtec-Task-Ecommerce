// class Pagination<T> {
//   final List<T> items;
//   final int itemsPerPage;
//   int _currentPage = 1;
//
//   Pagination({required this.items, this.itemsPerPage = 10});
//
//   int get currentPage => _currentPage;
//
//   int get totalPages => (items.length / itemsPerPage).ceil();
//
//   List<T> get currentItems {
//     final startIndex = (_currentPage - 1) * itemsPerPage;
//     final endIndex = (startIndex + itemsPerPage).clamp(0, items.length);
//     return items.sublist(startIndex, endIndex);
//   }
//
//   void nextPage() {
//     if (_currentPage < totalPages) _currentPage++;
//   }
//
//   void previousPage() {
//     if (_currentPage > 1) _currentPage--;
//   }
//
//   void goToPage(int page) {
//     if (page >= 1 && page <= totalPages) {
//       _currentPage = page;
//     }
//   }
//
//   bool get hasNext => _currentPage < totalPages;
//
//   bool get hasPrevious => _currentPage > 1;
// }
import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            TextButton(
              onPressed: () => onPageChanged(currentPage - 1),
              child: const Text("Previous"),
            ),
          Text("Page $currentPage of $totalPages"),
          if (currentPage < totalPages)
            TextButton(
              onPressed: () => onPageChanged(currentPage + 1),
              child: const Text("Next"),
            ),
        ],
      ),
    );
  }
}
