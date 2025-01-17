import 'package:flutter/material.dart';

class SliverAppBarTitle extends StatefulWidget {
  final Widget child;

  const SliverAppBarTitle({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _SliverAppBarTitleState createState() {
    return new _SliverAppBarTitleState();
  }
}

class _SliverAppBarTitleState extends State<SliverAppBarTitle> {
  late ScrollPosition _position;
  late bool _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  void initState() {
    _position = Scrollable.of(context).position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: SizedBox(
        width: double.infinity,
        child: widget.child,
      ),
    );
  }
}
