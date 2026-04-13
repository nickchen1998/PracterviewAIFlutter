import 'package:flutter/widgets.dart';

enum LayoutBreakpoint { compact, medium, expanded }

const double kCompactMax = 599;
const double kMediumMax = 1199;

LayoutBreakpoint layoutOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width <= kCompactMax) return LayoutBreakpoint.compact;
  if (width <= kMediumMax) return LayoutBreakpoint.medium;
  return LayoutBreakpoint.expanded;
}

bool isCompact(BuildContext context) =>
    layoutOf(context) == LayoutBreakpoint.compact;

bool isExpanded(BuildContext context) =>
    layoutOf(context) == LayoutBreakpoint.expanded;
