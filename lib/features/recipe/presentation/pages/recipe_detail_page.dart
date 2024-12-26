import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_step.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeDetailPage extends StatefulWidget {
  final String? recipeId;

  const RecipeDetailPage({Key? key, this.recipeId}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _substrateController;
  late TextEditingController _chamberTempController;
  late TextEditingController _pressureController;
  List<RecipeStep> _steps = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _substrateController = TextEditingController();
    _chamberTempController = TextEditingController();
    _pressureController = TextEditingController();

    if (widget.recipeId != null) {
      context.read<RecipeBloc>().add(RecipeEvent.getRecipeById(widget.recipeId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _substrateController.dispose();
    _chamberTempController.dispose();
    _pressureController.dispose();
    super.dispose();
  }

  void _loadRecipeData(Recipe recipe) {
    _nameController.text = recipe.name;
    _substrateController.text = recipe.substrate;
    _chamberTempController.text = recipe.chamberTemperatureSetPoint.toString();
    _pressureController.text = recipe.pressureSetPoint.toString();
    setState(() {
      _steps = List.from(recipe.steps);
    });
  }

  void _saveRecipe() {
    if (_nameController.text.isEmpty) {
      _showValidationError('Please enter a recipe name');
      return;
    }

    if (_substrateController.text.isEmpty) {
      _showValidationError('Please enter a substrate');
      return;
    }

    if (_steps.isEmpty) {
      _showValidationError('Please add at least one step to the recipe');
      return;
    }

    final recipe = Recipe(
      id: widget.recipeId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      substrate: _substrateController.text,
      steps: _steps,
      chamberTemperatureSetPoint: double.tryParse(_chamberTempController.text) ?? 150.0,
      pressureSetPoint: double.tryParse(_pressureController.text) ?? 1.0,
    );

    if (widget.recipeId == null) {
      context.read<RecipeBloc>().add(RecipeEvent.createRecipe(recipe));
    } else {
      context.read<RecipeBloc>().add(RecipeEvent.updateRecipe(recipe));
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAddStepDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Add Step',
                  style: TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.loop, color: Color(0xFF64FFDA)),
                title: const Text('Loop', style: TextStyle(color: Color(0xFFE0E0E0))),
                onTap: () {
                  Navigator.pop(context);
                  _addStep(StepType.loop);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward, color: Color(0xFF64FFDA)),
                title: const Text('Valve', style: TextStyle(color: Color(0xFFE0E0E0))),
                onTap: () {
                  Navigator.pop(context);
                  _addStep(StepType.valve);
                },
              ),
              ListTile(
                leading: const Icon(Icons.air, color: Color(0xFF64FFDA)),
                title: const Text('Purge', style: TextStyle(color: Color(0xFFE0E0E0))),
                onTap: () {
                  Navigator.pop(context);
                  _addStep(StepType.purge);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF64FFDA)),
                title: const Text('Set Parameter', style: TextStyle(color: Color(0xFFE0E0E0))),
                onTap: () {
                  Navigator.pop(context);
                  _addStep(StepType.setParameter);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addStep(StepType type) {
    setState(() {
      switch (type) {
        case StepType.loop:
          _steps.add(RecipeStep(
            type: StepType.loop,
            parameters: Map<String, dynamic>.from({'iterations': 1, 'temperature': null, 'pressure': null}),
            subSteps: [],
          ));
          break;
        case StepType.valve:
          _steps.add(RecipeStep(
            type: StepType.valve,
            parameters: Map<String, dynamic>.from({
              'valveType': ValveType.valveA.toString().split('.').last,
              'duration': 5
            }),
          ));
          break;
        case StepType.purge:
          _steps.add(RecipeStep(
            type: StepType.purge,
            parameters: Map<String, dynamic>.from({'duration': 10}),
          ));
          break;
        case StepType.setParameter:
          _steps.add(RecipeStep(
            type: StepType.setParameter,
            parameters: Map<String, dynamic>.from({
              'component': null,
              'parameter': null,
              'value': null,
            }),
          ));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        state.mapOrNull(
          loaded: (state) {
            if (widget.recipeId != null && state.recipes.isNotEmpty) {
              _loadRecipeData(state.recipes.first);
            }
          },
          saved: (_) {
            Navigator.pop(context);
          },
          error: (state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            title: Text(widget.recipeId == null ? 'Create Recipe' : 'Edit Recipe'),
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.save, color: Color(0xFF64FFDA)),
                onPressed: state.maybeMap(
                  saving: (_) => null,
                  orElse: () => _saveRecipe,
                ),
              ),
            ],
          ),
          body: state.maybeMap(
            loading: (_) => const Center(child: CircularProgressIndicator()),
            saving: (_) => const Center(child: CircularProgressIndicator()),
            orElse: () => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Recipe Name',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _substrateController,
                    label: 'Substrate',
                    icon: Icons.layers,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Global Parameters',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _chamberTempController,
                    label: 'Chamber Temperature (°C)',
                    icon: Icons.thermostat,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _pressureController,
                    label: 'Pressure (atm)',
                    icon: Icons.compress,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recipe Steps',
                        style: TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Step'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF121212),
                            backgroundColor: const Color(0xFF64FFDA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _showAddStepDialog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStepsList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Color(0xFFE0E0E0)),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        prefixIcon: Icon(icon, color: const Color(0xFF64FFDA)),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF64FFDA)),
        ),
      ),
    );
  }

  Widget _buildStepsList() {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return _buildStepCard(step, index);
      }).toList(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final RecipeStep item = _steps.removeAt(oldIndex);
          _steps.insert(newIndex, item);
        });
      },
    );
  }

  Widget _buildStepCard(RecipeStep step, int index) {
    return Card(
      key: ValueKey(step),
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(
          'Step ${index + 1}: ${_getStepTitle(step)}',
          style: const TextStyle(color: Color(0xFFE0E0E0)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepEditor(step),
                if (step.type == StepType.loop) _buildLoopSubSteps(step),
              ],
            ),
          ),
        ],
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF64FFDA)),
              onPressed: () => _showEditStepDialog(step, index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteStepDialog(index),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(RecipeStep step) {
    switch (step.type) {
      case StepType.loop:
        return 'Loop ${step.parameters['iterations']} times';
      case StepType.valve:
        return '${step.parameters['valveType'] == ValveType.valveA ? 'Valve A' : 'Valve B'} for ${step.parameters['duration']}s';
      case StepType.purge:
        return 'Purge for ${step.parameters['duration']}s';
      case StepType.setParameter:
        return 'Set ${step.parameters['component']} ${step.parameters['parameter']} to ${step.parameters['value']}';
      default:
        return 'Unknown Step';
    }
  }

  Widget _buildStepEditor(RecipeStep step) {
    switch (step.type) {
      case StepType.loop:
        return Column(
          children: [
            _buildNumberInput(
              label: 'Number of iterations',
              value: step.parameters['iterations'],
              onChanged: (value) {
                setState(() {
                  step.parameters['iterations'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildNumberInput(
              label: 'Temperature (°C)',
              value: step.parameters['temperature'],
              onChanged: (value) {
                setState(() {
                  step.parameters['temperature'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildNumberInput(
              label: 'Pressure (atm)',
              value: step.parameters['pressure'],
              onChanged: (value) {
                setState(() {
                  step.parameters['pressure'] = value;
                });
              },
            ),
          ],
        );
      case StepType.valve:
        return Column(
          children: [
            _buildDropdown<ValveType>(
              label: 'Valve',
              value: step.parameters['valveType'] != null
                ? ValveType.values.firstWhere(
                    (v) => v.toString().split('.').last == step.parameters['valveType']
                  )
                : ValveType.valveA,
              items: ValveType.values,
              onChanged: (value) {
                setState(() {
                  step.parameters['valveType'] = value.toString().split('.').last;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildNumberInput(
              label: 'Duration (seconds)',
              value: step.parameters['duration'],
              onChanged: (value) {
                setState(() {
                  step.parameters['duration'] = value;
                });
              },
            ),
          ],
        );
      case StepType.purge:
        return _buildNumberInput(
          label: 'Duration (seconds)',
          value: step.parameters['duration'],
          onChanged: (value) {
            setState(() {
              step.parameters['duration'] = value;
            });
          },
        );
      case StepType.setParameter:
        return _buildSetParameterEditor(step);
      default:
        return const Text(
          'Unknown Step Type',
          style: TextStyle(color: Color(0xFFE0E0E0)),
        );
    }
  }

  Widget _buildSetParameterEditor(RecipeStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown<String>(
          label: 'Component',
          value: step.parameters['component'],
          items: const ['Chamber', 'Pump', 'Heater', 'Valve'],
          onChanged: (value) {
            setState(() {
              step.parameters['component'] = value;
              step.parameters['parameter'] = null;
              step.parameters['value'] = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (step.parameters['component'] != null)
          _buildDropdown<String>(
            label: 'Parameter',
            value: step.parameters['parameter'],
            items: _getParameterOptions(step.parameters['component']),
            onChanged: (value) {
              setState(() {
                step.parameters['parameter'] = value;
                step.parameters['value'] = null;
              });
            },
          ),
        const SizedBox(height: 16),
        if (step.parameters['parameter'] != null)
          _buildNumberInput(
            label: 'Value',
            value: step.parameters['value'],
            onChanged: (value) {
              setState(() {
                step.parameters['value'] = value;
              });
            },
          ),
      ],
    );
  }

  List<String> _getParameterOptions(String component) {
    switch (component) {
      case 'Chamber':
        return ['Temperature', 'Pressure'];
      case 'Pump':
        return ['Speed', 'Power'];
      case 'Heater':
        return ['Temperature', 'Power'];
      case 'Valve':
        return ['Position', 'Flow Rate'];
      default:
        return [];
    }
  }

  Widget _buildNumberInput({
    required String label,
    required dynamic value,
    required Function(dynamic) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFB0B0B0)),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: value?.toString() ?? '',
            style: const TextStyle(color: Color(0xFFE0E0E0)),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            onChanged: (newValue) {
              onChanged(num.tryParse(newValue));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFB0B0B0)),
          ),
        ),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<T>(
            value: value,
            onChanged: onChanged,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                ),
              );
            }).toList(),
            dropdownColor: const Color(0xFF1E1E1E),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoopSubSteps(RecipeStep loopStep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Loop Steps:',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...loopStep.subSteps!.asMap().entries.map((entry) {
          int index = entry.key;
          RecipeStep subStep = entry.value;
          return _buildSubStepCard(subStep, index, loopStep);
        }).toList(),
        const SizedBox(height: 8),
        ElevatedButton(
          child: const Text('Add Loop Step'),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF121212),
            backgroundColor: const Color(0xFF64FFDA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _showAddStepDialog(),
        ),
      ],
    );
  }

  Widget _buildSubStepCard(RecipeStep step, int index, RecipeStep parentStep) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          'Substep ${index + 1}: ${_getStepTitle(step)}',
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF64FFDA)),
              onPressed: () => _showEditStepDialog(step, index, parentStep: parentStep),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  parentStep.subSteps!.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStepDialog(RecipeStep step, int index, {RecipeStep? parentStep}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Edit Step',
            style: TextStyle(color: Color(0xFFE0E0E0)),
          ),
          content: SingleChildScrollView(
            child: _buildStepEditor(step),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFF64FFDA)),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteStepDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Delete Step',
            style: TextStyle(color: Color(0xFFE0E0E0)),
          ),
          content: const Text(
            'Are you sure you want to delete this step?',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _steps.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }
}