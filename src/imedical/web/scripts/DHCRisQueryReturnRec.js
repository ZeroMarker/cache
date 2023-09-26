//DHCRisQueryReturnRec
function BodyLoadHandler()
{
	var stdate=document.getElementById("StDate");
	var eddate=document.getElementById("EdDate");
    if (stdate.value=="")
    {
		//stdate.value=DateDemo();
		//eddate.value=DateDemo();
			
	
		stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
		stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
		
	} 
		
	var LocID=document.getElementById("LocID");
	LocID.value=session["LOGON.CTLOCID"] ;
    
	var GetLocNameFunction=document.getElementById("LocName").value;
	var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
    var LocName=document.getElementById("LocName");
    LocName.value=value;
    
	
}


function GetLocInfo(Info)
{
	var tem=Info.split("^");
	var GetLocObj=document.getElementById("LocName");
	var LocID=document.getElementById("LocID");
	LocID.value=tem[1];
	//GetLocObj.value=tem[0];
}


function DateDemo()
{
   var d, s="";          
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;	
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getFullYear();	
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
}

document.body.onload = BodyLoadHandler;



