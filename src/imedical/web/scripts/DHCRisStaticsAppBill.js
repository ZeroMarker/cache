///DHCRisStaticsAppBill.js
function BodyLoadHandler()
{
	var stdate=document.getElementById("StDate");
	var eddate=document.getElementById("EndDate");

	if (stdate.value=="")
	{
	    stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	    eddate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
    } 

    var Staticsobj=document.getElementById("Statics");
	if (Staticsobj)
	{
	   Staticsobj.onclick=Staticsclick;
	}
	  
}

function Staticsclick()
{
	AppLocName=document.getElementById("AppLoc").value;
	if (AppLocName=="")
	{
		document.getElementById("AppLocID").value="";
		//alert(document.getElementById("AppLocID").value);
			
	}
   	RecLocName=document.getElementById("RecLoc").value;
	if (RecLocName=="")
	{
		document.getElementById("RecLocID").value="";	
	}
	
	return Statics_click();
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


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisStaticsAppBill');
	if (objtbl) 
	{
	  var rows=objtbl.rows.length; 
	}
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	CurrentSel=selectrow;
	
	OEordItemID=document.getElementById('oeorditemIDz'+selectrow).innerText;

	var browsezlink='Browsez'+selectrow;

   	if (eSrc.id==browsezlink)
  	{
	   var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppBillBrowse"+"&OEOrdItemID="+OEordItemID;    
       var mynewlink=open(link,"DHCRisAppBillBrowse","scrollbars=yes,resizable=yes,top=6,left=6,width=800,height=680");
       return false;
  	}
  	return false;
}

function GetLoc(Info)
{
	//alert(Info);
	var Item=Info.split("^");
	document.getElementById('AppLocID').value=Item[1];
	//alert(document.getElementById('AppLocID').value);

	
}
function GetExeLoc(Info)
{
	//alert(Info);
	var Item=Info.split("^");
	document.getElementById('RecLocID').value=Item[1];

}
document.body.onload = BodyLoadHandler;


