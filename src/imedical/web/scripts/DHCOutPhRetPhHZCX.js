//DHCOutPhRetPhHZCX
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhRetPhHZCX");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj;
var BResetobj,BPrintobj;
var printobj;

function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click; 
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  ctlocobj=document.getElementById("ctloc");
  var locobj=document.getElementById("CDepDesc");
  if (locobj) {
	  locobj.onkeydown=popCDepDesc;
	  locobj.onblur=CDepDescCheck; ;
  }
  useridobj=document.getElementById("userid");
  var BFindobj=document.getElementById("BRetrieve");
  if (BFindobj) BFindobj.onclick=Retrieve_click;
 
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;

}
function popCDepDesc()
{ 
	if (window.event.keyCode==13) 
	{ 
	   window.event.keyCode=117;
	   window.event.isLookup=true
	   CDepDesc_lookuphandler(window.event);
	}
}
function CDepDescCheck()
{	
	var obj=document.getElementById("CDepDesc");
	var obj2=document.getElementById("CDepCode");
	if (obj){
		if (obj.value==""){ 
			obj2.value="";
		}
	}
}
function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetPhHZCX";
 }

function Retrieve_click()
 {
  var stdate=document.getElementById("CDateSt").value
  var enddate=document.getElementById("CDateEnd").value
  var depcode=document.getElementById("CDepCode").value
  var depdesc=document.getElementById("CDepDesc").value
  var tdoctor=document.getElementById("CDoctor").value
  var ctloc=document.getElementById("ctloc").value
  
 location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetPhHZCX&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc+"&CDepCode="+depcode+"&CDoctor="+tdoctor+"&CDepDesc="+depdesc;

 
 }
function Print_click(){
	var HospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
	var CtLocDesc=tkMakeServerCall("web.DHCSTPharmacyCommon","GetDefaultLoc",session['LOGON.CTLOCID'])
	if (tblobj.rows.length==0) {alert(t['01']);return 0;}
	var rows,Rrow,prt,name,pmino,printflag,inv;
	rows=tblobj.rows.length-1
	var path
	var Ls_orderitemtmp,RowN,i
	var getmethod=document.getElementById('gpath');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var path=cspRunServerMethod(encmeth)
	var datest=document.getElementById('CDateSt');
	var dateend=document.getElementById('CDateEnd');
	var pagerow=35;
	var xlApp,obook,osheet,xlsheet,xlBook
	var paymoney
	var Template
	Template=path+"yftyhz.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet 
	xlsheet.cells(1,1).value=HospDesc+CtLocDesc+"ÍËÒ©»ã×Ü"
	xlsheet.cells(2,1).value=datest.value+t['02']+dateend.value
	var pagenum
	if (Math.floor(rows/pagerow)==(rows/pagerow)){pagenum=Math.floor(rows/pagerow);}
	else {pagenum=Math.floor(rows/pagerow)+1;}  
	var k,j,l,RowNum,count;
	var  lastnum = rows-(pagenum-1)*pagerow 
	for (k=1;k<=pagenum;k++){
		if (k==pagenum){
			RowNum=lastnum;
		} else { 
			RowNum = pagerow;
		}
		for (l=4;l<=pagerow+3;l++){
			for(j=1;j<=4;j++){
				xlsheet.Cells(l, j).value="";
			}
		}
		for(i=1;i<=RowNum;i++){
			xlsheet.cells(3+i,1).value=document.getElementById("TPhDescz"+(i+(k-1)*pagerow)).innerText
			xlsheet.cells(3+i,2).value=document.getElementById("TPhUomz"+(i+(k-1)*pagerow)).innerText
			xlsheet.cells(3+i,3).value=document.getElementById("TRetQtyz"+(i+(k-1)*pagerow)).innerText
			xlsheet.cells(3+i,4).value=document.getElementById("TRetMoneyz"+(i+(k-1)*pagerow)).innerText
		}
		xlsheet.printout
	}   
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null
}	   
function GetDropDep(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CDepCode");
  shdr.value=val[1];
}
function GetDropDoctor(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CDoctor");
  shdr.value=val[1];
}

document.body.onload = BodyLoadHandler;
