import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/swing_cubit.dart';
import 'swing_chart.dart';

class SwingDetailPage extends StatefulWidget {
  final String swingId;
  final int totalSwings;

  const SwingDetailPage({
    super.key,
    required this.swingId,
    required this.totalSwings,
  });

  @override
  State<SwingDetailPage> createState() => _SwingDetailPageState();
}

class _SwingDetailPageState extends State<SwingDetailPage>
    with TickerProviderStateMixin {
  late String currentSwingId;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    currentSwingId = widget.swingId;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToSwing(int newIndex, bool isNext, List<String> swingIds) {
    if (newIndex >= 0 && newIndex < swingIds.length && !_isAnimating) {
      final newSwingId = swingIds[newIndex];

      setState(() {
        _isAnimating = true;
      });

      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: isNext ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _animationController.forward().then((_) {
        context.read<SwingCubit>().selectSwing(newSwingId);

        setState(() {
          currentSwingId = newSwingId;
        });

        _slideAnimation = Tween<Offset>(
          begin: isNext ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));

        _animationController.reset();
        _animationController.forward().then((_) {
          setState(() {
            _isAnimating = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwingCubit, SwingState>(
      listener: (context, state) {
        if (state.swingIds.isEmpty) {
          Navigator.of(context).pop();
        } else if (state.selectedSwingId != null && state.selectedSwingId != currentSwingId) {
          if (!_isAnimating) {
            setState(() {
              _isAnimating = true;
            });

            final isNext = state.swingIds.indexOf(state.selectedSwingId!) >
                state.swingIds.indexOf(currentSwingId);

            _slideAnimation = Tween<Offset>(
              begin: Offset.zero,
              end: isNext ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ));

            _animationController.forward().then((_) {
              setState(() {
                currentSwingId = state.selectedSwingId!;
              });

              _slideAnimation = Tween<Offset>(
                begin: isNext ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ));

              _animationController.reset();
              _animationController.forward().then((_) {
                setState(() {
                  _isAnimating = false;
                });
              });
            });
          }
        }
      },
      child: BlocBuilder<SwingCubit, SwingState>(
        builder: (context, state) {
          final swingIds = state.swingIds;
          final currentIndex = swingIds.indexOf(currentSwingId);
          final totalSwings = swingIds.length;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Swing Analysis'),
              backgroundColor: const Color(0xFF1A1A1A),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A0A0A),
                    Color(0xFF1A1A1A),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF00E676).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Swing $currentSwingId',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'of $totalSwings swings',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.sports_golf,
                                color: Color(0xFF00E676),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: currentIndex <= 0
                                ? null
                                : () => navigateToSwing(currentIndex - 1, false, swingIds),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentIndex <= 0
                                  ? Colors.grey.withOpacity(0.3)
                                  : const Color(0xFF00E676),
                              foregroundColor: currentIndex <= 0
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: currentIndex >= totalSwings - 1
                                ? null
                                : () => navigateToSwing(currentIndex + 1, true, swingIds),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentIndex >= totalSwings - 1
                                  ? Colors.grey.withOpacity(0.3)
                                  : const Color(0xFF00E676),
                              foregroundColor: currentIndex >= totalSwings - 1
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: Card(
                        elevation: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.analytics,
                                      color: Color(0xFF00E676),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Flexion/Extension & Ulnar/Radial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: BlocBuilder<SwingCubit, SwingState>(
                                    builder: (context, state) {
                                      if (state.selectedSwingData != null &&
                                          state.selectedSwingId == currentSwingId) {
                                        return SwingChart(
                                          flexionExtensionData: state
                                              .selectedSwingData!.flexionExtension,
                                          ulnarRadialData:
                                              state.selectedSwingData!.ulnarRadial,
                                        );
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete Swing'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5252),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Delete Swing',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete Swing $currentSwingId? This action cannot be undone.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SwingCubit>().deleteSwing(currentSwingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}