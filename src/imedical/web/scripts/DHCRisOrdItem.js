//DHCRisOrdItem.js
//DHCRisEQStatics
 var RowsperPage=28;
 var colsperPage=5;
	 
function BodyLoadHandler()
{
	var stdate=document.getElementById("StDate");
	var eddate=document.getElementById("EndDate");
	
	if (stdate.value=="")
	{
	    stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	    eddate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	}
  	
	var GetLocNameFunction=document.getElementById("LocName").value;
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
function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisOrdItem');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    var OrdNameDesc=document.getElementById("OrdNamez"+selectrow).innerText;
    if (OrdNameDesc=="ºÏ¼Æ")
       return false;
       
   	var ItemID=document.getElementById("ItemIDz"+selectrow).innerText;
   	var ItemIDLink='ItemIDz'+selectrow;
 
   	if (eSrc.id==ItemIDLink)
  	{
	  	var LocID=document.getElementById("LocID").value;
	  	var StDate=document.getElementById("StDate").value;
	  	var EndDate=document.getElementById("EndDate").value;
	  	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrdItemDetail"+"&LocID="+LocID+"&StDate="+StDate+"&EndDate="+EndDate+"&ArcItemID="+ItemID;
	   	var NewWin=open(lnk,"bb","scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");
        return false;

	  
   	}
   	return false;
   	
  	
}

function onprint()
{
	var PrintedRows=0;
	var CellRows=0;
	var Pageindex=0;
	
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRis_OrdNumsStatics.xls";
	    alert(Template)
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    ClearPage(xlsheet);
	    
	    var stdate=document.getElementById("StDate");
	    var eddate=document.getElementById("EndDate");
        var LocName=document.getElementById("LocName").value;
	    
	    var Info=LocName+" "+t['StaticsDate']+":"+stdate.value+"-"+eddate.value;
	   
	   	var objtbl=document.getElementById('tDHCRisOrdItem');
	   	
		var Nums=objtbl.rows.length;
		
	    xlsheet.cells(2,1)=Info;
	  	for (var i=1;i<Nums;i++)
		{	
		    PrintedRows=PrintedRows+1
		    xlsheet.cells(PrintedRows+3,1)=document.getElementById("OrdNamez"+i).innerText;
	    	xlsheet.cells(PrintedRows+3,2)=document.getElementById("Countsz"+i).innerText;
	    	xlsheet.cells(PrintedRows+3,4)=document.getElementById("InComez"+i).innerText;
	    	xlsheet.cells(PrintedRows+3,3)=document.getElementById("PeopleNumsz"+i).innerText;
	       	CellRows=PrintedRows%RowsperPage;
		
		   	if ((CellRows==0))
			{   
				Pageindex=Pageindex+1
				xlsheet.cells(RowsperPage+4,1)=t["Index"]+Pageindex+t["Page"];
		     	xlsheet.cells(RowsperPage+4,3)=t["PrintDate"]+GetCurrentTime();
		    	xlsheet.printout;
				ClearPage(xlsheet);
				PrintedRows=PrintedRows%RowsperPage
			}
			else if (i==Nums-1)
			{
				Pageindex=Pageindex+1;
		  		var CurrTime=GetCurrentTime();
		  		xlsheet.cells(RowsperPage+4,1)=t["Index"]+Pageindex+t["Page"];
		   		xlsheet.cells(RowsperPage+4,3)=t["PrintDate"]+CurrTime;
		  		xlsheet.printout;
	    	}
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

