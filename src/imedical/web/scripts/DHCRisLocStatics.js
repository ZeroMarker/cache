var TemplatePath;
var selectrow;
var RowsperPage=35;  //per page has 35 rows
var colsperPage=11;



function BodyLoadHandler()
{
	var stdate=document.getElementById("stdate");
	var eddate=document.getElementById("eddate");
	if (stdate.value=="")
	{
		stdate.value=DateDemo();
		eddate.value=DateDemo();
	}
	var LocID=document.getElementById("LocID")
	LocID.value=session["LOGON.CTLOCID"];
	
	var GetLocNameFunction=document.getElementById("getlocname").value;
 	var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
    var LocName=document.getElementById("FLocation");
    LocName.value=value;
	ini()
	
	var regObj=document.getElementById("Set");
	if (regObj)
	{
		regObj.onclick=Set_click;
	}
	var printobj=document.getElementById("print")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
 	//alert(TemplatePath);

  
}
function Set_click()
{
	var strrowidObj=document.getElementById("Oeordresrowid");

	if (strrowidObj.value!="")
	{
		//alert(strrowidObj.value);
		var obj=document.getElementById("Flag");
		flag=obj.value;
	    var updateflag1=document.getElementById("updateflag").value
	    var sqlcode=cspRunServerMethod(updateflag1,strrowidObj.value,flag);
    	//alert(sqlcode);
    	if (sqlcode!="0")
    	{
	    	  alert(t['updateFailure']);
    	}
    	else
    	{ 	
	    var stdate=document.getElementById("stdate").value;
	    var eddate=document.getElementById("eddate").value;
	   	var LocName=document.getElementById("FLocation").value;
		var BodyPartName=document.getElementById("BodyPart").value;
		var Techican=document.getElementById("Techician").value;
		var ReportDoc=document.getElementById("ReportDoc").value;
		var CheckDoc=document.getElementById("CheckDoc").value;		
	 
	    	
    	}
	}
	else
	{
		alert(t['SelectOrder']);
		
	}
    
	
}
function onprint()
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"LocStatics.xls";
	    var CellRows ; //
	    var Isprint=0;
	    var Pageindex=0;
	
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var GetNumsFunction=document.getElementById("GetNums").value;
	    var Nums=cspRunServerMethod(GetNumsFunction);
	       
	    ClearPage(xlsheet);
	    
	    for (var i=1;i<=Nums;i++)
		{			
			CellRows=i%RowsperPage;
			if (CellRows==0) CellRows=RowsperPage;
			if ((CellRows==1)&&(i!=1))
			{   
				 Pageindex=Pageindex+1
		     	 xlsheet.cells(RowsperPage+3,7)=t['PrintDate']+DateDemo();
		     	 xlsheet.cells(RowsperPage+3,3)=t['di']+Pageindex+t['page'];
		    	 xlsheet.printout;
				 ClearPage(xlsheet);
				 Isprint=1
			}
		    var GetDataFunction=document.getElementById("GetPrintData").value;
	       	var printdata=cspRunServerMethod(GetDataFunction,i)
	         if (printdata!="")
		    {
			   var item=printdata.split("^");
			    for (var j=1; j<=colsperPage;j++)
			    {
				   if (item[j-1]==0) item[j-1]="";
				   xlsheet.cells(CellRows+2,j)=item[j-1];
			    }
			    Isprint=0
			    }
	    }
	    if (Isprint==0)
	    {
		  Pageindex=Pageindex+1
		  xlsheet.cells(RowsperPage+3,7)=t['PrintDate']+DateDemo();
		  xlsheet.cells(RowsperPage+3,3)=t['di']+Pageindex+t['page'];
		  xlsheet.printout;
		
	    }
		 xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null;
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
			 xlsheet.cells(i+2,j)="";
			 
		 }
	 }
 }
 function ini()
 {
	var obj=document.getElementById("Flag");
	if (obj){		
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['V1'],t['V1']);
	  obj.options[1]=new Option(t['V2'],t['V2']);
	 }
	}
	
function setDefaultLoc()
{
	var xlocid=session["LOGON.CTLOCID"] ;
	var LocID=document.getElementById("LocID")
	if (LocID) LocID.value=xlocid;
	
	
	
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
   
   sYear  = d.getYear();		
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
}


function GetProvCareInfo(str)
{
	//alert(str);
	var obj=document.getElementById('Techician');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
} 

function GetReportDocInfo(str)
{
	var obj=document.getElementById('ReportDoc');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
} 

function GetVeriedDocInfo(str)
{
	var obj=document.getElementById('CheckDoc');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
} 

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisLocStatics');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;
  
    var Trowid=document.getElementById("Tordresultrowidz"+selectrow).value;
    
    var strrowidObj=document.getElementById("Oeordresrowid");
    strrowidObj.value=Trowid;
    
}
function GetTypeDesc(Info)
{
	var item=Info.split("^");
	document.getElementById("PatientType").value=item[0];
	document.getElementById("type").value=item[1];

}




document.body.onload = BodyLoadHandler;