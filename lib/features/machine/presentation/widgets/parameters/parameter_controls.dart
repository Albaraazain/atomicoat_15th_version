import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/parameter.dart';
import '../../bloc/machine_bloc.dart';
import '../../bloc/machine_event.dart';

class ParameterControls extends StatefulWidget {
  final String machineId;
  final String componentId;
  final Parameter parameter;

  const ParameterControls({
    Key? key,
    required this.machineId,
    required this.componentId,
    required this.parameter,
  }) : super(key: key);

  @override
  State<ParameterControls> createState() => _ParameterControlsState();
}

class _ParameterControlsState extends State<ParameterControls> {
  late TextEditingController _controller;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.parameter.value;
    _controller = TextEditingController(
      text: widget.parameter.value.toStringAsFixed(2),
    );
  }

  @override
  void didUpdateWidget(ParameterControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parameter.value != widget.parameter.value) {
      _sliderValue = widget.parameter.value;
      _controller.text = widget.parameter.value.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double value) {
    setState(() {
      _sliderValue = value;
      _controller.text = value.toStringAsFixed(2);
    });
  }

  void _submitValue() {
    final value = double.tryParse(_controller.text);
    if (value != null) {
      context.read<MachineBloc>().add(
            SetParameterValueEvent(
              machineId: widget.machineId,
              componentId: widget.componentId,
              parameterId: widget.parameter.id,
              value: value,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Controls',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      suffixText: widget.parameter.unit,
                      border: const OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue != null) {
                        _updateValue(parsedValue);
                        _submitValue();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: _submitValue,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 48),
                    ),
                    child: const Text('Set'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  widget.parameter.minValue.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Expanded(
                  child: Slider(
                    value: _sliderValue,
                    min: widget.parameter.minValue,
                    max: widget.parameter.maxValue,
                    onChanged: _updateValue,
                    onChangeEnd: (value) => _submitValue(),
                  ),
                ),
                Text(
                  widget.parameter.maxValue.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildQuickSetButton(
                    context,
                    'Min',
                    widget.parameter.minValue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickSetButton(
                    context,
                    'Mid',
                    (widget.parameter.minValue + widget.parameter.maxValue) / 2,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickSetButton(
                    context,
                    'Max',
                    widget.parameter.maxValue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSetButton(
    BuildContext context,
    String label,
    double value,
  ) {
    return OutlinedButton(
      onPressed: () {
        _updateValue(value);
        _submitValue();
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
      ),
      child: Text(label),
    );
  }
}