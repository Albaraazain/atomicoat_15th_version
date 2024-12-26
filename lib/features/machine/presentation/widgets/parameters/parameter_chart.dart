import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/parameter.dart';
import '../../bloc/machine_bloc.dart';
import '../../bloc/machine_event.dart';
import '../../bloc/machine_state.dart';

class ParameterChart extends StatefulWidget {
  final String machineId;
  final String componentId;
  final Parameter parameter;

  const ParameterChart({
    Key? key,
    required this.machineId,
    required this.componentId,
    required this.parameter,
  }) : super(key: key);

  @override
  State<ParameterChart> createState() => _ParameterChartState();
}

class _ParameterChartState extends State<ParameterChart> {
  final List<Parameter> _history = [];
  final int _maxDataPoints = 100;
  DateTime _startTime = DateTime.now().subtract(const Duration(hours: 1));
  DateTime _endTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    context.read<MachineBloc>().add(
          GetParameterHistoryEvent(
            machineId: widget.machineId,
            componentId: widget.componentId,
            parameterId: widget.parameter.id,
            startTime: _startTime,
            endTime: _endTime,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildTimeRangeSelector(context),
            const SizedBox(height: 24),
            Expanded(
              child: _buildChart(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parameter History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              widget.parameter.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadHistory,
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    return SegmentedButton<Duration>(
      segments: const [
        ButtonSegment(
          value: Duration(hours: 1),
          label: Text('1h'),
        ),
        ButtonSegment(
          value: Duration(hours: 6),
          label: Text('6h'),
        ),
        ButtonSegment(
          value: Duration(hours: 24),
          label: Text('24h'),
        ),
        ButtonSegment(
          value: Duration(days: 7),
          label: Text('7d'),
        ),
      ],
      selected: {_endTime.difference(_startTime)},
      onSelectionChanged: (Set<Duration> selection) {
        setState(() {
          _endTime = DateTime.now();
          _startTime = _endTime.subtract(selection.first);
          _loadHistory();
        });
      },
    );
  }

  Widget _buildChart(BuildContext context) {
    return BlocBuilder<MachineBloc, MachineState>(
      builder: (context, state) {
        if (state is ParameterHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ParameterHistoryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: _loadHistory,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ParameterHistoryLoaded) {
          _history.clear();
          _history.addAll(state.parameters);
          if (_history.isEmpty) {
            return const Center(
              child: Text('No data available for the selected time range'),
            );
          }
        }

        return LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final time = DateTime.fromMillisecondsSinceEpoch(
                      value.toInt(),
                    );
                    return Text(
                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            minX: _startTime.millisecondsSinceEpoch.toDouble(),
            maxX: _endTime.millisecondsSinceEpoch.toDouble(),
            minY: widget.parameter.minValue,
            maxY: widget.parameter.maxValue,
            lineBarsData: [
              LineChartBarData(
                spots: _history
                    .map((p) => FlSpot(
                          p.lastUpdated.millisecondsSinceEpoch.toDouble(),
                          p.value,
                        ))
                    .toList(),
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final time = DateTime.fromMillisecondsSinceEpoch(
                      spot.x.toInt(),
                    );
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(2)} ${widget.parameter.unit}\n'
                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}