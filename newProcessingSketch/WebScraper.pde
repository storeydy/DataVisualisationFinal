import http.requests.*;
import java.time.LocalDate;

 //String watchUrl = row.getString("Letterboxd URI");
 //String actualMovieUrl = watchUrl.replace("/pitbull1", "");
 //GetRequest get = new GetRequest(actualMovieUrl);
 //get.send();
 //println("Response Content: " + get.getContent());
 
public static class WebScraper
{
  
  
  void printSomething(){
    println("Response Content: 3"); 
  }
  
  static String getUrlContent(String url){
     GetRequest get = new GetRequest(url);
     get.send();
     println("Response Content: " + get.getContent());
     return get.getContent();
  }
  
  
}
