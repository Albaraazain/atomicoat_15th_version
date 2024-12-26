import 'package:flutter/material.dart';
import '../../../domain/entities/parameter.dart';

class ParameterValueDisplay extends StatelessWidget {
  final Parameter parameter;

  const ParameterValueDisplay({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameter.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getParameterTypeText(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                _buildStatusIndicator(context),
              ],
            ),
            const SizedBox(height: 16),
            _buildValueDisplay(context),
            const SizedBox(height: 8),
            _buildRangeIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final color = parameter.isInRange ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            parameter.isInRange ? Icons.check_circle : Icons.warning,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            parameter.isInRange ? 'In Range' : 'Out of Range',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueDisplay(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          parameter.value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: parameter.isInRange ? Colors.blue : Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            parameter.unit,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildRangeIndicator(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${parameter.minValue.toStringAsFixed(2)} ${parameter.unit}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Max: ${parameter.maxValue.toStringAsFixed(2)} ${parameter.unit}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (parameter.value - parameter.minValue) /
              (parameter.maxValue - parameter.minValue),
          backgroundColor: Colors.grey[200],
          color: parameter.isInRange ? Colors.blue : Colors.red,
        ),
      ],
    );
  }

  String _getParameterTypeText() {
    switch (parameter.type) {
      case ParameterType.temperature:
        return 'Temperature';
      case ParameterType.pressure:
        return 'Pressure';
      case ParameterType.flow:
        return 'Flow Rate';
      case ParameterType.power:
        return 'Power';
      case ParameterType.voltage:
        return 'Voltage';
      case ParameterType.current:
        return 'Current';
      case ParameterType.signalQuality:
        return 'Signal Quality';
      case ParameterType.purity:
        return 'Purity';
      case ParameterType.humidity:
        return 'Humidity';
      case ParameterType.concentration:
        return 'Concentration';
    }
  }
}