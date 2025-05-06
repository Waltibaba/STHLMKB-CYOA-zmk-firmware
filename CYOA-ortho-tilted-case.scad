// Keyboard bottom shell for sthlmkb Choose Your Own Adventure ortholinear 5x12 (breakable to smaller sizes)
// Authored by Walter Sereinig 2025
// License: WTFPL


$fa=0.5; // default minimum facet angle is now 0.5
$fs=0.5; // default minimum facet size is now 0.5 mm
$fn=50;

key                           = 19.1;
// keyboard is 12x5 so 229.2 x 95.5 mm, theoretically

// reconfigure if you need it smaller
keyboard_width                = 229.2; //calculate yours with key*number of keys. This is 12*19.1 
keyboard_depth                = 95.5;  //calculate with key*number of keys. This is 5*19.1
keyboard_height               = 2;     //PCB and diodes thickness
keyboard_bottom_offset        = 3;     //z-spacing to the shell at the bottom (where the spacebar is)
keyswitch_height              = 11;    //case intersection height for nicer projection
// keyswitch_height              = 20.8; // real height

//if you use a socketed or thicker microcontroller you can enter details here to view it simulated in the preview
mcu_height                    = 8.2;
mcu_depth                     = 36;
mcu_width                     = 18.4;
mcu_offset_left               = 39;
mcu_offset_top                = 3;

// screwhole_positions in every corner, so multiples of 19.1 x 19.1

case_perimiter_tolerance      = 0.1; //the left and right side tolerance is very tight, you can increase it here at the cost of top and bottom tolerance being even looser
case_thickness_edge           = 3;
case_thickness_bottom         = 3;
case_overlap_height           = 6.5;  //how high the case edges go up the sides of the keyswitches, above the Z-height of the PCB (pre-tilt)
keyboard_tilt_angle           = 6;    //how far to rotate the keyboard down in the front, up in the rear. This gives the MCU space and makes it more ergonomic

screwpost_diameter_outer      = 6.9;
screwpost_diameter_inner      = 3.0;  //fits M2 brass heatset nuts
screwpost_max_height          = 12;   //if you increase your tilt angle or bottom offset, this might need to be increased too or the screwposts will be too short


module keyboard() {
  union() {
    translate([0,0,keyboard_bottom_offset]) cube([keyboard_width, keyboard_depth, keyboard_height]);
    translate([mcu_offset_left,keyboard_depth-mcu_depth-mcu_offset_top,-mcu_height+keyboard_bottom_offset]) cube([mcu_width, mcu_depth, mcu_height]);
  }
}

module keys() {
  translate([0,0,keyboard_height+keyboard_bottom_offset]) cube([keyboard_width, keyboard_depth, keyswitch_height]);
}

module keyboard_with_keys() {
  keyboard();
  keys();
}


module screw_post() {
  difference(){
    cylinder(h = screwpost_max_height+keyboard_bottom_offset, r = screwpost_diameter_outer/2);
    cylinder(h = screwpost_max_height+keyboard_bottom_offset, r = screwpost_diameter_inner/2);
  }
}

module keyboard_post(row,col){
  translate([row * key, keyboard_depth - col * key, -screwpost_max_height]) screw_post();
}

module keyboard_posts_relative() {

  keyboard_post(1,1);
  // keyboard_post(1,3);
  keyboard_post(1,4);
  keyboard_post(4,1);
  keyboard_post(4,3);
  keyboard_post(6,4);
  keyboard_post(8,1);
  keyboard_post(8,3);
  keyboard_post(11,1);
  // keyboard_post(11,3);
  keyboard_post(11,4);
}

module keyboard_posts_flat_cut() {
  intersection() {
    linear_extrude(height = screwpost_max_height+keyboard_bottom_offset+keyboard_height) keyboard_projection();//base projection extruded up
    rotate(a=keyboard_tilt_angle, v=[1,0,0]) keyboard_posts_relative();
  }
}

module keyboard_projection() {
  projection(cut=false) rotate(a=keyboard_tilt_angle, v=[1,0,0]) keyboard_with_keys();
}

module keyboard_projection_with_tolerance() {
  minkowski() {
    keyboard_projection();
    circle(r = case_perimiter_tolerance);
  }
}

module base_surface() {
  minkowski() {
    keyboard_projection_with_tolerance();
    circle(r=case_thickness_edge);
  }
}

module base_plate() {
  translate([0,0,-case_thickness_bottom]) linear_extrude(height = case_thickness_bottom) base_surface();
}

module case_walls() {
  linear_extrude(height = 25)
  difference(){
    base_surface();
    keyboard_projection_with_tolerance();
  }
}

module top_cutter() {
  rotate(a=keyboard_tilt_angle, v=[1,0,0]) translate([-keyboard_width, -keyboard_depth, keyboard_bottom_offset+case_overlap_height-keyswitch_height]) scale(v = [3,3,2]) keys();
}

module usb_cutter() {
  rotate(a=keyboard_tilt_angle, v=[1,0,0])
  translate([mcu_offset_left,keyboard_depth-mcu_depth-mcu_offset_top+15,-mcu_height+keyboard_bottom_offset])
  cube([mcu_width, mcu_depth, mcu_height]);
}
difference() {
  union() {
    base_plate();
    difference() {
      case_walls();
      top_cutter();
      usb_cutter();
    }
    keyboard_posts_flat_cut();
  }

//comment or uncomment the following lines to get a feel for the fit in the preview

// rotate(a=keyboard_tilt_angle, v=[1,0,0]) keyboard_with_keys();
  rotate(a=keyboard_tilt_angle, v=[1,0,0]) keyboard();
// rotate(a=keyboard_tilt_angle, v=[1,0,0]) keys();
}
