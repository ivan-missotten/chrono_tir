/*
Copyright 2011 Ivan Missotten.

This progrm is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>

*/

#include <WConstants.h> 
#include <LiquidCrystal.h>
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

long commencement;

int etatclear;
int minutePasser;
int secondePasser;
int minuteTotal;
int secondeTotal;
int etat;
int led_state;
char secondes;
char minutes;
char color;
char ligne;
char printLigne;
char typeLigne; 
char changement;
bool chrono = false;


#define WORK 0
#define MENU 1

#define vert 1
#define orange 2
#define rouge 0

#define ledVert 10
#define ledOrange 9
#define ledRouge 8

#define btnDroit 6
#define btnMilieu 7
#define btnGauche 13

#define abcd 1
#define abc 0
#define a 0 || 1
#define b 2
#define c 3
#define ab 1
#define cd 2

void setup()
{ 
  etatclear = 0;
  minutePasser = 0;
  secondePasser = 0;
  minuteTotal = 0;
  secondeTotal = 0;
  changement = 2;
  printLigne = a;
  typeLigne = abc;
  color = rouge;
  etat = WORK;
  minutes = 2;
  secondes = 10;
  pinMode(btnDroit, INPUT);
  pinMode(7, INPUT);
  pinMode(btnGauche, INPUT);
  pinMode(ledVert, OUTPUT);
  pinMode(ledOrange, OUTPUT);
  pinMode(ledRouge, OUTPUT);
  Serial.begin(9600);
  lcd.begin(16, 4);
}

void loop ()
{
  switch(etat)
  {
    case WORK:
      actionconteur();
    break;
    case MENU:
      actionmenu();
    break;
  }
}
  
void actionconteur() // fonction principal (conteur).
{
  if (digitalRead(btnDroit) == LOW)
  {
    etat = MENU;
  }
  conteur();
  printConteur();
  ledState();
  gestionLigne();
  printmenu();
  lcd.setCursor(0, 0);
  lcd.print("getsion des feux");
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          
void conteur ()
{
  if (digitalRead(7) == LOW)
  {
    chrono = true;
    while(chrono == true)
    {
    sortieConteur();
    printConteur();
    ledState();
    gestionLigne();
    printmenu();
    static unsigned long currentMillis = 0;
    if ((millis() - currentMillis) > 1000)
    {
      if (secondes > 0)
        secondes --;
      else if(minutes > 0) 
      {
        secondes = 59;
        minutes --;
      }
      if (minutes == 2 && secondes == 9)
      {
        Serial.print ("rouge");
        color = rouge;
      }
      if (minutes == 2 && secondes == 0)
      {
        color = rouge;
        Serial.print("rouge \n");
      }
      if (minutes >= 0 && secondes > 30) 
      {
         color = vert;
         Serial.print("vert \n");
      } 
      if (minutes == 0 && secondes == 0) 
      {
         while (changement =! 0 && changement > 0)
         {
         changement --;
         Serial.println(ligne);
         }
         color = rouge;
         Serial.print("rouge \n");
      } 
      else if(minutes == 0 && secondes <= 30) 
      {
         color = orange;
         Serial.print("orange \n");
      }
      currentMillis = millis();
    }
    }
  }
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

void sortieConteur()
{
    chrono == false;
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

void printConteur()
{
  lcd.setCursor (12, 1);
  lcd.print ((int)minutes);
  lcd.print (":");
  if (secondes < 10)
  {
    lcd.print ("0");
  }
  lcd.print ((int)secondes);
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

void ledState ()// sert a allumer la led correstondante a l'etat.
{
  conteur();
  switch (color)
  {
    case rouge:
      lcd.setCursor(0, 1);
      lcd.print("etat:");
      lcd.setCursor(5, 1);
      lcd.print("      ");
      lcd.setCursor(5, 1);
      lcd.print("rouge");
      digitalWrite(ledVert, LOW);
      digitalWrite(ledOrange, LOW);
      digitalWrite(ledRouge, HIGH);
    break;
    case vert:
      lcd.setCursor(0, 1);
      lcd.print("etat:");
      lcd.setCursor(5, 1);
      lcd.print("     ");
      lcd.setCursor(5, 1);
      lcd.print("vert");
      digitalWrite(ledRouge, LOW);
      digitalWrite(ledOrange, LOW);
      digitalWrite(ledVert, HIGH);
    break;
    case orange:
      lcd.setCursor(0, 1);
      lcd.print("etat:");
      lcd.setCursor(5, 1);
      lcd.print("     ");
      lcd.setCursor(5, 1);
      lcd.print("orange");      
      digitalWrite(ledRouge, LOW);
      digitalWrite(ledVert, LOW);
      digitalWrite(ledOrange, HIGH);
    break;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

void gestionLigne()
{
  switch (typeLigne)
  {
    case abc:
      conteur();
      switch (changement)
      {
        case 2:
          changement --;
          Serial.println(changement);
          Serial.print ("ligne initialiser à A");
          Serial.print(ligne);
          lcd.setCursor(-4, 2);
          lcd.print("type abc");
          lcd.setCursor(5, 2);
          lcd.print("ligne:A");
        break;
        
        case 0:
          Serial.print(changement);
          changement ++;
          if(ligne = a)
          {
            Serial.print ("ligne changer de A à B \n");
            Serial.println(ligne);
            ligne = b;
            lcd.setCursor(-4, 2);
            lcd.print("type abc");
            lcd.setCursor(5, 2);
            lcd.print("ligne:B");
          }
        else if(ligne = b)
        {
          Serial.print("ligne changer B à C \n");
          Serial.println(ligne);
          ligne = c;
          lcd.setCursor(-4, 2);
          lcd.print("type abc");
          lcd.setCursor(5, 2);
          lcd.print("ligne:C");
        }
        else if(ligne = c)
        {
          Serial.print("ligne changer C à A \n");
          Serial.println(ligne);
          ligne = a;
          lcd.setCursor(-4, 2);
          lcd.print("type abc");
          lcd.setCursor(5, 2);
          lcd.print("ligne:A");
        }
      break;
      }
    break;
    case abcd:
    break;
  }
  
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

void printmenu()
{
    if (chrono == false)
    {
      lcd.setCursor (-4, 3);
      lcd.print ("Menu");
      lcd.setCursor (1, 3);
      lcd.print ("Start");
      lcd.setCursor (7, 3);
      lcd.print("Reset");
    }
    if (chrono == true)
    {
      lcd.setCursor (-4, 3);
      lcd.print ("       ");
      lcd.setCursor (2, 3);
      lcd.print ("Stop ");
      lcd.setCursor (7, 3);
      lcd.print("     "); 
    }
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



void actionmenu() // setup de la carte.
{
  while (etatclear == 0)
  {
    lcd.clear();
    etatclear ++;
  }
  affichagemenu();
  setupTemp();
  setupLigne();
  printSetupLigne();
  printSetupTemp();
}

void affichagemenu()
{

}

void printSetupLigne()
{

}

void printSetupTemp()
{
  lcd.setCursor(0, 0);
  lcd.print("setup temp");
  lcd.setCursor (5, 1);
  lcd.print ((int)minutes);
  lcd.print (":");
  if (secondes < 10)
  {
    lcd.print ("0");
  }
  lcd.print ((int)secondes);
}

void setupTemp()
{
  secondeTotal = secondes + secondePasser;
  minuteTotal = minutes + minutePasser;
  minuteTotal ++;
  if (secondes > 59);
  {
    secondes = 0;
    minuteTotal ++;
  }
  secondes == secondeTotal;
  minutes == minuteTotal;
}

void setupLigne()
{

}