$fn = 30;

demo = true;

make_lid = true;
make_body = false;
make_mount = false;
make_lock = false;
number_of_ways = 2;

module_width = 34.9;
module_inner_length = 84.1;
module_outer_length = 91.9;
module_height = 40;
module_under_clearance = 2;

module_radius = 2;
slide_depth = 16.8;
slide_notch_thickness = 2.2;
slide_notch_wall_width = 1.8;
slide_radius = 2;
slide_width = 4;
lock_channel_width = 8;
lock_height = 8.4; // relative to slide
lock_thickness = 1.4;
lock_depth = 2.2;
lid_depth = 6;
lid_wall_thickness = 2;
lid_inner_radius = 2;
internal_width = 30;
internal_length = 78;
body_screw_diameter = 2.6;
lid_screw_diameter = 2.2;
lid_screw_head_diameter = 3.6;
lid_screw_head_depth = 2;
lid_screw_recess = 0.5;
mount_width = 39.6;
mount_height = 32;
mount_length = 10;
mount_radius = 3;
mount_wall_thickness = 2;
mount_clip_body_width = 24.4;
mount_clip_body_thickness = 2.1;
mount_clip_front_width = 30.8;
mount_clip_front_thickness = 1.6;
mount_slot_width = 10.4;
fixing_outer_diameter = 10;
fixing_inner_diameter = 4;
fixing_depth = 4;

//module_z_offset = -(mount_height - slide_depth)/2-1+module_under_clearance;
module_z_offset = (mount_height - module_height)/-2 + (slide_depth - mount_height)/2 + module_under_clearance;
lid_z_offset = (module_z_offset + module_height/2 - lid_depth);

if(demo) {
    demo(2);
} else {
    main();
}

module demo(num=3) {
    make_boxes(num);
    make_mounts(num);
    make_locks(num);
    translate([0,(num-1) * (mount_width - mount_wall_thickness),0]) {
        rotate([0,0,180]) {
            make_mounts(num);
            make_locks(num);
        }
    }
}

module make_boxes(num) {
    translate([0,0,(mount_height-slide_depth)/2]) {
    for(i=[0:num -1]) {
        translate([0,i * (mount_width - mount_wall_thickness),0]) {
            make_box();
        }
    }
    for(i=[0:num -1]) {
        translate([0,i * (mount_width - mount_wall_thickness),0]) {
            lid_offset = (i == num-1) ? 15:0;
            translate([0,0,lid_z_offset+lid_offset+lid_depth/2+3.2]) {
                rotate([180,0,0]) {
                    difference() {
                        lid();
                        lid_screws();
                    }
                }
            }
        }
    }
}
}

module make_mounts(num) {
    translate([module_inner_length/2 + 1,0,0]) {
    difference() {
        union() {
            for(i=[0:num -1]) {
                translate([0,i * (mount_width - mount_wall_thickness),0]) {
                    mount();
                }
            }
            mount_fixings(num);
        }
        
        if(number_of_ways > 1) {
            for(i=[1:num -1]) {
                translate([-6,(i - 0.5) * (mount_width - mount_wall_thickness),0]) {
                    cube([4,mount_wall_thickness + 1,mount_height +1], center=true);
                }
            }
        }
    }
    }
}
    
module make_locks(num) {
    translate([module_inner_length/2,0,0]) {
        for(i=[0:num -1]) {
            translate([0,i * (mount_width - mount_wall_thickness),0]) {
                slide_lock();
            }
        }
    }
}

module make_box() {
    body();
    
    difference() {
        lid();
        lid_screws();
    }
}
    


module main() {

    if(make_body) {
        difference() {
        body();
//            translate([15,0,0]) cube([module_outer_length + 1, module_width + 1, module_height + 1], center=true);
        }
    }
    
    if(make_lid) {
        translate([0,80,0]) {
            difference() {
                lid();
                lid_screws();
            }
//                lid_screws();
        }
    }

    if(make_mount) {
        translate([80,0,0]) {
            difference() {
                for(i=[0:number_of_ways -1]) {
                    translate([0,i * (mount_width - mount_wall_thickness),0]) {
                        mount();
                    }
                }
                if(number_of_ways > 1) {
                    for(i=[1:number_of_ways -1]) {
                        translate([-6,(i - 0.5) * (mount_width - mount_wall_thickness),0]) {
                            cube([4,mount_wall_thickness + 1,mount_height +1], center=true);
                        }
                    }
                }
            }
            mount_fixings();
        }
    }


    if(make_lock) {
        translate([-50,-100,0]) {
            rotate([90,0,0]) slide_lock();
        }
    }
}

module mount_fixings(num = number_of_ways) {
    mount_fixing();
    if(num > 2) {
        offset = (num -1) * (mount_width - mount_wall_thickness);
        translate([0,offset,0]) {
            mount_fixing();
        }
    }
}

module mount_fixing_prism() {
    translate([5,10,-mount_height/2+20]) {
        rotate([-90,0,-90]) {
            prism(20,20,10);
        }
    }
}

module mount_fixing() {
    difference() {
        hull() {
            translate([4,0,5-mount_height/2]) {
                cube([0.5,20,10],center=true);
            }
            translate([12,0,(fixing_depth-mount_height)/2]) {
                cylinder(d = fixing_outer_diameter, h = fixing_depth, center=true);
            }
        }
        // `This cutout prevents the foot from overlapping the lock recess
        translate([4,0,-mount_height/2]) cube([4,6.4,4], center=true);
        translate([12,0,(fixing_depth-mount_height)/2]) {
            translate([0,0,fixing_depth+10]) {
                cylinder(d = fixing_outer_diameter, h = fixing_depth+20, center=true);
            }
                cylinder(d = fixing_inner_diameter, h = fixing_depth+0.1, center=true);
        }
    }
}

module mount() {
    difference() {
        union() {
    difference() {
        roundedcube([mount_length, mount_width, mount_height], center=true, radius=mount_radius, apply_to="z");
        translate([-mount_wall_thickness,0,mount_height-slide_depth]) {
            roundedcube([mount_length, mount_width - 2 * mount_wall_thickness, mount_height+1], center=true, radius=slide_radius, apply_to="z");
        }
        translate([-mount_wall_thickness-mount_clip_body_thickness-mount_clip_front_thickness,0,0]) {
            cube([mount_length, mount_width - 2 * mount_wall_thickness, mount_height+1], center=true);
        }
    }

        translate([(mount_length-mount_clip_body_thickness)/2-mount_wall_thickness,0,0]) {
            cube([mount_clip_body_thickness + 0.6,mount_clip_body_width,mount_height], center=true);
            translate([-mount_clip_body_thickness,0,0]) {
                cube([mount_clip_front_thickness,mount_clip_front_width,mount_height], center=true);
            }
        }
    }
        slide_lock(0.4);

        translate([mount_length/2-mount_wall_thickness-2,0,0]) {
            cube([2,6.4,mount_height - 4 * mount_wall_thickness], center=true);
        }

    }
}

module slide_lock(clearance=0) {
    cube([2,6 + clearance,mount_height+0.02], center=true);
    translate([2.1,0,mount_height/2-1+0.04]) {
        cube([6,6 + clearance,2.08 + clearance/2], center=true);
    }
    translate([2.1,0,-mount_height/2+1-0.04]) { 
        cube([6,6 + clearance,2.08 + clearance/2], center=true);
    }
    translate([-1,-3,(mount_height - slide_depth)/2+3.5]) {
        rotate([-90,0,90]) {
            prism(6,2.5,1.2);
        }
    }
    translate([-1,3,(mount_height - slide_depth)/2-3.5]) {
        rotate([-90,180,90]) {
            prism(6,2.5,1.3);
        }
    }
}

module lid(clearance = 0.1) {
    mirror([0,0,1]) {
    translate([0,0,-module_height/2]) {
        difference() {
            translate([0,0,clearance/2]) {
                roundedcube([module_inner_length + clearance, module_width + clearance, module_height + clearance], center=true, radius=slide_radius);
            }
            translate([0,0,-lid_depth]) {
                cube([module_inner_length+1, module_width+1, module_height], center=true);
            }
            translate([0,0,-lid_wall_thickness]) {
                roundedcube([module_inner_length - 2 * lid_wall_thickness, module_width - 2 * lid_wall_thickness, module_height], center=true, radius=lid_inner_radius, apply_to="z");
            }
//        cube([20,100,100], center=true);
        }
    }
    lid_posts(clearance);
    }
}

module lid_posts(clearance) {
    lid_post(clearance);
    rotate([0,0,180]) lid_post(clearance);
    mirror([1,0,0]) lid_post(clearance);
    mirror([1,0,0]) rotate([0,0,180]) lid_post(clearance);
}

module lid_post(clearance) {
    translate([module_inner_length/2 - 4, module_width/2 - 4,-lid_depth/2]) {
        cylinder(h = lid_depth, d = 6 - clearance, center=true);
    }
}

module lid_screws() {
    lid_screw();
    rotate([0,0,180]) lid_screw();
    mirror([1,0,0]) lid_screw();
    mirror([1,0,0]) rotate([0,0,180]) lid_screw();
}

module lid_screw() {
    translate([module_inner_length/2 - 4, module_width/2 - 4, -0.6]) {
        mirror([0,0,1]) {
            screw_countersunk(l = lid_depth+0.2,dh=lid_screw_head_diameter,lh=lid_screw_head_depth,ds=lid_screw_diameter,recess=lid_screw_recess);
        }
    }
/*
        cylinder(h = lid_depth + 0.1, d = lid_screw_diameter, center=true);
        translate([0,0,-lid_screw_head_depth]) {
            cylinder(h = lid_screw_head_depth, d = lid_screw_head_diameter, center=true);
        }
    }
*/
}


module body() {

    difference() {
        union() {
            roundedcube([module_outer_length, module_width, slide_depth], center=true, radius=slide_radius, apply_to="z");
            translate([0,0,module_z_offset]) {
                roundedcube([module_inner_length, module_width, module_height], center=true, radius=module_radius);
            }
        }
        slots();
        locks();
        translate([0,0,module_height/2 + module_z_offset]) rotate([180,0,0]) lid(clearance = 0.2);
        translate([0,0,lid_wall_thickness + module_z_offset]) {
            cube([internal_length, internal_width - 10, module_height], center=true);
            cube([internal_length - 10, internal_width, module_height], center=true);
        }
        body_screws();
    }
}

module body_screws() {
    body_screw();
    rotate([0,0,180]) body_screw();
    mirror([1,0,0]) body_screw();
    mirror([1,0,0]) rotate([0,0,180]) body_screw();
}

module body_screw() {
    translate([module_inner_length/2 - 4, module_width/2 - 4,lid_depth/2+module_z_offset]) {
        cylinder(h = module_height, d = body_screw_diameter, center=true);
    }
}

module slots() {
    slot();
    rotate([0,0,180]) {
        slot();
    }
}

module slot() {
    translate([module_inner_length/2 + slide_notch_thickness/2,0]) {
        cube([slide_notch_thickness, module_width - 2 * slide_notch_wall_width, slide_depth + 0.2], center=true);
        translate([(module_outer_length - module_inner_length)/2+0.1,0,0]) {
            cube([module_outer_length - module_inner_length,module_width - 2 * slide_width,slide_depth + 0.2], center=true);
        }
    }
}

module locks() {
    lock();
    rotate([0,0,180]) {
        lock();
    }
}

module lock() {
    translate([(module_inner_length - lock_depth)/2,0,0]) {
        difference() {
            translate([0,0,module_z_offset]) cube([lock_depth + 0.1,lock_channel_width, module_height+1], center=true);
            cube([lock_depth + 0.1, lock_channel_width + 0.1, lock_thickness], center=true);
        }
/*
        translate([0,0,lock_height + lock_thickness/2]) {
            cube([lock_depth + 0.1,lock_channel_width, module_height/2], center=true);
        }
        translate([0,0,-lock_height - lock_thickness/2]) {
            cube([lock_depth + 0.1,lock_channel_width, slide_depth], center=true);
        }
*/
    }
}


// The roundedcube function, shamelessy lifted from:
// https://danielupshaw.com/openscad-rounded-corners/
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}

module prism(l, w, h){
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}
// Initially taken from:
// https://gist.github.com/Stemer114/af8ef63b8d10287c825f
// However, I tweaked it slightly to allow for a counterbore.
module screw_countersunk(
        l=20,   //length
        dh = 6,   //head dia
        lh = 3,   //head length
        ds = 3.2,  //shaft dia
        recess = 0
        )
{
    rotate([180,0,0])
    union() {
        if(recess > 0) {
            cylinder(h=recess, d=dh);
        }
        translate([0,0,recess]) {
            cylinder(h=lh, r1=dh/2, r2=ds/2);
            cylinder(h=l, d=ds);
        }
    }
}

