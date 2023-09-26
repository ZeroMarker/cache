function runCmd(){
 	   s=new   ActiveXObject("WScript.Shell");   
       cmd="cmd /c sndrec32";   
       s.Run(cmd);    
 }
