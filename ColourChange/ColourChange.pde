color bg;
color orange = color(247, 155, 15);
color white = color(255, 255, 255);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color black = color(0, 0, 0);

color squarecolor = red;
int blackstrip = 800;
int newbackground = 920;
color newbgcolor = green;
int score;
float speed = 1000.0;
int speedstep = 1;
int Highscore;
boolean alive = true;


int flashcount = 0;


float startx = 100;//sets up variables for position and size of the start button
float starty = 50;
float startw = 150;
float starth = 80;


float quitx = 300;//sets up variables for the position and size of the quit button
float quity = 50;
float quitw = 150;
float quith = 80;

float pausex = 20;//sets up variables for the position and size of the pause button
float pausey = 20;
float pausew = 20;
float pauseh = 20;

color quitbc = white;//sets up button colors
color startbc = white;

boolean menudisplay = true;


void setup () {
  bg = red;
  size(800, 500); 
  // Load text file as a string
  String[] stuff = loadStrings("Highscore.txt");
  // Convert string into an array of integers using ',' as a delimiter
  Highscore = int(split(stuff[0], ',')[0]);
  print(Highscore);
}


void draw () {
  if (menudisplay == true) {
    menuon();
  } else {
    /* Do normal game stuff */
    background (bg); 
    pausePressed();
    fill(black);
    rect(blackstrip, 0, 120, 500);

    fill(newbgcolor);
    rect(newbackground, 0, 800, 500);

    fill(squarecolor);
    rect(400, 250, 60, 60);

    fill(white);
    textSize(15);
    text("Score = " + score/100, 10, 60);

    fill(white);
    textSize(15);
    text("Highscore = " + Highscore, 10, 80);
    
    rect(pausex, pausey, pausew, pauseh);

    if (alive) {
      alive = !checkCollision();
      if (!alive) { 
        if (score/100 > Highscore) {
          Highscore = score/100;
          saveHighscore();
        }
      }
    }

    if (!alive) {
      if (++flashcount < 40) {
        if ((flashcount % 10) < 5) {
          background(white);
        }
      } else {
        textSize(50);
        fill(white);
        text("GAME OVER", 280, 200);
        text("YOUR SCORE WAS " + score/100, 200, 250);
        textSize(35);
        text("TAP THE SCREEN TO CONTINUE", 165, 300);
      }
    } else {

      if (blackstrip <= -121) {
        blackstrip = 800;
      }
      if (newbackground <= -1) {
        newbackground = 920;
        bg = newbgcolor;
        newbgcolor = randomColor();
      }
      newbackground = newbackground-speedstep;
      blackstrip = blackstrip-speedstep;
      speed = speed+1;
      speedstep = (int)speed/1000;

      score = score + 1;
    }
  }
} 

void saveHighscore() {
  // Create a new file in the sketch directory
  PrintWriter output = createWriter("Highscore.txt"); 
  output.println(Highscore);
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
}

void keyPressed() {

  if (alive) {
    if (squarecolor == red) {
      squarecolor = blue;
    } else if (squarecolor == blue) {
      squarecolor = green;
    } else if (squarecolor == green) {
      squarecolor = red;
    }
  } else {
    squarecolor = red;
    bg = red;
    blackstrip = 800;
    newbackground = 920;
    newbgcolor = green;
    score = 0;
    speed = 1000.0;
    alive = true; 
    flashcount = 0;
  }
}

int randomColor() {
  float randomColor = random(3);
  color theColor = red;
  if (randomColor <= 1.0) {
    theColor = red;
  }
  if (randomColor <= 2.0 && randomColor > 1.0) { 
    theColor = blue;
  }
  if (randomColor <= 3.0 && randomColor > 2.0) { 
    theColor = green;
  }
  return theColor;
}

void menuon() {

  fill(startbc);//sets up the start button and color
  rect(startx, starty, startw, starth);
  fill(quitbc);//sets up the quit button and color
  rect(quitx, quity, quitw, quith);

  fill(green);//draws the button text
  textSize(40);
  text("start", 135, 100);

  fill(green);//draws the button text
  textSize(40);
  text("quit", 335, 100);

  //changes the color of the buttons if they are pressed
  if (mousePressed) {
    if (mouseX>startx && mouseX <startx+startw && mouseY>starty && mouseY <starty+starth) {
      println("The mouse is pressed and over the start button");
      startbc = black;
      menudisplay = false;
    } else {
      if (mouseX>quitx && mouseX <quitx+quitw && mouseY>quity && mouseY <quity+quith) {
        println("The mouse is pressed and over the quit button");
        quitbc = red;
        exit();
      }
    }
  }
}

boolean checkCollision() {
  if (getLeftBackground() == black && getRightBackground() == black) {
    return false;
  }

  if (getRightBackground() == newbgcolor) {
    if (newbgcolor == squarecolor) {
      return false;
    } else {     
      return true;
    }
  } else {
    if (bg == squarecolor) {
      return false;
    } else {
      return true;
    }
  }
}

color getRightBackground() {
  return getColorBehindXPosition(460);
}

color getLeftBackground() {

  return getColorBehindXPosition(400);
}

color getColorBehindXPosition(int x) {
  if (blackstrip <= x && (blackstrip + 120) > x) {
    return black;
  }

  if (newbackground <= x) {
    return newbgcolor;
  } 

  return bg;
}

void pausePressed () {
  if (mousePressed) {
    if (mouseX>pausex && mouseX <pausex+pausew && mouseY>pausey && mouseY <pausey+pauseh) {
      println("The mouse is pressed and over the pause button"); 
      /*if (looping)  noLoop();
       else          loop();*/
    }
  }
} 
 
