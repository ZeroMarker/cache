/// DHCST.PIVA.PRINTLABEL
var classcolor=""
function BodyLoadHandler()
{	document.onkeydown = setfcous;

	var obj=document.getElementById("BodyLoaded");
	if (obj)
	{
		if (obj.value!=1){
			setDefaultValByLoc();
			GetRecord()
		}
		else {
			GetAdmsAtLoad();
			GetRecord();
		}
	}
	
	var obj = document.getElementById("tPType");
	if (obj){
		InitPivaType();
	}
	
	var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
	
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) cnt=getRowcount(objtbl);
	try{
	  if (cnt>0) SetTblRowsColorNew(objtbl,2);
	}catch(e){alert(e.message)} 
	var obj=document.getElementById("tPLoc");
	if (obj){
		obj.onkeydown=PLocKeyDown;
		obj.onfocus=PLocOnFocus;
	 	obj.onblur=PLocLostFocus;
	}
	var objcreg = document.getElementById("cByRegNo");
	if (objcreg){
		objcreg.onclick = ChkRegNo;
		//objcreg.checked = false;
	}
	var obj = document.getElementById("cByWard");
	if (obj){
		obj.onclick = ChkWard;
		if (objcreg.checked==false)
		{
			obj.checked = true;
			ChkWard();
		}
		else{
			DisableFieldByID("mGetComponentID","tWard");
		}
	}	
	var obj = document.getElementById("tRegNo");
	if (obj) {
		obj.onblur = RegNoLostFocus;
		obj.onfocus = RegNoOnFocus;
		obj.onkeydown = RegNoKeyDown;
	}
	var obj = document.getElementById("tAdms");
	if (obj){
		obj.onchange = AdmSelect;
	}
	var obj = document.getElementById("tBatNo");
	if (obj) {
		//obj.onblur = BatNoLostFocus;
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	//if (obj) obj.readOnly = true;
	var obj=document.getElementById("tPaInfo");
	if (obj) obj.readOnly=true;
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onkeydown=WardKeyDown;
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
	}
	var obj = document.getElementById("tItmDesc");
	if (obj){
		obj.onblur=ItmLostFocus;
		obj.onfocus=ItmOnFocus;
		obj.onkeydown=ItmKeyDown;
	}
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl){
	    //objtbl.ondblclick=tbDbClick;
    	///objtbl.onmouseup=tbMouseUp;
    }
    
    var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl){
    	objtbl.onkeydown=UpdBatno;
    	objtbl.onmousedown=GetBatno;
    }
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj=document.getElementById("bPrint");
	if (obj) obj.onclick=PrintClick;
	var obj=document.getElementById("bPrintTPN");
	if (obj) obj.onclick=PrintTPNClick;
	var obj=document.getElementById("PogflagY");
	if (obj) obj.onclick=PogflagYClick;
	var obj=document.getElementById("PogflagN");
	if (obj) obj.onclick=PogflagNClick;
	var obj=document.getElementById("IfPlogFlag");
	if (obj) obj.onclick=setPlogFlag;
	var obj=document.getElementById("SumBat")
	if (obj) obj.onclick=OpenParaSetup;
	setBodyLoaded();
	var obj = document.getElementById("tpre");
	if (obj){
		if (obj.value==1){
			obj.value=0;
			//ReFind();
		}
	}
	
	RegNoLostFocus();
}

function InitPivaType()
{
	var objtPType=document.getElementById("tPType");
		if (objtPType){
		objtPType.size=1; 
	 	objtPType.multiple=false;
	 	objtPType.options[1]=new Option("TPN","TPN");
	 	objtPType.options[2]=new Option("HL","HL");
	}
}
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded");
	if (obj) obj.value=1;
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
		var nuraudit=arrset[10];
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
		var objnur = document.getElementById("tNotAudit");
		if (objnur){
			if (objnur.checked==false) objnur.checked=!nuraudit;
		}
	}
}
function GetAdmsAtLoad()
{
	var obj1=document.getElementById("cByRegNo");
  	var obj2=document.getElementById("tRegNo");
  	if ((obj1)&&(obj2)){
	  	if ((obj1.checked==true)&&(obj2.value!="")){
		  	RegNoOnFocus();
		}
  	}
}
function GetRecord()
{
	var obj=document.getElementById("mGetRecord");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var pid="";
	var str="";
	var recordnum=0;
	var pnums=0;
    var obj=document.getElementById("tbPIDz"+1);
	if (obj) pid=obj.value;
	if (pid!=""){
		str=cspRunServerMethod(encmeth,pid);
	}
	var strarr=str.split("^")
	if (strarr.length>1){
		recordnum=strarr[0];
		pnums=strarr[1];
	}
	var obj=document.getElementById("clCnt");
	if (obj){
		obj.innerText="记录数:"+recordnum+" "+"袋数:"+pnums
	}
}

function ChkWard()
{
	var obj = document.getElementById("cByWard");
	if (obj){
		if (obj.checked == true){
			DisableFieldByID("mGetComponentID","tRegNo");
			EnableFieldByID("mGetComponentID","tWard");
			var objcno = document.getElementById("cByRegNo");
			if (objcno) objcno.checked = false;
			var obj = document.getElementById("tWard");
			if (obj) obj.focus();
			ClearRegNo();
		}
		else{
			EnableFieldByID("mGetComponentID","tRegNo");
			DisableFieldByID("mGetComponentID","tWard");
			var obj = document.getElementById("cByRegNo");
			if (obj) obj.checked = true;
			var obj = document.getElementById("tRegNo");
			if (obj) obj.focus();
			ClearWard();
		}
	}
}
function ChkRegNo()
{
	var obj = document.getElementById("cByRegNo");
	if (obj){
		if (obj.checked == true){
			//DisableFieldByID("mGetComponentID","tWard");
			EnableFieldByID("mGetComponentID","tRegNo");
			var obj = document.getElementById("cByWard");
			if (obj) obj.checked = false;
			var obj = document.getElementById("tRegNo");
			if (obj) obj.focus();
			ClearWard();
		}
		else{
			//EnableFieldByID("mGetComponentID","tWard");
			DisableFieldByID("mGetComponentID","tRegNo");
			var obj = document.getElementById("cByWard");
			if (obj) obj.checked = true;
			//var obj = document.getElementById("tWard");
			//if (obj) obj.focus();
			ClearRegNo();
		}
	}
}
function ClearWard()
{
	var objward = document.getElementById("tWard");
	if (objward) objward.value = "";
	var objwardid = document.getElementById("tWardID");
	if (objwardid) objwardid.value = "";
}
function ClearRegNo()
{
	var objno = document.getElementById("tRegNo");
	if (objno) objno.value = "";
	ClearAdm();
}
function ClearAdm()
{
	var objadm = document.getElementById("tAdmID");
	if (objadm) objadm.value = "";
	var obj=document.getElementById("tPaInfo");
	if (obj) obj.value="";
	var obj=document.getElementById("tAdms");
	if (obj) obj.options.length=0;
}
/// tPLoc
function PLocKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		window.event.isLookup=true;
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
/// tWardID
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
		window.event.isLookup=true;
		tWard_lookuphandler();
	}
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value == ""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value = ""
		}
	}
}
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}
/// tItmDesc
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
	  	//tItmDesc_lookuphandler();
	  	window.event.isLookup=true;
	  	tItmDesc_lookuphandler(window.event);  ///bianshuai 2015-12-02 修改 IE11无法弹出放大镜 
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
	  	//tBatNo_lookuphandler();
	  	window.event.isLookup=true;
	  	tBatNo_lookuphandler(window.event);  ///bianshuai 2015-12-02 修改 IE11无法弹出放大镜 
	}
}
function BatNoLostFocus()
{

}
/// adm
function AdmSelect()
{
	var obj=document.getElementById("cByRegNo");
	if (obj){
		if(obj.checked==true){
			var objadm=document.getElementById("tAdms");
			if(objadm){
				if (objadm.options.selectedIndex>=0) var Adm=objadm.value;
			}
		}
	}
	else
		{var Adm=""}
	var obj=document.getElementById("tAdmID");
	if (obj) obj.value=Adm;
}
function RegNoKeyDown()
{
	var key=websys_getKey();
	if (key==13)
	{
		RegNoLostFocus();
		var obj=document.getElementById("tAdms");
		if(obj) obj.focus();
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
	ClearAdm();
	if (regno == ""){
		return;
	}
	else{
		regno=getRegNo(regno);
		objregno.value=regno
	}
	/// set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa',regno)=='') {}
	/// Adm
    var getadm=document.getElementById('mGetAdm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetAdm',regno)=='') {}
	
}
/// set patient info of compoment
function SetPa(value)
{
	var painfo=value.split("^")	;
	var obj=document.getElementById("tPaInfo");
	if (obj){
		if (painfo.length >0){
			obj.value=painfo[0]+" -- " +painfo[1] + " -- " +painfo[2] ;
		}
	 	else{
		 	alert(t['INVALID_REGNO']) ;
	 	 	return ;
	 	}
	}
}
function SetAdm(value)
{
	if (value=="") return;
	var ss=value.split("^");
	if (ss.length<1) return;
	var obj=document.getElementById("tAdms");
	var i;
	var xx ;
	var info;
	
	obj.size=1; 
	obj.multiple=false;
	
	for (i=0;i<ss.length;i++)
	{
		xx=ss[i] ;
		info=xx.split("&") ;
		if (obj){
			obj.options[i]=new Option (info[1],info[0]) ;
			}
		}
	if (obj.options.length>0){
		obj.options.selectedIndex=0;
		var objadm=document.getElementById("tAdmID");
		if (objadm) objadm.value=obj.value;
		
	}
}

function Clear()
{
	var obj;
	KillTmpBeforeFind();
	setDefaultValByLoc();
	ClearWard();
	ClearRegNo();
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
	obj=document.getElementById("tNoQty");
	if (obj) obj.checked=false;
	/// obj=document.getElementById("tNotAudit");
	/// if (obj) obj.checked=false;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
	if (objtbl) DelAllRows(objtbl);
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0"+" "+"袋数:0";
}
/// 双击
function tbDbClick()
{
	var cnt=0;
	var pogflag=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var moeori=document.getElementById("tbMOeoriz"+row).value;
 	var grp=document.getElementById("tbGrpNoz"+row).value;
 	if ((moeori=="")||(grp=="")) return;
	var flag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		var rmoeori=document.getElementById("tbMOeoriz"+i).value;
		var rgrp=document.getElementById("tbMOeoriz"+i).value;
		if ((rmoeori==moeori)&&(rgrp==grp)){
			objrow.className="clsRowSelected"
			pogflag=1
		}
		if (((rmoeori!=moeori)||(rgrp!=grp))&&(pogflag==1)) break;
	}
	var loc=document.getElementById("tPLocID").value
	var batno=document.getElementById("tbBatNoz"+row).innerText;
	//var odate=document.getElementById("tbOexeDatez"+row).innerText;
	var bed=document.getElementById("tbBedNoz"+row).innerText;
	//var linko=document.getElementById("tbSeqNoz"+row).innerText;
	//var markstr=odate+" "+bed+" "+linko
	var markstr=bed
	/// 打开窗口修改批次
	var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.UPDBAT&LocID="+loc+"&Moeori="+moeori+"&GrpNo="+grp+"&CurBat="+batno+"&Smark="+markstr
	//window.open(link,"_TARGET","height=170,width=450,menubar=no,status=yes,toolbar=no")
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.UPDBAT&LocID='+loc+"&Moeori="+moeori+"&GrpNo="+grp+"&CurBat="+batno+"&Smark="+markstr,'','dialogHeight:180px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
    if (resondr!="") FindClick();
	
}
/*
function tbMouseUp()
{
	var cnt=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var objrow=objtbl.rows[1];
	if (objrow){
		if (objrow.className=="clsRowSelected"){
			ResetRowClass(objtbl);
			SetTblRowsColor(objtbl);
		}
	}
}*/
/// 统计配液
function FindClick()
{
	if (ChkFindCondition()==false) return;
	ReFind();
}
function ReFind()
{
	KillTmpBeforeFind();
    GetDocuDate();
  	bFind_click();
}

function GetDocuDate()
{
	var docu=parent.frames['DHCST.PIVA.PREPRINT'].document
	if (docu){
		var sd=docu.getElementById("tStartDate").value;
		var ed=docu.getElementById("tEndDate").value;
	}
	
	var stobj=document.getElementById("tStartDate");
	if (stobj){
		stobj.value=sd;
	}
	var edobj=document.getElementById("tEndDate");
	if (edobj){
		edobj.value=ed;
	}
	
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
   	objbyadm=document.getElementById("cByRegNo");
	if (objbyadm){
		if (objbyadm.checked==true){
			var objadm=document.getElementById("tAdmID");
			if (objadm.value==""){
				alert(t['NO_REGNO']);
				return false;
			}
		}
	}
  	objbyward=document.getElementById("cByWard");
	if (objbyward){
		if (objbyward.checked==true){
			var objbyward=document.getElementById("tWardID");
			if (objbyward.value==""){
				alert(t['NO_WARD']);
				return false;
			}
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
function KillTmpAfterSave(pid)
{
	var objktmp=document.getElementById("mKTmpAfterSave");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	cspRunServerMethod(encmeth,pid);
}
function KillTmpBeforeFind()
{
	var pid="";
	var obj=document.getElementById("tbPIDz"+1);
    if (obj) pid=obj.value;
    if (pid>0) KillTmpAfterSave(pid);
}

function PrintTPNClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) var cnt=getRowcount(objtbl) ;
    if (cnt==0){
	    alert(t['NO_ANY_ROWS']);
	    return;
    }
    var pid=""
    var obj=document.getElementById("tbPIDz"+1);
	if (obj) pid=obj.value;
	if (pid==""){
		alert(t['NO_PID']);
		return;
	}
	if (confirm(t['CONFIRM_PRINT'])==false) return;
	/// 1 save data
	var PhacRowid=CspRunSaveDisp(pid);
	if (PhacRowid<0){
		alert(t['SAVE_FAILED']+PhacRowid);
		return;
	}
	/// KillTmpAfterSave(pid);
	/// 2 print data
	if (PhacRowid>0){
		var ret=PrintHTPN(PhacRowid); /// 打印首页
		if(ret==false) return;
		var pid=PrintLabelDetailTPN(PhacRowid);	/// 打印明细标签
		KillTmpPrint(pid);
	}
	ReFind();
}






/// 打印标签1:保存 DHC_PHACollected?PIVA_OrdGrp? PIVA_OrdGrpItm?PIVA_OrdGrpState?2?打签
function PrintClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) var cnt=getRowcount(objtbl) ;
    if (cnt==0){
	    alert(t['NO_ANY_ROWS']);
	    return;
    }
    var pid=""
    var obj=document.getElementById("tbPIDz"+1);
	if (obj) pid=obj.value;
	if (pid==""){
		alert(t['NO_PID']);
		return;
	}
	//if (confirm(t['CONFIRM_PRINT'])==false) return;
	if (confirm("确认要打印吗?")==false) return;
	/// 1 save data
	var PhacRowid=CspRunSaveDisp(pid);
	//alert(PhacRowid)
	if (PhacRowid<0){
		alert(t['SAVE_FAILED']+PhacRowid);
		return;
	}
	/// KillTmpAfterSave(pid);
	/// 2 print data
	if (PhacRowid>0){
		var ret=PrintH(PhacRowid); /// 打印首页
		if(ret==false) return;
		var pid=PrintLabelDetail(PhacRowid);	/// 打印明细标签
		KillTmpPrint(pid);
	}
	ReFind();
}

function CspRunSaveDisp(pid)
{
	var obj=document.getElementById("mSaveDisp");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid);
	return result;
}
function CspRunGetPrintH(phac)
{
	var obj=document.getElementById("mGetPrintHData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phac);
	return result;
}
/// 某配液单的所有批次种类及其数量
function CspRunGetPhBatList(phac)
{
	var obj=document.getElementById("mGetPhBatList");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phac);
	return result;
}
/// 打印首页
function PrintH(phac)
{
	var strh=CspRunGetPrintH(phac)
	if (strh==""){
		alert(t['PRINTH_ERR']);
		return false;
	}
	var strb=CspRunGetPhBatList(phac);
	if (strb==""){
		alert(t['PRINT_BATERR']);
		return false;
	}
	var Bar= new ActiveXObject("DHCSTPrint.PIVALabel");
	//Device?InDateTime?PatWard?PrintNo?InUserName? HeadType?HeadBat1?HeadBat2????HeadBat9?HeadBatSum
	//PageWidth,PageHeight,PageLeftMargine,PageTopMargine,HeadFontSize
	//ploc_"^"_ward_"^"_user_"^"_pdate_"^"_ptime_"^"_pno
	Bar.Device="PIVA";
	Bar.PageWidth=65;
	Bar.PageHeight=90;
	Bar.HeadFontSize=12;
	Bar.HPageStr=strh;
	Bar.HeadType="";
	Bar.HeadBatStr=strb;
	Bar.PageLeftMargine=1;
	Bar.PrintHPage();
}
/// 打印明细
function PrintLabelDetail(phac)
{
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
    var obj=document.getElementById("mGetPrintItm");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var retstr=cspRunServerMethod(encmeth,phac);
    if (retstr=="") return;
    var vstr=retstr.split("^")
    if (vstr.length<1) return;
    var pid=vstr[0]
    var pognums=vstr[1]
    if (pognums==0) return;
    if (pid=="") return;
    var i,j;
    var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
    for (i=1;i<=pognums;i++){
	    var pogstr=cspRunListPog(pid,i)
	    if (pogstr=="") return;
	    var pogistr=cspRunListPogItm(pid,i)
	    if (pogistr=="") return;
	    Bar.Device="PIVA";
	    Bar.PageWidth=65;
		Bar.PageHeight=90;
		Bar.HeadFontSize=12;
		Bar.FontSize=10;
		Bar.Title=Hospname+"输液单";
		Bar.HeadType="";
		Bar.IfPrintBar="false";
		Bar.BarFontSize=25;
		Bar.BarTop=63;
		Bar.BarLeftMarg=5;
		Bar.PageSpaceItm=2;
		Bar.ItmFontSize=10;
		Bar.ItmCharNums=26; //药名每行显示的字符数
		Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
		Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
		//alert(pogstr)
		Bar.PageItmStr=pogistr;	// 打印标签药品信息
		Bar.PageLeftMargine=1;
		Bar.PageSpace = 1;
		Bar.BarWidth=24;
		Bar.BarHeight=8;
		//Bar.PageSpace = 1;
		Bar.PrintDPage();
    }
    return pid;
 }
/// 打印首页
function PrintHTPN(phac)
{
	var strh=CspRunGetPrintH(phac)
	if (strh==""){
		alert(t['PRINTH_ERR']);
		return false;
	}
	var strb=CspRunGetPhBatList(phac);
	if (strb==""){
		alert(t['PRINT_BATERR']);
		return false;
	}
	var Bar= new ActiveXObject("DHCSTPrintTPN.PIVATPNLabel");
	//Device?InDateTime?PatWard?PrintNo?InUserName? HeadType?HeadBat1?HeadBat2????HeadBat9?HeadBatSum
	//PageWidth,PageHeight,PageLeftMargine,PageTopMargine,HeadFontSize
	//ploc_"^"_ward_"^"_user_"^"_pdate_"^"_ptime_"^"_pno
	Bar.Device="PIVATPN";
	Bar.PageWidth=100;
	Bar.PageHeight=190;
	Bar.HeadFontSize=12;
	Bar.HPageStr=strh;
	Bar.HeadType="";
	Bar.HeadBatStr=strb;
	Bar.PageLeftMargine=1;
	Bar.PrintHPage();
}
/// 打印明细
function PrintLabelDetailTPN(phac)
{
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
    var obj=document.getElementById("mGetPrintItm");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var retstr=cspRunServerMethod(encmeth,phac);
    if (retstr=="") return;
    var vstr=retstr.split("^")
    if (vstr.length<1) return;
    var pid=vstr[0]
    var pognums=vstr[1]
    if (pognums==0) return;
    if (pid=="") return;
    var i,j;
    var Bar=new ActiveXObject("DHCSTPrintTPN.PIVATPNLabel");
    for (i=1;i<=pognums;i++){
	    var pogstr=cspRunListPog(pid,i)
	    if (pogstr=="") return;
	    var pogistr=cspRunListPogItm(pid,i)
	    if (pogistr=="") return;
	    Bar.Device="PIVATPN";
	    Bar.PageWidth=130;
		Bar.PageHeight=160;
		Bar.HeadFontSize=12;
		Bar.FontSize=10;
		Bar.Title=Hospname+"输液单";
		Bar.HeadType="";
		Bar.IfPrintBar="true";
		Bar.BarFontSize=25;
		Bar.BarTop=140;
		Bar.BarLeftMarg=5;
		Bar.PageSpaceItm=2;
		Bar.ItmFontSize=10;
		Bar.ItmCharNums=26; //药名每行显示的字符数
		Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
		Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
		Bar.PageItmStr=pogistr;	// 打印标签药品信息
		Bar.PageLeftMargine=1;
		Bar.PageSpace = 1;
		Bar.BarWidth=24;
		Bar.BarHeight=8;
		//Bar.PageSpace = 1;
		Bar.PrintDPage();
    }
    return pid;
 }

function cspRunListPog(pid,li)
{
	var obj=document.getElementById("mListPrintPog");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var str=cspRunServerMethod(encmeth,pid,li);
    return str;
}
function cspRunListPogItm(pid,li)
{
	var obj=document.getElementById("mListPrintPogItm");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var str=cspRunServerMethod(encmeth,pid,li);
    return str;
}
function KillTmpPrint(pid)
{
	var objktmp=document.getElementById("mKTmpPrint");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var PhacRowid=cspRunServerMethod(encmeth,pid);
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
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
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


function UpdBatno(e)
{
  if (window.event.keyCode!=13) {return;}
  
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")
  if (ss.length>0)	  
	   {
		    if (ss[0]=="tbBatNo")
			 {
					var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
				 	//var moeori=document.getElementById("tbMOeoriz"+row).value;
				 	var moeori=document.getElementById("tbMdodisz"+row).value;
				 	var grp=document.getElementById("tbGrpNoz"+row).value;
				 	if ((moeori=="")||(grp=="")) return;
				 	var ploc=document.getElementById("tPLocID").value
					var batnoobj=document.getElementById("tbBatNoz"+row);
					var batno=batnoobj.value
					var dsp=document.getElementById("tbDSPz"+row).value;
		
				 	obj=document.getElementById("mUpdBat");
					if (obj) {var encmeth=obj.value;}  else {var encmeth='';}
					var ret=cspRunServerMethod(encmeth,moeori,grp,trim(batno),ploc,dsp);
					if (ret<0) {document.getElementById("tbBatNoz"+row).value=Currbat;}
					if (ret==-6) {alert("更新失败,选择主医嘱后再重试...");return;}
					if (ret!=0) {alert("更新失败");return;}
					if (ret==0){alert("更新成功!")}
					for (i=row+1;i<=cnt;i++)
					 {
						//var rmoeori=document.getElementById("tbMOeoriz"+i).value;
						var rmoeori=document.getElementById("tbMdodisz"+i).value; 
						var rgrp=document.getElementById("tbGrpNoz"+i).value;
						
						if ((rmoeori==moeori)&&(rgrp==grp))
						{
							var rbatnoobj=document.getElementById("tbBatNoz"+i);
							if (rbatnoobj) rbatnoobj.value=trim(batno);
						}
						else
						{
							return;
						}
					 }
					 

			 }
	   }

}

function GetBatno(e)
{

  //if (window.event.keyCode!=13) {return;}
  
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="tbBatNo")
			 { 

					var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
					var batno=document.getElementById("tbBatNoz"+row).value;

                    Currbat=batno;
                    //alert(Currbat)
			 }
	   }
}

///初始化配液分类
function GetAdmData()
{
	var obj=document.getElementById("mGetAdmData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,regno);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			if (listobj)
			{
				
				listobj.size=1; 
			 	listobj.multiple=false;
			 	listobj.options[i+1]=new Option(type,typeindex);
		    }
			
		}
		
	}
	

}
/// 选择行
function SelectRowHandler() 
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;
	//changeBGC(selectrow);
	var obj=document.getElementById("tbBatNoz"+selectrow);
	recordobj=obj;
	if(obj) obj.select();
}

///// 键盘上下键控制光标移动    add by ysj 20150617
function setfcous(tep)
{
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) var cnt=getRowcount(objtbl) ;
    if ((event.keyCode!=38)&&(event.keyCode!=40)) {return;} //限制死循环yunhaibao20160304
	if(event.keyCode==38) tep=-1;
	if(event.keyCode==40) tep=1;
	if ((selectrow==1)&&(event.keyCode==38)){return} //第一行不能再向上
	if ((selectrow==cnt)&&(event.keyCode==40)){return} 
	var nextrow=selectrow+tep;
	var obj=document.getElementById("tbBatNoz"+nextrow);
	if(obj) {recordobj=obj;}
	if(obj)
	{ 
		obj.focus();
		obj.select();
		//changeBGC(nextrow);
		selectrow=nextrow;
	}
	if (obj==null) {
		if (nextrow==cnt){
			tep=-1
		}
		selectrow=selectrow+tep
		setfcous(tep);}
	//if(obj&&(!obj.value)) setfcous(tep);
} 
function setselect()
{
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL")
	if (objtbl)
	{ 
	     var cnt=objtbl.rows.length-1;
	     for (var i=1;i<=cnt; i++)
	          {	     
	          var eSrc=objtbl.rows[i];
		      var RowObj=getRow(eSrc);
		      if (RowObj){
			             var obj=document.getElementById("tbBatNoz"+i)
			      		 if(obj)  obj.onfocus=PrecordFocus;
		      			}
		      	}
	}
}
function PrecordFocus()
{
	if (recordobj) recordobj.select();

}
/// 改变选中行的背景色            add by ysj 20150617
function changeBGC(row)
{
	var obj=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
	var rows=obj.getElementsByTagName("tr");
	var color=rows[row].style.backgroundColor;
	alert(rows[row].getHexBgColor())
	classcolor=color;
	rows[row].style.background="#8EB9F5";
}

function PogflagYClick()
{
	var plogflag="P";
	UpdatePogFalg(plogflag);
}

function PogflagNClick()
{
	var plogflag="N";
	UpdatePogFalg(plogflag);
}

function UpdatePogFalg(plogflag)
{
	var cnt=0,i,exe;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) var cnt=getRowcount(objtbl) ;
    if (cnt==0){
	    alert(t['NO_ANY_ROWS']);
	    return;
    }
 	var obj=document.getElementById("mSetPogFlag");
 	if (obj) exe=obj.value;
 	else exe="";
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objx=document.getElementById("tbDSP"+"z"+i);
			if (objx) tbDSPId=objx.value ;
    		var ret=cspRunServerMethod(exe,tbDSPId,plogflag);
    		if (ret!=="0")
   			{
	   			if (ret=="3"){
		   			alert("第"+i+"行,打包状态为护士打包,"+"不允许再次修改打包状态!");
		   		}
	   			else if (ret=="4"){
		   			alert("第"+i+"行,打包状态为二次打包,"+"不允许再次修改打包状态!");
		   		}
	   			else{
	   				alert("修改正常打包状态失败！"+ret);
	   			}
	   		}
   		}
 	}
 	FindClick();
}
function setPlogFlag(){
	var obj=document.getElementById("IfPlogFlag");
	if (obj.checked){
		obj.value=1
	}else{
		obj.value=0
	}
}
function OpenParaSetup()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PRINTLABELCOUT"
    window.open(lnk,"","height=300,width=400,top=300,left=900,toolbar=false,menubar=false,location=false,status=false") ;
   }
   
function selectClick(){
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PRINTLABEL");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("selectz"+row);
 	var mdodis=document.getElementById("tbMdodisz"+row).value;
	if (cell){
		if (cell.checked==false) {setvalue=false;}
		else {setvalue=true;}
	}
	var mdodisflag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var objmdodis=document.getElementById("tbMdodisz"+i)
		if (objmdodis) mdodisid=objmdodis.value;
		if (mdodisid==mdodis){
			var objsel=document.getElementById("selectz"+i);
			objsel.checked=setvalue;
			mdodisflag=1
		}
		if ((mdodisid!=mdodis)&&(mdodisflag==1)) break;
	}
}
document.body.onload=BodyLoadHandler;
