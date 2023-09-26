/// DHCST.PIVA.PRESTAT
function BodyLoadHandler()
{
	InitForm();
	SetObjHandler();
}
function InitForm()
{
	setDefaultValByLoc();
	setPassAudit();
	GetRecord();
}
function setDefaultValByLoc()
{
	var locid = "";
	var objlocid = document.getElementById("tPLocID");
	if (objlocid) locid = objlocid.value;
	if (locid == "") return;
	var strsets = cspRunGetLocSet(locid);
	if (strsets != "")
	{
		var arrset = strsets.split("^")
		var sdate = arrset[2];
		var edate = arrset[3];
		var stdate = GetCalDate("mGetDate",sdate);
		var eddate = GetCalDate("mGetDate",edate);
		var objsd = document.getElementById("tStartDate");
		if (objsd){
			if (objsd.value=="") objsd.value = stdate;
		}
		var objed = document.getElementById("tEndDate");
		if (objed){
			if (objed.value=="") objed.value = eddate;
		}
	}
}
function setPassAudit()
{
	var obj=document.getElementById("tPassAudit");
	if (obj) InitPassAudit(obj);
	var objindex=document.getElementById("PassAuditIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
function GetRecord()
{
	var recordnum=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRESTAT");
	if (objtbl){
		recordnum=objtbl.rows.length-1;
	}
	var obj=document.getElementById("clCnt");
	if (obj){
		obj.innerText="记录数:"+recordnum;
	}
}
function SetObjHandler()
{
	var obj = document.getElementById("tBatNo");
	if (obj) {
		//obj.onblur = BatNoLostFocus;
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	//if (obj) obj.readOnly = true;
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
	var obj=document.getElementById("tPLoc");
	if (obj){
		obj.onkeydown=PLocKeyDown;
		obj.onfocus=PLocOnFocus;
	 	obj.onblur=PLocLostFocus;
	}
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
		obj.onkeydown=WardKeyDown;
	}
	var obj = document.getElementById("tPassAudit");
	if (obj){
		obj.onchange=PassAuditSelect;
	}
	var obj = document.getElementById("tPrintNo");
	if (obj){
		obj.onblur=PrintNoLostFocus;
		obj.onfocus=PrintNoOnFocus;
		obj.onkeydown=PrintNoKeyDown;
	}
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bPrint");
	if (obj) obj.onclick=PrintClick;
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}
/// tPLoc Handler
function PLocKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tPLoc_lookuphandler();
	}
}
function PLocOnFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj) obj.select();
}
function PLocLostFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPLocID");
			if (obj) obj.value=""
		}
	}
}
function DispLocLookUpSelect(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("tPLocID");
	if (obj){
		if (loc.length>0) obj.value=loc[1];
		else obj.value="";
	}
}
/// tWard Handler
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value=""
		}
	}
}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj){
		if (ward.length>0)   obj.value=ward[1];
		else  obj.value="" ;
	 }
}
function WardKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tWard_lookuphandler();
	}
}/// tBatNo
function BatNoOnFocus()
{
	var obj=document.getElementById("tBatNo");
	if (obj) obj.select();
}
function BatNoKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tBatNo_lookuphandler();
	}
}
/// tOecpr
function OecprLostFocus()
{
	var obj = document.getElementById("tOecpr");
	if (obj.value=="") {
		var objid=document.getElementById("tOecprID");
		objid.value="";
	}
}
function OecprOnFocus()
{
	var obj = document.getElementById("tOecpr");
	obj.select();
}
function OecprKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		tOecpr_lookuphandler();
	}
}
function OecprLookupSelect(str)
{
	var cpr=str.split("^");
	var obj=document.getElementById("tOecprID");
	if (obj){
		if (cpr.length>0)   obj.value=cpr[2] ;
		else  obj.value="" ;
	}

}
/// tPassAudit
function PassAuditSelect()
{
	var obj=document.getElementById("PassAuditIndex");
	if(obj){
		var objpass=document.getElementById("tPassAudit");
		obj.value=objpass.selectedIndex;
	}
}
/// tPrintNo
function PrintNoLostFocus()
{
	var obj=document.getElementById("tPrintNo");
	if (obj){
		if (obj.value!=""){
			obj.value=FormatNo(obj.value)
		}
	}
}
function PrintNoOnFocus()
{
	var obj=document.getElementById("tPrintNo");
	if (obj) obj.select();
}
function PrintNoKeyDown()
{
	if (window.event.keyCode==13){
	  	PrintNoLostFocus();
	}
}
/// cmd handler
function Clear()
{
	var obj;
	//KillTmpBeforeFind();
	setDefaultValByLoc();
	var objward = document.getElementById("tWard");
	if (objward) objward.value = "";
	var objwardid = document.getElementById("tWardID");
	if (objwardid) objwardid.value = "";
	obj=document.getElementById("tBatNo");
	if (obj) obj.value="";
	obj=document.getElementById("tOecprID");
	if (obj) obj.value="";
	obj=document.getElementById("tOecpr");
	if (obj) obj.value="";
	obj=document.getElementById("tPrintNo");
	if (obj) obj.value="";
	obj=document.getElementById("tPassAudit");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0";
}
function FindClick()
{
	if (ChkFindCondition()==false) return;
  	bFind_click();
}
 /// 检查查询条件
function ChkFindCondition()
{
	var obj;
	obj=document.getElementById("tPLocID") ;
	if (obj){
		if (obj.value==""){
		    alert(t["NO_DISPLOC"]);
	   	    return false;
	   	}
	}
	var obj1=document.getElementById("tStartDate") ;
	if (obj1.value=="" ){
		alert(t['NO_STARTDATE']);
	  	return false;
	}
	var obj2=document.getElementById("tEndDate") ;
	if (obj2.value=="" ){
		alert(t['NO_ENDDATE']) ;
	  	return false;
	}
    if (DateStringCompare(obj1.value,obj2.value )==1){
	    alert(t['INVALID_DATESCOPE']);
     	return  false ;
	}
	var objward=document.getElementById("tWardID");
	if (objward.value=="") {
		alert(t['NO_WARD']);
		return false;
	}
	return true ;
}
function PrintClick()
{
	try
	{
	var ward="";
	var sd="";
	var ed="";
	var batno="";
	var prio="";
	var printno="";
	var hospname="";
	var currow;
	var i;
	var j;
	var itmdesc;
	var uom;
	var qty;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRESTAT");
	var rowcount=getRowcount(objtbl);
	if (rowcount<=0){
		alert(t['NO_ANY_ROWS'])
		return ;
	}
	var startRow=5;
	var cols=4;
	var pagerows=30;
	var prnpath=getPrnPath();
	var Template=prnpath+"DHCST_PIVA_STATARR.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	var hospname=getHospName();
	var obj=document.getElementById("tWard") ;
	if (obj) ward=obj.value;
	var ward=getDesc(ward);
	var obj=document.getElementById("tStartDate") ;
	if (obj) sd=obj.value;
	var obj=document.getElementById("tEndDate") ;
	if (obj) ed=obj.value;
	var obj=document.getElementById("tBatNo") ;
	if (obj) batno=obj.value;
	var obj=document.getElementById("tOecpr") ;
	if (obj) prio=obj.value;;
	///
	xlsheet.Cells(1,1).Value =hospname+"配液预统计单"
	xlsheet.Cells(2,1).Value ="病区:"+ward+"    "+"日期:"+(sd)+"至"+(ed);
	xlsheet.Cells(3,1).Value ="批次:"+batno+"    优先级:"+prio;
	for (i=1;i<=pagerows;i++){
		for (j=1;j<=cols;j++){
			currow=i+startRow-1
			xlsheet.Cells(currow,j).Borders(1).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(2).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(3).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(4).LineStyle = 0;
		}
	}
	for (i=1;i<=rowcount;i++){
		currow=i+startRow-1
		var obj=document.getElementById("tbItmDesc"+"z"+i) ;
		if (obj) itmdesc=obj.innerText;
		var obj=document.getElementById("tbUom"+"z"+i) ;
		if (obj) uom=obj.innerText;
		var obj=document.getElementById("tbQty"+"z"+i) ;
		if (obj) qty=obj.innerText;
		//var tmpitm=itmdesc.split("(")
		//itmdesc=tmpitm[0];
		xlsheet.Cells(currow,1).Value=i;
		xlsheet.Cells(currow,2).Value=itmdesc;
		xlsheet.Cells(currow,4).Value=uom;
		xlsheet.Cells(currow,3).Value=qty;
	}
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
	}
	catch(e)
	{
		alert(e.message);
		xlBook.Close (savechanges=false);
		xlApp.Quit();
	}
}
function getHospName()
{
	var obj=document.getElementById("mPrtHospName");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var hospname=cspRunServerMethod(encmeth,'','');
	return hospname;
}
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
}
document.body.onload=BodyLoadHandler;