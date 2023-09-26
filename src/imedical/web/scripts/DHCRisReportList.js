//DHCRisReportList.js
//
//
var TemplatePath;
var RowsperPage=21;
var colsperPage=7;
var PrintLocName;


function BodyLoadHandler()
{
	var stdate=document.getElementById("stdate");
	var eddate=document.getElementById("eddate");
	var xlocid=session["LOGON.CTLOCID"] ;
	var LocID=document.getElementById("LocID");
	LocID.value=xlocid;
	
	if (stdate.value=="")
	{
	    stdate.value=DateDemo();
	    eddate.value=DateDemo(); 
	}
  	
	var LocNameFunctionOBJ=document.getElementById("LocName");
	var GetLocNameFunction=LocNameFunctionOBJ.value;
	//alert(GetLocNameFunction);

 	var value=cspRunServerMethod(GetLocNameFunction,xlocid);
    LocNameFunctionOBJ.value=value;
    
  
	var Printobj=document.getElementById("Print");
	
	if (Printobj)
	{
	   Printobj.onclick=Printobjclick;
	}
	
	
	var PrintFoceobj=document.getElementById("PrintFoce");
	
	if (PrintFoceobj)
	{
	   PrintFoceobj.onclick=PrintFoceobjclick;
	}
	
	
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
 	
 	var splits = /-/i;   
    PrintLocName=value;         
    var pos = PrintLocName.search(splits); 
    if (pos>0)
    {           
  	    var Item=PrintLocName.split("-");
		PrintLocName=Item[1];
    }
    //alert(PrintLocName);
    

	
}
function ReportStaticsobjclick()
{
	var locid=session["LOGON.CTLOCID"] ;
	var stdate=document.getElementById("stdate").value;
	var eddate=document.getElementById("eddate").value;	
	

	//alert(stdate);
	
}
function Printobjclick()
{
	onprint(false);
}
function PrintFoceobjclick()
{
	onprint(true);
	
}

///
function onprint(Ans1)
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRis_WorkList.xls";
	    var CellRows ; //
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		    
	    var SetPrintFunction=document.getElementById("SetPrintFlag").value;
        //alert(SetPrintFunction);
          
	    ClearPage(xlsheet);
	    var ordtab=document.getElementById("tDHCRisReportList");
	    var Nums=ordtab.rows.length;
	    
        if (ordtab) 
        {
     		for (var i=1;i<Nums;i++)
     	    {
	     	   var IsPrint=document.getElementById("TPrintz"+i).innerText;
	     	   var RegID=document.getElementById("RegNoz"+i).innerText;
		       var Name=document.getElementById("Namez"+i).innerText;
		       var Sex=document.getElementById("Sexz"+i).innerText;
		       var TAge=document.getElementById("TAgez"+i).innerText;
		       var WardName=document.getElementById("WardNamez"+i).innerText;
		       var TBedCode=document.getElementById("TBedNOz"+i).innerText;
		       var StudyNo=document.getElementById("StudyNoz"+i).innerText;
		       if (IsPrint=="Y")
	     	   {
		     	  //var Ans=confirm(RegID+" "+Name+" "+t['IsPrint']);
		     	  //var Ans=IsPrint;
		     	  
		          if (Ans1==true)		     	   
	     	      {
	     	  	     PrintedRows=PrintedRows+1
		     	     xlsheet.cells(PrintedRows+2,1)=StudyNo;
		     	     xlsheet.cells(PrintedRows+2,2)=RegID;
		       	     xlsheet.cells(PrintedRows+2,3)=Name;
		     	     xlsheet.cells(PrintedRows+2,4)=Sex;
		     	     xlsheet.cells(PrintedRows+2,5)=TAge;
		     	     xlsheet.cells(PrintedRows+2,6)=WardName;
		     	     xlsheet.cells(PrintedRows+2,7)=TBedCode;
		     	     CellRows=PrintedRows%RowsperPage;
		     	     if ((CellRows==0))
				     {   
				       Title=PrintLocName+t['PrintTitle'];
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
		             var printdata=cspRunServerMethod(SetPrintFunction,StudyNo);
	     	       }
	     	     }
	     	     else
	     	     {
		     	     PrintedRows=PrintedRows+1
		     	     xlsheet.cells(PrintedRows+2,1)=StudyNo;
		     	     xlsheet.cells(PrintedRows+2,2)=RegID;
		     	     xlsheet.cells(PrintedRows+2,3)=Name;
		     	     xlsheet.cells(PrintedRows+2,4)=Sex;
		     	     xlsheet.cells(PrintedRows+2,5)=TAge;
		     	     xlsheet.cells(PrintedRows+2,6)=WardName;
		     	     xlsheet.cells(PrintedRows+2,7)=TBedCode;
		     	    
		     	     CellRows=PrintedRows%RowsperPage;
		     	     if ((CellRows==0))
				     { 
				       Title=PrintLocName+t['PrintTitle'];
				       xlsheet.cells(1,1)=Title;
		     	       Pageindex=Pageindex+1
		     	       xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+GetCurrentTime();
		     	       xlsheet.printout;
				       ClearPage(xlsheet);
				       PrintedRows=PrintedRows%RowsperPage
				       Isprint=1;
			         }
			         else
			         { 
				        Isprint=0; 
			         }
		             var printdata=cspRunServerMethod(SetPrintFunction,StudyNo);
     
	     	     }
	     	   }
	     	   if (Isprint==0)
               {
	                Title=PrintLocName+t['PrintTitle'];
				    xlsheet.cells(1,1)=Title;
		     	    Pageindex=Pageindex+1;
		  			var CurrTime=GetCurrentTime();
		  			//alert(CurrTime);
		  			xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+CurrTime;
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


function GetReportStatus(Info)
{
	//Status
	var item=Info.split("^");
	document.getElementById("Status").value=item[2];
	
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
function ClearPage(xlsheet)
 {
	 for (var i=1; i<=RowsperPage;i++)
	 {
		 for(var j=1;j<=colsperPage;j++)
		 {
			 xlsheet.cells(i+2,j)="";
			 
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


