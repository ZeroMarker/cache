//DHCOutPhMZYPTJ
//门诊药房-药房统计-麻醉药品处方统计
var tblobj=document.getElementById("tDHCOutPhMZYPTJ");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BPrintobj;
var printobj;

function BodyLoadHandler() {
	BResetobj=document.getElementById("BReset");
	if (BResetobj) BResetobj.onclick=Reset_click;
	var BPrintobj=document.getElementById("BExport");
	if (BPrintobj) BPrintobj.onclick=Export_click;
	ctlocobj=document.getElementById("ctloc");
	var objPoison=document.getElementById("Poison");
	if (objPoison) 
	{	
		objPoison.onkeydown=popPoison;
	 	objPoison.onblur=PoisonCheck;
	} 
	
	var objCIncCatDesc=document.getElementById("CIncCatDesc");
	if (objCIncCatDesc) 
	{	
		objCIncCatDesc.onkeydown=popCIncCatDesc;
	 	objCIncCatDesc.onblur=CIncCatDescCheck;
	} 
	
	
}
function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhMZYPTJ";
 }

function GInci(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("inci")
     fydrobj.value=sstr[1]
}
function GCatID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CIncCatID")
     fydrobj.value=sstr[1]
     
}

function Export_click() 
{ 

 var ctloc=document.getElementById("ctloc").value;
 var userid=document.getElementById("userid").value;
 var rows,pagerow;
 var getmethod=document.getElementById('getrows');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var PrintRows=cspRunServerMethod(encmeth,ctloc)
  if (PrintRows==0){return ;}

var oXL = new ActiveXObject("Excel.Application"); 
var oWB = oXL.Workbooks.Add(); 
var oSheet = oWB.ActiveSheet; 
var mainrows=PrintRows;
var mainlie = tblobj.rows(0).cells.length;
oSheet.Range(oSheet.Cells(1, 1), oSheet.Cells(mainrows,mainlie)).NumberFormatLocal="@";
var i,j;
  for (j=1;j<mainlie;j++){  
     oSheet.Cells(1,j).value = tblobj.rows(0).cells(j).innerText;
     }
   for (i=1;i<=mainrows;i++)
     {
	   var getmethod=document.getElementById('getrowinf');
       if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
       var PrintSet=cspRunServerMethod(encmeth,ctloc,i)
       var sstr=PrintSet.split("^")
       oSheet.Cells(i+1,1).value =sstr[0];
       oSheet.Cells(i+1,2).NumberFormatLocal="@";
       oSheet.Cells(i+1,2).value =sstr[1];
       oSheet.Cells(i+1,3).value =sstr[2];
       oSheet.Cells(i+1,4).value =sstr[3];
       oSheet.Cells(i+1,5).value =sstr[4];
       oSheet.Cells(i+1,6).value =sstr[5];
       oSheet.Cells(i+1,7).value =sstr[6];
       oSheet.Cells(i+1,8).value =sstr[7];
       oSheet.Cells(i+1,9).value =sstr[8];
       oSheet.Cells(i+1,10).value =sstr[9];
       oSheet.Cells(i+1,11).value =sstr[10];
       oSheet.Cells(i+1,12).value =sstr[11];
       oSheet.Cells(i+1,13).value =sstr[12];
       oSheet.Cells(i+1,14).value =sstr[13];
       oSheet.Cells(i+1,15).value =sstr[14];
       oSheet.Cells(i+1,16).value =sstr[15];
       oSheet.Cells(i+1,17).value =sstr[16];
       oSheet.Cells(i+1,18).value =sstr[17];  
  
	 } 
oXL.Visible = true; 
oXL.UserControl = true; 
} 
///管制分类
function PoisonLookUpSelect(str)
{ 
    //取管制分类rowid
	var cat=str.split("^");
	var obj=document.getElementById("PoisonRowid");
	if (obj)
	{if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
}
function popPoison()
{ 
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	Poison_lookuphandler();
	}
}
function PoisonCheck()
{
	var obj=document.getElementById("Poison");
	var obj2=document.getElementById("PoisonRowid");
	if (obj)
	{
		if (obj.value=="") obj2.value=""
	}
}

//库存分类liangqiang 20151016
function popCIncCatDesc()
{ 
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	CIncCatDesc_lookuphandler();
	}
}
function CIncCatDescCheck()
{
	var obj=document.getElementById("CIncCatDesc");
	var obj2=document.getElementById("CIncCatID");
	if (obj)
	{
		if (obj.value=="") obj2.value=""
	}
}
document.body.onload = BodyLoadHandler;
