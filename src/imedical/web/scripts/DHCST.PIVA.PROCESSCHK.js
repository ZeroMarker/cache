/// DHCST.PIVA.PROCESSCHK
/// 配液状态执行
function BodyLoadHandler()
{
  	InitForm();
  	SetObjHandler();
	SetTblColor();
	SelectAll();
	setUnVisible();
}
function InitForm()
{
	setDefaultValByLoc();
	setPassAudit();
	GetRecord();
	SetFocus();
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
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
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
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
	
	
    var obj = document.getElementById("tExeState");
	if (obj){
		setExeState();
		obj.onchange=ExeStateSelect;

	}
	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
    if (objtbl) objtbl.ondblclick=tbDbClick;
	var objtbl=document.getElementById("cSelectAll");
	if (objtbl) objtbl.onclick = SelectClick;
	//var objtbl=document.getElementById("cClearAll");
	//if (objtbl) objtbl.onclick = ClearAll;
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bReCheckOK");
	if (obj) obj.onclick=bReCheckOKClick;
	var obj=document.getElementById("bReCheckNO");
	if (obj) obj.onclick=bReCheckNOClick;
	
	var obj=document.getElementById("bCancel");
	if (obj) obj.onclick=bCancelCheckClick;
	
	var obj = document.getElementById("Barcode");
    if (obj) obj.onkeydown=ReCheckByBarcode;
    var obj = document.getElementById("tChecked");
    if (obj) obj.onclick=tCheckedClick;
	
	
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}
//
/// 选择或者清除行
function tbSelectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
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
function BatNoLostFocus()
{

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
	obj=document.getElementById("clCnt");
	if (obj)obj.innerText="记录数:0"+" "+"袋数:0";
}
function FindClick()
{

	if (ChkFindCondition()==false) return;
	ReFind();
	//setUnVisible();
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
	
	objstate=document.getElementById("tExeState");
	if (objstate.value==""){alert("请先选择< 预执行状态 >后再重试...")
	return false;}
	
	var objward=document.getElementById("tWardID");
	var objreg=document.getElementById("tRegNo");
	if ((objward.value=="")&&(objreg.value=="")) {
		if (confirm(t['NO_SELECT'])) {return true;} else {return false;}
	}

	return true ;
}

function bCancelCheckClick()
{
	
	var objChecked=document.getElementById("tChecked");
	if(objChecked.checked==false){
		alert("请选择已执行查询后再取消执行!")
		return;
	}
	if (!confirm(t['CONFIRM_OK'])) return;
	ReFind();
	var cnt=0;
	var dsp;
	var pog;
	var ppog="";
	var ret;
	var exestate=""
	var objexe=document.getElementById("tExeState");
	if (objexe) {var exestate=objexe.value ; }
	if (exestate=="") 
	{
		alert("请选择预执行状态后,再重试...")
	    return;
	}
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var pid=CspRunGetNewPid();
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)

		if (cell.checked==true){
			dsp=document.getElementById("tbDSPz"+i).value;
			var batno=document.getElementById("tbBatNoz"+i).innerText;
			pog=document.getElementById("tbPogIDz"+i).value;
			if (pog!=ppog){
				ppog=pog
				
				ret=CspRunCancelCheck(pid,pog,exestate);
				var ret=0
				//var itmdesc=CspRunGetNoQtyItmDesc()
				var msgstr="行数"+i+" 批次"+batno //+" "+itmdesc;
				if (ret==-9){
					alert("此时不能执行该状态!"+msgstr);
					return;
				}
				if (ret!=0){
					alert(t['SAVE_FAILED']+ret+" "+msgstr);
					return;
				}
			}
		}
	}
	CspRunClearAfterSave(pid);
	ReFind();
}


/// 复核通过,1-更新 PIVA_OrdGrp ,2-插入 PIVA_OrdGrpState 
function bReCheckOKClick()
{
	var objChecked=document.getElementById("tChecked");
	if(objChecked.checked==true){
		alert("请选择未执行查询后再执行!")
		return;
	}
	if (!confirm(t['CONFIRM_OK'])) return;
	ReFind();
	var cnt=0;
	var dsp;
	var pog;
	var ppog="";
	var ret;
	var exestate=""
	var objexe=document.getElementById("tExeState");
	if (objexe) {var exestate=objexe.value ; }
	if (exestate=="") 
	{
		alert("请选择预执行状态后,再重试...")
	    return;
	}
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	
	var pid=CspRunGetNewPid();
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		
		if (cell.checked==true){
			
			
			dsp=document.getElementById("tbDSPz"+i).value;
			//var bed=document.getElementById("tbBedNoz"+i).innerText;
			//var batno=document.getElementById("tbBatNoz"+i).innerText;
			pog=document.getElementById("tbPogIDz"+i).value;
            
			if (pog!=ppog){
				ppog=pog

				ret=CspRunSaveCheckOK(pid,pog,exestate);				
				if (ret!=0){
					var batno=getSelectBatNo(i)
					var msgstr="行数"+i+" 批次"+batno//+" "+itmdesc;					
				}
				if (ret==-9){
					alert("此时不能执行该状态!"+msgstr);
					return;
				}
				else if (ret==-11){
					alert(msgstr+"的病人已出院结算!");
					return;
				}
				else if (ret!=0){
					alert(t['SAVE_FAILED']+ret+" "+msgstr);
					return;
				}
			}
		}
	}
	CspRunClearAfterSave(pid);
	ReFind();
}

function CspRunCancelCheck(pid,pog,exestate)
{
	var obj=document.getElementById("mCancelCheck");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid,pog,exestate);
	return result;
}

function CspRunSaveCheckOK(pid,pog,exestate)
{
	var obj=document.getElementById("mSaveCheckOK");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid,pog,exestate);
	return result;
}
function CspRunGetNoQtyItmDesc()
{
	var obj=document.getElementById("mGetNoQtyItmDesc");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	return result;
}
function CspRunGetNewPid()
{
	var obj=document.getElementById("mGetNewPid");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	return result;
}
function CspRunClearAfterSave(pid)
{
	var obj=document.getElementById("mClearRCSAVE");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	cspRunServerMethod(encmeth,pid);
}
function CspRunGetPhac(pid)
{
	var obj=document.getElementById("mGetPhac");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var phacString=cspRunServerMethod(encmeth,pid);
	return  phacString;
}
/// 复核不通过
function bReCheckNOClick()
{
	if (!confirm(t['CONFIRM_NO'])) return;
	var cnt=0;
	var pog;
	var ppog="";
	var ret;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell.checked==true){
			pog=document.getElementById("tbPogIDz"+i).value;
			if (pog!=ppog){
				ppog=pog
				ret=CspRunSaveCheckNo(ppog);
				if (ret<0){
					alert(t['SAVE_FAILED']+ret);
					return;
				}
			}
		}
	}
	ReFind();
}
function CspRunSaveCheckNo(pog)
{
	var obj=document.getElementById("mSaveCheckNo");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pog);
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var setvalue;
 	var cell=document.getElementById("tbSelectz"+row);
 	var pog=document.getElementById("tbPogIDz"+row);
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



///配液执行状态索引
function setExeState()
{
	var obj=document.getElementById("tExeState");
	if (obj) PInitExeState(obj);
	var objindex=document.getElementById("ExeStateIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
///初始化配液执行状态
function PInitExeState(listobj)
{
	var objlocid = document.getElementById("tPLocID");
	if (objlocid) locid = objlocid.value;
	var obj=document.getElementById("mGetExeState");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			///初始化配液执行状态
			if (listobj)
			{
				listobj.size=1; 
			 	listobj.multiple=false;
			 	listobj.options[i+1]=new Option(type,typeindex);
			 	
		    }
			
		}
		
	}
	else
	{
			    listobj.size=1; 
			 	listobj.multiple=false;
	}
	

}
/// ExeState
function ExeStateSelect()
{

	var obj=document.getElementById("ExeStateIndex");
	if(obj){
		var objpass=document.getElementById("tExeState");
		obj.value=objpass.selectedIndex;
		SetFocus();
	}
	
}


///扫描条码
function ReCheckByBarcode()
{
	var objBarcode = document.getElementById("Barcode");

	if (window.event.keyCode==13){
		
		
		var objexe=document.getElementById("tExeState");
	    if (objexe) {var exestate=objexe.value ; }
	    if (exestate=="") 
	    {
		 alert("请选择预执行状态后,再重试...")
	     return;
	    }

        var str=objBarcode.value;
		var tmpstr=str.split("-");
		var tmpstr1 = tmpstr [0];
		var tmpstr2 = tmpstr [1];
		var tmpstr3 = tmpstr [2];
		var tmpmoeori=tmpstr1+"||"+tmpstr2
		var tmppod=tmpstr3

		var cnt=0
		var objtbl=document.getElementById("t"+"DHCST_PIVA_PROCESSCHK");
	    if (objtbl) cnt=getRowcount(objtbl);
		if (cnt>0){
      
        var pid=CspRunGetNewPid();
        var pogflag=0;
		for (var i=1;i<=cnt; i++) {
			var celltbMOeori=document.getElementById("tbMOeoriz"+i);
			var moeori=celltbMOeori.value;
			var celltbPogID=document.getElementById("tbPogIDz"+i);
			var pod=celltbPogID.value;
			//alert(moeori+"**"+tmpmoeori)
            //alert(pod+"**"+tmppod)
   
			if ((moeori==tmpmoeori)&&(pod==tmppod))
			{

			   var celltbSelect=document.getElementById("tbSelectz"+i);
			   if (celltbSelect) 
			      {  
				        celltbSelect.checked=true;
				        var ret=0
				        if (pogflag==0)
				        {
							ret=CspRunSaveCheckOK(pid,pod,exestate);
						}
						
						objBarcode.value="";
							
						var msgstr="行数"+i;
						if (ret==-9){
							alert("此时不能执行该状态!"+msgstr);
							return;
						}
						
						if (ret!=0){
							alert(t['SAVE_FAILED']+ret+" "+msgstr);
							return;
						}
						
				        var objrow=objtbl.rows[i];
				        objrow.className="RowPink"
				        pogflag=1
			       }
			  }
			  
			 
			  if ((pod!=tmppod)&&(pogflag==1))
			  {
				  
				  break;
				  } 
    	}
		
	}
	
	  	
   }
	
	
	
}

function SetFocus()
{
	 obj=document.getElementById("Barcode");
     if (obj) websys_setfocus(obj.id);
}
function setUnVisible()
{	
    
	var objChecked=document.getElementById("tChecked");
	var objChkY=document.getElementById("bReCheckOK");
	var objChkN=document.getElementById("bReCheckNO");
	var objChkC=document.getElementById("bCancel");
	if(objChecked)
	{
		if(objChecked.checked==true){
			if (objChkY) objChkY.disabled=true;
			if (objChkN) objChkN.disabled=true;
			if (objChkC) objChkC.disabled=false;
		}
	    else
		{
			if (objChkY) objChkY.disabled=false;
			if (objChkN) objChkN.disabled=false;
			if (objChkC) objChkC.disabled=true;
			//DisableFieldByID("mGetComponentID","bCancel");
		}
	}
}
function tCheckedClick()
{
	var obj = document.getElementById("tChecked");
	var objChkY = document.getElementById("bReCheckOK");
	if (obj.checked)
	{
		objChkY.disabled=true;
	}
	else
	{
		objChkY.disabled=false;
	}
}
 ///yunhaibao,因批次显示为空,此处获取选中行的批次
function getSelectBatNo(selectnum)
{
	var batnotext=""
	var batnoobj=document.getElementById("tbBatNoz"+selectnum);
	if (batnoobj){
		batnotext=batnoobj.innerText;
		}
	if (batnotext==""){
		return getSelectBatNo(selectnum-1)		
	}
	else{
		return batnotext
	}
}
document.body.onload=BodyLoadHandler;