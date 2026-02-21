//
// Simple waste bin that goes next to the sink.  Put a divided slot next to hit to hold the sieve
//

// The Belfry OpenScad Library, v2:  https://github.com/BelfrySCAD/BOSL2
// This library must be installed in your instance of OpenScad to use this model.
include <BOSL2/std.scad>

// *** Model Parameters ***
/* [Model Parameters] */

// Overall Width of the waste bin.  The side slot will be within this width.
bin_width = 120;

// Indicates if there should be a side slot.
add_side_slot = false;

// Width of the side slot
side_slot = 15;

// Depth of the waste bin.
bin_depth = 150;

// Overall height of the waste bin.
bin_height = 140;

// Thickness of the walls for the waste bin.
wall_thickness = 2;

// Rounding of the outside corners.
corner_rounding = 10;

// True to cut in slots for a bag to be folded in to.  
add_bag_slot = false;

// How long to make the bag slot as measure from the top fo the bin. Only used if a add_side_slot is true.
bag_slot_len = 25;

// Width of the bag slot.
bag_slot_width = 4;

// Set to true to add a mouse hole to one edge at the top of the bin.
add_mouse_hole = true;

// Diameter of the mouse hole at the top of the bin; used as a cord exit when sized for a power strip cover.
mouse_hole_diam = 14;

// Height of the mouse hole
mouse_hole_height = 18;

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
// Adds in slots to fold in a bag
//
module bag_slot() {
  x_shift = ( (bin_depth / 2) - (wall_thickness / 2));
  y_shift = (bin_width / 2) - side_slot - bag_slot_width / 2 - (wall_thickness / 2) - wall_thickness;
  z_shift = (bin_height / 2) - (bag_slot_len / 2);
  notch_rounding = -(bag_slot_width / 2);

  // Creates the right then left notches.
  for (i = [-1:1]) {
    translate([i * x_shift, y_shift, z_shift])
      cuboid(size=[wall_thickness * 2, bag_slot_width, bag_slot_len], rounding=notch_rounding, edges=[FRONT + TOP]);
  }
}

//
// Creates the mouse hole at the top of the bin.
//
module mouse_hole() {
  translate([(bin_depth / 2) - wall_thickness / 2, 0, (bin_height / 2) - (mouse_hole_height / 2)])
    cuboid(size=[wall_thickness * 2, mouse_hole_diam, mouse_hole_height], rounding=mouse_hole_diam / 2, edges=[BOT + FRONT, BOT + BACK]);
}

//
// Builds the entire model.
//
module build_model() {

  difference() {

    union() {
      waste_bin();

      if (add_side_slot) {
        side_slot();

        // bag_slot();
      }
    }

    if (add_side_slot && add_bag_slot) {
      bag_slot();
    }

    if (add_mouse_hole) mouse_hole();
  }
}

build_model();
