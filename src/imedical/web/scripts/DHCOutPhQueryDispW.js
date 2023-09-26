//DHCOutPhQueryDispW
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhQueryDispW");
var f=document.getElementById("fDHCOutPhQueryDispW");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
var GFyFlag;
   GFyFlag="2"
  if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['work_top'];
		bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
	}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryDispWSub');


function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BRetrieveobj=document.getElementById("BRetrieve");
  var bexport=document.getElementById("BExport");
  if (bexport) bexport.onclick=Export_click;
   var pmino=document.getElementById("CPmiNo");
   if (pmino) pmino.onkeydown=GetPmino;
    ctlocobj=document.getElementById("ctloc");
  // document.onkeydown=OnKeyDownHandler;
   if (BRetrieveobj){
	   BRetrieveobj.onclick=Retrieve_click;
	   if (tbl.rows.length>1){RowClick();}
	   else
	   { var phd=""
 	     var flag=""
 	     var ctloc=ctlocobj.value;
 	     var prescno=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispWSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno;
       	    bottomFrame.location.href=lnk;
	   }
	  }
  
  
  useridobj=document.getElementById("userid");
 websys_setfocus('CPmiNo');

}
function OnKeyDownHandler(e){
  var key=websys_getKey(e);
 // var patname=document.getElementById('CPatName');
}



function GReasID(value)
{ if (value=="") {return;}
  var sstr=value.split("^")
  var reasid=document.getElementById("CReasID")
     reasid.value=sstr[1]
  
	
}
function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var phd=document.getElementById("tphdz"+selectrow).value
	var ctlocobj=document.getElementById("ctloc");
	var fy=document.getElementById("tPyNamez"+selectrow).innerText
	//if (fy=="W"){GFyFlag="2";}
	var ctloc=ctlocobj.value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispWSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
 	websys_setfocus('CPmiNo');



}

function RowClick()
{
  var prescno=document.getElementById("TPrescNoz"+1).innerText
  var phd=document.getElementById("tphdz"+1).value
  var ctlocobj=document.getElementById("ctloc");
  var ctloc=ctlocobj.value;
  	var fy=document.getElementById("tPyNamez"+1).innerText
	GFyFlag="2";

	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispWSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
 	websys_setfocus('CPmiNo');

}
function GetPmino() {
 var key=websys_getKey(e);
 var pmiobj=document.getElementById("CPmiNo");
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){ websys_setfocus('CPerName'); return ;}
 	if (plen>8){alert(t['01']);return;}
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 Retrieve_click();
	 pmiobj.value=""
	 websys_setfocus('CPmiNo');
 }
}
function GPmino()
{
 if (pmiobj.value=="") return ;
  var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0)  {  websys_setfocus('CPerName'); return ;}
 	if (plen>8){alert(t['01']);return;}
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 Retrieve_click();
   //websys_setfocus('CPerName');

}
function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispW";
 	var prt=""
 	var phd=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispWSub&rPhd="+phd;
 	bottomFrame.location.href=lnk;
	 }
 
function GFydr(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CFyDr")
     fydrobj.value=sstr[1]
}
function GPydr(value)
{
  var sstr=value.split("^")
  var pydrobj=document.getElementById("CPyDr")
     pydrobj.value=sstr[1]
}
function GInci(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("inci")
     fydrobj.value=sstr[1]
}

function Retrieve_click()
{
  stdateobj=document.getElementById("CDateSt")
  enddateobj=document.getElementById("CDateEnd")
  pmiobj=document.getElementById("CPmiNo")
  pnameobj=document.getElementById("CPerName")
  ctlocobj=document.getElementById("ctloc")
   var ctloc=ctlocobj.value;
  var stdate=stdateobj.value
  var enddate=enddateobj.value
  var pmino=pmiobj.value
  var plen=pmiobj.value.length
  var i;
  var lszero=""
    if (plen>8){alert(t['01']);return;}
    if (plen>0) { for (i=1;i<=8-plen;i++)
         {
	 	 lszero=lszero+"0"  
    	 }
	 pmino=lszero+pmino;
	} 
  var pname=pnameobj.value
  
  var prtinv=document.getElementById("CPrtInv").value
  var inci=document.getElementById("inci").value
  var pydr=document.getElementById("CPydr").value
  var fydr=document.getElementById("CFydr").value
    GFyFlag="2";
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispW&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc+"&CPmiNo="+pmino+"&CPerName="+pname+"&CPrtInv="+prtinv+"&inci="+inci+"&CPydr="+pydr+"&CFydr="+fydr+"&FyFlag="+GFyFlag;
  topFrame.location.href=lnk;
  
   websys_setfocus('CPmiNo');


}

function Export_click() 
{
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryDispWSub');
var tblobj=document.getElementById("tDHCOutPhQueryDispW");
var oXL = new ActiveXObject("Excel.Application"); 
var oWB = oXL.Workbooks.Add(); 
var oSheet = oWB.ActiveSheet; 
var rows = subtblobj.rows.length; 
var mainrows=tblobj.rows.length;
var RowSel=SelectedRow 
var lie = subtblobj.rows(0).cells.length; 
var mainlie = tblobj.rows(0).cells.length; 
   if (mainrows==1) {return ;}
   if (SelectedRow==0) {RowSel=1;}
var ii;
    for (ii=0;ii<mainlie;ii++)
   {oSheet.Cells(1,ii+1).value= tblobj.rows(RowSel).cells(ii).innerText;  }
var i,j;
// Add table headers going cell by cell. 
for (i=0;i<rows;i++){ 
    for (j=0;j<lie;j++){ 
        oSheet.Cells(i+2,j+1).value = subtblobj.rows(i).cells(j).innerText; } ;
   } 
oXL.Visible = true; 
oXL.UserControl = true; 
} 

document.body.onload = BodyLoadHandler;
