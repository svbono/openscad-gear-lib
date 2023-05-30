//SPUR GEAR MODULE
//REV 30 MAY 2023

//this script contains 2 modules for generating spur gears and commented out examples for use
//spur_gear_1 is incomplete and has been since I made this script in 2020
//please ignore anything below the spur_gear_0 example

$fn = 64;

//spur_gear_0
//generates a spur gear as a function of teeth, di, do, wi, wa, wo, thigg, axis, rat

module spur_gear_0(teeth, di, do, wi, wa, wo, thigg, axis, rat)
{
    difference()
    {
        union()
        {
            //calculate dp (pitch/active diameter)
            dp = (do - di) / (rat + 1) * rat + di;
            //calculate ap (pressure angle)
            ap = acos(di / dp);
            //calculate wix (circular inner distance between teeth)
            wix = di * 3.14159 / teeth - wi;
            //calculate wax (circular active distance between teeth)
            wax = dp * 3.14159 / teeth - wa;
            //calculate wox (circular outer distance between teeth)
            wox = do * 3.14159 / teeth - wo;
            //calculate module
            mod = dp / teeth;
            //gear body
            cylinder(h = thigg, d = di, center = true);
            //teeth    
            for(i = [0 : 1 : teeth])
            {
                rotate([0, 0, i * 360 / teeth])
                //tooth
                polyhedron
                (
                    points = 
                    [
                        //internal
                        [-.5 * wi, .375 * di, -.5 * thigg], //0
                        [-.5 * wi, .375 * di, .5 * thigg],  //1
                        [.5 * wi, .375 * di, -.5 * thigg],  //2
                        [.5 * wi, .375 * di, .5 * thigg],   //3
                        //inner
                        [-.5 * wi, .5 * di, -.5 * thigg],   //4
                        [-.5 * wi, .5 * di, .5 * thigg],    //5
                        [.5 * wi, .5 * di, -.5 * thigg],    //6
                        [.5 * wi, .5 * di, .5 * thigg],     //7
                        //active
                        [-.5 * wa, .5 * dp, -.5 * thigg],   //8
                        [-.5 * wa, .5 * dp, .5 * thigg],    //9
                        [.5 * wa, .5 * dp, -.5 * thigg],    //10
                        [.5 * wa, .5 * dp, .5 * thigg],     //11
                        //outer
                        [-.5 * wo, .5 * do, -.5 * thigg],   //12
                        [-.5 * wo, .5 * do, .5 * thigg],    //13
                        [.5 * wo, .5 * do, -.5 * thigg],    //14
                        [.5 * wo, .5 * do, .5 * thigg]      //15
                    ],
                    faces = 
                    [
                        [0, 1, 3, 2],           //a
                        [0, 2, 6, 4],           //b 
                        [5, 7, 3, 1],           //c
                        [4, 5, 1, 0],           //d [0, 1, 5, 4]
                        [2, 3, 7, 6],           //e 
                        [8, 9, 5, 4],           //f [4, 5, 9, 8]
                        [6, 7, 11, 10],         //g
                        [12, 13, 9, 8],         //h [8, 9, 13, 12]
                        [10, 11, 15, 14],       //i
                        [6, 10, 14, 12, 8, 4],  //j [4, 8, 12, 14, 10, 6]
                        [9, 13, 15, 11, 7, 5],  //k [5, 7, 11, 15, 13, 9]
                        [14, 15, 13, 12]        //l [12, 13, 15, 14]
                    ]
                );
            };
            //messages
            echo("SPUR GEAR REPORT:");
            echo("MODULE = ", mod);
            echo("PITCH DIAMETER = ", dp);
            echo("PRESSURE ANGLE = ", ap);
            echo("APX INNER WIDTH BETWEEN TEETH = ", wix);
            echo("APX ACTIVE WIDTH BETWEEN TEETH = ", wax);
            echo("APX OUTER WIDTH BETWEEN TEETH = ", wox);
        }
        union()
        {
            //axis cutout
            cylinder(h = thigg * 2, d = axis, center = true);
        }
    }
}

/*
    teeth = number of teeth
    di = inner diameter
    do = outer diameter
    wi = inner tooth width (root)
    wa = active tooth width (width at pitch diameter/flank)
    wo = outer tooth width (flat)
    thigg = thickness of gear
    axis = diameter of the center hole
    rat = ratio between inner and outer zones of teeth, going with 2 for now, 1.25 is also common 
        
    Note: the method of calculating the widths between teeth mixes linear and circular formulas, hence the "APX"
    The report numbers become less accurate as the teeth arrangment becomes more abnormal, which has proven to not yet be an issue
    I'm not going to bother figuring out and listing the exact relationships yet
    I'll probably come back to rectify this, or at least make that list 
*/
       
/*
//example
spur_gear_0
(
    teeth = 16, 
    di = 35, 
    do = 45, 
    wi = 4, 
    wa = 4, 
    wo = 2, 
    thigg = 5, 
    axis = 4, 
    rat = 1
);
*/











/*
//spur_gear_1
//generates a spur gear as a function of mod, dp, do, wi, wo, thigg, axis, rat, des

module spur_gear_1(mod, dp, do, wi, wo, thigg, axis, rat, des)
{
    difference()
    {
        union()
        {
            //starting messages
            echo("REPORT FOR SPUR GEAR", des);
            //calculate teeth
            teeth = dp / mod;
            if(round(teeth) == teeth)
            {
                echo("MODULE VALID");
            }
            else
            {
                teeth = round(teeth);
                mod = 0;
                echo("MODULE INVALID, ROUNDED TO", mod);
            };
            //calculate di
            dp = (do - di) / (rat + 1) * rat + di;
            //calculate ap (pressure angle)
            ap = acos(di / dp);
            //calculate wix (circular inner distance between teeth)
            wix = di * 3.14159 / teeth - wi;
            //calculate wax (circular active distance between teeth)
            wax = dp * 3.14159 / teeth - wa;
            //calculate wox (circular outer distance between teeth)
            wox = do * 3.14159 / teeth - wo;
            //gear body
            cylinder(h = thigg, d = di, center = true);
            //teeth    
            for(i = [0 : 1 : teeth])
            {
                rotate([0, 0, i * 360 / teeth])
                //tooth
                polyhedron
                (
                    points = 
                    [
                        //internal
                        [-.5 * wi, .375 * di, -.5 * thigg], //0
                        [-.5 * wi, .375 * di, .5 * thigg],  //1
                        [.5 * wi, .375 * di, -.5 * thigg],  //2
                        [.5 * wi, .375 * di, .5 * thigg],   //3
                        // inner
                        [-.5 * wi, .5 * di, -.5 * thigg],   //4
                        [-.5 * wi, .5 * di, .5 * thigg],    //5
                        [.5 * wi, .5 * di, -.5 * thigg],    //6
                        [.5 * wi, .5 * di, .5 * thigg],     //7
                        // active
                        [-.5 * wa, .5 * dp, -.5 * thigg],   //8
                        [-.5 * wa, .5 * dp, .5 * thigg],    //9
                        [.5 * wa, .5 * dp, -.5 * thigg],    //10
                        [.5 * wa, .5 * dp, .5 * thigg],     //11
                        // outer
                        [-.5 * wo, .5 * do, -.5 * thigg],   //12
                        [-.5 * wo, .5 * do, .5 * thigg],    //13
                        [.5 * wo, .5 * do, -.5 * thigg],    //14
                        [.5 * wo, .5 * do, .5 * thigg]      //15
                    ],
                    faces = 
                    [
                        [0, 1, 3, 2], // a
                        [0, 2, 6, 4], // b 
                        [5, 7, 3, 1], // c
                        [4, 5, 1, 0], // d [0, 1, 5, 4]
                        [2, 3, 7, 6], // e 
                        [8, 9, 5, 4], // f [4, 5, 9, 8]
                        [6, 7, 11, 10], // g
                        [12, 13, 9, 8], // h [8, 9, 13, 12]
                        [10, 11, 15, 14], // i
                        [6, 10, 14, 12, 8, 4], // j [4, 8, 12, 14, 10, 6]
                        [9, 13, 15, 11, 7, 5], // k [5, 7, 11, 15, 13, 9]
                        [14, 15, 13, 12] // l [12, 13, 15, 14]
                    ]
                );
            };
        // final messages
        echo("TEETH = ", teeth);
        echo("PITCH DIAMETER = ", dp);
        echo("PRESSURE ANGLE = ", ap);
        echo("APX INNER WIDTH BETWEEN TEETH = ", wix);
        echo("APX ACTIVE WIDTH BETWEEN TEETH = ", wax);
        echo("APX OUTER WIDTH BETWEEN TEETH = ", wox);
        }
        union()
        {
            // axis cutout
            cylinder(h = thigg * 2, d = axis, center = true);
        }
    }
}

/* 
    mod = module (number of teeth per
    di = inner diameter
    do = outer diameter
    wi = inner tooth width (root)
    wa = active tooth width (width at pitch diameter/flank)
    wo = outer tooth width (flat)
    thigg = thickness of gear
    axis = diameter of the center hole
    rat = ratio between inner and outer zones of teeth, going with 2 for now, 1.25 is also common 
    des = designation for gear, shows up in console
        
    The formulas for calculating the widths between teeth mixes linear and circular formulas, hence the "APX"
    so the report numbers become less accurate if you do anything too weird 
    I'm not going to bother figuring out and listing the exact relationships yet
    I'll probably come back to fix this or at least make that list 
*/
        
/*
spur_gear_1
(
    mod = 6,
    di = 40,
    dp = 20, 
    do = 60, 
    wi = 5,
    wa = 6,
    wo = 10, 
    thigg = 20, 
    axis = 5, 
    rat = 1, 
    des = 5
);
*/
