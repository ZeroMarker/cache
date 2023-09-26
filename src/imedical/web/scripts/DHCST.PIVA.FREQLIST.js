var currRow; 
var desc;

function BodyLoadHandler()
{
	var obj=document.getElementById("OK")
	if (obj) obj.onclick=SetFreq;
	//var obj=document.getElementById("Cancel")
	//if (obj) obj.onclick=Cancel;
	}

function SetFreq()
{  

   var maindocu=window.opener.document
  
    var mainrow;
	if (maindocu) {

	   // var obj=document.getElementById("MainRow")
	    //if (obj) var mainrow=obj.value;
	    
	   // if (mainrow>0)
	    //{
		    var obj=maindocu.getElementById("Freq")
            if (obj) obj.value=desc  ;
 

                       
       // }
    }
   window.close();
}
	
function SelectRowHandler()
{

    if (currRow>0)
    var obj=document.getElementById("TSelect"+"z"+currRow)
    if (obj) {obj.checked=false}
	currRow=selectedRow(window)
	if (currRow>0){
	    var objdesc=document.getElementById("Tdesc"+"z"+currRow)
         desc=objdesc.innerText
	    var obj2=document.getElementById("TSelect"+"z"+currRow)
	    if (obj2) {obj2.checked=true; }
	  }   
}
function Cancel()
{ window.close();
}

document.body.onload=BodyLoadHandler;

