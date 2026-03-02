import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/outlet.dart';
import '../services/api_service.dart';
import '../widgets/shimmer_loading.dart';

class _PdfViewerScreen extends StatefulWidget {
  final String menuUrl;

  const _PdfViewerScreen({required this.menuUrl});

  @override
  State<_PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<_PdfViewerScreen> {
  late final PdfViewerController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              _controller.zoomLevel = _controller.zoomLevel + 0.25;
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              _controller.zoomLevel = _controller.zoomLevel - 0.25;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.menuUrl,
            controller: _controller,
            onDocumentLoaded: (details) {
              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
            onDocumentLoadFailed: (details) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'Failed to load PDF: ${details.description}';
                });
              }
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  final ApiService _apiService = ApiService();
  List<Outlet> _outlets = [];
  List<Outlet> _filteredOutlets = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadOutlets();
  }

  Future<void> _loadOutlets() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final outlets = await _apiService.getOutlets();
      if (!mounted) return;
      setState(() {
        _outlets = outlets;
        _filteredOutlets = outlets;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load outlets. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _filterOutlets(String query) {
    setState(() {
      _filteredOutlets =
          _outlets
              .where(
                (outlet) =>
                    outlet.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _openPdfMenu(BuildContext context, String menuUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PdfViewerScreen(menuUrl: menuUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.8)),
          ),
        ),
        title: Text(
          'Outlets',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOutlets,
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 32),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: _filterOutlets,
                  decoration: InputDecoration(
                    hintText: 'Search outlets...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    filled: false,
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? _buildShimmerList()
                      : _hasError
                      ? _buildErrorWidget()
                      : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _filteredOutlets.length,
                        itemBuilder: (context, index) {
                          final outlet = _filteredOutlets[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap:
                                  () => _openPdfMenu(
                                    context,
                                    outlet.menuLink.trim().replaceAll('`', ''),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            outlet.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to view menu',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ShimmerLoading(
            width: double.infinity,
            height: 80,
            borderRadius: 12,
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadOutlets,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
