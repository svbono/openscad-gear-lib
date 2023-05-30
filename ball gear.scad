//BALL GEAR MODULE 
//REV 30 MAY 2023

//this gear is for conveying or grabbing balls

$fn = 64;

module ball_gear(teeth, da, db, thigg, axis, balls)
{
    //calculate di
    di = da - db;
    //calculate do
    do = da + db;
    //everything else
    difference()
    {
        union()
        {
            //gear body
            cylinder(h = thigg, d = da, center = true);
        }
        union()
        {
            //teeth    
            for(i = [0 : 1 : teeth])
            {
                rotate([0, 0, i * 360 / teeth])
                translate([da / 2, 0, 0])
                cylinder(h = 2 * thigg, d = db, center = true);
            }
            //axis cutout
            cylinder(h = thigg * 2, d = axis, center = true);
        }
    }
    //illustration balls    
    if(balls == 1)
    {
        for(i = [0 : 1 : teeth])
        {
            color("red")
            rotate([0, 0, i * 360 / teeth])
            translate([da / 2, 0, 0])
            sphere(d = db);
        }
    }
    //messages
    echo("BALL GEAR REPORT:");
    echo("INNER DIAMETER = ", di);
    echo("ACTIVE DIAMETER = ", da);
    echo("OUTER DIAMETER = ", do);
    echo("BALL SLOTS = ", teeth);
    if(balls == 1)
    {
        echo("BALLS ACTIVATED");
    }
    else
    {
        echo("BALLS DEACTIVATED");
    }
}

/*
    teeth = teeth
    di = inner diameter
    da = active diameter
    do = outer diameter
    db = ball diameter
    thigg = thickness (z axis)
    axis = axis cutout length
    balls = shows balls (binary)
*/
       
/*
//example
ball_gear
(
    teeth = 12,
    da = 5,
    db = 1,
    thigg = 1,
    axis = 1,
    balls = 1
);
*/