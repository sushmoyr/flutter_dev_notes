import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'view_model.dart';

class View<T extends ViewModel> extends StatefulWidget {
  final T Function(BuildContext context) viewModelBuilder;
  final Widget Function(BuildContext context, T viewModel) builder;

  const View({
    Key? key,
    required this.builder,
    required this.viewModelBuilder,
  }) : super(key: key);

  @override
  _ViewState createState() => _ViewState<T>();
}

class _ViewState<T extends ViewModel> extends State<View<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: widget.viewModelBuilder(context),
      child: Consumer<T>(
        builder: _buildUi,
      ),
    );
  }

  Widget _buildUi(BuildContext context, T viewModel, Widget? child) =>
      !viewModel.initialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                widget.builder(context, viewModel),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  color:
                      viewModel.isLoading ? Colors.black26 : Colors.transparent,
                  child: Visibility(
                    visible: viewModel.isLoading,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                if (viewModel.isLoading)
                  const ModalBarrier(
                    dismissible: false,
                  ),
              ],
            );
}
