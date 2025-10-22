import 'package:flutter/material.dart';

class StageVisualization extends StatelessWidget {
  final String currentStage;
  final Function(String) onStageTap;

  const StageVisualization({
    Key? key,
    required this.currentStage,
    required this.onStageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStageColor().withOpacity(0.1),
            _getStageColor().withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Progress Text
          Text(
            'Support Level: ${currentStage.toUpperCase()}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getStageColor(),
            ),
          ),
          const SizedBox(height: 8),
          
          // Progress Bar
          LinearProgressIndicator(
            value: currentStage == 'companion' ? 0.3 : 0.8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getStageColor()),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          
          // Stage Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStageChip('Companion', 'companion'),
              _buildStageChip('Psychologist', 'psychologist'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageChip(String label, String stage) {
    final bool isActive = currentStage == stage;
    
    return GestureDetector(
      onTap: () => onStageTap(stage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? _getStageColor() : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isActive ? _getStageColor() : Colors.grey[400]!,
            width: 1,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: _getStageColor().withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              stage == 'companion' ? Icons.chat : Icons.psychology,
              size: 14,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStageColor() {
    return currentStage == 'companion' ? Colors.blue : Colors.purple;
  }
}