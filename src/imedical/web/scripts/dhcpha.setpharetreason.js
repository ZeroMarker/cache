var currRow; 
var retReason ;
var retReasonDesc;

function BodyLoadHandler()
{
	var obj=document.getElementById("OK")
	if (obj) obj.onclick=SetRetReason;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Cancel;
}
function SetRetReason()
{  
   var maindocu=window.opener.document
   var mainrow;
	if (maindocu) {
	  //	var objtbl=maindocu.getElementById("t"+"dhcpha_phadisp")
	  
		//mainrow=selectedRow(maindocu.window)
		//
		//
	    var obj=document.getElementById("MainCurrentRow")
	    if (obj) var mainrow=obj.value;
	    
	    if (mainrow>0)
	    { 
		    var obj=maindocu.getElementById("TReasonDR"+"z"+mainrow)
		    if ((obj)&&(retReason)) obj.value=retReason   
		    var obj=maindocu.getElementById("TReason"+"z"+mainrow)
		    if ((obj)&&(retReasonDesc)) obj.innerText=retReasonDesc   
        }
    }
   window.close();
}	
function SelectRowHandler()
{
    if (currRow>0)
    var obj=document.getElementById("select"+"z"+currRow)
    if (obj) {obj.checked=false}
	currRow=selectedRow(window)
	if (currRow>0){
	    var obj=document.getElementById("TRowid"+"z"+currRow)
	    if (obj) 
	     {retReason=obj.value; }
	    var obj=document.getElementById("TRetReason"+"z"+currRow)
	    if (obj) 
	     {retReasonDesc=obj.innerText; }
	     
	    var obj2=document.getElementById("select"+"z"+currRow)
	    if (obj2) 
	     {obj2.checked=true; }
	  }   
}
function Cancel()
{ window.close();
}


document.body.onload=BodyLoadHandler;
