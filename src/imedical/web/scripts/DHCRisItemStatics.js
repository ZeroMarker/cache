//DHCRisItemStatics
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
	var LocID=document.getElementById("LocID");
	LocID.value=session["LOGON.CTLOCID"];
	
	var locobj=document.getElementById("getlocname");
	
	var GetLocNameFunction=locobj.value;
 	var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
    locobj.value=value;
}

function DateDemo(){
   var d, s="";         
   d = new Date();                          
   s += d.getDate() + "/";                 
   s += (d.getMonth() + 1) + "/";           
   s += d.getYear();                       
   return(s);                               
}


function GetProvCareInfo(str)
{
	//alert(str);
	var obj=document.getElementById('TOptionDoc');
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
	var obj=document.getElementById('VeriedDoc');
	var tem=str.split("^");
	obj.value=tem[0];
	obj.text=tem[1];
} 

function GetTypeDesc(Info)
{
	var item=Info.split("^");
	document.getElementById("PatientType").value=item[0];
	document.getElementById("type").value=item[1];
	//FindClickHandler();

}

document.body.onload = BodyLoadHandler;
