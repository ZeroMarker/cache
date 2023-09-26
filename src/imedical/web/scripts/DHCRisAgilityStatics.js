//DHCRisAgilityStatics

var gOptionId;
var gTechnicianId;
var gReportDocId;
var gVerifyDocId;
var gArcItemRowId;
var gBodyPartId;
var TemplatePath;
var RowsperPage=21;
var colsperPage=20;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	SetLocName();
	var stdate=document.getElementById("StartDate");
	var eddate=document.getElementById("EndDate");
	
	if (stdate.value=="")
	{
	    stdate.value=DateDemo();
	    eddate.value=DateDemo(); 
	}
  	
    var Staticsobj=document.getElementById("Statics");
	if (Staticsobj)
	{
	   Staticsobj.onclick=StaticsobjClick;
	}
 	
    var printobj=document.getElementById("Print")
	if (printobj)
	{
		printobj.onclick=onprint;
	}
	var BedofOrderObj=document.getElementById("BedofOrder");
	if (BedofOrderObj)
	{
		BedofOrderObj.onclick=BedofOrderClick;
	}
	var NotBedOrdObj=document.getElementById("NotBedOrd");
	if (NotBedOrdObj)
	{
		NotBedOrdObj.onclick=NotBedOrdClick;
	}
	var EngancedOrderObj=document.getElementById("EngancedOrder");
	if (EngancedOrderObj)
	{
		EngancedOrderObj.onclick=EngancedOrderClick;
	}
	var CommOrderObj=document.getElementById("CommOrder");
	if (CommOrderObj)
	{
		CommOrderObj.onclick=CommOrderClick;
	}
		
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);

}

function SetLocName()
{
	var xlocid=session["LOGON.CTLOCID"] ;
	document.getElementById("LocID").value=xlocid;

    var GetLocNameFunction=document.getElementById("GetLocName").value;
	var LocName=cspRunServerMethod(GetLocNameFunction,xlocid);
	
	document.getElementById("LocName").value=LocName;

	
}
function GetAppLocInfo(Info)
{
	var Item=Info.split("^");
	document.getElementById("AppLocId").value=Item[1];
	//alert(document.getElementById("AppLocId").value);
	
	
}

function GetOptionDocID(Info)
{
  Item=Info.split("^");
  document.getElementById("gOptionId").value=Item[1];
  
}

function GetTechnicianInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("gTechnicianId").value=Item[1];
}


function GetReportDocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("gReportDocId").value=Item[1];

}

function GetVerifyDocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("gVerifyDocId").value=Item[1];

}

function GetSelectLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocID").value=Item[1];
}
function GetOrdInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("OrdName").value=Item[0];
  document.getElementById("gArcItemRowId").value=Item[1];
}

function GetBodyInfo(Info)
{
	Item=Info.split("^");
	document.getElementById("gBodyPartId").value=Item[1];
}

function BedofOrderClick()
{
	var BedofOrderObj=document.getElementById("BedofOrder");
	if (BedofOrderObj.checked)
	{
	  document.getElementById("NotBedOrd").checked=false;
	  document.getElementById("EngancedOrder").checked=false;
      document.getElementById("CommOrder").checked=false;
	}
	
}
function NotBedOrdClick()
{
	var NotBedOrdObj=document.getElementById("NotBedOrd");
	if (NotBedOrdObj.checked)
	{
	  document.getElementById("BedofOrder").checked=false;
	  document.getElementById("EngancedOrder").checked=false;
      document.getElementById("CommOrder").checked=false;
	}
}
function EngancedOrderClick()
{
	var EngancedOrderObj=document.getElementById("EngancedOrder");
	if (EngancedOrderObj.checked)
	{
	  document.getElementById("BedofOrder").checked=false;
	  document.getElementById("NotBedOrd").checked=false;
      document.getElementById("CommOrder").checked=false;
	}
}
function CommOrderClick()
{
	var CommOrderOrderObj=document.getElementById("CommOrder");
	if (CommOrderOrderObj.checked)
	{
	  document.getElementById("BedofOrder").checked=false;
	  document.getElementById("NotBedOrd").checked=false;
      document.getElementById("EngancedOrder").checked=false;
	}
	
}

function StaticsobjClick()
{
	var LocID=document.getElementById("LocID").value;
	if (document.getElementById("OptionDoc").value=="")
	{
		document.getElementById("gOptionId").value=""
	}
	var OptionId=document.getElementById("gOptionId").value;
	
	if (document.getElementById("Technician").value=="")
	{
		document.getElementById("gTechnicianId").value="";
		
	}
	var TechnicianId=document.getElementById("gTechnicianId").value;
	
	
	if (document.getElementById("ReportDoc").value=="")
	{
		document.getElementById("gReportDocId").value="";
	}
	var ReportDocId=document.getElementById("gReportDocId").value;

	if (document.getElementById("VerifyDoc").value=="")
	{
		document.getElementById("gVerifyDocId").value="";
	}
	var VerifyDocId=document.getElementById("gVerifyDocId").value;
	
	if (document.getElementById("OrdName").value=="")
	{
		document.getElementById("gArcItemRowId").value="";
	}
	var ArcItemRowId=document.getElementById("gArcItemRowId").value;
	
	if (document.getElementById("Body").value=="")
	{
		document.getElementById("gBodyPartId").value="";
	}
	var BodyPartId=document.getElementById("gBodyPartId").value;
	var strConditionObj=document.getElementById("strCondition");
    strConditionObj.value=LocID+"^"+OptionId+"^"+TechnicianId+"^"+ReportDocId+"^"+VerifyDocId+"^"+ArcItemRowId+"^"+BodyPartId;
     
    var BedofOrderObj=document.getElementById("BedofOrder");
	if (BedofOrderObj.checked)
	{
		strConditionObj.value=strConditionObj.value+"^Y"
	}
	else
	{
		strConditionObj.value=strConditionObj.value+"^N"
	}
		
	var NotBedOrdObj=document.getElementById("NotBedOrd");
	if (NotBedOrdObj.checked)
	{
	 	strConditionObj.value=strConditionObj.value+"^Y"
	}
	else
	{
		strConditionObj.value=strConditionObj.value+"^N"
	}
	
	var EngancedOrderObj=document.getElementById("EngancedOrder");
	if (EngancedOrderObj.checked)
	{
	 	strConditionObj.value=strConditionObj.value+"^Y"
	}
	else
	{
		strConditionObj.value=strConditionObj.value+"^N"
	}	 
	 
	 var CommOrderObj=document.getElementById("CommOrder");
	 if (CommOrderObj.checked)
	 {
	 	strConditionObj.value=strConditionObj.value+"^Y"

	 }
	 else
	 {
		 strConditionObj.value=strConditionObj.value+"^N"
	 }
	 if (document.getElementById("AppLocName").value=="")
	 {
		 document.getElementById("AppLocId").value=""
	 } 
    var Applocid=document.getElementById("AppLocId").value;
    strConditionObj.value=strConditionObj.value+"^"+Applocid;
    	 
	 
	 
	var StdDate=document.getElementById("StartDate").value;
	var endDate=document.getElementById("EndDate").value;
	var strCondition=document.getElementById("strCondition").value;
 
	//var para=" &strCondition="+strCondition+"&StartDate="+StdDate+" &EndDate="+endDate;
	//alert(para);
	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAgilityStatics="+para;

	 
	return  Statics_click();
	
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
   
   sYear  = d.getYear();		
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
   
                             
}

function onprint()
{
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRis_AgilityList.xls";
	    var CellRows ; //
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    LocName=document.getElementById("LocName").value;
	
	         
	    ClearPage(xlsheet);
	    var ordtab=document.getElementById("tDHCRisAgilityStatics");
	    var Nums=ordtab.rows.length;
	    
        if (ordtab) 
        {
     		for (var i=1;i<Nums;i++)
     	    {
    	  	   PrintedRows=PrintedRows+1
	     	   xlsheet.cells(PrintedRows+2,1)=document.getElementById("RegNoz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,2)=document.getElementById("Namez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,3)=document.getElementById("Sexz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,4)=document.getElementById("Typez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,5)=document.getElementById("TOrdNamez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,6)=document.getElementById("Numz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,7)=document.getElementById("InComez"+i).innerText;
	
		       xlsheet.cells(PrintedRows+2,8)=document.getElementById("BodyPartz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,9)=document.getElementById("TOptionDocz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,10)=document.getElementById("RegDatez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,11)=document.getElementById("RegTimez"+i).innerText;
		       
		       xlsheet.cells(PrintedRows+2,12)=document.getElementById("TReportDocz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,13)=document.getElementById("ReportDatez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,14)=document.getElementById("ReportTimez"+i).innerText;
		       
		       xlsheet.cells(PrintedRows+2,15)=document.getElementById("TVerifyDocz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,16)=document.getElementById("VerifyDatez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,17)=document.getElementById("VerifyTimez"+i).innerText;
		       
		       
		       xlsheet.cells(PrintedRows+2,18)=document.getElementById("positivez"+i).innerText;
		       xlsheet.cells(PrintedRows+2,19)=document.getElementById("StudyNoz"+i).innerText;
		       xlsheet.cells(PrintedRows+2,20)=document.getElementById("AppLocDescz"+i).innerText;
		         
		       CellRows=PrintedRows%RowsperPage;
		       if ((CellRows==0))
			   {   
				  Title=LocName+t['PrintTitle'];
				  Pageindex=Pageindex+1
				  xlsheet.cells(1,1)=Title;
		     	  xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+GetCurrentTime();
		     	  //xlsheet.cells(RowsperPage+3,3)="ตฺ"+Pageindex+"าณ";
		    	  xlsheet.printout;
				  ClearPage(xlsheet);
				  PrintedRows=PrintedRows%RowsperPage
				  Isprint=1;
			   }
			   else
			   { 
				  Isprint=0; 
			   }
		     }
	     	 if (Isprint==0)
             {
	            Title=LocName+t['PrintTitle'];
				xlsheet.cells(1,1)=Title;
		     	Pageindex=Pageindex+1;
		  		var CurrTime=GetCurrentTime();
		   		xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+GetCurrentTime();
		  		xlsheet.printout;
	    	 }
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



 function ClearPage(xlsheet)
 {
	 for (var i=1; i<=RowsperPage;i++)
	 {
		 for(var j=1;j<=colsperPage;j++)
		 {
			 xlsheet.cells(i+3,j)="";
			 
		 }
	 }
 }

 function GetCurrentTime()
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
   
    sYear  = d.getYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    
    
    s = sYear +"-"+sMonth+"-"+sDay +" "+sHoure+":"+sMintues;
    return s;
}





