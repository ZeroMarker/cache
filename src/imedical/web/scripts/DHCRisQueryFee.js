//DHCRisQueryFee

function BodyLoadHandler()
{
	var RegOBJ=document.getElementById("RegNo");
	if (RegOBJ.value=="")
	{
		var GetPatientInfo=document.getElementById("getpatientinfo").value;
		var paadmdr=document.getElementById("paadmdr").value;
		//alert(paadmdr);
		var value=cspRunServerMethod(GetPatientInfo,paadmdr);
		Infolist=value.split("^");
	}
    //var RegOBJ=document.getElementById("RegNo");
    RegOBJ.value=Infolist[0];
    var NameOBJ=document.getElementById("Name");
    NameOBJ.value=Infolist[1];
   
    /*var locck=document.getElementById("LocOEORDITEM");
    if (locck.value=="on")
     locck.checked=true;
    else
     locck.checked=false;
     */
       
    
    var FINDOBJ=document.getElementById("FIND11");
    if (FINDOBJ)
    {
	    FINDOBJ.onclick=findclick11;
    }
    
    
    
}
function findclick11()
{
    var locid=session['LOGON.CTLOCID'];
    var paadmdr=document.getElementById("paadmdr").value;
    
    var loc="on";
   var locck=document.getElementById("LocOEORDITEM");
   if (locck.checked)
   {
	   loc="on";
   }
   else
   {
	   loc="";
   }
	//alert(loc);   
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryFee"+"&paadmdr="+paadmdr+"&LocOEORDITEM="+loc+"&LocID="+locid;    
    location.href=link;
    	
	
}
document.body.onload = BodyLoadHandler;