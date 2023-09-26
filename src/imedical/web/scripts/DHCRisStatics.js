//DHCRisStatics
//var gLocID="";
var TemplatePath=""
var RowsperPage=21;
var colsperPage=6;


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
	    location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisStatics&Type="+"O"+"&LocID="+xlocid+"&stdate="+stdate.value+"&eddate="+eddate.value		
	}
  	
 	var GetLocNameFunction=document.getElementById("getlocname").value;
	
 	var value=cspRunServerMethod(GetLocNameFunction,xlocid);
    var LocName=document.getElementById("LocName");
    
    /*var OEItemStaticsobj=document.getElementById("OEItemStatics");
	if (OEItemStaticsobj)
	{
	   OEItemStaticsobj.onclick=OEItemStaticsobjclick;
	}
	*/

	
	/*var RegStaticsobj=document.getElementById("RegStatics");
	if (RegStaticsobj)
	{
	   RegStaticsobj.onclick=RegStaticsobjclick;
	}
	*/
    LocName.value=value;
    
 	
    var printobj=document.getElementById("Print")
	if (printobj)
	{
		printobj.onclick=onprint;
		
	}
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
 	//alert(TemplatePath);
}

	

function OEItemStaticsobjclick()
{
	var locid=session["LOGON.CTLOCID"] ;
	var stdate=document.getElementById("stdate").value;
	var eddate=document.getElementById("eddate").value;	
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisStatics&Type="+"O"+"&LocID="+locid+"&stdate="+stdate+"&eddate="+eddate
	var stdateElt=document.getElementById("stdate");
	var eddateElt=document.getElementById("eddate");
	stdateElt.value=stdate;
	eddateElt.value=eddate;
	//alert(stdate);
	
}
function RegStaticsobjclick()
{
	var locid=session["LOGON.CTLOCID"] ;
	var stdate=document.getElementById("stdate").value;
	var eddate=document.getElementById("eddate").value;	
	if (document.getElementById("EQName").value=="")
	{
		document.getElementById("EQID").value="";
	}
	var EQName=document.getElementById("EQName").value;
	var EQID=document.getElementById("EQID").value;

	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisStatics&Type="+"P"+"&LocID="+locid+"&stdate="+stdate+"&eddate="+eddate+"&EQName="+EQName+"&EQID="+EQID;
	
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
		var para="&stdate="+stdate+"&eddate="+eddate+"&FLocation="+LocName+"&BodyPart="+BodyPartName+"&Techican="+Techican+"&ReportDoc="+ReportDoc+"&CheckDoc="+CheckDoc
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisLocStatics"+para

	    	
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
	    var Template=TemplatePath+"DHCRis_DoctorWorkStatics.xls";
	  
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    ClearPage(xlsheet);
	    var stdate=document.getElementById("stdate");
	    var eddate=document.getElementById("eddate");
        var LocName=document.getElementById("LocName").value;
	    
	    var Info=LocName+" "+t['StaticsDate']+":"+stdate.value+"-"+eddate.value+"  "+t['PrintDate']+DateDemo();
	   
	   	var objtbl=document.getElementById('tDHCRisStatics');
		var Nums=objtbl.rows.length;
		
	    xlsheet.cells(2,1)=Info;
	  	for (var i=1;i<Nums;i++)
		{	
		    xlsheet.cells(i+3,1)=document.getElementById("TDocNamez"+i).innerText;
	    	xlsheet.cells(i+3,2)=document.getElementById("TRegNumz"+i).innerText;
	    	xlsheet.cells(i+3,3)=document.getElementById("TARegNumz"+i).innerText;
	    	xlsheet.cells(i+3,4)=document.getElementById("TReportNumz"+i).innerText;
	   		xlsheet.cells(i+3,5)=document.getElementById("TVervReportNumz"+i).innerText;
	   		//alert("kk");
	   		xlsheet.cells(i+3,6)=document.getElementById("OptionNumberz"+i).innerText;
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


/////////////////////////////////////////
function GetRegLoc(Info)
{
	var Item=Info.split("^")
	document.getElementById("EQID").value=Item[0];
	document.getElementById("EQName").value=Item[2];
	
	
	
}


document.body.onload = BodyLoadHandler;


