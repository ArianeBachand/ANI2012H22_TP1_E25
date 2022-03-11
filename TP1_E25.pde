import processing.sound.*;

float xTv;
float yTv;
float largeurFenetre;
float hauteurFenetre;

int xspeed;
int yspeed;

int sectionActiveAtStartup = 1;
int sectionActive = sectionActiveAtStartup;

PImage imgDvd;
PImage imgOffice;
PImage imgRoasted;
PImage imgVictoire;

SoundFile audioTitre;
SoundFile audioJeux;
SoundFile audioDefaite;
SoundFile audioVictoire;
SoundFile audioStrike;

boolean b1; //Bouton Facile enfoncé
boolean b2; //Bouton Normal enfoncé
boolean b3; //Bouton Difficile enfoncé

PFont fontGaramond;
PFont fontGoudy;
PFont fontHimalaya;

float r, g, b; //Variables de couleur

boolean isPlayButtonPressed;
boolean isMouseInsidePlayButton;

float playButtonPositionX;
float playButtonPositionY;
float playButtonWidth;
float playButtonHeight;
float playButtonScaleUp;
float playButtonScaleDown;
float playButtonMinX;
float playButtonMinY;
float playButtonMaxX;
float playButtonMaxY;

color colorPlayButtonNormal = color(68, 255, 0);
color colorPlayButtonInside = color(0, 214, 104);
color colorPlayButtonPressed = color(214, 4, 0);

//boolean isDvdButtonPressed; pas certain qu'on en a de besoin
boolean isMouseInsideDvdButton;
boolean isDvdButtonPressed;

float dvdButtonPositionX;
float dvdButtonPositionY;
float dvdButtonWidth;
float dvdButtonHeight;
float dvdButtonScaleUp;
float dvdButtonScaleDown;
float dvdButtonMinX;
float dvdButtonMinY;
float dvdButtonMaxX;
float dvdButtonMaxY;

int score;
int strikeCount;
int maxStrike = 3;
int scoreGagnant = 30;

//stop-motion-----------------------------------
// paramètres
String filePrefix = "feu";
String fileExtension = ".png";

// nombre d'image dans l'animation
int animationFrameCount = 38;

// variables
PImage[] animation;

String fileName;

int keyframe;



void setup()
{
  size(800, 650);
  //frameRate(30);
  
  b1 = false; //Bouton Facile enfoncé
  b2 = true; //Bouton Normal enfoncé
  b3 = false; //Bouton Difficile enfoncé
  
  fontGaramond = loadFont("Garamond-Bold-48.vlw");
  fontGoudy = loadFont("GoudyStout-48.vlw");
  fontHimalaya = loadFont("Microsoft_Himalaya-200.vlw");
  
  imgDvd = loadImage("dvd_logo_fond.png");
  imgOffice = loadImage("logo.png");
  imgRoasted = loadImage("nooo.jpg");
  imgVictoire = loadImage("party.jpg");
  
  audioTitre = new SoundFile(this, "opening.mp3");
  audioJeux = new SoundFile(this, "medley.mp3");
  audioDefaite = new SoundFile(this, "lose.mp3");
  audioVictoire = new SoundFile(this, "win.mp3");
  audioStrike = new SoundFile(this, "no.mp3");
  
  audioTitre.loop();
  
  xTv = random(width);
  yTv = random(height);
  xspeed = 4; //Vitesse normale par défaut
  yspeed = 4;
  setRandomColor();
  
  playButtonPositionX = width / 2.0f;
  playButtonPositionY = (height/8.0f) * 7.0f;
  playButtonWidth = (width/9.0f) * 4.0f;
  playButtonHeight = (height/675.0f) * 100.0f;
  playButtonScaleUp = 1.05f;
  playButtonScaleDown = 0.95f;
  playButtonMinX = playButtonPositionX - (playButtonWidth / 2.0f);
  playButtonMinY = playButtonPositionY - (playButtonHeight / 2.0f);
  playButtonMaxX = playButtonPositionX + (playButtonWidth / 2.0f);
  playButtonMaxY = playButtonPositionY + (playButtonHeight / 2.0f);
  isPlayButtonPressed = false;
  isMouseInsidePlayButton = false;
  
  dvdButtonWidth = imgDvd.width;
  dvdButtonHeight = imgDvd.height;
  score = 0;
  strikeCount = 0;
}

void setDifficulty() //Dessine l'intérieur du bouton radio sélectionné
{
  if(b1)//Facile
  {
    fill(0);
    ellipse(width/3.0f, height/12.0f, width/60.0f, width/60.0f);
  }
  if(b2)//Normal
  {
    fill(0);
    ellipse(width/2, height/12.0f, width/60.0f, width/60.0f);
  }
  if(b3)//Difficile
  {
    fill(0);
    ellipse((width/3.0f)*2, height/12.0f, width/60.0f, width/60.0f);
  }
}

void setRandomColor()
{
  r = random(100, 256);
  g = random(100, 256);
  b = random(100, 256);
  
}

void draw()
{
 switch (sectionActive)
  {
    case 1:
      sectionTitre();
      break;
    case 2:
      sectionJeux();
      break;
    case 3:
      sectionDefaite();
      break;
    case 4:
      sectionVictoire();
      break;
  }
}

void sectionTitre()//------------------------------------------------------------------------------------------------------------------------------------------------------------------
{ 
   
  background(0);
  tint(255);
  imageMode(CENTER);
  image(imgOffice, width/2, height/4);
  fill(255);
  textAlign(CENTER, CENTER);
  textFont(fontHimalaya, 125);
  text("THE DVD GAME", width/2, height/2);
  
  
  textAlign(CENTER, CENTER);
  textFont(fontGaramond, 35);
  text("Comment jouer :", width/2, (height/5)*3);
  text("Clique sur le logo DVD le plus de fois possible", width/2, (height/3)*2);
  textFont(fontGaramond, 25);
  text("(Tu as droit à trois erreurs.)", width/2, (((height*1000)/600)*440)/1000);
  
  
  //Bouton "Jouer"
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed == true)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  fill(255);
  textFont(fontGoudy, 40);
  text("Jouer!", playButtonPositionX, playButtonPositionY);
  
  
  //Les trois boutons radio
  fill(255);
  textFont(fontGaramond, 30);
  text("Facile", width/3.0f, height/24.0f);
  
  fill(255);
  textFont(fontGaramond, 30);
  text("Normal", width/2, height/24.0f);
  
  fill(255);
  textFont(fontGaramond, 30);
  text("Difficile", (width/3.0f)*2.0f, height/24.0f);
  
  //Bouton radio FACILE
  fill(255);
  ellipse(width/3.0f, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();
  
  //Bouton radio NORMAL
  fill(255);
  ellipse(width/2, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();
  
  //Bouton radio DIFFICILE
  fill(255);
  ellipse((width/3.0f)*2, height/12.0f, width/36.0f, width/36.0f);
  setDifficulty();

}

void sectionJeux()//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
  background(0);
  fill(255);
  tint(r, g, b);
  rectMode(CORNER);
  rect(0, (height/13.0f)*12.0f, width, (height/13.0f));
  fill(0);
  textAlign(CENTER, CENTER);
  textFont(fontGoudy, 30);
  text("Score : " + score + "   Strike : " + strikeCount, (width/2.0f), ((height/13.0f)*12.0f)+((height/13.0f)/2.0f));
  imageMode(CORNER);
  tint(r, g, b);
  image(imgDvd, xTv, yTv);

  dvdButtonMaxX = dvdButtonWidth + xTv;
  dvdButtonMaxY = dvdButtonHeight + yTv;
  isMouseInsideDvdButton = false;
  isDvdButtonPressed = false;
  
  //Valide si la souris est à l'interieur de l'image Dvd
  if (mouseX >= xTv && mouseX <= dvdButtonMaxX)
  {
    if (mouseY >= yTv && mouseY <= dvdButtonMaxY)
    {
      isMouseInsideDvdButton = true;
    }

  }
  else
    isMouseInsideDvdButton = false;

  
  xTv = xTv + xspeed;
  yTv = yTv + yspeed;

//Valide si l'image atteint le bord
  if (xTv + imgDvd.width >= width)
  {
    xspeed = -xspeed;
    xTv = width - imgDvd.width;
    setRandomColor();
  } else if (xTv <= 0)
  {
    xspeed = -xspeed;
    xTv = 0;
    setRandomColor();
  }
  
  if (yTv + imgDvd.height >= (height/13.0f)*12.0f)
  {
    yspeed = -yspeed;
    yTv = (height/13.0f)*12.0f - imgDvd.height;
    setRandomColor();
  } else if (yTv <= 0)
  {
    yspeed = -yspeed;
    yTv = 0;
    setRandomColor();
  }
} 
  

void sectionDefaite()//----------------------------------------------------------------------------------------------------------------------------------------------------------------
{
  background(255);
  imageMode(CORNER);
  tint(0, 0 , 255);
  image(imgRoasted, 0, 0);
  filter(POSTERIZE, 15);
  fill(255);
  textFont(fontGaramond, 60);
  text("ROASTED.", width/2, height/3);
  textFont(fontGaramond, 40);
  text("Score = " + score, width/2, (height*3)/4);
  
  fill(150);
  noStroke();
  circle(width/6.0f, (height/32.0f)*17.0f, width/6.0f);
  rectMode(CENTER);
  square(width/6.0f, ((height/32.0f)*17.0f) + (width/6.0f)/2.0f, width/6.0f);
  stroke(50);
  strokeWeight(2);
  rect(width/6.0f, ((height/32.0f)*17.0f) + (width/6.0f) + ((width/6.0f)/6.0f)/2.0f - 1.0f, (width/6.0f)+(width/6.0f)/4.0f, (width/6.0f)/6.0f, 12, 12, 1, 1);
  strokeWeight(10);
  strokeCap(SQUARE);
  line(width/6.0f, (((height/32.0f)*17.0f) + (width/6.0f)/2.0f) - (width/6.0f)/4.0f, width/6.0f, (((height/32.0f)*17.0f) + (width/6.0f)/2.0f) + (width/6.0f)/4.0f);
  line(width/6.0f - (width/6.0f)/6.0f, ((height/32.0f)*17.0f) + (width/6.0f)/2.0f - (width/6.0f)/12.0f, 
       width/6.0f + (width/6.0f)/6.0f, ((height/32.0f)*17.0f) + (width/6.0f)/2.0f - (width/6.0f)/12.0f);
  noStroke();
  
  fill(50);
  textFont(fontGaramond, 30);
  text("R.I.P.", width/6.0f, (height/32.0f)*17.0f);
  
  //((height/32.0f)*17.0f) + (width/6.0f)/2.0f    (height/32.0f)*17.0f + (width/6.0f)/16.0f
  
  //Bouton Réessayer
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  fill(255);
  textFont(fontGoudy, 28);
  text("Réessayer?", playButtonPositionX, playButtonPositionY);

}


void sectionVictoire()//---------------------------------------------------------------------------------------------------------------------------------------------------------------
{
  background(255);
  tint(255);
  imageMode(CORNER);
  image(imgVictoire, 0, 0);
  fill(255);
  textFont(fontGaramond, 60);
  text("Victoire!", width/2, height/2);
  textFont(fontGaramond, 40);
  text("Score = " + score, width/2, (height*2)/3);
  
  //Bouton rejouer
  rectMode(CENTER);
  if (mouseX >= playButtonMinX && mouseX <= playButtonMaxX)
  {
    // valider si le curseur est à l'intérieur des limites du bouton sur l'axe Y
    if (mouseY >= playButtonMinY && mouseY <= playButtonMaxY)
    {
      // le curseur est à l'intérieur du bouton
      isMouseInsidePlayButton = true;
    }
    else
      isMouseInsidePlayButton = false;
  }
  else
    isMouseInsidePlayButton = false;

  // valider si le bouton est enfoncé
  if (isPlayButtonPressed)
  {
    // dessiner le bouton en mode enfoncé
    fill(colorPlayButtonPressed);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleDown, playButtonHeight * playButtonScaleDown, 40);

  }
  else if (isMouseInsidePlayButton) // le bouton n'est pas enfoncé, mais le curseur est-il à l'intérieur ?
  {
    // dessiner le bouton en mode relâché avec curseur à l'intérieur
    fill(colorPlayButtonInside);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth * playButtonScaleUp, playButtonHeight * playButtonScaleUp, 40);
  }
  else // le bouton n'est pas enfoncé et le curseur est à l'extérieur
  {
    // dessiner le bouton en mode relâché avec curseur à l'extérieur
    fill(colorPlayButtonNormal);
    rect(playButtonPositionX, playButtonPositionY, playButtonWidth, playButtonHeight, 40);
  }

  fill(255);
  textFont(fontGoudy, 35);
  text("Rejouer?", playButtonPositionX, playButtonPositionY);

//stop-motion___________________________________________________________
  frameRate(50);
  

  // initialiser le tableau qui contiendra les images de l'animation
  animation = new PImage[animationFrameCount];

  for (keyframe = 1; keyframe <= animationFrameCount; ++keyframe)
  {
    // construire le nom du fichier en fonction du keyframe
    // la fonction nf() permet de formatter un nombre vers une chaîne de 4 caractères
    // afin de correspondre au nom du fichier de chaque image
    fileName = filePrefix + nf(keyframe, 4) + fileExtension;

    // importer l'image qui correspond au nom de fichier
    animation[keyframe - 1] = loadImage(fileName);
  }

  keyframe = 0;
  
  
  // déterminer le keyframe courant
  keyframe = frameCount % animationFrameCount;

  // afficher l'image courante de l'animation
  
  image(animation[keyframe], 500, 300);
  image(animation[keyframe], 100, 300);
  //fin du stop-motion____________________________________________________________________________
}


void mousePressed()//------------------------------------------------------------------------------------------------------------------------------------------------------------------
{
   switch (sectionActive)
  {
    case 1:
      if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      if (mouseX >= (width/3.0f)-((width/36.0f)/2.0f) && mouseX <= (width/3.0f)+((width/36.0f)/2.0f))//facile
        {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//facile
          {
            b1 = true;
            b2 = false;
            b3 = false;
            xspeed = 2;
            yspeed = 2;
          }
        }
      if (mouseX >= (width/2.0f)-((width/36.0f)/2.0f) && mouseX <= (width/2.0f)+((width/36.0f)/2.0f))//Normal
      {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//Normal
        {
          b1 = false;
          b2 = true;
          b3 = false;
          xspeed = 4;
          yspeed = 4;
        }
      }
      if (mouseX >= ((width/3.0f)*2)-((width/36.0f)/2.0f) && mouseX <= ((width/3.0f)*2)+((width/36.0f)/2.0f))//Normal
      {
        if (mouseY >= (height/12.0f)-((width/36.0f)/2.0f) && mouseY <= (height/12.0f)+((width/36.0f)/2.0f))//Normal
        {
          b1 = false;
          b2 = false;
          b3 = true;
          xspeed = 7;
          yspeed = 7;
        }
      }
      break;
    case 2:
        if (isMouseInsideDvdButton)
          {
            if (mouseButton == LEFT || mouseButton == RIGHT)
              {
                //Clique réussis;
                score++;
              }
          }
          else
            {
              //Clique raté;
              strikeCount++;
              if(strikeCount < 3)
                audioStrike.play();
            }
              
        if (maxStrike == strikeCount)
        {
          if (score >= scoreGagnant)
            {
              audioJeux.stop();
              sectionActive = 4;
              audioVictoire.play();
            }
            else
              {
              audioJeux.stop();
              sectionActive = 3;
              audioDefaite.play();
              }
        }
  
      break;
    case 3:
    
    if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      
      break;
    case 4:
      
      if (isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          isPlayButtonPressed = true;
          }
        }
      
      break;
  }
}

void mouseReleased()
{
  switch (sectionActive)
  {
    case 1:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          sectionActive = 2;
          audioJeux.loop();
          audioDefaite.stop();
          audioVictoire.stop();
          audioTitre.stop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      break;
    case 2:
      
      break;
    case 3:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          score = 0;
          strikeCount = 0;
          sectionActive = 1;
          audioJeux.stop();
          audioVictoire.stop(); 
          audioDefaite.stop();
          audioTitre.loop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      break;
    case 4:
      if(isPlayButtonPressed)
      {
        if(isMouseInsidePlayButton)
        {
        if (mouseButton == LEFT || mouseButton == RIGHT)
          {
          score = 0;
          strikeCount = 0;
          sectionActive = 1;
          audioJeux.stop();
          audioVictoire.stop(); 
          audioDefaite.stop();
          audioTitre.loop();
          isPlayButtonPressed = false;
          isMouseInsidePlayButton = false;
          }
        }
      }
      isPlayButtonPressed = false;
      break;
  }
}

//Raccourci pour naviguer dans les sections
void keyReleased()
{
  if (key == '1')
    sectionActive = 1;
    audioJeux.stop();
    audioVictoire.stop(); 
    audioDefaite.stop();
    audioTitre.loop();

  if (key == '2')
    {
    score = 0;
    strikeCount = 0;
    audioJeux.loop();
    audioDefaite.stop();
    audioVictoire.stop();
    audioTitre.stop();
    sectionActive = 2;
    } 

  if (key == '3')
    {
    audioJeux.stop();
    audioVictoire.stop();
    audioTitre.stop();
    audioDefaite.play();
    sectionActive = 3;
    
    }
    
  if (key == '4')
    {
    audioJeux.stop();
    audioDefaite.stop();
    audioTitre.stop();
    audioVictoire.play(); 
    sectionActive = 4;
    }
} 
  
  
  
  
  
  
 
