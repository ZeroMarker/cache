/// DHCST.PIVA.QUERY
/// 配液综合查询列表
var rcnumber=70;
function BodyLoadHandler()
{     
  	InitForm();       
  	SetObjHandler();
	SetTblColor();
}
function InitForm()
{     
	//setDefaultValByLoc();       
	//setPassAudit();
	//setSpecStat();       
	//setDlabPrint();
	GetRecord();
	HiddenItem()
	
	var objtbl=document.getElementById("tDHCST_PIVA_QUERY");
    if (objtbl){
    	objtbl.onkeydown=UpdBatno;
    	objtbl.onmousedown=GetBatno;
    }
	
}
function setDefaultValByLoc()
{
	var locid = "";
	var docu=parent.frames['DHCST.PIVA.QUERY1'].document
    if (docu){
	    	var objlocid = docu.getElementById("tPLocID");
			if (objlocid) locid = objlocid.value;
			if (locid == "") return;
			
			var objPloc = document.getElementById("tPLocID");
			if (objPloc) objPloc.value=locid ;
    }

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
		var objsdo = document.getElementById("tCPrintStartDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tCPrintEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = stdate;
		}
		var objst = document.getElementById("tCPrintStartTime");
		if (objst){
			if (objst.value=="") objst.value = "00:00";
		}
		var objet = document.getElementById("tCPrintEndTime");
		if (objet){
			if (objet.value=="") objet.value = "23:59";
		}

	}
}
/// /// tDlabPrint
function setDlabPrint()
{
	var listobj=document.getElementById("tDlabPrint");
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("是","1");
	 	listobj.options[2]=new Option("否","0");
	}
	var objindex=document.getElementById("tDlabPrintIndex");
	if (objindex) listobj.selectedIndex=objindex.value;
}
function DlabPrintSelect()
{
	var objindex=document.getElementById("tDlabPrintIndex");
	if(objindex){
		var obj=document.getElementById("tDlabPrint");
		objindex.value=obj.selectedIndex;
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
	
	if (objindex.value!="")
	{
	    if (objindex) obj.selectedIndex=objindex.value;
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
function SetTblColor()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt>0){
		/*for (var i=1;i<objtbl.rows.length; i++) {
			var cell=document.getElementById("tbSelectz"+i);
			if (cell){cell.onclick=tbSelectClick;}
    	}*/
    	SetTblRowsColorNew(objtbl,2);
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
	var listobj=document.getElementById("tDlabPrint");
	if (listobj) {
		listobj.onclick=DlabPrintSelect;
	}
	var listobj=document.getElementById("tSpecStat");
	if (listobj) {
		listobj.onclick=SpecSelect;
	}	
	//var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    //if (objtbl) objtbl.ondblclick=tbDbClick;
	var objtbl=document.getElementById("cSelectAll");
	if (objtbl) objtbl.onclick = SelectClick;
	//var objtbl=document.getElementById("cClearAll");
	//if (objtbl) objtbl.onclick = ClearAll;
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bRePrintLabel");
	if (obj) obj.onclick=RePrintLab;
	//if (obj) obj.onclick=PrintDetaill;
	//if (obj) obj.onclick=PrintPresc;
	//
	var obj=document.getElementById("bRePrintTPNLabel");
	if (obj) obj.onclick=RePrintTPNLab;
	
	var obj=document.getElementById("bPrintDTPNLabel");
	if (obj) obj.onclick=PrintTPNDLab;
	
	var obj=document.getElementById("bPrintDLabel");
	if (obj) obj.onclick=PrintDLab;
	
	var obj=document.getElementById("bPrintPresc");
	if (obj) obj.onclick=PrintPresc;
	
	var obj=document.getElementById("bDOrderPrint");
	if (obj) obj.onclick=PrintDOrder;

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
	obj=document.getElementById("tState");
	if (obj) obj.value="";
	obj=document.getElementById("tPassAudit");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("tSpecStat");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("tDlabPrint");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0"+" "+"袋数:0";
}
function FindClick()
{
	ReFind();
}
function ReFind()
{
 	bFind_click();
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


/// 重打签TPN
function RePrintTPNLab()
{
	if (!confirm(t['CONFIRM_REPRINT'])) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			if (pog!=ppog){
				ppog=pog;
				ret=CspRunSavePogState(ppog);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintTPNLabel(ppog,"补");
				if (ret==false) {return;}
			}
		}
	}
	ReFind();
}

/// 打印TPN标签
function PrintTPNLabel(pog,stype)
{
	var Bar=new ActiveXObject("DHCSTPrintTPN.PIVATPNLabel");
	if (!Bar) return false;
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
    alert(Hospname)
	var pogstr=CspRunGetPogPrintM(pog)
	if (pogstr==""){
		alert(t['ERR_GETPRINTM']);
		return false;
	}
	var pogistr=CspRunGetPogPrintI(pog)
	if (pogistr==""){
		alert(t['ERR_GETPRINTI']);
		return false;
	}
	Bar.Device="PIVATPN";
	Bar.PageWidth=130;
	Bar.PageHeight=160;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	Bar.Title=Hospname+"输液单";
	Bar.HeadType=stype;
	Bar.IfPrintBar="false";
	Bar.BarFontSize=25;
	Bar.BarTop=140;
	Bar.BarLeftMarg=5;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=10;
	Bar.ItmCharNums=30; //药名每行显示的字符数
	Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
	Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
	Bar.PageItmStr=pogistr;	// 打印标签药品信息
	Bar.PageLeftMargine=1;
	Bar.PageSpace = 1;
	Bar.BarWidth=24;
	Bar.BarHeight=8;
	Bar.PrintDPage();
	return true;
}


//---------------------------------------------------------


/// 重打签
function RePrintLab()
{
	if (!confirm(t['CONFIRM_REPRINT'])) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			if (pog!=ppog){
				ppog=pog;
				ret=CspRunSavePogState(ppog);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintLabel(ppog,"补");
				if (ret==false) {return;}
			}
		}
	}
	//ReFind();
	
}
/// 重打标签时检查如果是复核不通过的需更新配液状态
function CspRunSavePogState(pog)
{
	var obj=document.getElementById("mSavePogState");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pog);
	return ret;
}


/// 打印TPN停止标签
function PrintTPNDLab()
{
	if (!confirm(t['CONFIRM_PRINTD'])) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var pcp=CspRunInsCprint();
	
	if (pcp<0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			var oest=document.getElementById("tbOeStatusz"+i).innerText;
			var spest=document.getElementById("tbSpecStatz"+i).innerText;
			var pogst=document.getElementById("tbStatez"+i).innerText;
			var cprintno=trim(document.getElementById("tbCPrintNoz"+i).innerText);
			
			if (((oest=="停止")||(spest!="N"))&&(pog!=ppog)&&(cprintno=="")&&(pogst!="复核")){
				ppog=pog;
				/// 更新配液医嘱组主表取消打印信息
				num=num+1;
				ret=CspRunSavePogCprint(ppog,pcp,num);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintTPNLabel(ppog,"")
				if (ret==false) {return;}
			}
		}
	}
	if (num>0){
		//var ret=PrintTPNH(pcp); /// 打印首页
	}
	//if(ret==false) return;
	ReFind();
}



/// 打印停止标签
function PrintDLab()
{
	if (!confirm(t['CONFIRM_PRINTD'])) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var pcp=CspRunInsCprint();
	if (pcp<0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			var oest=document.getElementById("tbOeStatusz"+i).innerText;
			var spest=document.getElementById("tbSpecStatz"+i).innerText;
			var pogst=document.getElementById("tbStatez"+i).innerText;
			var cprintno=trim(document.getElementById("tbCPrintNoz"+i).innerText);
			if (((oest=="停止")||(spest!="N"))&&(pog!=ppog)&&(cprintno=="")&&(pogst!="复核")){
				ppog=pog;
				/// 更新配液医嘱组主表取消打印信息
				num=num+1;
				ret=CspRunSavePogCprint(ppog,pcp,num);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				var ret=PrintLabel(ppog,"")
				if (ret==false) {return;}
			}
		}
	}
	if (num>0){
		//var ret=PrintH(pcp); /// 打印首页
	}
	//if(ret==false) return;
	ReFind();
}
/// 打印标签
function PrintLabel(pog,stype)
{
	var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
	//var Bar=new ActiveXObject("blpvscci.ConfectCharge");
	//if (!Bar) alert(1)
	//var aa=Bar.ConfectCharge("2-219-56","1","","");
	if (!Bar) return false;
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
	var pogstr=CspRunGetPogPrintM(pog)
	if (pogstr==""){
		alert(t['ERR_GETPRINTM']);
		return false;
	}
	var pogistr=CspRunGetPogPrintI(pog)
	if (pogistr==""){
		alert(t['ERR_GETPRINTI']);
		return false;
	}
	Bar.Device="PIVA";
	Bar.PageWidth=65;
	Bar.PageHeight=90;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	Bar.Title=Hospname+"输液单";
	Bar.HeadType=stype;
	Bar.IfPrintBar="true";
	Bar.BarFontSize=25;
	Bar.BarTop=63;
	Bar.BarLeftMarg=5;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=10;
	Bar.ItmCharNums=30; //药名每行显示的字符数
	Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
	Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
	Bar.PageItmStr=pogistr;	// 打印标签药品信息
	Bar.PageLeftMargine=1;
	Bar.PageSpace = 1;
	Bar.BarWidth=24;
	Bar.BarHeight=8;
	Bar.PrintDPage();
	return true;
}
/// 打印首页
function PrintH(pcp)
{
	var strh=CspRunGetPrintH(pcp)
	if (strh==""){
		alert(t['PRINTH_ERR']);
		return false;
	}
	var strb=CspRunGetPhBatList(pcp);
	if (strb==""){
		alert(t['PRINT_BATERR']);
		return false;
	}
	var Loc="";
	var Ward="";
	var objward = document.getElementById("tWard");
	if (objward) Ward=objward.value;
	var objloc = document.getElementById("tPLoc");
	if (objloc) Loc=objloc.value;
	strh=Loc+"^"+Ward+"^"+strh;
	var Bar= new ActiveXObject("DHCSTPrint.PIVALabel");
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

/// 打印TPN首页
function PrintTPNH(pcp)
{
	var strh=CspRunGetPrintH(pcp)
	if (strh==""){
		alert(t['PRINTH_ERR']);
		return false;
	}
	var strb=CspRunGetPhBatList(pcp);
	if (strb==""){
		alert(t['PRINT_BATERR']);
		return false;
	}
	var Loc="";
	var Ward="";
	var objward = document.getElementById("tWard");
	if (objward) Ward=objward.value;
	var objloc = document.getElementById("tPLoc");
	if (objloc) Loc=objloc.value;
	strh=Loc+"^"+Ward+"^"+strh;
	var Bar= new ActiveXObject("DHCSTPrintTPN.PIVATPNLabel");
	Bar.Device="PIVATPN";
	Bar.PageWidth=100;
	Bar.PageHeight=180;
	Bar.HeadFontSize=12;
	Bar.HPageStr=strh;
	Bar.HeadType="";
	Bar.HeadBatStr=strb;
	Bar.PageLeftMargine=1;
	Bar.PrintHPage();
}



function CspRunGetPrintH(pcp)
{
	var obj=document.getElementById("mGetPrintHData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pcp);
	return result;
}
/// 某配液单的所有批次种类及其数量
function CspRunGetPhBatList(pcp)
{
	var obj=document.getElementById("mGetPhBatList");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pcp);
	return result;
}
/// 插入取消打印表
function CspRunInsCprint()
{
	var objktmp=document.getElementById("mInsCPrint");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var pcp=cspRunServerMethod(encmeth);
	return pcp;
}
/// 取消打印时更新配液医嘱组主表
function CspRunSavePogCprint(pog,pcpdr,number)
{
	var objktmp=document.getElementById("mSavePogCprint");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pog,pcpdr,number);
	return ret;
}
/// 取打印主信息
function CspRunGetPogPrintM(pog)
{
	var objktmp=document.getElementById("mGetPrintPog");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,pog);
	return str;
}
/// 取打印明细信息字符串
function CspRunGetPogPrintI(pog)
{
	var objktmp=document.getElementById("mGetPrintPogItm");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,pog);
	return str;
}
/// cSelectAll
function SelectClick()
{
	var obj=document.getElementById("cSelectAll");
    if (obj){
	    if (obj.checked==true){SelectAll();}
	    else {ClearAll();}
    }
}
/// 选择所有行
function SelectAll()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell) cell.checked=true;
	}
}
/// 清除所有行
function ClearAll()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell) cell.checked=false;
	}
}
/// 选择或者清除行
function tbSelectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("tbSelectz"+row);
 	var pog=document.getElementById("tbPogIDz"+row).value;
	if (cell){
		if (cell.checked==false) {setvalue=false;}
		else {setvalue=true;}
	}
	var pogflag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var objpog=document.getElementById("tbPogIDz"+i)
		if (objpog) pogid=objpog.value;
		if (pogid==pog){
			var objsel=document.getElementById("tbSelectz"+i);
			objsel.checked=setvalue;
			pogflag=1
		}
		if ((pogid!=pog)&&(pogflag==1)) break;
	}
}
function bartest()
{
    // retstr=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_dt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex_"^"_stype
    // pogistr=pogistr_"||"_incidesc_"^"_dosage_"^"_spec
    var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
    var pogstr = "1^100||1^1^PEYQHL-普儿一区护理^P080501001^2^1^CP080502001^1^长期医嘱^Bid^静脉滴注^2008-5-01 10:00^100ml^5^2^加加19床^张三一二^12345678^28^男^";
    var pogistr = "葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖葡萄糖^100ml^100ml/瓶^||氯化钾^5ml^5ml/支^1||氯化钾^5ml^5ml/支^||氯化钾^5ml^5ml/支^";
    Bar.Device = "tiaoma";
    Bar.PageWidth = 75;
    Bar.PageHeight = 90;
    Bar.HeadFontSize = 12;
    Bar.FontSize = 10;
    Bar.Title = "北京地坛医院输液单";
    Bar.HeadType = "补";
    Bar.IfPrintBar = "True";
    Bar.BarTop = 60;
    Bar.ItmCharNums = 20;
    Bar.ItmOmit = "False";
    Bar.PageMainStr = pogstr;
    Bar.PageItmStr = pogistr;
    Bar.PageSpace = 1;
    Bar.PrintDPage();
}


/// 打印处方
function PrintPrescOld()
{
	if (!confirm(t['CONFIRM_PRINTD'])) {return;}
	var cnt=0;
	var ppog="";
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++)
	    {
		    var cell=document.getElementById("tbSelectz"+i)
		    if ((cell.checked==true))
		    { 
			    var gProcessID=document.getElementById("tbPIDz"+i).value;
				var pog=document.getElementById("tbPogIDz"+i).value;
				if (ppog!=pog)
				{
                        ppog=pog;
						var gDetailCnt=getDispDetail(pog,gProcessID) ; // 获取记录数
						var gPrnpath=getPrnPath();
						if (gPrnpath=="") 
						{
							  alert(t["CANNOT_FIND_TEM"]) ;
							  return ;                
					    }
						var Template=gPrnpath+"DHCST_PIVA_PRTPRESC.xls";
						var xlApp = new ActiveXObject("Excel.Application");
						var xlBook = xlApp.Workbooks.Add(Template);
						var xlsheet = xlBook.ActiveSheet ;
					     //-------自定义纸张 lq
					     /*
					        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
					        var papersize=paperset.GetPaperInfo("stockxy");
					        //alert(papersize);
					        if (papersize!=0){
					        xlsheet.PageSetup.PaperSize = papersize;}
					        */
					     //-------
					    var startNo=2 ;
					    var row ;
					    var tmpRegno="" ;
					    if (xlsheet==null) 
					    {       
					    	alert(t["CANNOT_CREATE_PRNOBJ"]);
					        return ;                
					    }
					    PagNum=+1;
					    row=startNo;
					    var exeDetail;
					    var obj=document.getElementById("mListDispDetail")
					    if (obj) exeDetail=obj.value;
					    else exeDetail=""
					    var admloc;
					
					    if (gDetailCnt>0)  
					     {    
						    for (var i=1;i<=gDetailCnt;i++)
						    {           
						        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
						        var datas=ss.split("^")
					            var ward=datas[0];
						        var bedcode=datas[3];
						        var name=datas[1];
						        var paregno=datas[2];
						        var orddate=datas[4];
						        var prtno=datas[5];
						        var orditemdesc=datas[6]
						        var dosqty=datas[7];
						        var doctor=datas[8];
						        
						        
						        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
						         {//setBottomDblLine(xlsheet,row,1,13); 
							      	//setBottomLine(xlsheet,row,1,9);
							     }  
							     //row++;                        
						        if (tmpRegno=="")
						        {  
						            row=row+1
						           	//mergcell(xlsheet,row,1,4)
						            xlsheet.Cells(row, 1).Value ="姓名:"+name+" "+ward+" "+"床号:"+bedcode+" "+"登记号:"+paregno
						            row=row+1;
						            //xlsheet.Cells(row, 1).Value ="药名"
						            //xlsheet.Cells(row, 2).Value ="剂量"
						            setBottomLine(xlsheet,row,1,4);
						          	//cellEdgeRightLine(xlsheet,row,1,13)
						        }
						        /*
						        else
						        {if (paregno!=tmpRegno)
						            {  
						                row=row+2 
						                mergcell(xlsheet,row,1,4)   
						                xlsheet.Cells(row, 1).Value ="姓名:"+name+" "+ward+" "+"床号:"+bedcode+" "+"登记号:"+paregno
						                row=row+1;
							            xlsheet.Cells(row, 1).Value ="药名"
							            xlsheet.Cells(row, 2).Value ="剂量"
							            setBottomLine(xlsheet,row,1,4);
					
						            }
						        }
						        */
						        row=row+1;
						        if (row==13)
						         {
							        h=1; 
							     }
							     if (row>13)
							     {
								     h=1+1;
							     }
							    if ((row==13) || (row>13))
							    {
								    xlsheet.Cells(h, 3).Value =orditemdesc ;
								    xlsheet.Cells(h, 4).Value =orditemdesc ;
							    }
							    else
							    {
									xlsheet.Cells(row, 1).Value =orditemdesc ;
									xlsheet.Cells(row, 2).Value =dosqty ;
								}	
						        tmpRegno=paregno;
						    }
						        // setBottomLine(xlsheet,row+2,1,13)
					       } 
						
						    row+=1;
							//总计
							//xlsheet.Cells(1, 1).Value = "中国医科大学附属第一医院"
						    //xlsheet.Cells(2, 1).Value = "输液医嘱单"
						    setBottomLine(xlsheet,12,1,4)
						    xlsheet.Cells(13, 1).Value ="调剂人:"+"     "+"审核人:"+"     "+"医师:"+doctor+" "+"药单号:"+prtno;
						    xlsheet.printout();
						    SetNothing(xlApp,xlBook,xlsheet);
			
			     	  }
		      }
		}

}

function getDispDetail(pog,pid)
{
    var exe;
    var obj=document.getElementById("mGetDispDetail") ;
    if (obj) exe=obj.value;
    else exe=""
    var result=cspRunServerMethod(exe,pog,pid)
    return result;
}

function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if(prnpath.substring(prnpath.length,prnpath.length-1)!="\\"){prnpath=prnpath+"\\"}
	return prnpath
} 

function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}


function PrintPresc()
{
	if (!confirm(t['CONFIRM_PRINTD'])) {return;}
	var cnt=0;
	var ppog="";
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var gPrnpath=getPrnPath();
		if (gPrnpath=="") 
		{
			  alert(t["CANNOT_FIND_TEM"]) ;
			  return ;                
	    }
	var Template=gPrnpath+"DHCST_PIVA_PRTPRESC.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }
	    
	var startNo=2 ;
	var row=startNo;
	var tmpRegno="" ;

	for (var i=1;i<objtbl.rows.length; i++)
	    {
		    var cell=document.getElementById("tbSelectz"+i)
		    if ((cell.checked==true))
		    { 
			    var gProcessID=document.getElementById("tbPIDz"+i).value;
				var pog=document.getElementById("tbPogIDz"+i).value;
				if (ppog!=pog)
				{
                        ppog=pog;
						var gDetailCnt=getDispDetail(pog,gProcessID) ; // 获取记录数

					    var exeDetail;
					    var obj=document.getElementById("mListDispDetail")
					    if (obj) exeDetail=obj.value;
					    else exeDetail=""
					    var admloc;
					
					    if (gDetailCnt>0)  
					     {    
						    for (var h=1;h<=gDetailCnt;h++)
						    {           
						        var ss=cspRunServerMethod(exeDetail,gProcessID,h)   
						        var datas=ss.split("^")
					            var ward=datas[0];
						        var bedcode=datas[3];
						        var name=datas[1];
						        var paregno=datas[2];
						        var orddate=datas[4];
						        var prtno=datas[5];
						        var orditemdesc=datas[6]
						        var dosqty=datas[7];
						        var doctor=datas[8];
                        
                                /*
						        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
						         { 
							      	setBottomLine(xlsheet,row,1,4);
							     }  
							     row++;                        
 
						        if (tmpRegno=="")
						        {   
						            xlsheet.Cells(row, 1).Value =ward;
						        	xlsheet.Cells(row, 2).Value =paregno;    
						            xlsheet.Cells(row, 3).Value =name;
						            
						        }
						        else
						        {if ((paregno==tmpRegno)&&(ppog!=pog))
						            {  
						            xlsheet.Cells(row, 1).Value =ward;
						            xlsheet.Cells(row, 2).Value =paregno;
						            xlsheet.Cells(row, 3).Value =name;

						            }
						        }
						        */
						        
						        if (h==1)
						        {   
						            setBottomLine(xlsheet,row,1,4)
						            if (tmpRegno!="") row=row+2;
						            else 
						            {row=row+1}
							        xlsheet.Cells(row, 1).Value =ward;
						        	xlsheet.Cells(row, 2).Value =paregno;    
						            xlsheet.Cells(row, 3).Value =name;
						            xlsheet.Cells(row, 4).Value =bedcode;
						        }
						        row++; 
						        xlsheet.Cells(row, 1).Value =orditemdesc; 
	                            xlsheet.Cells(row, 2).Value =dosqty;
						        tmpRegno=paregno;
						     }
						        
					       } 
			
			      }
		     }
		      
		}
		
		    setBottomLine(xlsheet,row,1,4)
		    xlsheet.printout();
		    SetNothing(xlApp,xlBook,xlsheet);

}




function PrintDetaill()
{
	if (!confirm(t['CONFIRM_PRINTD'])) {return;}
	var cnt=0;
	var ppog="";
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var gPrnpath=getPrnPath();
		if (gPrnpath=="") 
		{
			  alert(t["CANNOT_FIND_TEM"]) ;
			  return ;                
	    }
	var Template=gPrnpath+"DHCST_PIVA_PRTDETAIL.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }
	    
	var startNo=3 ;
	var serialNo=0;
	var tmppog="" ;
	var patTotal=0;	
    
    var gProcessID=document.getElementById("tbPIDz"+1).value;
    
    var obj=document.getElementById("mListPrtDetail")
    if (obj) exe=obj.value;
    else  exe="" ;
    //
    var bat="",ward="";
    var objbat=document.getElementById("tBatNo");
    if (objbat) {bat=objbat.value} ;
    
    var objward=document.getElementById("tWard");
    if (objward) {ward=objward.value} ;
    
    var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gHospname=cspRunServerMethod(encmeth,'','') ;
	//alert(gHospname)

    //xlsheet.Cells(1, 1).Value =gHospname;
    xlsheet.Cells(2, 1).Value ="病区"+ward+"    "+"批次"+bat;

	var str=""		
    do 
        {

	    	datas=cspRunServerMethod(exe,gProcessID,str);
	        if (datas!="")
            {
	            
	             var datas=datas.split("^")
				 var ward=datas[0];
				 var bedcode=datas[3];
				 var name=datas[1];
				 var paregno=datas[2];
		         var orddate=datas[4];
		         var prtno=datas[5];
		         var orditemdesc=datas[6]
		         var dosqty=datas[7];
		         var doctor=datas[8];
	             var bat=datas[9];
	             var pog=datas[10];
	             var pogsub=datas[11];
	             var freq=datas[12];
	             
	             str=ward+"/"+bedcode+"/"+paregno+"/"+bat+"/"+pog+"/"+pogsub
	         
	             
	             serialNo++;
	             
	             
	             if ((tmppog!="")&&(pog!=tmppog) )
	             { 
		      	     // setBottomLine(xlsheet,startNo+serialNo,1,3);
		         }   
	             
	             
		        if (tmppog=="")
		        {   
		        	xlsheet.Cells(startNo+serialNo, 1).Value =paregno;    
		            xlsheet.Cells(startNo+serialNo, 2).Value =bedcode;
		            xlsheet.Cells(startNo+serialNo, 3).Value =name; 
		            
		            patTotal=patTotal+1;
		        }
		        else
		        {if (tmppog!=pog)
		            {  
		             xlsheet.Cells(startNo+serialNo, 1).Value =paregno;
		             xlsheet.Cells(startNo+serialNo, 2).Value =bedcode;
		             xlsheet.Cells(startNo+serialNo, 3).Value =name;
		              
		             patTotal=patTotal+1;
		             
		             setBottomLine(xlsheet,startNo+serialNo-1,1,6)
		            }
		        }
		        
		        xlsheet.Cells(startNo+serialNo, 4).Value =orditemdesc; 
				xlsheet.Cells(startNo+serialNo, 5).Value =dosqty;
				xlsheet.Cells(startNo+serialNo, 6).Value =freq
	
			    tmppog=pog
            }
            else {str=""}
            
        } while (str!="")
                       
	setBottomLine(xlsheet,startNo+serialNo,1,6)
		
	xlsheet.Cells(startNo+serialNo+1, 1).Value="共计:"+patTotal+"袋      打印时间:"+ formatDate2(getPrintDate())+" "+getPrintTime()+"    "+"打印人:"+session['LOGON.USERNAME'];
	
	
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet);
	KillTmpAfterPrint(pid);

}





function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
        
}

function KillTmpAfterPrint(pid)
{
    var obj=document.getElementById("mKillPrt") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gHospname=cspRunServerMethod(encmeth,'','') ;
        
}

function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}

function HiddenItem()
{
	window.document.all("bFind").style.display="none";
}

//保存并打印停止医嘱列表
function PrintDOrder()
{	
	if (!confirm(t['CONFIRM_PRINT_DORDER'])) {return;}
	var cnt=0;
	var ppog="";
	var ret;
	var num=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_QUERY");
    	if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var pcp=CspRunInsCprint();
	if (pcp<0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			var pog=document.getElementById("tbPogIDz"+i).value;
			var oest=document.getElementById("tbOeStatusz"+i).innerText;
			var spest=document.getElementById("tbSpecStatz"+i).innerText;
			var pogst=document.getElementById("tbStatez"+i).innerText;
			var cprintno=trim(document.getElementById("tbCPrintNoz"+i).innerText);
			var visit=document.getElementById("tbVisitStatusz"+i).innerText;	//住院状态
			alert(pogst)
			alert(visit)
			alert(cprintno)
			//if (((oest=="停止")||(spest!="N")||((pogst=="打签")&&(visit=="D")))&&(pog!=ppog)&&(cprintno=="")&&(pogst!="复核")){
			if (((oest=="停止")||(spest!="N")||(pogst=="打签"))&&(pog!=ppog)&&(cprintno=="")){
				ppog=pog;
				/// 更新配液医嘱组主表取消打印信息
				num=num+1;
				
				ret=CspRunSavePogCprint(ppog,pcp,num);
				if (ret!=0){
					alert(t['SAVE_FAILED']);
					return;
				}
				
			}
		}
	}
	alert(num)
	if (num>0){
		PrintListClick(pcp);
	}
	ReFind();
}
///Descript:	打印停止医嘱列表
///Creater:		zhouyg
///CreateDate:	20100318
///Input:		pcpDr-PIVA_CPrint的RowID
function PrintListClick(pcpDr)
{
	alert(pcpDr)
	var rowstr=CspRunGetPogCprint(pcpDr);
	var rowarr=rowstr.split("^");
	var pid=rowarr[0];
	var wardcount=rowarr[1];  //病区数
	if (wardcount<=0){
		alert(t['ERR_GETPRINTI']);
		return;
	}
		var ploc="";
		var sd="";
		var ed="";
		var osd="";
		var oed="";
		var hospname="";
		var currow=0;
		var i;
		var j;
		var startRow=5;
		var cols=8;
		var prnpath=getPrnPath();
		var Template=prnpath+"DHCST_PIVA_DOrder.xls";	
		var ward="";
	try
	{
		for(i=1;i<=wardcount;i++){
		  var xlApp = new ActiveXObject("Excel.Application");
		  var xlBook = xlApp.Workbooks.Add(Template);
		  var xlsheet = xlBook.ActiveSheet ;
		  var obj=document.getElementById("mPrtHospName");
	      if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	      var hospname=cspRunServerMethod(encmeth,'','');

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
		  var obj=document.getElementById("tOrdStDate") ;
		  if (obj) osd=obj.value;
		  var obj=document.getElementById("tOrdEndDate") ;
		  if (obj) oed=obj.value;
		///
		  xlsheet.Cells(1,1).Value =hospname+"PIVAS停止医嘱明细表"
		  xlsheet.Cells(2,1).Value ="打签日期:"+(sd)+"至"+(ed)+"    医嘱日期:"+(osd)+"至"+(oed);
		  xlsheet.Cells(3,1).Value = "配液科室:"+ploc;
		  var ward=CspRunGetWard(pid,ward)
		  if(ward=="")return;
		  wardnum=CspRunGetWardNum(pid,ward)
		  for (k=1;k<=wardnum;k++){
			  var sttdate="";
			  var patname="";
			  var freq="";
			  var ward="";
			  var Bed="";
			  var BatNo="";
			  var listStr=CspRunGetListByWard(pid,ward,k)
			  if (listStr=="") return;
			  var strarr=listStr.split("!")
			  var mstr=strarr[0];
			  var dstr=strarr[1];
			  if (mstr=="") return;
			  if (dstr=="") return;
			  var mstrarr=mstr.split("^")
			  sttdate=mstrarr[12];
			  ward=mstrarr[3];
			  var wardarr=ward.split("-");
			  if(wardarr.length>1){var ward=wardarr[1]};
			  //ward=ward.substring(0,8);
			  Bed=mstrarr[16];
			  patname=mstrarr[17];
			  BatNo=mstrarr[6];
			  freq=mstrarr[10];
			  //
			  var dstrarr=dstr.split("||");
			  for (j=0;j<=dstrarr.length-1;j++){
				var arcname="";
				var dosage="";
				var dosunit=""
				if (currow==0){currow=startRow;}
				else {currow=currow+1}
				var ordarr=dstrarr[j].split("^")
				arcname=ordarr[0];
				dosage=ordarr[1];
				if (j==0){
					xlsheet.Cells(currow,1).Value=sttdate;
					xlsheet.Cells(currow,2).Value=ward;
					xlsheet.Cells(currow,3).Value=Bed;
					xlsheet.Cells(currow,4).Value=patname;
					xlsheet.Cells(currow,5).Value=BatNo;
					xlsheet.Cells(currow,6).Value=freq;
				}
				xlsheet.Cells(currow,7).Value=arcname;
				xlsheet.Cells(currow,8).Value=dosage;
				xlsheet.Range(xlsheet.Cells(currow, 1), xlsheet.Cells(currow,1)).Borders(1).LineStyle=1;
				xlsheet.Range(xlsheet.Cells(currow, 7), xlsheet.Cells(currow,8)).Borders(1).LineStyle=1;
				xlsheet.Range(xlsheet.Cells(currow, 1), xlsheet.Cells(currow,8)).Borders(2).LineStyle=1;
				xlsheet.Range(xlsheet.Cells(currow, 7), xlsheet.Cells(currow,8)).Borders(3).LineStyle=1;
			}
			xlsheet.Range(xlsheet.Cells(currow, 1), xlsheet.Cells(currow,cols)).Borders(4).LineStyle=1;
		 }
		 if (currow>0){
			xlsheet.printout();
		 }
		 if (pid>0){
			  KillTmpAfterCprint(pid,"PCPL");
			  KillTmpAfterCprint(pid,"WARD");
			  KillTmpAfterCprint(pid,"WARDLIST");
		 }
	     SetNothing(xlApp,xlBook,xlsheet);
	   } 
		
	}
	catch(e)
	{
		if (pid>0){
		 KillTmpAfterCprint(pid,"PCPL");
		 KillTmpAfterCprint(pid,"WARD");
		 KillTmpAfterCprint(pid,"WARDLIST");
		}
		alert(e.message);
		SetNothing(xlApp,xlBook,xlsheet);
	}
}
function CspRunGetPogCpList(pid,no)
{
	var objtmp=document.getElementById("mGetCPrintList");
	if (objtmp) {var encmeth=objtmp.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,no);
	return ret;
}
function CspRunGetPogCprint(pcpdr)
{
	var objktmp=document.getElementById("mGetCPrintData");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pcpdr);
	return ret;
}
function KillTmpAfterCprint(pid,para)
{
	var objktmp=document.getElementById("KTmpGlobal");
	if (objktmp) {var encmeth=objktmp.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,para);
}
function CspRunGetWardNum(pid,ward)
{
	var obj=document.getElementById("mGetWardNum");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,ward);
	return ret;
}
function CspRunGetWard(pid,ward)
{
	var obj=document.getElementById("mGetNextWard");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,ward);
	return ret;
}
function CspRunGetListByWard(pid,ward,k)
{
	var obj=document.getElementById("mGetListByWard");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,ward,k);
	return ret;
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
					var objtbl=document.getElementById("tDHCST_PIVA_QUERY");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
				 	var moeori=document.getElementById("tbMdodisz"+row).value;
				 	var grp=document.getElementById("tbGrpNoz"+row).innerText;
				 	if ((moeori=="")||(grp=="")) return;
				 	var ploc=parent.frames['DHCST.PIVA.QUERY1'].document.getElementById("tPLocID").value;
					var batno=document.getElementById("tbBatNoz"+row).value
					var dsp=document.getElementById("tbDSPz"+row).value;
		
					ret=tkMakeServerCall("web.DHCSTPIVAPRINTLABEL","UpdBat",moeori,grp,trim(batno),ploc,dsp);
					if (ret<0) {document.getElementById("tbBatNoz"+row).value=Currbat;}
					if (ret==-6) {alert("更新失败,选择主医嘱后再重试...");return;}
					if (ret==-7){alert("当前记录已配液配置,不允许修改批次...");return }
					if (ret==-8){alert("当前记录已减库存,不需要修改批次...");return }
					if (ret==-5){alert("修改后批次不存在...");return }
					if (ret!=0) {alert("更新失败");return;}
					if (ret==0){alert("更新成功!")}
					for (i=row+1;i<=cnt;i++)
					 {
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

  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="tbBatNo")
			 { 

					var objtbl=document.getElementById("tDHCST_PIVA_QUERY");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
					var batno=document.getElementById("tbBatNoz"+row).value;

                    Currbat=batno;
			 }
	   }
}
document.body.onbeforeunload = function(){
	var pid=""; 
	var obj=document.getElementById("tbPIDz"+1);
    if (obj) pid=obj.value;
    if (pid>0) {
		tkMakeServerCall("web.DHCSTPIVAQUERY","ClearAllTmp",pid)
	}
}
document.body.onload=BodyLoadHandler;