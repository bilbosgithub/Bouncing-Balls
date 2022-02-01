# Bouncing Balls

In order to run the program, the user should ensure that the folder titled "textures" is in the same folder as the BouncingBalls.pde file. Then, in the .pde file, the user should just run the program. Some details of the program are provided below.

We begin in a box of size (DisplayWidth x DisplayHeight x Depth), centred in the display window. The user should click the mouse at (x,y) on the screen 
to shoot a ball along the Zaxis, with a random texture and in a random direction, according to the XY plane. The user can generate as many balls as they 
wish, each of uniform RADIUS - and hence mass, as we assume no changes to the density of the ball - and will only spawn if the position (x, y) of the 
mouse is at least RADIUS distance from the walls. There is a texture pool of 8 textures (see the setup function). To randomise the direction, we set the initial x 
and y velocity to be a random number in a predetermined range, in either a positive or negative direction. When this is added to the initial position of the
ball generated, namely (mouseX, mouseY, 0), the ball will thus shoot in that randomised direction.

The ball will always remain in the display after it is fired, as the box is enclosed. By this, we mean that the ball will collide with any of the 6 walls of
the box (the 6th being the camera) and rebound; given by reversing the direction of its velocity. In each iteration, the x and z component of the velocity 
vector is multiplied by the dampingVelocity value, which is less than one, to ensure that the motion along these axes converges to zero. In each iteration,
gravity is added to the y component of the velocity vector to simulate a gravitational force pulling on it. Further, the y component is multiplied by 
yDamping; a value less than one, each time the ball bounces upwards after colliding with the floor, simulating friction. In this way, the y component of the 
velocity vector also converges to zero and hence, the net velocity does indeed converge to zero, meaning that the ball does eventually become stationary.

We note that the ball also rotates while it is travelling, with its direction determined by its current (and hence original) direction of motion and its collisions. 
In particular, the angle of rotation is initialised to zero and is incremented by the x component of velocity, meaning that the angle not only depends on the 
direction of motion, but also reverses after the ball collides with a wall or another ball. As two balls collide, their velocities are also adjusted
appropriately. We note that if a ball B1 is at rest and another ball, B2 collides with it, then B1 will no longer remain at rest, since it gained momentum and 
hence velocity, through its collision with B2.