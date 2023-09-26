//DHCRisAppointTypeStatics

function BodyLoadHandler()
{

	var stdate=document.getElementById("StartDate");
	var eddate=document.getElementById("EndDate");
	
	if (stdate.value=="")
	{
		stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","-2");
		eddate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	}
 	
   
	
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


