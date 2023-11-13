import http.requests.*;
   String watchUrl = row.getString("Letterboxd URI");
   String actualMovieUrl = watchUrl.replace("/pitbull1", "");
   GetRequest get = new GetRequest(actualMovieUrl);
   get.send();
   println("Response Content: " + get.getContent());
