use <pin_headers.scad>;

WIDTH = 56;
LENGTH = 85;
HEIGHT = 1.5;

RIGHT = [90,0,0];
LEFT = [-90,0,0];

FINE = .5;

METALLIC = "silver";
CHROME = [.9, .9, .9];
BLUE = [.4,.4,.95];

ETHERNET_LENGTH = 21.2;
ETHERNET_WIDTH = 16;
ETHERNET_HEIGHT = 13.3;
ETHERNET_DIMENSIONS = [ETHERNET_LENGTH, ETHERNET_WIDTH, ETHERNET_HEIGHT];

function offset_x(ledge) = LENGTH - ETHERNET_LENGTH + ledge;

module ethernet_port ()
	{  
    ledge = 1.2;
    pcb_margin = 1.5;
    offset = [offset_x(ledge), pcb_margin, HEIGHT];
        
	color(METALLIC)
        translate(offset) 
            cube(ETHERNET_DIMENSIONS); 
	}

module usb_port ()
	{
	color(METALLIC)
        translate([LENGTH-9.5,25,HEIGHT]) 
            cube([17.3,13.3,16]);
	}

module composite_block () {
    color("yellow")
        cube([10,10,13]);
}

module composite_jack () {
    translate([5,19,8])
        rotate(RIGHT)
            color(CHROME)
                cylinder(h = 9.3, r = 4.15, $fs=FINE);
}
    
module composite_port ()
	{
    offset_x = LENGTH-43.6;
    offset_y = WIDTH - 12;
	translate([offset_x, offset_y, HEIGHT])
		{
        composite_block();
        composite_jack();
		}
	}

function radius(diameter) = diameter / 2;
    
module audio_jack () {
	translate([LENGTH-26,WIDTH-11.5,HEIGHT]) {
        diameter= 6.7;
        radius = radius(diameter);
		color(BLUE)
            cube([12.1,11.5,10.1]);
        
        translate([6,11.5,10.1-radius])
            rotate(LEFT)
                color(BLUE)
                    cylinder(h = 3.5, r = radius, $fs=FINE);
	}
}


module gpio ()
	{
	//headers
	rotate([0,0,180])
	translate([-1,-WIDTH+6,HEIGHT])
	off_pin_header(rows = 13, cols = 2);
	}

module hdmi ()
	{
	color (METALLIC)
	translate ([37.1,-1,HEIGHT])
	cube([15.1,11.7,8-HEIGHT]);
	}

module power ()
	{
	color(METALLIC)
	translate ([-0.8,3.8,HEIGHT])
	cube ([5.6, 8,4.4-HEIGHT]);
	}

module sd ()
	{
	color ([0,0,0])
	translate ([0.9, 15.2,-5.2+HEIGHT ])
	cube ([16.8, 28.5, 5.2-HEIGHT]);

	color ([.2,.2,.7])
	translate ([-17.3,17.7,-2.9])
	cube ([32, 24, 2] );
	}

module mhole ()
	{
	cylinder (r=3/2, h=HEIGHT+.2, $fs=0.1);
	}

module pcb ()
	{
		difference ()
		{
		color([0.2,0.5,0])
		linear_extrude(height = HEIGHT)
		square([LENGTH,WIDTH]); //pcb
		translate ([25.5, 18,-0.1]) mhole (); 
		translate ([LENGTH-5, WIDTH-12.5, -0.1]) mhole (); 
		}
	}

module leds()
	{
		// act
		color([0.9,0.1,0,0.6])
		translate([LENGTH-11.5,WIDTH-7.55,HEIGHT]) led();
		// pwr
		color([0.9,0.1,0,0.6])
		translate([LENGTH-9.45,WIDTH-7.55,HEIGHT]) led();

		// fdx
		color([0.9,0.1,0,0.6])
		translate([LENGTH-6.55,WIDTH-7.55,HEIGHT]) led();
		// lnk
		color([0.9,0.1,0,0.6])
		translate([LENGTH-4.5,WIDTH-7.55,HEIGHT]) led();
		// 100
		color([0.9,0.1,0,0.6])
		translate([length-2.45,WIDTH-7.55,HEIGHT]) led();
	}
module led()
	{
		cube([1.0,1.6,0.7]);
	}

module rpi ()
	{
		pcb ();
		ethernet_port ();
		usb_port (); 
		composite_port (); 
		audio_jack (); 
		gpio (); 
		hdmi ();
		power ();
		sd ();
		leds ();
	}

rpi (); 
