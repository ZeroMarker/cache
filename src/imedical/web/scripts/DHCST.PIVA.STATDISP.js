/// DHCST.PIVA.STATDISP
function BodyLoadHandler()
{
  	GetRecord();
  	//InitForm();
  	//SetObjHandler();
}
function InitForm()
{
	setDefaultValByLoc();
	setPassAudit();
	setSpecStat();
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
		var sdate = arrset[6];
		var edate = arrset[7];
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
		var objst = document.getElementById("tStartTime");
		if (objst){
			if (objst.value=="") objst.value = "00:00";
		}
		var objet = document.getElementById("tEndTime");
		if (objet){
			if (objet.value=="") objet.value = "23:59";
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
function setSpecStat()
{
	var obj=document.getElementById("tSpecStat");
	if (obj) InitSpecStat(obj);
	var objindex=document.getElementById("SpecStatIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
function GetRecord()
{
	var recordnum=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATDISP");
    if (objtbl) recordnum=getRowcount(objtbl)-1;
    if(recordnum<0){recordnum=0;}
	var obj=parent.frames['DHCST.PIVA.STATDISPM'].window.document.getElementById("clCnt");
	if (obj){
		obj.innerText=""; //"记录数:"+recordnum;
	}
}
function SetObjHandler()
{
	var obj = document.getElementById("tBatNo");
	if (obj) obj.readOnly = true;
	var obj = document.getElementById("tOecpr");
	if (obj) obj.readOnly = true;
	//if (obj) obj.readOnly=true;
	var obj = document.getElementById("tRegNo");
	if (obj) {
		obj.onblur = RegNoLostFocus;
		obj.onfocus = RegNoOnFocus;
		obj.onkeydown = RegNoKeyDown;
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
	var obj = document.getElementById("tItmDesc");
	if (obj){
		obj.onblur=ItmLostFocus;
		obj.onfocus=ItmOnFocus;
		obj.onkeydown=ItmKeyDown;
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
	var listobj=document.getElementById("tSpecStat");
	if (listobj) {
		listobj.onclick=SpecSelect;
	}
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bPrint");
	if (obj) obj.onclick = PrintClick;
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
}
/// tRegNo Handler
function RegNoKeyDown()
{
	var key=websys_getKey();
	if (key==13)
	{
		RegNoLostFocus();
	}
	
}
function RegNoOnFocus()
{
	var obj=document.getElementById("tRegNo");
	if (obj) obj.select();
}
function RegNoLostFocus()
{
	var regno;
	var objregno=document.getElementById("tRegNo");
	if (objregno) regno=objregno.value;
	if (regno==""){
		return;
	}
	else{
		regno=getRegNo(regno);
		objregno.value=regno
	}
}
/// tItmDesc Handler
function ItmLostFocus()
{
	var obj=document.getElementById("tItmDesc");
	if (obj){
		if (obj.value == ""){
			var obj=document.getElementById("tItmID");
			if (obj) obj.value = ""
		}
	}
}
function ItmOnFocus()
{
	var obj=document.getElementById("tItmDesc");
	if (obj) obj.select();
}
function ItmKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tItmDesc_lookuphandler();
	}
}
function ItmLookupSelect(str)
{	
	var inci=str.split("^");
	var obj=document.getElementById("tItmID");
	if (obj){
		if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}
/// tOecpr
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
/// tSpecStat
function SpecSelect()
{
	var obj=document.getElementById("SpecStatIndex");
	if(obj){
		var objspec=document.getElementById("tSpecStat");
		obj.value=objspec.selectedIndex;
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
	var objno = document.getElementById("tRegNo");
	if (objno) objno.value = "";
	obj=document.getElementById("tItmID");
	if (obj) obj.value="";
	obj=document.getElementById("tItmDesc");
	if (obj) obj.value="";
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATDISP");
	if (objtbl) DelAllRows(objtbl);
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0";
}
function FindClick()
{
	var rowcount=0;
	if (ChkFindCondition()==false) return;	
	KillTmpBeforeFind();	
  	bFind_click();	
  	KillTmpBeforeFind();
}
function KillTmpAfterFind(pid)
{
	var objktmp=document.getElementById("mKTmpAfterFind");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	cspRunServerMethod(encmeth,pid);
}
function KillTmpBeforeFind()
{
	var pid=""; 
	var obj=document.getElementById("tbPIDz"+1);
    if (obj) pid=obj.value;
    if (pid>0) KillTmpAfterFind(pid);
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
	var objreg=document.getElementById("tRegNo");
	if ((objward.value=="")&&(objreg.value=="")) {
		if (confirm(t['NO_SELECT'])) {return true;} else {return false;}
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
	var hospname="";
	var currow;
	var i;
	var j;
	var itmdesc;
	var uom;
	var qty;
	var price;
	var manf;
	var amount;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATDISP");
	var rowcount=getRowcount(objtbl);
	if (rowcount<=0){
		alert(t['NO_ANY_ROWS'])
		return ;
	}
	var startRow=5;
	var cols=5;
	var pagerows=32;
	var prnpath=getPrnPath();
	var Template=prnpath+"DHCST_PIVA_STATDISP.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	var hospname=getHospName();
	var obj=document.getElementById("tWard") ;
	if (obj) ward=obj.value;
	if(ward!=""){
		var ward1=ward.split("-");
		var ward=ward1[1];
	}
	var obj=document.getElementById("tStartDate") ;
	if (obj) sd=obj.value;
	var obj=document.getElementById("tEndDate") ;
	if (obj) ed=obj.value;
	///
	xlsheet.Cells(1,1).Value =hospname+"发药统计表"
	xlsheet.Cells(2,1).Value ="统计日期:"+(sd)+"至"+(ed);
	xlsheet.Cells(3,1).Value ="病区:"+ward;
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
		var obj=document.getElementById("tbPrice"+"z"+i) ;
		if (obj) price=obj.innerText;
		var obj=document.getElementById("tbManf"+"z"+i) ;
		if (obj) manf=obj.innerText;
		var obj=document.getElementById("tbAmount"+"z"+i) ;
		if (obj) amount=obj.innerText;
		//var tmpitm=itmdesc.split("(")
		//itmdesc=tmpitm[0];
		xlsheet.Cells(currow,1).Value=i;
		if (i==rowcount){xlsheet.Cells(currow,1).Value=""};
		xlsheet.Cells(currow,2).Value=itmdesc;
		xlsheet.Cells(currow,3).Value=uom;
		xlsheet.Cells(currow,4).Value=price;
		xlsheet.Cells(currow,5).Value=qty;
		xlsheet.Cells(currow,6).Value=amount;
		xlsheet.Cells(currow,7).Value=manf;
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
	//sheet.Quit;
	book.Close (savechanges=false);
	app.Quit();
	sheet=null;
	book=null;
	app=null;
}
document.body.onload=BodyLoadHandler;