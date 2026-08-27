import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
//  MilkBarChart  –  Daily production bar chart
//  • Always renders bars (even for 1 day)
//  • Fixed Y-axis with clear labels (0L / 10L / 20L …)
//  • Value label above every bar
//  • X-axis labels sit BELOW the 0L baseline
//  • Today's bar highlighted
//  • Tap a bar → tooltip overlay
//  • Horizontally scrollable
// ─────────────────────────────────────────────────────────
class MilkBarChart extends StatefulWidget {
  const MilkBarChart({
    super.key,
    required this.dataPoints,
    required this.xLabels,
    this.barColor = const Color(0xFF2D6A4F),
    // Legacy params accepted for compatibility
    Color? lineColor,
    Color? fillColor,
    List<DateTime>? originalDates,
    this.unit = 'L',
    this.height = 220,
    this.barWidthPx = 28.0,
    this.barSpacingPx = 10.0,
  });

  final List<double> dataPoints;
  final List<String> xLabels;
  final Color barColor;
  final String unit;
  final double height;
  final double barWidthPx;
  final double barSpacingPx;

  @override
  State<MilkBarChart> createState() => _MilkBarChartState();
}

class _MilkBarChartState extends State<MilkBarChart> {
  int? _selectedIndex;
  final ScrollController _scrollController = ScrollController();

  static const double _yAxisWidth = 42.0;
  static const double _topPadding = 24.0;
  static const double _xLabelHeight = 28.0; // below baseline
  static const int _gridLines = 4;

  @override
  void initState() {
    super.initState();
    _scrollToRecent();
  }

  @override
  void didUpdateWidget(covariant MilkBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataPoints.length != widget.dataPoints.length ||
        oldWidget.dataPoints != widget.dataPoints) {
      _scrollToRecent();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToRecent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataPoints.isEmpty) {
      return _emptyState();
    }

    final double maxVal = widget.dataPoints.reduce(math.max);
    final double displayMax = (maxVal <= 0) ? 10.0 : _niceMax(maxVal);

    final double barPitch = widget.barWidthPx + widget.barSpacingPx;
    final double chartBodyWidth =
        widget.dataPoints.length * barPitch + widget.barSpacingPx;

    // Chart area height (between topPadding and the 0L baseline)
    final double chartHeight = widget.height - _topPadding - _xLabelHeight;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ── Fixed Y-axis column ────────────────────────
          SizedBox(
            width: _yAxisWidth,
            child: Padding(
              padding: EdgeInsets.only(
                  top: _topPadding, bottom: _xLabelHeight),
              child: CustomPaint(
                painter: _YAxisPainter(
                  maxVal: displayMax,
                  gridLines: _gridLines,
                  unit: widget.unit,
                ),
              ),
            ),
          ),
          // ── Scrollable bar area ────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartBodyWidth,
                height: widget.height,
                child: Stack(
                  children: <Widget>[
                    // Grid lines (behind bars)
                    Positioned(
                      top: _topPadding,
                      left: 0,
                      right: 0,
                      height: chartHeight,
                      child: CustomPaint(
                        painter: _GridPainter(gridLines: _gridLines),
                      ),
                    ),
                    // Bars (chart area only, not x-label area)
                    Positioned(
                      top: _topPadding,
                      left: 0,
                      right: 0,
                      height: chartHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(width: widget.barSpacingPx),
                          for (int i = 0;
                              i < widget.dataPoints.length;
                              i++) ...<Widget>[
                            _buildBarBody(i, chartHeight, displayMax),
                            SizedBox(width: widget.barSpacingPx),
                          ],
                        ],
                      ),
                    ),
                    // X-axis labels (below baseline, never overlapping bars)
                    Positioned(
                      top: _topPadding + chartHeight,
                      left: 0,
                      right: 0,
                      height: _xLabelHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: widget.barSpacingPx),
                          for (int i = 0;
                              i < widget.dataPoints.length;
                              i++) ...<Widget>[
                            SizedBox(
                              width: widget.barWidthPx,
                              child: Text(
                                widget.xLabels[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: (i == widget.dataPoints.length - 1)
                                      ? widget.barColor
                                      : Colors.grey.shade600,
                                  fontWeight:
                                      (i == widget.dataPoints.length - 1)
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: widget.barSpacingPx),
                          ],
                        ],
                      ),
                    ),
                    // Tooltip overlay
                    if (_selectedIndex != null)
                      Positioned(
                        left: _tooltipLeft(_selectedIndex!),
                        top: _topPadding + 4,
                        child: _buildTooltip(_selectedIndex!),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarBody(int index, double chartHeight, double displayMax) {
    final double value = widget.dataPoints[index];
    final bool isToday = index == widget.dataPoints.length - 1;
    final bool isSelected = _selectedIndex == index;
    final bool isEmpty = value <= 0;

    final double barFraction =
        isEmpty ? 0.0 : (value / displayMax).clamp(0.0, 1.0);
    final double barHeight =
        math.max(barFraction * chartHeight, isEmpty ? 0 : 4.0);

    final Color barFill = isSelected
        ? widget.barColor
        : isToday
            ? widget.barColor
            : widget.barColor.withValues(alpha: 0.55);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = (_selectedIndex == index) ? null : index;
        });
      },
      child: SizedBox(
        width: widget.barWidthPx,
        height: chartHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Value label above bar
            if (!isEmpty) ...<Widget>[
              Text(
                '${value.toStringAsFixed(1)}${widget.unit}',
                style: TextStyle(
                  fontSize: 7.5,
                  fontWeight:
                      isToday ? FontWeight.bold : FontWeight.w500,
                  color: isToday
                      ? widget.barColor
                      : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 2),
            ],
            // Bar body
            Container(
              width: widget.barWidthPx,
              height: barHeight,
              decoration: BoxDecoration(
                color: isEmpty ? Colors.grey.shade200 : barFill,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(5)),
                border: isSelected
                    ? Border.all(color: widget.barColor, width: 1.5)
                    : null,
                boxShadow: isToday && !isEmpty
                    ? <BoxShadow>[
                        BoxShadow(
                          color:
                              widget.barColor.withValues(alpha: 0.22),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltip(int index) {
    final double value = widget.dataPoints[index];
    final String label = widget.xLabels[index];
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            value <= 0
                ? 'No Record'
                : '${value.toStringAsFixed(1)} ${widget.unit}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double _tooltipLeft(int index) {
    final double barPitch = widget.barWidthPx + widget.barSpacingPx;
    final double x = widget.barSpacingPx + index * barPitch;
    return (x - 30).clamp(0.0, double.infinity);
  }

  Widget _emptyState() {
    return Container(
      height: widget.height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Text(
        'No milk records yet.\nStart recording to see production trends.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
      ),
    );
  }

  // Round up to a nice ceiling (10, 20, 25, 30, 50, …)
  double _niceMax(double val) {
    final double scaled = val * 1.2;
    const List<double> niceSteps = <double>[
      5, 10, 15, 20, 25, 30, 40, 50, 60, 75, 100, 125, 150, 200
    ];
    for (final double s in niceSteps) {
      if (scaled <= s) return s;
    }
    return (scaled / 50).ceil() * 50.0;
  }
}

// ── Y-Axis Painter ─────────────────────────────────────────
class _YAxisPainter extends CustomPainter {
  const _YAxisPainter({
    required this.maxVal,
    required this.gridLines,
    required this.unit,
  });

  final double maxVal;
  final int gridLines;
  final String unit;

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter tp =
        TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= gridLines; i++) {
      final double y =
          size.height - (i * size.height / gridLines);
      final double val = i * maxVal / gridLines;
      tp.text = TextSpan(
        text: '${val.toStringAsFixed(0)}$unit',
        style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500),
      );
      tp.layout();
      tp.paint(canvas,
          Offset(size.width - tp.width - 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _YAxisPainter old) =>
      old.maxVal != maxVal;
}

// ── Grid Painter ───────────────────────────────────────────
class _GridPainter extends CustomPainter {
  const _GridPainter({required this.gridLines});
  final int gridLines;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (int i = 0; i <= gridLines; i++) {
      final double y = size.height - (i * size.height / gridLines);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => false;
}

// Keep MilkLineChart as alias so all existing references compile
typedef MilkLineChart = MilkBarChart;
