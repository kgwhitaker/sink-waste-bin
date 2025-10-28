//
// Simple waste bin that goes next to the sink.  Put a divided slot next to hit to hold the sieve
//

// The Belfry OpenScad Library, v2:  https://github.com/BelfrySCAD/BOSL2
// This library must be installed in your instance of OpenScad to use this model.
include <BOSL2/std.scad>

// *** Model Parameters ***
/* [Model Parameters] */

// Overall Width of the waste bin.  The side slot will be within this width.
bin_width = 200;

// Indicates if there should be a side slot.
add_side_slot = true;

// Width of the side slot
side_slot = 15;

// Depth of the waste bin.
bin_depth = 150;

// Overall height of the waste bin.
bin_height = 200;

// Thickness of the walls for the waste bin.
wall_thickness = 2;

// Rounding of the outside corners.
corner_rounding = 10;

// *** "Private" variables ***
/* [Hidden] */

// OpenSCAD System Settings
$fa = 1;
$fs = 0.4;

//
// Waste Bin
//
module waste_bin() {

  difference() {
    cuboid(size=[bin_depth, bin_width, bin_height], rounding=corner_rounding, except=[BOT, TOP]);

    // Cut out main bin area.
    translate([0, 0, wall_thickness]) {
      cuboid(size=[bin_depth - 2 * wall_thickness, (bin_width - (2 * wall_thickness)), bin_height], rounding=corner_rounding, except=[TOP]);
    }
  }
}

//
// Adds in the side slots.
//
module side_slot() {
  // Put in a divider for the side slot.
  translate([0, (bin_width / 2) - side_slot - wall_thickness, 0]) {
    cuboid(size=[bin_depth, wall_thickness, bin_height]);
  }

  // Divide the side slot by 2.
  translate([0, (bin_width / 2) - side_slot + wall_thickness * 3, 0]) {
    cuboid(size=[wall_thickness, side_slot, bin_height]);
  }
}

//
// Builds the entire model.
//
module build_model() {
  waste_bin();

  if (add_side_slot) {
    side_slot();
  }
}

build_model();
