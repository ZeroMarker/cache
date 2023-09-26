/// DHCST.PIVA.STATWARDBAT
function BodyLoadHandler()
{
  	InitForm();
  	SetObjHandler();
}
function InitForm()
{
	setDefaultValByLoc();
	setPassAudit();
	setSpecStat();
	settOecType();
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
		var objsdo = document.getElementById("tOrdStDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tOrdEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = eddate;
		}
	}
		/*
	    var objst = document.getElementById("tStartDateTime");
		if (objst){
			if (objst.value=="") objst.value = "00:00";
		}
	    var objet = document.getElementById("tEndDateTime");
		if (objet){
			if (objet.value=="") objet.value = "23:59";
		}
		*/
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
function settOecType()
{	
	var obj = document.getElementById("tOecType");
		if (obj){
			setOecType();
			obj.onchange=OecTypeSelect;
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
	//if (obj) obj.readOnly = true;
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
	var obj=document.getElementById("tPhcCat");
	if (obj){
		obj.onblur=PhcLostFocus;
		obj.onchange=PhcLostFocus;
		obj.onfocus=PhcOnFocus;
	}
	var obj=document.getElementById("tPhcSubCat");
	if (obj){
		obj.onblur=PhscLostFocus;
		obj.onchange=PhscLostFocus;
		obj.onfocus=PhscOnFocus;
	}
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj = document.getElementById("bPrint");
	if (obj) obj.onclick = PrintClick;
	
	var obj = document.getElementById("tLocGrp");
	if (obj) {
		 obj.onkeydown=popLocGrp;
	 	 obj.onblur=LocGrpCheck;
	}
	
	
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
/// tBatNo
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
/// tPhcCat Handler
function PhcLostFocus()
{
	var obj=document.getElementById("tPhcCat");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPhcCatDr");
			if (obj) obj.value=""
			var obj=document.getElementById("tPhcSubCatDr");
			if (obj) obj.value=""
			var obj=document.getElementById("tPhcSubCat");
			if (obj) obj.value=""
		}
	}
}
function PhcOnFocus()
{
	var obj=document.getElementById("tPhcCat");
	if (obj) obj.select()
}
function PhcCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj) obj.value="";
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.value="";
}
///tPhcSubCat Handler
function PhscLostFocus()
{
	var obj=document.getElementById("tPhcSubCat");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPhcSubCatDr");
			if (obj) obj.value=""
		}
	}
}
function PhscOnFocus()
{
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.select();
}
function PhcSubCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
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
	obj=document.getElementById("tBatNo");
	if (obj) obj.value="";
	obj=document.getElementById("tOecprID");
	if (obj) obj.value="";
	obj=document.getElementById("tOecpr");
	if (obj) obj.value="";
	obj=document.getElementById("tItmID");
	if (obj) obj.value="";
	obj=document.getElementById("tItmDesc");
	if (obj) obj.value="";
	obj=document.getElementById("tPrintNo");
	if (obj) obj.value="";
	obj=document.getElementById("tPassAudit");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("PassAuditIndex");
	if (obj) obj.value="0";
	obj=document.getElementById("tSpecStat");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("SpecStatIndex");
	if (obj) obj.value="0";
	ReloadWinow()
}
function FindClick()
{
	if (ChkFindCondition()==false) return;	
	KillTmpBeforeFind();
	//合并条件
	var catdr="";
	var typedr="";
	var objcat=document.getElementById("tPhcSubCatDr");
	if (objcat) var catdr=objcat.value  ;
	var objtype=document.getElementById("tOecType");
	if (objtype)var typedr=objtype.value ;
	
	var objStat=document.getElementById("tTypeStat");
	if (objStat)
	{
		var statflag=0;
		if (objStat.checked)
		{
			statflag=1 ;
		}
	}
	
	var objpst=document.getElementById("tStartDateTime");
	if (objpst)var pst=objpst.value ;
	var objpet=document.getElementById("tEndDateTime");
	if (objpet)var pet=objpet.value ;
	
	var objstr=document.getElementById("tPhcStr");
	objstr.value=catdr+"^"+typedr+"^"+statflag+"^"+pst+"^"+pet
	//	
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
	return true ;
}
function PrintClick()
{
	try
	{
	var ploc="";
	var ward="";
	var sd="";
	var ed="";
	var hospname="";
	var currow;
	var i;
	var j;
	var batno;
	var packs;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATWARDBAT");
	var rowcount=getRowcount(objtbl);
	if (rowcount<=0){
		alert(t['NO_ANY_ROWS'])
		return ;
	}
	var startRow=5;
	var cols=4;
	var pagerows=32;
	var prnpath=getPrnPath();
	var Template=prnpath+"DHCST_PIVA_STATWARDBAT.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	var hospname=getHospName();
	var obj=document.getElementById("tPLoc") ;
	if (obj) ploc=obj.value;
	if(ploc!=""){
		var ploc1=ploc.split("-");
		if(ploc1.length>1){var ploc=ploc1[1]};
	}
	var obj=document.getElementById("tStartDate") ;
	if (obj) sd=obj.value;
	var obj=document.getElementById("tEndDate") ;
	if (obj) ed=obj.value;
	
	var ward="";
	var obj=document.getElementById("tWard") ;
	if (obj) ward=obj.value;
	var ward1=ward.split("-");
	var warddesc=ward1[1];
	var obj=document.getElementById("tStartDate") ;
	if (obj) sd=obj.value;
	var obj=document.getElementById("tEndDate") ;
	if (obj) ed=obj.value;
	var obj=document.getElementById("tBatNo") ;
	if (obj) batno=obj.value;
	var obj=document.getElementById("tOecpr") ;
	if (obj) prio=obj.value;
	var obj=document.getElementById("tPrintNo") ;
	if (obj) printno=obj.value;
	var objst = document.getElementById("tStartDateTime");
	if (objst){	if (objst.value=="") objst.value = "00:00"; }
	if (objst){	var stime=objst.value;  }
	var objet = document.getElementById("tEndDateTime");
	if (objet){	if (objet.value=="") objet.value = "23:59"; }
	if (objet){	var etime=objet.value;  }
	///
	xlsheet.Cells(1,1).Value =hospname+"输液单统计表"

	xlsheet.Cells(2,1).Value ="统计日期:"+(sd)+" "+stime+"至"+(ed)+" "+etime+" "+"打印人:"+session['LOGON.USERNAME']+" 打印日期:"+getPrintDateTime()
	xlsheet.Cells(3,1).Value = "配液科室:"+ploc + " "+"批次:"+batno+"    优先级:"+prio+"    打印单号:"+printno;
	for (i=1;i<=pagerows;i++){
		for (j=1;j<=cols;j++){
			currow=i+startRow-1
			xlsheet.Cells(currow,j).Borders(1).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(2).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(3).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(4).LineStyle = 0;
		}
	}
	var lastward=""
	for (i=1;i<=rowcount;i++){
		currow=i+startRow-1
		var obj=document.getElementById("tbWard"+"z"+i) ;
		if (obj) ward=obj.innerText;
		if(ward!=""){
			var ward1=ward.split("-");
			if(ward1.length>1){var ward=ward1[1]};
		}
		
		var obj=document.getElementById("tbBatNo"+"z"+i) ;
		if (obj) batno=obj.innerText;
		var obj=document.getElementById("tbPacks"+"z"+i) ;
		if (obj) packs=obj.innerText;
		var obj=document.getElementById("tbtype"+"z"+i) ;
		if (obj) type=obj.innerText;

        xlsheet.Cells(currow,1).Value=i;
		xlsheet.Cells(currow,2).Value=ward;
		xlsheet.Cells(currow,3).Value=batno;
		//xlsheet.Cells(currow,3).Value=type;
		xlsheet.Cells(currow,4).Value=packs;

	    if (trim(batno)!="")
		{ 
		  setBottomLine(xlsheet,currow-1,1,4);
		}
		

        if (i==rowcount){ setBottomLine(xlsheet,currow-1,1,4);}
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

///配液分类索引
function setOecType()
{
	var obj=document.getElementById("tOecType");
	if (obj) PInitOecType(obj);
	var objindex=document.getElementById("OecTypeIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
///初始化配液分类
function PInitOecType(listobj)
{
	var obj=document.getElementById("mGetPivaType");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			///初始化配液分类
			if (listobj)
			{
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[i+1]=new Option(type,typeindex);
		    }
			
		}
		
	}
	

}
/// tOecType
function OecTypeSelect()
{
	var obj=document.getElementById("OecTypeIndex");
	if(obj){
		var objpass=document.getElementById("tOecType");
		obj.value=objpass.selectedIndex;
	}
}

/// tLocGrp Handler
function LocGrpCheck()
{
	var obj=document.getElementById("tLocGrp");
	var obj2=document.getElementById("tWardID");
	if (obj) 
	{
		if (obj.value=="")
		{
			obj2.value="";
			EnableFieldByID("mGetComponentID","tWard");
	    } 		
	}
}
function popLocGrp()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tLocGrp_lookuphandler();
	}
}
function LocGrpLookupSelect(str)
{	
	var loc=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj)
	{
		if (loc.length>0)   
		{
			obj.value=loc[1]+"G"
			DisableFieldByID("mGetComponentID","tWard"); 
		}
		else  
		{
			obj.value=""
		} 
	}

}

function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}
function ReloadWinow()
{	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.STATWARDBAT" ;
	location.href=lnk;
}
document.body.onload=BodyLoadHandler;