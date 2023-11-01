import java.time.LocalDate;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.math.BigDecimal;
import java.util.Calendar;
import java.text.DecimalFormat;
import processing.pdf.*;
import java.util.Arrays;

void setup(){
  beginRecord(PDF, "output.pdf");
  size(1000, 1000);
  background(20);

  Table table;
float[] ratings, averageRatings;
Date[] datesWatched;
String movieNames[], rewatch[];

int N;

table = loadTable("diary.csv", "header");
N = table.getRowCount();


datesWatched = new Date[N];

ratings = new float[N];
averageRatings = new float[N];
movieNames = new String[N];
rewatch = new String[N];

try{
for(int i = 0; i < N; i++)  //Extract data 
{
   TableRow row = table.getRow(i);
   datesWatched[i] = new SimpleDateFormat("dd/MM/yyyy").parse(row.getString("Watched Date"));
   movieNames[i] = row.getString("Name");
   ratings[i] = row.getFloat("Rating");
   averageRatings[i] = row.getFloat("Average Rating");
   rewatch[i] = row.getString("Rewatch");
}
}
catch(Exception ex){
  System.out.println(ex);
}

fill(#5A5F5B);  //Dark grey for centre of circle
translate(500, 500);  //Move axis to centre of visualisation
circle(0, 0, 600); 

String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
fill(255, 255 ,255);  //Fill with black

for(int i = 0; i < 12; i++)    //Draw circular calendar with seasons
{
 strokeWeight(0.2);
 stroke(0,0,0);
 pushMatrix();
 if(i == 0) { strokeWeight(1); }                      //Slightly thicker line to start the year
 if(i == 1) { strokeWeight(2); stroke(#0d8509); }    // Thick green line for start of spring
 if(i == 4) { strokeWeight(2); stroke(#f7ec02); }    // Thick yellow line for start of summer
 if(i == 7) { strokeWeight(2); stroke(#8a5d0f); }    // Thick brown line for start of autumn
 if(i == 10) { strokeWeight(2); stroke(#0017c2); }   // Thick navy line for start of winter
 line(0, 0, 0, -300);
 for(int j = 0; j < monthNames[i].length(); j++){  //Print out letters of month name and slightly rotate after each letter
    text(monthNames[i].charAt(j), 10, -100);            
    rotate(0.1);
 }
 popMatrix();
 rotate(PI/6.0);    // Rotate to position of next month
}

    for(int j = 1; j <= 5; j++)    //Fill in outlines for star-ratings (1-5)
    {
      strokeWeight(0.25);
     stroke(#E8E8E8);
    
     fill(#E8E8E8);
     star(-5, -300 -(j*30), 2.5, 5.8 , 5);   
     
     if(j == 5) strokeWeight(1);  //Thicker outer line for 5-stars
     noFill();
     circle(0,0, 600 + 2*(j*30) );
  
    }
    


int[] daysInMonths = {31 +1, 28 + 1, 31 + 1, 30 + 1, 31 + 1, 30 + 1, 31 + 1, 31 + 1, 30 + 1, 31 + 1, 30 + 1, 31 + 1};    //Leaving an extra day in each month to reduce clustering when movie watched on last day of previous month

Calendar cal = Calendar.getInstance();
int index = 0;
float lengthOfAverageRatingLine = 0;
float lengthOfRatingLine = 0;
float differenceAcrossMonth = 0;
Date previousDate = cal.getTime();
DecimalFormat df = new DecimalFormat();
pushMatrix();
for(int i = 0; i < 11; i++)  //Draw movie data on each month
{
  cal.setTime(datesWatched[index]);                 //Set calendar date as the first movie date in each month
  int dayNumber = cal.get(Calendar.DAY_OF_MONTH);     //Taken as the day number of the movie current in the list, at position 'index'
  differenceAcrossMonth = 0;

  float angleBetweenDays = (float)Math.toRadians(30.0f / daysInMonths[i]);    //Angle of rotation for each day proportional to the number of days in each month
  int monthNo = cal.get(Calendar.MONTH) + 1;                                  //Current month number (1 -> Jan) set from calendar date
  
  while(monthNo == i + 1)
  {
    print("Month No: " + monthNo + "\n");
    print("I: " + i + " " );
    pushMatrix();
    
    rotate(angleBetweenDays * (dayNumber - 1));    //Rotate an amount proportional to the date that the movie was watched
    translate(0, -300);    //Move to perimeter of circle
     
    lengthOfAverageRatingLine = (averageRatings[index] / 5)*150;
    lengthOfRatingLine = (ratings[index] / 5) * 150;
    
    float differenceBetweenMineAndAverage = ratings[index] - averageRatings[index];
    differenceAcrossMonth += differenceBetweenMineAndAverage;
    
    colorMode(HSB, 360, 100, 100);
    dayNumber = cal.get(Calendar.DAY_OF_MONTH);
    
    if(cal.getTime().equals(previousDate)) //Current movie watched on the same day as the last movie
    {
      print("made it here");
      strokeWeight(0.25);    //Draw more star outlines for this month outside the original ones
      stroke(#E8E8E8);
      noFill();
      translate(0, 300);
      rotate(-PI/2);
      rotate(- (angleBetweenDays * (dayNumber - 1) ));
      print("and here");
      for(int k = 1; k <= 5; k++)
      {
       arc(0, 0, 900+60*k, 900+60*k, 0, PI/6.0); 
      }      
      rotate(angleBetweenDays * (dayNumber - 1));
      rotate(PI/2);
      translate(0, -450);    //Move to the start of the first outer star rating arc
    }
    
    float differenceAsSaturation = 0;

    print("Movie Name: " + movieNames[index] + " " );
    
    strokeWeight(2);
    if(differenceBetweenMineAndAverage < 0) {
      differenceAsSaturation = map(differenceBetweenMineAndAverage, -0.1, -1.8, 10, 100);    //Most negative difference between my rating and the average rating is -1.8, choosing R colour with H=360, S -> [20, 100], B=100
      fill(360, differenceAsSaturation, 100);
      stroke(360, differenceAsSaturation, 100);      
    }
    else if(differenceBetweenMineAndAverage > 0){
      differenceAsSaturation = map(differenceBetweenMineAndAverage, 0.1, 1.4, 10, 100);    //Most positive difference between my rating and the average rating is 1.4, choosing G colour H=125, S -> [20, 100], B = 100
      fill(125, differenceAsSaturation, 100);
      stroke(125, differenceAsSaturation, 100);
    }
    else if(differenceBetweenMineAndAverage == 0){
      fill(210, differenceAsSaturation, 100);                //Draw movies where my rating is equal to the averrage rating as a blue line
      stroke(210, 50, 100);
    }
    line(0, -2, 0, -lengthOfRatingLine);
    
    textSize(7.5);
    rotate(-PI/2);  //Rotate 90° to write the movie title
    
    if(i > 5){    //Flip the text 180° if on the far side of the calendar
     rotate(-PI); 
     translate(100, 0);
    }
    
    if(movieNames[index].length() > 20) movieNames[index] = movieNames[index].substring(0, 20) + "...";    //Trim long movie titles
    
    if(!cal.getTime().equals(previousDate))  text(movieNames[index], -90, 0);    //Movie was not watched on same day as previous movie - a normal output
    
    else 
    {    //Movie watched on same date as last movie
      if(i > 5) text(movieNames[index], -155, -10);    //Movie is in second half of year, with translated position
      else text(movieNames[index], 5, -10);     //Movie is in first half of year
    }
    
    if(i > 5){  //Flip rotation back
    rotate(PI);
    translate(100, 0 );
    }
    
    rotate(PI/2);  //Rotate 90° for average review point
    strokeWeight(4);
    stroke(210, 50, 100);
    line(-1, -lengthOfAverageRatingLine, 1, -lengthOfAverageRatingLine);

    index++;  //Increment index to next movie in list
    previousDate = cal.getTime();    //Extract the date of the current movie to compare with the date of the next
    if(index == N) { popMatrix(); break; }    //Break if final movie reached
    cal.setTime(datesWatched[index]);    //Set the calendar date as the new movie date
    monthNo = cal.get(Calendar.MONTH) + 1;    //Extract month number of the new movie, breaks out of the while loop if last movie in month reached
    dayNumber = cal.get(Calendar.DAY_OF_MONTH);    
    popMatrix();    //Reset plane conditions back to the start of the while loop
  }
  
  pushMatrix();
  rotate((PI/12.0));    //Rotate half a month
  translate(0, -120);   //Movie ~a third of the way to the perimeter
  textSize(12);
  
  if(differenceAcrossMonth > 0) {
   fill(#06C42A);                  //If overall positive difference between mine and average display in green outside the month name
     text("+" + df.format(differenceAcrossMonth), -10, 0);    
  }
  else if(differenceAcrossMonth < 0) {
    fill(#FC2130);               // Else display in red outside the month name
  text(df.format(differenceAcrossMonth), -10, 0);
  }
  
  popMatrix();    //Return back to centre of circle
  rotate((PI/6.0));  //Rotate to position of next month
  
}
popMatrix();

int numRewatches = 0;
for(int k = 0; k < rewatch.length; k++){
 if(rewatch[k].equals("Yes") ) numRewatches++;    //Calculate the total number of rewatches
}

textSize(23);    //Print title across top of plot
fill(210, 50, 100);
text("Deviation between my ratings and average ratings on Letterboxd", -255, -465);

textSize(12);  //Print circle for total number of movies
fill(#9542f5);
circle(-450, -450, 90);
fill(0);
text(movieNames.length + " movies", -480, -450);


fill(#FFFF00); //Print circle for total number of rewatches
circle(-330, -450, 90);
fill(0);
text(numRewatches + " rewatches", -365, -450);

stroke(210, 50, 100); //Print legend for average review colour
circle(-465, -370, 5);
fill(210, 50, 100);
textSize(15);
text(" average rating", -460, -365);

stroke(#00FF00);  //Print legend for positive review colour
fill(#00FF00);
circle(-465, -350, 5);
text(" +ive diff. from avg", -460, -345);

stroke(#FF0000);   //Print legend for negative review colour
fill(#FF0000);
circle(-465, -330, 5);
text(" -ive diff. from avg", -460, -325);


save("output.png");    //Save png of output
endRecord();           //Save pdf of output
}

void draw(){
}
  
void star(float x, float y, float radius1, float radius2, int npoints) {    //Taken from processing example at https://processing.org/examples/star.html
   rotate(-PI/30);
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  rotate(PI/30);
}
