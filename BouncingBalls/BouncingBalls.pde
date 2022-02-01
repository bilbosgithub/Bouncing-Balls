import java.util.ArrayList;

int displayWidth = 1300;
int displayHeight = 850;
Box box = new Box(displayWidth, displayHeight, -500);

ArrayList<PImage> textures = new ArrayList<PImage>();
int textureIndex;

ArrayList<Ball> balls = new ArrayList<Ball>();
Ball b;

float gravity = 0.7;
float yDamping = 0.85;
float dampingVelocity = 0.9965;

class Ball {

  public PVector position;
  public PVector velocity;
  
  public float angle = 0;
  public PShape ball;
  public final int RADIUS = 50;

  public Ball(PImage texture) {

    beginShape();
    noStroke();
    this.ball = createShape(SPHERE, RADIUS);
    this.ball.setTexture(texture); 
    endShape();

    this.position = new PVector(mouseX, mouseY, 0);
    
    // Math.round(Math.random()) gives either 0 or 1
    // (-1 + 2 * (Math.round(Math.random()))) gives either -1 or 1, corresponding to the direction of the ball  
    float velX = random(8, 13) * (-1 + 2 * (Math.round(Math.random())));
    float velY = random(6, 8) * (-1 + 2 * (Math.round(Math.random())));
    float velZ = random(-7, -4);
    this.velocity = new PVector(velX, velY, velZ); 
  }

  void checkWallCollisions(Box box) {

    // If the ball collides with the left or right wall, change it's x direction and rest its position
    if ( this.position.x - RADIUS < 0) {
      this.position.x = RADIUS;
      this.velocity.x *= -1;
    }
    else if (this.position.x + RADIUS > box.boxWidth) {
      this.position.x = box.boxWidth - RADIUS;
      this.velocity.x *= -1;
    }

    // If the ball collides with the roof, change it's y direction
    if (this.position.y - RADIUS <= 0) {
      this.position.y = RADIUS;
      this.velocity.y *= -1 ;
    } 
    
    // If the ball collides with the floor, change it's y direction
    // Also depreciate the y value as energy is lost through friction with the floor
    else if (this.position.y + RADIUS >= box.boxHeight) {
      this.position.y = box.boxHeight - RADIUS;
      this.velocity.y *= - yDamping;
    }

    // If the ball collides with the back wall, change it's z direction
    if (this.position.z - RADIUS < box.boxDepth) {
      this.position.z = box.boxDepth + RADIUS;
      this.velocity.z *= -1;
    }
    else if (this.position.z + RADIUS > 50) {
      this.position.z = 50 - RADIUS;
      this.velocity.z *= -1;
    }
  }
  
  void checkBallCollisions() {
    
    // check each ball in the arraylist
    // if the balls are the same entity or they do not intersect then continue
    // otherwise, we must collide them
    for (Ball b : balls){
      
      if (this.equals(b) || this.position.dist(b.position) >= 2 * RADIUS){
        continue;
      }
     
      this.collide(b);   
    }   
  }
  
  void collide(Ball b) {
   
    // In the following, when we refer to "the current ball", we mean the ball calling the method
    
    /* We compute the normalized relative position vector (this.position - b1.position)/(the length of this vector)
      This gives the new direction of the current ball after the collision
      Note that for a smooth transition in motion, we need to normalize the vector. Remove ".normalize()" and see what happens! */
    
    PVector normalizedRelativePosition = new PVector();
    normalizedRelativePosition.set(this.position).sub(b.position).normalize();
    
    /* While the balls intersect, we need to translate the current ball in its new direction
       We do this by adding the normal relative position vector to the position of the current ball */
    
    while (this.position.dist(b.position) < 2 * RADIUS) {
      this.position.add(normalizedRelativePosition);
      b.position.sub(normalizedRelativePosition);
    }
    
    // Now the balls are no longer intersecting
    // All that is left to do is update their velocities 
    // We recompute the normalizedRelativePosition vector since the current ball has moved

     normalizedRelativePosition.set(this.position).sub(b.position).normalize();
     
     // We also require the relative velocity between the current ball and b
     
     PVector relativeVelocity = new PVector();
     relativeVelocity.set(this.velocity).sub(b.velocity);
     
     // Compute the dot product between the normalizedRelativePosition vector and the relativeVelocity vector
     // This essentially tells us how much of the relativeVelocity vector is applied in the direction of the normalisedRelativePosition (the direction in which the current 
     // (ball is moving)
     
     float dotProduct = normalizedRelativePosition.dot(relativeVelocity);
     
     // We now scale the normalizedRelativePosition by the dotProduct to account for the amount of relativeVelocity in this direction
     // If any component becomes negative, it corresponds to a direction change
     
     PVector vel = new PVector();
     vel.set(normalizedRelativePosition).mult(dotProduct);
     
     // Finally, the difference between the relativeVelocity vector and the vector vel, gives the relative velocity 
     relativeVelocity.sub(vel);
     this.velocity = PVector.add(b.velocity, relativeVelocity);
     b.velocity = PVector.add(b.velocity, vel); 
  }
  
  void move() {
    
    // Only move the ball in the x direction if its x velocity is larger than the threshold - this way, the ball's motion in the x direction will eventually stop    
    this.velocity.x *= dampingVelocity;
    this.velocity.y += gravity;
    this.velocity.z *= dampingVelocity;
    
    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;
    this.position.z += this.velocity.z;
  }
  
  void printToScreen() {

    pushMatrix();
    translate(this.position.x, this.position.y, this.position.z);
    this.angle += radians(this.velocity.x);
    rotate(this.angle);
    shape(ball);
    popMatrix();
  }
}

class Box {
  
  public int boxWidth;
  public int boxHeight;
  public int boxDepth;
  
  public Box(int boxWidth, int boxHeight, int boxDepth){
    
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.boxDepth = boxDepth;    
  }
 
  void printToScreen() {
  
    pushMatrix();
      colorMode(RGB);
      stroke (0, 255, 255);
      noFill();
      translate(width/2, height/2, this.boxDepth/2);
      box(this.boxWidth, this.boxHeight, this.boxDepth);
    popMatrix(); 
  }
}

void mouseClicked() {
  
  // spawn a ball if it is within the box  
  if (mouseX > RADIUS && mouseX < width - RADIUS && mouseY > RADIUS && mouseY < height - RADIUS) {
    textureIndex = int(random(0, textures.size()));
    b = new Ball(textures.get(textureIndex));
    balls.add(b);
  }
}

void setup(){
    size(displayWidth, displayHeight, P3D);
    
    textures.add(loadImage("textures//blue.jpg"));   
    textures.add(loadImage("textures//zebra.jpg"));
    textures.add(loadImage("textures//fire.PNG"));
    textures.add(loadImage("textures//wood.jpeg"));
    textures.add(loadImage("textures//glass.jpg"));
    textures.add(loadImage("textures//neural.jpg"));
    textures.add(loadImage("textures//sparks.jpg"));
    textures.add(loadImage("textures//trees.jpg"));
}

void draw(){
  background(0);
    
  box.printToScreen();

  for (Ball b : balls){
    
    b.checkWallCollisions(box);
    b.checkBallCollisions();   
    b.move();
    b.printToScreen();   
  }
}
  
