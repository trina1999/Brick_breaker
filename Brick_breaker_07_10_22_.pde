             //////////////////configuration variables////////////////
int numBrickRows = 4;
int brickWidth = 60;
int brickHeight = 30;
int paddleHeight = brickHeight;
int paddleWidth = int(brickWidth*1.1);
int ballDiameter = 15;
int round = 1;
int maxround = 3;
int tempround = round +1;
////////////////global variables/////////////
Brick[] bricks = new Brick[0];
Paddle myPaddle;
Ball myBall;
           ///////////////normal setup function//////////////////
void setup() {
  size(400, 400);
  smooth();
                  /////////////placing the bricks////////////
  for (int j=0; j < numBrickRows; j++) { // rows
           ////////////////////location of each row///////////
    int y = brickHeight / 2 + j * brickHeight;
           //////////////set the roww offset//////
    int offset = 0;
    if (j % 2 == 0) {
      offset = brickWidth / 2;
    }
                   ////////////draw the row/////////
    for (int i=offset; i < width+brickWidth/2.0; i += brickWidth) { // columns
      bricks = (Brick[]) append(bricks, new Brick(i, y));
    }
  }
                 /////////create paddle///////////
  myPaddle = new Paddle();
}
 ////////////////////normal draw() function/////////////

void draw() {
  background(255);
          ////////////////draw bricks/////////////
  for (int i=0; i < bricks.length; i++) {
    if (bricks[i] != null) {
      bricks[i].draw();
    }
  }
                 ///////////////draw and update ball/////////////////
  if (myBall != null) {
    myBall.draw();                                                                        ////////////////////////////////////////////////////
    myBall.update();
  }
           /////////////////////counting of round number////////////////
 int temp = round - 1;
 text ("max round: 3",50, height- 80);
 text("round no: "+temp, 50, height - 50);
                   ////////////draw paddle///////
  myPaddle.display();
                      ///////////////////////test for ball with paddle///////////
  if (myBall != null && myPaddle.impact(myBall)) {
    myBall.bounce();
    myPaddle.speedOfBall(myBall);
  }
  if (myBall != null) {
    for (int i=0; i < bricks.length; i++) {
      if (bricks[i] != null && bricks[i].impact(myBall) == true) {
        myBall.bounce();
        bricks[i] = null;
      }
    }
  }
  if (myBall != null && myBall.yPosition-ballDiameter/2 < 0) {
    myBall.bounce();
  }
  if (myBall != null && myBall.yPosition-ballDiameter/2 > height) {
    myBall = null;
  }
}
                     /////////////////mouseclicked, which fires a new ball///////////////
void mouseClicked() {
  if (round <= maxround) {
    if (myBall == null) {
      myBall = new Ball(myPaddle.xPos, height - paddleHeight - ballDiameter/2, 0, -2);        //-------------------------------------------------------------------------------------
      round = round +1;
    }
  } else
  {
    textSize(30);
    text("game over", width/2, height/2);
    textSize(15);
    text("Score:- 4", width/2, 350);
    
  }
}
                    ///////////////////ball for brick-breaker///////////////
class Ball {
  int xPosition;
  int yPosition;
  int xSpeed;
  int ySpeed;
               ////////////////////////initial speed in x and initial speed in y direction//////////////////////
  Ball(int x, int y, int xInitialSpeed, int yInitialSpeed) {
    xPosition = x;
    yPosition = y;
    xSpeed = 2;
    ySpeed = 2;
  }
          /////////////////////draws the ball//////////
  void draw() {
    fill(0);
    ellipse(xPosition, yPosition, ballDiameter, ballDiameter);
  }
               /////////////////////updates the position the ball, bouncing off verticals////////////////////
  void update() {
              //////////////update position/////////////
    xPosition += xSpeed;
    yPosition += ySpeed;
              /////////////////bounces the ball vertically/////////////////
    if (xPosition < 0 || xPosition > width) {
      xSpeed *= -1;
    }
  }
                 /////////////bounces the ball horizontally//////////////////
  void bounce() {
    ySpeed *= -1;
  }
}
                      //////////////////represents the brick in the game//////////////////////////
class Brick {
  int xPosition;
  int yPosition;
  color c;
  
                       //////////////x-position and y-position of the brick/////////////////////////
  Brick(int x, int y) {
    xPosition = x;
    yPosition = y;
    c = color(random(255), random(255), random(255));
  }
             /////////////////for drawing the brick///////////
  void draw() {
    rectMode(CENTER);
    fill(c);
    rect(xPosition, yPosition, brickWidth, brickHeight);
  }
              /////////////////detects whether the ball b impacts the brick//////////////////////
              ///////////////ball b testing/////////////
              ////////////////////returns true if there was an impact, or else false/////////////////
    boolean impact(Ball b) {
    if (xPosition - brickWidth/2 <= b.xPosition &&
      b.xPosition <= xPosition + brickWidth/2 &&
      yPosition + brickHeight/2 > b.yPosition-ballDiameter/2)
      return true;
    else
      return false;
  }
}
        /////////////paddle of the game////////////
class Paddle {
  int xPos = mouseX;
  int yPos = height - paddleHeight/2;
  int xPosPrevious;
      ///////////////displays the paddle///////////////////
  void display() 
    {
      fill(0);
      xPosPrevious = xPos;
      xPos = mouseX;
      rect(xPos, yPos, paddleWidth, paddleHeight);
    }
    ////detects whether the ball is effecting the paddle or not
    ///////tesing the ball b whether its effecting
         ////////returns whether there's any impact
  boolean impact(Ball b) {
    if (xPos - paddleWidth/2 <= b.xPosition && b.xPosition <= xPos + paddleWidth/2 && yPos - paddleHeight/2 < b.yPosition+ballDiameter/2)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
       /////x velocity of the paddle to the ball
  void speedOfBall(Ball b) {
    int xVector = xPos - xPosPrevious;
    b.xSpeed += xVector;
  }
  
}
