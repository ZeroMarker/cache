///DHCRisBookEQStatics.js
var TemplatePath;
var RowsperPage=30;
var colsperPage=20;

function BodyLoadHandler()
{
	var stdate=document.getElementById("Stdate");
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
	
	var printobj=document.getElementById("Print")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	
	GetLocName()
	
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
	  
}

function Staticsclick()
{
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




function GetExeLoc(Info)
{
	//alert(Info);
	var Item=Info.split("^");
	document.getElementById('RecLoc').value=Item[0];
	document.getElementById('LocID').value=Item[1];

}
function GetTypeDesc(Info)
{
	var item=Info.split("^");
	document.getElementById("PatientType").value=item[0];
	document.getElementById("PatType").value=item[1];
}


function onprint()
{
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRis_BookStatics.xls";
	    var CellRows ; 
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    var stdate=document.getElementById("Stdate");
	    var eddate=document.getElementById("EndDate");
	    var Info="统计日期:"+stdate.value+"-"+eddate.value;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	
	         
	    ClearPage(xlsheet);
	    var ordtab=document.getElementById("tDHCRisBookEQStatics");
	    var Nums=ordtab.rows.length;
	    xlsheet.cells(2,1)=Info;
	    
        if (ordtab) 
        {
     		for (var i=1;i<Nums;i++)
     	    {
    	  	   PrintedRows=PrintedRows+1
	     	   xlsheet.cells(PrintedRows+3,1)=document.getElementById("TDescz"+i).innerText;
		       xlsheet.cells(PrintedRows+3,2)=document.getElementById("TNumz"+i).innerText;
		       
	    	}
	    	xlsheet.printout;
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

function GetLocName()
{
	var LocID=document.getElementById('LocID');
	if (LocID.value=="")
	{
	   LocID.value=session['LOGON.CTLOCID'];
	}
	 var LocName=document.getElementById("RecLoc").value;
	if (LocName=="")
	{
	   var GetLocNameFunction=document.getElementById("FunLocName").value;
	   var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
           var LocName=document.getElementById("RecLoc");
           LocName.value=value;
	}
	
}
document.body.onload = BodyLoadHandler;


