/// DHCST.PIVA.REFUSE
function BodyLoadHandler()
{
  	InitForm();
  	SetObjHandler();
	SetTblColor();
	//SelectAll;
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
		var objsdo = document.getElementById("tOrdStDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tOrdEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = eddate;
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt>0){
		/*for (var i=1;i<objtbl.rows.length; i++) {
			var cell=document.getElementById("tbSelectz"+i);
			if (cell){cell.onclick=tbSelectClick;}
    	}
    	*/
		SetTblRowsColor(objtbl,2);
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
	var listobj=document.getElementById("tSpecStat");
	if (listobj) {
		listobj.onclick=SpecSelect;
	}
	var obj = document.getElementById("tPrintNo");
	if (obj){
		obj.onblur=PrintNoLostFocus;
		obj.onfocus=PrintNoOnFocus;
		obj.onkeydown=PrintNoKeyDown;
	}

	var obj = document.getElementById("tLocGrp");
	if (obj) {
		 obj.onkeydown=popLocGrp;
	 	 obj.onblur=LocGrpCheck;
	}
	
	var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) objtbl.ondblclick=tbDbClick;
	var objtbl=document.getElementById("cSelectAll");
	if (objtbl) objtbl.onclick = SelectClick;
	//var objtbl=document.getElementById("cClearAll");
	//if (objtbl) objtbl.onclick = ClearAll;
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bRefuse");
	if (obj) obj.onclick=bRefuseClick;
	var obj=document.getElementById("bCancel");
	if (obj) obj.onclick=bCancelClick;
	var obj=document.getElementById("bNoRefuse");
	if (obj) obj.onclick=bNoRefuseClick;
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}
/// 选择或者清除行
function tbSelectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
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
	obj=document.getElementById("tPassAudit");
	if (obj) obj.selectedIndex=0;
	obj=document.getElementById("tSpecStat");
	if (obj) obj.selectedIndex=1;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
	if (objtbl) DelAllRows(objtbl);
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0"+" "+"袋数:0";
}
function FindClick()
{
	if (ChkFindCondition()==false) return;
	ReFind();
}
function ReFind()
{
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
/// 配液拒绝
function bRefuseClick()
{
	var cnt=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0)
	{
		alert("没有任何记录！")
		return;
	}
	
	if (!confirm(t['CONFIRM_REFUSE'])) return;
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.OPREASON&opType=R','','dialogHeight:380px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:yes')
	if (resondr=="") 
	{
		alert("错误提示:选择拒绝原因后重试...")
		return;
	}	
	var pog;
	var ppog="";
	var ret;
	var selRows=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			pog=document.getElementById("tbPogIDz"+i).value;
			selRows=selRows+1
			if ((pog!=ppog)){
				ppog=pog
				ret=CspRunSavePogRefuse(ppog,resondr);
				if (ret==-7){
					alert("第"+i+"行"+"医嘱已停止,不能拒绝!");
					return;
				}
				else if (ret==-8){
					alert("第"+i+"行"+"配液状态为已拒绝!");
					return;
				}
				else if (ret<0){
					alert(t['SAVE_FAILED']+",错误代码:"+ret);
					return;
				}
			}
		}
	}
	if (selRows==0)
	{
		alert("您没有选择任何记录")
		return;
	}
	ReFind();
}
function CspRunSavePogRefuse(pog,reasondr)
{
	var obj=document.getElementById("mSaveRefuse");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pog,reasondr);
	return result;
}
/// 取消配液拒绝
function bNoRefuseClick()
{
	var cnt=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0)
	{
		alert("没有任何记录！")
		return;
	}
	if (!confirm(t['CONFIRM_NOREFUSE'])) return;
	
	var pog;
	var ppog="";
	var ret;
	var selRows=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			pog=document.getElementById("tbPogIDz"+i).value;
			selRows=selRows+1;
			if ((pog!=ppog)){
				ppog=pog
				ret=CspRunSavePogNoRefuse(ppog);
				if (ret==-7){
					alert("第"+i+"行"+t['ERR_NOORDD']);
					return;
				}
				if (ret<0){					
					alert("第"+i+"行"+t['SAVE_FAILED']);
					return;
				}
			}
		}
	}
	if (selRows==0)
	{
		alert("您没有选择任何记录")
		return;
	}
	ReFind();
}
function CspRunSavePogNoRefuse(pog)
{
	var obj=document.getElementById("mSaveNoRefuse");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pog);
	return result;
}

/// 配液取消
function bCancelClick()
{
	if (!confirm(t['CONFIRM_CANCEL'])) return;
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.OPREASON&opType=C','','dialogHeight:180px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
	if (resondr=="") return;
	var cnt=0;
	var pog;
	var ppog="";
	var ret;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if ((cell.checked==true)){
			pog=document.getElementById("tbPogIDz"+i).value;
			if ((pog!=ppog)){
				ppog=pog
				ret=CspRunSavePogCancel(ppog,resondr);
				if (ret<0){
					alert(t['SAVE_FAILED']);
					return;
				}
			}
		}
	}
	ReFind();
}
function CspRunSavePogCancel(pog,reasondr)
{
	var obj=document.getElementById("mSaveCancel");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pog,reasondr);
	return result;
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell) cell.checked=false;
	}
}
/// 双击选择或者清除行
function tbDbClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_REFUSE");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("tbSelectz"+row);
 	var pog=document.getElementById("tbPogIDz"+row).value;
	if (cell){
		if (cell.checked==false) {setvalue=true;}
		else {setvalue=false;}
		//alert(setvalue)
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


document.body.onload=BodyLoadHandler;