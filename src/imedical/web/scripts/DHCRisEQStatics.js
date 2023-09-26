//DHCRisEQStatics
var RowsperPage=21;
var colsperPage=6;

function BodyLoadHandler()
{
	var stdate=document.getElementById("Stdate");
	var eddate=document.getElementById("EndDate");
	//alert(stdate.value);
	
	if (stdate.value=="")
	{
	    stdate.value=DateDemo();
	    //alert(stdate.value);
	    eddate.value=DateDemo(); 
	    //alert(xlocid);
	   // location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisStatics&Type="+"O"+"&LocID="+xlocid+"&stdate="+stdate.value+"&eddate="+eddate.value		
	}
  	
	var GetLocNameFunction=document.getElementById("GetLocName").value;
	var LocID=document.getElementById("LocID").value;
	
 	var value=cspRunServerMethod(GetLocNameFunction,LocID);
    var LocName=document.getElementById("LocName");
    LocName.value=value;
    
    	
    var printobj=document.getElementById("Print")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);

    
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
	    var Template=TemplatePath+"DHCRis_EQWorkStatics.xls";
	  
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    ClearPage(xlsheet);
	    var stdate=document.getElementById("Stdate");
	    var eddate=document.getElementById("EndDate");
        var LocName=document.getElementById("LocName").value;
	    
	    var Info=LocName+" "+t['StaticsDate']+":"+stdate.value+"-"+eddate.value+"  "+t['PrintDate']+DateDemo();
	   
	   	var objtbl=document.getElementById('tDHCRisEQStatics');
		var Nums=objtbl.rows.length;
		
	    xlsheet.cells(2,1)=Info;
	  	for (var i=1;i<Nums;i++)
		{	
		    xlsheet.cells(i+3,1)=document.getElementById("EQNamez"+i).innerText;
	    	xlsheet.cells(i+3,2)=document.getElementById("Countz"+i).innerText;
	    	xlsheet.cells(i+3,3)=document.getElementById("ExamCountsz"+i).innerText;
	    	xlsheet.cells(i+3,4)=document.getElementById("TotalInComez"+i).innerText;
		}
	    xlsheet.printout;
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
			 xlsheet.cells(i+3,j)="";
			 
		 }
	 }
 }



document.body.onload = BodyLoadHandler;


