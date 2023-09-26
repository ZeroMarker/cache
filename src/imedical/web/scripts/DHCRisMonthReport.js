//DHCRisMonthReport.js
//DHCRisReportList.js
//
//
var TemplatePath;


function BodyLoadHandler()
{
	var stdate=document.getElementById("StDate");
	var eddate=document.getElementById("EndDate");
	if (stdate.value=="")
	{
	    stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	    eddate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	}
	
	var xlocid=session["LOGON.CTLOCID"] ;
	var LocID=document.getElementById("LocID");
	LocID.value=xlocid;

	var LocNameFunctionOBJ=document.getElementById("LocName");
	var GetLocNameFunction=LocNameFunctionOBJ.value;

 	var value=cspRunServerMethod(GetLocNameFunction,xlocid);
    LocNameFunctionOBJ.value=value;
    
       
	var MonthOBJ=document.getElementById("Month");
	
	if (MonthOBJ)
	{
	   MonthOBJ.onclick=MonthClick;
	}
	
	
	var Yearobj=document.getElementById("Year");
	
	if (Yearobj)
	{
	   Yearobj.onclick=Yearclick;
	}

	var Printobj=document.getElementById("Print");
	
	if (Printobj)
	{
	   Printobj.onclick=PrintClick;
	}
	
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);

}
function PrintClick()
{
   onprint();	
}

function MonthClick()
{
	var Monthobj=document.getElementById("Month");
    if (Monthobj.checked)
	{
		 var VObj=document.getElementById("Year");
    	 VObj.checked=false;
    	 var QueryObj=document.getElementById("QueryType");
    	 QueryObj.value="1";
	}
}

function Yearclick()
{
	var Yearobj=document.getElementById("Year");
    if (Yearobj.checked)
	{
		 var VObj=document.getElementById("Month");
    	 VObj.checked=false;
    	 var QueryObj=document.getElementById("QueryType");
    	 QueryObj.value="2";
	}
}


///
function GetLocEQ(LocID)
{
	var GetEQNameOBJ=document.getElementById("GetEQName");
	var GetEQNameFunction=GetEQName.value;

	var value=cspRunServerMethod(GetEQNameFunction,LocID);
  
    LocNameFunctionOBJ.value=value;
    
}

function onprint()
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisMonthReport.xls";
	    var CellRows ; //
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		    
	    ClearPage(xlsheet);
	    
	    
	    var ordtab=document.getElementById("tDHCRisMonthReport");
	    var Nums=ordtab.rows.length;
	    
	    
	    var Title=""
	    var IsMonth=document.getElementById("Month").checked;
	    var IsYear=document.getElementById("Year").checked;
	    var LocName=document.getElementById("LocName").value;
	    if (IsMonth)
	    {
	    	Title=t["MonthTitle"]+"("+LocName+")";
	    }
	    else if(IsYear)
	    {
		    Title=t["YearTitle"]+"("+LocName+")";
	    }
	    
	    
	    
        if (ordtab) 
        {
	        xlsheet.cells(1,1)=Title;
		    
		    for (var i=1;i<Nums;i++)
     	    {
	     	   var Date=document.getElementById("Time1z"+i).innerText;
	     	   var Device1Fee=document.getElementById("Device1Feez"+i).innerText;
		       var Device1Count=document.getElementById("Device1Countz"+i).innerText;
		       var Device2Fee=document.getElementById("Device2Feez"+i).innerText;
		       var Device2Count=document.getElementById("Device2Countz"+i).innerText;
		       var Device3Fee=document.getElementById("Device3Feez"+i).innerText;
		       var Device3Count=document.getElementById("Device3Countz"+i).innerText;
		       var Device4Fee=document.getElementById("Device4Feez"+i).innerText;
		       var Device4Count=document.getElementById("Device4Countz"+i).innerText;
		       var Device5Fee=document.getElementById("Device5Feez"+i).innerText;
		       var Device5Count=document.getElementById("Device5Countz"+i).innerText;
		       var Device6Fee=document.getElementById("Device6Feez"+i).innerText;
		       var Device6Count=document.getElementById("Device6Countz"+i).innerText;
		    
		       if (i==1)
		       {
			       	 xlsheet.cells(2,2)=Device1Fee;
		     	     xlsheet.cells(2,4)=Device2Fee;
		       	     xlsheet.cells(2,6)=Device3Fee;
		     	     xlsheet.cells(2,8)=Device4Fee;
		     	     xlsheet.cells(2,10)=Device5Fee;
		     	     xlsheet.cells(2,12)=Device6Fee;
			   }
			   else
			   {
				   xlsheet.cells(i+2,1)=Date;
				   xlsheet.cells(i+2,2)=Device1Fee;
		     	   xlsheet.cells(i+2,3)=Device1Count;
		     	   xlsheet.cells(i+2,4)=Device2Fee;
		     	   xlsheet.cells(i+2,5)=Device2Count;
		     	   xlsheet.cells(i+2,6)=Device3Fee;
		     	   xlsheet.cells(i+2,7)=Device3Count;
		     	   xlsheet.cells(i+2,8)=Device4Fee;
		     	   xlsheet.cells(i+2,9)=Device4Count;
		     	   xlsheet.cells(i+2,10)=Device5Fee;
		     	   xlsheet.cells(i+2,11)=Device5Count;
		     	   xlsheet.cells(i+2,12)=Device6Fee;
		     	   xlsheet.cells(i+2,13)=Device6Count;
		     }
			} 
		    xlsheet.printout;
			ClearPage(xlsheet);
			xlBook.Close (savechanges=false);
	        xlApp=null;
	        xlsheet=null;
        }
	}
	catch(e) 
	{
		alert(e.message);
	};
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
function ClearPage(xlsheet)
{
	xlsheet.cells(2,2)="";
	xlsheet.cells(2,4)="";
	xlsheet.cells(2,6)="";
	xlsheet.cells(2,8)="";
	xlsheet.cells(2,10)="";
	xlsheet.cells(2,12)="";
			
	 for (var i=4; i<=35;i++)
	 {
		 for(var j=1;j<=13;j++)
		 {
			 xlsheet.cells(i,j)="";
		 }
	 }
}
 
document.body.onload = BodyLoadHandler;


