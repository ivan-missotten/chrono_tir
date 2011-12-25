/* Copyright 2011 Ivan Missotten

   This progrm is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 13, 5, 4, 3, 2);
char etat; /* Config ou En fonctionnement */
char color; /* Couleur du feu */

char minutes, secondes;
char configLigne;
char countDown; /* Countdown enabled */

#define WORK 0
#define CONFIG 1

#define RED 0
#define ORANGE 1
#define GREEN 2

#define REDLED 9
#define ORANGELED 10
#define GREENLED 11

#define MENUBTN 6
#define STARTBTN 7
#define RESETBTN 8

#define ABC 0
#define ABCD 1

void setup()
{
  etat = WORK;
  color = RED;
  minutes = 2;
  secondes = 10;
  configLigne = ABC;
  countDown = 0;

  lcd.begin(16, 4);
  pinMode(MENUBTN, INPUT);
  pinMode(STARTBTN, INPUT);
  pinMode(RESETBTN, INPUT);
  pinMode(REDLED, OUTPUT);
  pinMode(ORANGELED, OUTPUT);
  pinMode(GREENLED, OUTPUT);
  
}
void loop()
{
  switch(etat)
  {
    case WORK:
      actionWork();
    break;
    case CONFIG:
      actionConfig();
    break;
  }
  
}

void actionWork()
{
  lcd.setCursor (0, 0);
  lcd.print ("Gestion des feux");
  ledShowColor();
  lcdPrintColor();
  lcdPrintTime();
  lcdPrintLineConfig();
  lcd.setCursor (6, 2);
  lcd.print ("A");
  if (countDown)
    runCounter();
  handleBtn();
  lcdShowScreen();
}

void lcdShowScreen()
{
  if (!countDown) 
  {
    lcd.setCursor (-4, 3);
    lcd.print ("Menu");
    lcd.setCursor (1, 3);
    lcd.print ("Start");
    lcd.setCursor (7, 3);
    lcd.print("Reset");
  }
  else
  {
    lcd.setCursor (-4, 3);
    lcd.print ("     ");
    lcd.setCursor (1, 3);
    lcd.print ("Stop ");
    lcd.setCursor (7, 3);
    lcd.print("     ");    
  }

}

void lcdPrintColor ()
{
  lcd.setCursor (0, 1);
  switch (color) {
    case RED:
      lcd.print ("Rouge ");
      break;
    case ORANGE:
      lcd.print ("Orange");
      break;
    case GREEN:
      lcd.print ("Vert  ");
      break;
  }
}

void ledShowColor ()
{
    switch (color) {
    case RED:
      digitalWrite (REDLED, HIGH);
      digitalWrite (ORANGELED, LOW);
      digitalWrite (GREENLED, LOW);
      break;
    case ORANGE:
      digitalWrite (REDLED, LOW);
      digitalWrite (ORANGELED, HIGH);
      digitalWrite (GREENLED, LOW);
      break;
    case GREEN:
      digitalWrite (REDLED, LOW);
      digitalWrite (ORANGELED, LOW);
      digitalWrite (GREENLED, HIGH);
      break;
  }
}

void lcdPrintTime ()
{
  lcd.setCursor (10, 1);
  lcd.print ((int)minutes);
  lcd.print (":");
  if (secondes < 10)
    lcd.print ("0");
  lcd.print ((int)secondes);
}

void lcdPrintLineConfig ()
{
  lcd.setCursor (-4, 2);
   switch (configLigne) {
    case ABC:
      lcd.print ("ABC");
      break;
    case ABCD:
      lcd.print ("ABCD");
      break;
  }
}

void runCounter()
{
  static unsigned long currentMillis = 0;
  if ((millis() - currentMillis) > 1000) {
    if (secondes > 0)
      secondes --;
    else if(minutes > 0) {
      secondes = 59;
      minutes --;
    }
    if (minutes >= 0 && secondes > 30) {
       color = GREEN;
    } 
    if (minutes == 0 && secondes == 0) {
       color = RED;
    } else if(minutes == 0 && secondes <= 30) {
       color = ORANGE;
    }
    currentMillis = millis();
  }

}

void handleBtn()
{
  static char MenuBtn = 0;
  static char ResetBtn = 0;
  static char StartBtn = 0;
  
  if ((!digitalRead (RESETBTN)) && ResetBtn && (!countDown))
  {
    minutes = 2;
    secondes = 10;
    color = RED;
  }
  
  if ((!digitalRead (STARTBTN)) && StartBtn)
  {
    countDown = !countDown;
  }
  
  if ((!digitalRead (MENUBTN)) && MenuBtn && (!countDown))
  {
    etat = CONFIG;
    lcd.clear();
  }
  
  MenuBtn = digitalRead (MENUBTN);
  ResetBtn = digitalRead (RESETBTN);
  StartBtn = digitalRead (STARTBTN);
  
}

void actionConfig()
{
  if 
}
