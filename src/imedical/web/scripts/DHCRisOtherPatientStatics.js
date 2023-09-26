//DHCRisOtherPatientStatics.js
//
//DHCRisStatics
//var gLocID="";
 var RowsperPage=28;
 var colsperPage=9;
	

function BodyLoadHandler()
{
	var stdate=document.getElementById("StartDate");
	var eddate=document.getElementById("EndDate");
	var xlocid=session["LOGON.CTLOCID"] ;
	var LocID=document.getElementById("LocID");
	LocID.value=xlocid;
	
	if (stdate.value=="")
	{
	    stdate.value=DateDemo();
	    eddate.value=DateDemo(); 
	}
  	
	var GetLocNameFunction=document.getElementById("getlocname").value;
 	var value=cspRunServerMethod(GetLocNameFunction,xlocid);
    var LocName=document.getElementById("LocName");
    LocName.value=value;
  
  
	
	var Staticsobj=document.getElementById("Statics");
	if (Staticsobj)
	{
	   Staticsobj.onclick=Staticsobjclick;
	}
    
    var printobj=document.getElementById("Print1")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
 	
 	var TransPatientObj=document.getElementById("TransPatient");
   	if (TransPatientObj)
   	{
	   	TransPatientObj.onclick=onTransPatientClick;
   	}
	var TransUnitObj=document.getElementById("TranUnit");
	
	var FeelaterObj=document.getElementById("LaterFeePatient");
	if (FeelaterObj)
	{
		FeelaterObj.onclick=onFeelaterClick;
	}
		
    var printobj=document.getElementById("Print")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);

  
}

function onTransPatientClick()
{
	var TransPatientObj=document.getElementById("TransPatient");
   	if (TransPatientObj)
   	{
	   	if (TransPatientObj.checked)
	   	{
		   	var FeelaterObj=document.getElementById("LaterFeePatient");
         	if (FeelaterObj)
         	{
	         	FeelaterObj.checked=false;
	         	
         	}
         	var TransUnitObj=document.getElementById("TranUnit");
         	TransUnitObj.disabled=false;
		   	
	   	}
   	}
	
}
function onFeelaterClick()
{
	var FeelaterObj=document.getElementById("LaterFeePatient");
    if (FeelaterObj)
    {
	   if (FeelaterObj.checked)
	   {
		  var TransPatientObj=document.getElementById("TransPatient");
   		  if (TransPatientObj)
   		  {
	         TransPatientObj.checked=false;
	   	  }
	   	  var TransUnitObj=document.getElementById("TranUnit");
          TransUnitObj.disabled=true;
	
		   	
	   	}
   	}
	
}
function Staticsobjclick()
{
	var flag;
	TransPatientobj=document.getElementById("TransPatient");
	TranUnit=document.getElementById("TranUnit");
	LaterFeePatientObj=document.getElementById("LaterFeePatient");
	
	if (TransPatientobj.checked)
	{
		flag="O:"+TranUnit.value;
		document.getElementById("flag").value=flag;
		
	}
	else if (LaterFeePatientObj.checked)
	{
		document.getElementById("flag").value="laterFee";
	}

    //alert(document.getElementById("flag").value);
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
   
   sYear  = d.getYear();	
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
   
                          
}

function onprint()
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
		var TransPatientObj=document.getElementById("TransPatient");
		if (TransPatientObj.checked)
		{
	    	var Template=TemplatePath+"DHCRis_TransPatientStatics.xls";
		}
		else
		{
			var Template=TemplatePath+"DHCRis_LaterFeePatientStatics.xls";
		}
	    var CellRows ; //
	    var Isprint=0;
	    var Pageindex=0;
	    var PrintedRows=0;
	
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var objtbl=document.getElementById("tDHCRisOtherPatientStatics");
	    var Nums=objtbl.rows.length;
	   
	   
	    var stdate=document.getElementById("StartDate");
		var eddate=document.getElementById("EndDate");

	   	var LocName=document.getElementById("LocName").value;
   	    var Info=LocName+" "+t['StaticsDate']+":"+stdate.value+"-"+eddate.value;

	    ClearPage(xlsheet);
	    xlsheet.cells(2,1)=Info;
	
	
	    
	   if (objtbl) 
        {
     		for (var i=1;i<Nums;i++)
     	    {
	     	    
	     	   var TranUnit1=document.getElementById("TranUnit1z"+i).innerText;
	     	   var PatName=document.getElementById("PatNamez"+i).innerText;
		       var RegNo=document.getElementById("RegNoz"+i).innerText;
		       var Sex=document.getElementById("Sexz"+i).innerText;
		       var Age=document.getElementById("Agez"+i).innerText;
		       var StudyNo=document.getElementById("StudyNoz"+i).innerText;
		       var ItemName=document.getElementById("ItemNamez"+i).innerText;
		       var Fee=document.getElementById("Feez"+i).innerText;
		       var ReportDate=document.getElementById("ReportDatez"+i).innerText;
		       var RegDate=document.getElementById("RegDatez"+i).innerText;
		       if (TransPatientObj.checked)
	     	   {
		      	   PrintedRows=PrintedRows+1
		     	   xlsheet.cells(PrintedRows+3,1)=TranUnit1;
		     	   xlsheet.cells(PrintedRows+3,2)=PatName;
		       	   xlsheet.cells(PrintedRows+3,3)=RegNo;
		     	   xlsheet.cells(PrintedRows+3,4)=Sex;
		     	   xlsheet.cells(PrintedRows+3,5)=Age;
		     	   xlsheet.cells(PrintedRows+3,6)=StudyNo;
		     	   xlsheet.cells(PrintedRows+3,7)=ItemName;
		     	   xlsheet.cells(PrintedRows+3,8)=Fee;
		     	   xlsheet.cells(PrintedRows+3,9)=ReportDate;
	     	   }
	     	   else
	     	   {
		     	   PrintedRows=PrintedRows+1
		     	   xlsheet.cells(PrintedRows+3,1)=PatName;
		     	   xlsheet.cells(PrintedRows+3,2)=RegNo;
		       	   xlsheet.cells(PrintedRows+3,3)=Sex;
		     	   xlsheet.cells(PrintedRows+3,4)=Age;
		     	   xlsheet.cells(PrintedRows+3,5)=StudyNo;
		     	   xlsheet.cells(PrintedRows+3,6)=ItemName;
		     	   xlsheet.cells(PrintedRows+3,7)=Fee;
		     	   xlsheet.cells(PrintedRows+3,8)=RegDate;
		        }
		     	  
		     	CellRows=PrintedRows%RowsperPage;
		     	if ((CellRows==0))
				{   
				   Pageindex=Pageindex+1
				   xlsheet.cells(RowsperPage+4,1)=t["Index"]+Pageindex+t["Page"];
		       	   xlsheet.cells(RowsperPage+4,3)=t["PrintDate"]+":"+GetCurrentTime();
		    	   xlsheet.printout;
				   ClearPage(xlsheet);
				   PrintedRows=PrintedRows%RowsperPage
			     }
			     else if (i==Nums-1)
			     {
				 	Pageindex=Pageindex+1;
		  			var CurrTime=GetCurrentTime();
		  			xlsheet.cells(RowsperPage+4,1)=t["Index"]+Pageindex+t["Page"];
		    		xlsheet.cells(RowsperPage+4,3)=t["PrintDate"]+":"+CurrTime;
		  			xlsheet.printout;
	    	   	 }
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



document.body.onload = BodyLoadHandler;