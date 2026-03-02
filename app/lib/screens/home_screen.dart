import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:pufood/screens/comparison_screen.dart';
import '../models/food_item.dart';
import '../services/api_service.dart';

class FilterBottomSheet extends StatelessWidget {
  final Function(String) onFilterApplied;
  final String selectedOutlet;

  const FilterBottomSheet({
    Key? key,
    required this.onFilterApplied,
    required this.selectedOutlet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final outlets = ['All', 'Food Court', 'Cafeteria', 'Restaurant'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Outlet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...outlets.map(
            (outlet) => RadioListTile<String>(
              title: Text(outlet),
              value: outlet,
              groupValue: selectedOutlet,
              onChanged: (value) {
                if (value != null) {
                  onFilterApplied(value);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<FoodItem> _foodItems = [];
  List<FoodItem> _filteredItems = [];
  List<FoodItem> _selectedItems = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool get _canCompare =>
      _selectedItems.length >= 2 && _selectedItems.length <= 4;

  static const Color primaryColor = Color.fromARGB(255, 255, 0, 0);
  static const Color redPriceColor = Color(0xFFE53935);
  static const Color backgroundColor = Color(0xFFF5F5F7);

  final List<String> _filterOptions = [
    'All',
    'Price: Low to High',
    'Price: High to Low',
    'High Protein',
    'Custom Price Range',
  ];

  Widget _nutritionChip({required String label, required double value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(1)}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3436),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      print('Fetching food items...');
      final items = await _apiService.getFoodItems();
      print('Fetched ${items.length} food items');
      if (!mounted) return;
      items.shuffle();
      setState(() {
        _foodItems = items;
        _filteredItems = items;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching food items: $e');
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterItems() {
    setState(() {
      var items = List<FoodItem>.from(_foodItems);

      switch (_selectedFilter) {
        case 'Price: Low to High':
          items.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          items.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'High Protein':
          items.sort((a, b) => b.protein.compareTo(a.protein));
          break;
        case 'Custom Price Range':
          items =
              items
                  .where(
                    (item) =>
                        item.price >= _minPrice && item.price <= _maxPrice,
                  )
                  .toList();
          break;
      }

      _filteredItems =
          items
              .where(
                (item) => item.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
      print('Filtered items: ${_filteredItems.length}');
    });
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage.isNotEmpty ? _errorMessage : 'Failed to load items',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadFoodItems,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No food items found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadFoodItems,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Building HomeScreen: isLoading=$_isLoading, hasError=$_hasError, filteredItems=${_filteredItems.length}',
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.white),
              ),
            ),
            title: Image.asset(
              'assets/images/pufood_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterItems();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search food items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder:
                              (context) => StatefulBuilder(
                                builder:
                                    (context, setState) => Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Filter Options',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromARGB(
                                                255,
                                                193,
                                                36,
                                                36,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ..._filterOptions.map(
                                            (filter) => RadioListTile<String>(
                                              title: Text(filter),
                                              value: filter,
                                              groupValue: _selectedFilter,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedFilter = value!;
                                                });
                                                if (value !=
                                                    'Custom Price Range') {
                                                  Navigator.pop(context);
                                                  _filterItems();
                                                }
                                              },
                                            ),
                                          ),
                                          if (_selectedFilter ==
                                              'Custom Price Range') ...[
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Price Range',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            RangeSlider(
                                              values: RangeValues(
                                                _minPrice,
                                                _maxPrice,
                                              ),
                                              min: 0,
                                              max: 1000,
                                              divisions: 20,
                                              labels: RangeLabels(
                                                '₹${_minPrice.toStringAsFixed(0)}',
                                                '₹${_maxPrice.toStringAsFixed(0)}',
                                              ),
                                              onChanged: (RangeValues values) {
                                                setState(() {
                                                  _minPrice = values.start;
                                                  _maxPrice = values.end;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _filterItems();
                                              },
                                              child: const Text(
                                                'Apply Price Range',
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                              ),
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),
            actions: [
              if (_selectedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    '${_selectedItems.length} selected',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child:
                _isLoading
                    ? SizedBox(
                      height:
                          MediaQuery.of(context).size.height -
                          (kToolbarHeight + 60),
                      child: _buildLoadingWidget(),
                    )
                    : _hasError
                    ? SizedBox(
                      height:
                          MediaQuery.of(context).size.height -
                          (kToolbarHeight + 60),
                      child: _buildErrorWidget(),
                    )
                    : _filteredItems.isEmpty
                    ? SizedBox(
                      height:
                          MediaQuery.of(context).size.height -
                          (kToolbarHeight + 60),
                      child: _buildEmptyWidget(),
                    )
                    : const SizedBox.shrink(),
          ),
          if (!_isLoading && !_hasError && _filteredItems.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      MediaQuery.of(context).size.width > 600
                          ? 300
                          : MediaQuery.of(context).size.width > 400
                          ? 200
                          : 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 600 ? 0.85 : 0.75,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _filteredItems[index];
                  final isSelected = _selectedItems.contains(item);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.remove(item);
                        } else if (_selectedItems.length < 4) {
                          _selectedItems.add(item);
                        }
                      });
                    },
                    child: AnimatedScale(
                      scale: isSelected ? 0.98 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                isSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.grey[50]!],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.width > 600
                                      ? 200
                                      : 150,
                              maxHeight:
                                  MediaQuery.of(context).size.width > 600
                                      ? 300
                                      : 250,
                              minWidth:
                                  MediaQuery.of(context).size.width > 600
                                      ? 150
                                      : 100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.name.isNotEmpty
                                                ? item.name
                                                : 'Unknown Item',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  MediaQuery.of(
                                                            context,
                                                          ).size.width >
                                                          600
                                                      ? 18
                                                      : 16,
                                              height: 1.4,
                                              color: const Color(0xFF2D3436),
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            item.outlet.isNotEmpty
                                                ? item.outlet
                                                : 'Unknown Outlet',
                                            style: const TextStyle(
                                              color: Color(0xFF2D3436),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '₹${item.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: redPriceColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _nutritionChip(
                                        label: 'P',
                                        value: item.protein,
                                      ),
                                      _nutritionChip(
                                        label: 'C',
                                        value: item.carbs,
                                      ),
                                      _nutritionChip(
                                        label: 'F',
                                        value: item.fat,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: _filteredItems.length),
              ),
            ),
        ],
      ),
      floatingActionButton:
          _selectedItems.isNotEmpty
              ? AnimatedOpacity(
                opacity: _canCompare ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton.extended(
                  onPressed:
                      _canCompare
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ComparisonScreen(items: _selectedItems),
                              ),
                            );
                          }
                          : null,
                  label: const Text('Compare'),
                  icon: const Icon(Icons.compare_arrows),
                  backgroundColor:
                      _canCompare
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : Colors.grey[400],
                  elevation: 6,
                ),
              )
              : null,
    );
  }
}
