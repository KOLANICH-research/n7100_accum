/*
Samsung SDI
3100 mAh
3.8 V (actually 4.12 V at full charge)
Li-Ion,
upper part is 45.1 wide
height without upper part 71.5
plus is left, minus is right
*/


module bank_body(h=74, w=55, d=5.5){
	r = d/2;
	translate([r, 0, 0]){
		union(){
			wCubic = w-d;
			cube([wCubic, d, h]);
			translate([0, +r, 0])
				cylinder(r=r, h=h);
			translate([wCubic, +r,0])
				cylinder(r=r, h=h);
		}
	}
}

module contactGroup(contactW=2, contactD=4, contactSeparation=0.6, contactGoldLayer=1e-5, contactsLeftOffset=1, contactsCount=3){
	translate([contactsLeftOffset, - contactD/2, 0]){
		color("gold"){
			cube([contactW, contactD, contactGoldLayer]);
			for(i = [1:contactsCount - 1]){
				translate([i * (contactW + contactSeparation),0,0]){
					cube([contactW, contactD, contactGoldLayer]);
				}
			}
		}
	}
}

module bank(h=74, w=55, d=6, left=4, right=6, upperPartTotalHeight=2.4, pcbThickness=1){
	wCubic = w-d;
	r = d/2;
	translate([-w/2,-d/2,]){
		union(){
			color("#7B9095"){
				bank_body(h=h-upperPartTotalHeight, w=w, d=d);
			}
			translate([0,0, h - upperPartTotalHeight]){
				legsHeight=upperPartTotalHeight-pcbThickness;
				translate([left,0,0]){
					pcbLen=wCubic - right + r;
					color("#444")
						cube([pcbLen, d, legsHeight]);
					translate([0,0,legsHeight]){
						color("green")
							cube([pcbLen, d, pcbThickness]);
						// Position of contacts is inaccurate, need measure and offset them
						translate([0,d/2,pcbThickness]){
							contactGroup();
						}
					}
				}
			}
		}
		//line([3.5, 0, 1.2], [[1, 0, 3.6]])  # and reflected
	}
}

module cap(w=55, id=5.3, od=5.9, innerPlaceForUpperPartD=4.65, innerPlaceForUpperPartH=0.31, pinW=1.75, flatPartOuter=50, thinWallThickness=0.15, thickWallThickness=0.55){
	wCubic = w-od;
	translate([-w/2,-od/2, - innerPlaceForUpperPartH]){
		color("red", alpha=0.5){
			difference(){
				bank_body(h=1, w=w, d=od);
				echo(innerPlaceForUpperPartD, od - 2*thickWallThickness);
				translate([0, od/2 - innerPlaceForUpperPartD/2,0]){
					cube([flatPartOuter - 2*thickWallThickness, innerPlaceForUpperPartD, innerPlaceForUpperPartH]);
				}
			}
		}
	}
	echo("big vertical wall length calculated:", wCubic);
}

module bottom(h=0.8, w=55, d=5.5){
	color("black")
		translate([-w/2,-d/2,]){
			bank_body(h=h, w=w, d=d);
		}
}

module accum(h=74, w=55, d=5.5){
	translate([0,0,h+0]){
		//cap(w=w);
	}
	bank(h=h, w=w, d=d);
	translate([0,0,0-0]){
		bottom(h=1, w=w, d=d);
	}
}

module phone(h=151, w=81, d=10, bcH=75.2, bcW=55.5, bcD=5.5, bottomOffset=23, leftOffset=14){
	color("silver")
	translate([-w/2, -d/2 + bcD/2, -bottomOffset]){
		difference(){
			translate([0, 0, 0]){
				cube([w, d, h]);
			}
			translate([leftOffset, -bcD/2, bottomOffset]){
				cube([bcW, bcD, bcH]);
			}
		}
	}
}

module phoneWithAccum(bottomOffset=23, leftOffset=14){
	phone(bottomOffset=bottomOffset, leftOffset=leftOffset);
	accum();
}

accum();
