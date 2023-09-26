/// DHCST.PIVA.CHEMAUDIT
//document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
//document.write("</object>");


var CurSelRow;
var LoadFlag="";
var regnoFocus = false;
function BodyLoadHandler()
{
	
	var obj=document.getElementById("PassAuditIndex");
//	var obj=document.getElementById("clear")
	//if (obj) obj.onclick=clearWindow;
	setDefaultValByLoc();
	var obj = document.getElementById("tPType");
	if (obj){
		InitPivaType();
	}
	
	var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
	
	var obj = document.getElementById("tPassAudit");
	if (obj){
		setPassAudit();
		obj.onchange=PassAuditSelect;
	}
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
	//if (obj) obj.readOnly = true;
	var obj=document.getElementById("painfo");
	if (obj) obj.readOnly=true;
	var obj = document.getElementById("regno");
	if (obj) {
		obj.onblur = regnoLostFocus;
		obj.onfocus = regnoOnFocus;
		obj.onkeydown = regnoKeyDown;
	}
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
		obj.onkeydown=WardKeyDown;
	}

	var obj=document.getElementById("CheckedY")
	if (obj) obj.onclick=CheckedYClick;
	
	var obj=document.getElementById("CheckedN")
	if (obj) obj.onclick=CheckedNClick;
	
	CheckedYClick();
	var obj=document.getElementById("selectall")
	if (obj) 
	{
		obj.onclick=selectall;
		obj.checked=true;
		selectall();
	}
	var obj=document.getElementById("recloc");
	if (obj){
		obj.onkeydown=reclocKeyDown;
		obj.onfocus=reclocOnFocus;
	 	obj.onblur=reclocLostFocus;
	}
	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    //if (objtbl) objtbl.ondblclick=tbDbClick;
    var obj = document.getElementById("tpre");
	if (obj){
		if (obj.value==1){
			obj.value=0;
			//FindClick();
		}
	}
    var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    if (objtbl) cnt=getRowcount(objtbl);
    //if (cnt>0){SetTblRowsColor(objtbl,1);}
    if (cnt>0){SetTblRowsColorNew(objtbl,1);}
	//var obj=document.getElementById("aupass")
	//if (obj) obj.onclick=passPT;
	//var obj=document.getElementById("tPassAuditTPN")
	//if (obj) obj.onclick=passTPN;
	//var obj=document.getElementById("tPassAuditHL")
	//if (obj) obj.onclick=passHL;
	
	var obj=document.getElementById("aupass")
	if (obj) obj.onclick=passOrdItems;
	
	
	var obj=document.getElementById("refuse")
	if (obj) obj.onclick=RefuseOrdItems;
	var obj=document.getElementById("find")
	if (obj) obj.onclick=FindClick;
	var obj=document.getElementById("bPrintLabel")
	if (obj) obj.onclick=PrintLabelClick;
	var obj=document.getElementById("bPrintList")
	if (obj) obj.onclick=PrintListClick;
	var obj=document.getElementById("bCancelPass")
	if (obj) obj.onclick=bCancelPassClick;
	///-------------合理用药------------
	//var obj=document.getElementById("singlePresc")
	//if (obj) obj.onclick=GetSinglePrescByDaTong; //单组液体提示说明
    //var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    //if (objtbl) objtbl.ondblclick=GetDaTongYDTS; //某个液体药品药典提示
    var obj=document.getElementById("DaTongPresc")
	if (obj) obj.onclick=GetDaTong; //全部液体处方分析
    //StartDaTongDll(); //初始化大通合理用药
    ///----------------------------------
	
	var objnotaudit=document.getElementById("tNotAudit");
	//if(objnotaudit)objnotaudit.onclick=setUnVisible;
	//setUnVisible();
	SetPurview();
	//*******美康接口*******//
	
	var obj=document.getElementById("MedicineInfo");
	if (obj) obj.onclick=testMK;
	/*
	ChangeRowStyle();
    WebServiceInit2();
    WebServiceInitCheck();
    */
    var obj = document.getElementById("tItmDesc");
	if (obj){
		obj.onblur=ItmLostFocus;
		obj.onfocus=ItmOnFocus;
		obj.onkeydown=ItmKeyDown;
	}
}
function setDefaultValByLoc()
{
	var objLoadFlag = document.getElementById("LoadFlag");
	LoadFlag=objLoadFlag.value;
	var locid = "";
	var objlocid = document.getElementById("reclocrowid");
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
		var objsd = document.getElementById("sd");
		
		if (objsd){
			if (objsd.value=="") objsd.value = stdate;
		}
		var objed = document.getElementById("ed");
		if (objed){
			if (objed.value=="") objed.value = eddate;
		}
		var objnur = document.getElementById("tNotAudit");
		if (objnur){
			if (LoadFlag=="")
			{
				if (objnur.checked==false) objnur.checked=!nuraudit;
			}
		}
	}
	objLoadFlag.value=1;
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


function setPassAudit()
{
	var obj=document.getElementById("tPassAudit");
	if (obj) PInitPassAudit(obj);
	var objindex=document.getElementById("PassAuditIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}
function PInitPassAudit(listobj)
{
	if (listobj){
		listobj.size=1; 
	 	listobj.multiple=false;
	 	listobj.options[1]=new Option("审核通过","SHTG");
	 	listobj.options[2]=new Option("审核拒绝","SHJJ");
	}
}

function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}
/// recloc Handler
function reclocKeyDown()
{
		if (window.event.keyCode==13)
	{  window.event.keyCode=117;
	  recloc_lookuphandler();
		}
}
function reclocOnFocus()
{
	var obj=document.getElementById("recloc");
	if (obj) {obj.select();}
}
function reclocLostFocus()
{
	var obj=document.getElementById("recloc");
	var obj2=document.getElementById("reclocrowid");
	if (obj)
	{if (obj.value=="") obj2.value=""		}
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
/// tOecType
function OecTypeSelect()
{
	var obj=document.getElementById("OecTypeIndex");
	if(obj){
		var objpass=document.getElementById("tOecType");
		obj.value=objpass.selectedIndex;
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
//select all the rows ;
function selectall()
{
	var checked;
	var obj=document.getElementById("selectall")
	if (obj) checked= obj.checked;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj);
  	if (cnt>0)
  	{
	  	for (i=1;i<=cnt;i++)
	  	{
			var obj=document.getElementById("select"+"z"+i);
			obj.checked=checked;
		}
	}
}
function DispLocLookUpSelect(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("reclocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;
	}
}
/// regno Handler
function regnoKeyDown()
{
	var key=websys_getKey();
	if (key==13)
	{
		regnoLostFocus();
	}

}
function regnoOnFocus()
{
	var obj=document.getElementById("regno");
	if (obj) obj.select();
	regnoFocus=true;
}
function regnoLostFocus()
{
	if (regnoFocus==false) return;
	var regno
	var objregno;
	var objpainfo;

	objregno=document.getElementById("regno");
 	objpainfo=document.getElementById("painfo");
	regno=objregno.value;

	if (regno=='')
	{
	 if (objpainfo) objpainfo.value="" ;
	 return;
	}
	regnoFocus=false;

 	regno=getRegNo(regno) ;
 	objregno.value=regno;
	var obj=document.getElementById("mGetPaInfo");
	var exe;
	if (obj) exe=obj.value;
	else exe="";

	var painfo=cspRunServerMethod(exe,regno)
	if (painfo=="")
	{
        //objregno.removeAttribute('onblur')
		alert(t['INVALID_REGNO']) ;
	  	objregno.value=""
	  	objpainfo.value=""
		return ;
	 }
	else
	{
		SetPa(painfo)}

	}
function SetPa(value)
{

	if (value=="")
	{
		var obj=document.getElementById("painfo");
		if (obj) obj.value="" ;
		return;
	}
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("painfo");
	if (obj)
	{
		if (painfo.length >0){
			obj.value=painfo[0]+" -- " +painfo[1] + " -- " +painfo[2] ;
		}
		else
		{
			alert(t['INVALID_REGNO']) ;
			return ;
			}
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
/// CheckedYClick
function CheckedYClick()
{
	var objy=document.getElementById("CheckedY");
	var objn=document.getElementById("CheckedN");
	var obj=document.getElementById("Checked");
	var objbcancp=document.getElementById("bCancelPass")
	var bottomFrame=parent.frames['DHCST.PIVA.CHEMAUDITM'];
	var auditobj=bottomFrame.document.getElementById("AuditFlag")
	if (objy){
		if (objy.checked==true){
			objn.checked=false;
			obj.value=1;
			auditobj.value=1
			//objbcancp.disabled=false;
		}
		else {
			objn.checked=true;
			obj.value=0;
			auditobj.value=0
			//objbcancp.disabled=true;
		}
	}
	SetPurview();
}
/// CheckedNClick
function CheckedNClick()
{
	var objy=document.getElementById("CheckedY");
	var objn=document.getElementById("CheckedN");
	var obj=document.getElementById("Checked");
	var objbcancp=document.getElementById("bCancelPass")
	var bottomFrame=parent.frames['DHCST.PIVA.CHEMAUDITM'];
	var auditobj=bottomFrame.document.getElementById("AuditFlag")
	if (objn){
		if (objn.checked==true){
			objy.checked=false;
			obj.value=0;
			auditobj.value=0
			//objbcancp.disabled=true;
		}
		else {
			objy.checked=true;
			obj.value=1;
			auditobj.value=1
			//objbcancp.disabled=false;
		}
	}
	SetPurview();
}
/// 选择或者清除行
function selectClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
 	var setvalue;
 	var moeorir;
 	var row=selectedRow(window);
 	var cell=document.getElementById("selectz"+row);
 	var moeori=document.getElementById("mOeoriz"+row).value;
 	//var moeori=document.getElementById("Tmdodisz"+row).value;
	if (cell){
		if (cell.checked==false) {setvalue=false;}
		else {setvalue=true;}
	}
	var pogflag=0;
	for (var i=1;i<objtbl.rows.length; i++) {
		var moeorir="";
		var objmoeori=document.getElementById("mOeoriz"+i)
		//var objmoeori=document.getElementById("Tmdodisz"+i)
		if (objmoeori) moeorir=objmoeori.value;
		if ((moeorir!=moeori)&&(pogflag==1)) break;
		if (moeorir==moeori){
			var objsel=document.getElementById("selectz"+i);
			objsel.checked=setvalue;
			pogflag=1
		}
	}
}
function clearWindow()
{
	//alert(window.document.location.href)
var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.ChemAudit"
window.document.location.href=lnk
 //window.reload()
	}
function SetPurview()
{
	var objy=document.getElementById("CheckedY");
	var objpass=document.getElementById("aupass");
	//var objpassHL=document.getElementById("tPassAuditHL");
	//var objpassTPN=document.getElementById("tPassAuditTPN");
	
	var objrefu=document.getElementById("refuse");
	var objplabe=document.getElementById("bPrintLabel");
	var objplist=document.getElementById("bPrintList");
	var objbcancp=document.getElementById("bCancelPass")
	var objMedicinePresc=document.getElementById("MedicineInfo");
	var objDaTongPresc=document.getElementById("DaTongPresc");
	if (objy.checked==true) {
		websys_disable(objpass);
		websys_disable(objrefu);
		websys_enable(objbcancp);
		websys_disable(objMedicinePresc);
		websys_disable(objDaTongPresc);
	}
	else {
		websys_enable(objpass);
		websys_enable(objrefu);
		websys_disable(objbcancp);
		websys_enable(objMedicinePresc);
		websys_enable(objDaTongPresc);
	}
}
///审核---------
function passPT()
{
	
	passOrdItems("");
}
function passHL()
{
	passOrdItems("HL");
}
function passTPN()
{
	passOrdItems("TPN");
}

function passOrdItemsOLD(ptype)
{

 	if (!confirm(t['CONFIRM_PASS'])) {return;}
 	var exe;
 	var obj=document.getElementById("mSetPass");
 	if (obj) exe=obj.value;
 	else exe="";
 	var oeori;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objx=document.getElementById("oeori"+"z"+i);
			if (objx) oeori=objx.value ;
    		var ret=cspRunServerMethod(exe,oeori,session['LOGON.USERID'],'SHTG',ptype)
   		}
 	}
 	find_click();
}

function passOrdItems()
{
 	var exe;
 	var oectype="";
 	var obj=document.getElementById("tOecType");
 	if (obj) var oectype=obj.value;
 	var obj=document.getElementById("mSetPass");
 	if (obj) exe=obj.value;
 	else exe="";
 	var oeori;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj);
	if(cnt==0){
		alert("明细无数据!")
		return;
	}
 	if (!confirm(t['CONFIRM_PASS'])) {return;}
	var snum=0;
 	var i;
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objx=document.getElementById("oeori"+"z"+i);
			if (objx) oeori=objx.value ;
			var objcatdr=document.getElementById("Tdrugcatdr"+"z"+i);
			if (objcatdr) 
			{
				if (oectype=="")
				{
                  catdr=objcatdr.value ;
				}
				else
				{
				  catdr=oectype ;
				}
			}
    		var ret=cspRunServerMethod(exe,oeori,session['LOGON.USERID'],'SHTG',catdr)
    		snum=snum+1;
   		}
 	}
 	if(snum==0){
	 	alert("请选择一条记录")
	 	return;
 	}
 	find_click();
}
function bCancelPassClick()
{
 	var exe;
 	var obj=document.getElementById("mSetPass");
 	if (obj) exe=obj.value;
 	else exe="";
 	var oeori;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
	if(cnt==0){
		alert("明细无数据!")
		return;
	}
	if (!confirm(t['CONFIRM_CancelPASS'])) {return;}
	var snum=0;
 	var i;
 	var bed="";
 	var itmdesc="";
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objx=document.getElementById("oeori"+"z"+i);
			if (objx) oeori=objx.value ;
    		var ret=cspRunServerMethod(exe,oeori,'','')
    		if ((ret==100)||(ret==101)){
	    		var objbed=document.getElementById("bed"+"z"+i);
	    		if (objbed) bed=objbed.innerText;
	    		var objitm=document.getElementById("arcimdesc"+"z"+i);
	    		if (objitm) itmdesc=objitm.innerText;
	    		if (ret==100){
	    			alert(t['INFO_PIVA']+"第"+i+"行 床号:"+bed+" 医嘱:"+itmdesc);
	    		}else if (ret==101){
		    		alert("医嘱已排批!"+"第"+i+"行 床号:"+bed+" 医嘱:"+itmdesc);
		    	}
    		}
    		snum=snum+1;
   		}
 	}
 	if(snum==0){
	 	alert("请选择需要取消审核的记录!")
	 	return;
 	}
 	find_click();
}


function RefuseOrdItems()
{
 	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
	if(cnt==0){
		alert("明细无数据!")
		return;
	}
 	if (!confirm(t['CONFIRM_REFUSE'])) {return;}
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.OPREASON&opType=P','','dialogHeight:380px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:yes')
	if (resondr=="") 
	{
		alert("错误提示:选择审核不通过原因后重试...")
		return;
	}
 	var exe;
 	var oectype="";
 	var obj=document.getElementById("tOecType");
 	if (obj) var oectype=obj.value;
 	var obj=document.getElementById("mSetPass");
 	if (obj) exe=obj.value;
 	else exe="";
 	var oeori;
	var snum=0;
 	var i;
 	for (i=1;i<=cnt;i++)
 	{
   		var obj=document.getElementById("select"+"z"+i);
   		if (obj.checked)
   		{
    		var objx=document.getElementById("oeori"+"z"+i);
    		if (objx) oeori=objx.value ;
    		var objcatdr=document.getElementById("Tdrugcatdr"+"z"+i);
			if (objcatdr) 
			{
				if (oectype=="")
				{
                  catdr=objx.value ;
				}
				else
				{
				  catdr=objcatdr.value ;
				}
			}
			var ret=cspRunServerMethod(exe,oeori,session['LOGON.USERID'],'SHJJ',catdr,resondr)
			snum=snum+1
   		}
	}
	if(snum==0){
	 	alert("请选择一条记录")
	 	return;
 	}
	find_click();
}

function RefuseOrdItemsNEW()
{
 	if (!confirm(t['CONFIRM_REFUSE'])) {return;}
 	var exe;
 	var oectype="";
 	var obj=document.getElementById("tOecType");
 	if (obj) var oectype=obj.value;
 	var obj=document.getElementById("mSetPass");
 	if (obj) exe=obj.value;
 	else exe="";
 	var oeori;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
 	var i;
 	for (i=1;i<=cnt;i++)
 	{
   		var obj=document.getElementById("select"+"z"+i);
   		if (obj.checked)
   		{
    		var objx=document.getElementById("oeori"+"z"+i);
    		if (objx) oeori=objx.value ;
    		var objcatdr=document.getElementById("Tdrugcatdr"+"z"+i);
			if (objcatdr) 
			{
				if (oectype=="")
				{
                                  catdr=objx.value ;
				}
				else
				{
				  catdr=objcatdr.value ;
				}
			}
			var ret=cspRunServerMethod(exe,oeori,session['LOGON.USERID'],'SHJJ',catdr)
   		}
	}
	find_click();
}

function FindClick()
{
	if (ChkFindCondition()==false) return;
	find_click();
}
 /// 检查查询条件
function ChkFindCondition()
{
	var obj;
	obj=document.getElementById("recloc") ;
	if (obj){
		if (obj.value==""){
		    alert(t["NO_DISPLOC"]);
	   	    return false;
	   	}
	}
	var reg=document.getElementById("regno").value;
	var ward=document.getElementById("tWardID").value;
	//if ((reg=="")&&(ward=="")){
	if ((ward=="")){
		//alert(t['NO_WARDREGNO']);
		alert("请选择病区！");
		return false;
	}
	var bottomFrame=parent.frames['DHCST.PIVA.CHEMAUDITM'];
	var pStartDateObj=bottomFrame.document.getElementById("tStartDate")
	var pEndDateObj=bottomFrame.document.getElementById("tEndDate")
	
	var obj1=document.getElementById("sd") ;
	obj1.value=pStartDateObj.value;
	if (obj1.value=="" ){
		alert(t['NO_STARTDATE']);
	  	return false;
	}
	var obj2=document.getElementById("ed") ;
	obj2.value=pEndDateObj.value;
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
/// 打印拒绝标签
function PrintLabelClick()
{
	if (!confirm(t['CONFIRM_PLABEL'])) {return;}
	var cnt=0;
	var pmoeori="";
	var ret;
	var num=0;	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	for (var i=1;i<objtbl.rows.length; i++) {
		var cell=document.getElementById("selectz"+i)
		var audit=document.getElementById("auditstatusz"+i).innerText
		if ((cell.checked==true)&(audit=="审核拒绝")){
			var moeori=document.getElementById("mOeoriz"+i).value;
			if (moeori!=pmoeori){
				pmoeori=moeori;
				var pogstr=CspRunGetPogPrintM(moeori)
				if (pogstr==""){
					alert(t['ERR_GETPRINTM']);
					return;
				}
				var pogistr=CspRunGetPogPrintI(moeori)
				if (pogistr==""){
					alert(t['ERR_GETPRINTI']);
					return;
				}
				var ret=PrintLabel(pogstr,pogistr,"");
				if (ret==false) {return;}
			}
		}
	}
}
/// 打印标签
function PrintLabel(pogstr,pogistr,stype)
{
	if (pogstr=="") return false;
	if (pogistr=="") return false;
	var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
	if (!Bar) return false;
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var Hospname=cspRunServerMethod(encmeth,'','');
	Bar.Device="tiaoma";
	Bar.PageWidth=75;
	Bar.PageHeight=90;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	Bar.Title=Hospname+"输液单";
	Bar.HeadType=stype;
	Bar.IfPrintBar="false";
	Bar.BarFontSize=18;
	Bar.BarTop=75;
	Bar.BarLeftMarg=5;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=12;
	Bar.ItmCharNums=26; //药名每行显示的字符数
	Bar.ItmOmit="false";	//药品名称是否取舍只打印一行
	Bar.PageMainStr=pogstr;	// 打印标签医嘱信息
	Bar.PageItmStr=pogistr;	// 打印标签药品信息
	Bar.PageLeftMargine=1;
	Bar.PrintDPage();
	return true;
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
function PrintListClick()
{
	if (!confirm(t['CONFIRM_PLIST'])) {return;}
	try
	{
	var ploc="";
	var sd="";
	var ed="";
	var hospname="";
	var currow;
	var i;
	var j;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
	var rowcount=getRowcount(objtbl);
	if (rowcount<=0){return ;}
	var startRow=5;
	var cols=9;
	var pagerows=32;
	var prnpath=getPrnPath();
	var Template=prnpath+"DHCST_PIVA_PASSREFUSE.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	var obj=document.getElementById("mPrtHospName");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var hospname=cspRunServerMethod(encmeth,'','');
    
	var obj=document.getElementById("recloc") ;
	if (obj) ploc=obj.value;
	if(ploc!=""){
		var ploc1=ploc.split("-");
		if(ploc1.length>1){var ploc=ploc1[1]};
	}
	var obj=document.getElementById("sd") ;
	if (obj) sd=obj.value;
	var obj=document.getElementById("ed") ;
	if (obj) ed=obj.value;
	///
	xlsheet.Cells(1,1).Value =hospname+"PIVAS配伍审核拒绝明细表"
	xlsheet.Cells(2,1).Value ="日期:"+(sd)+"至"+(ed);
	xlsheet.Cells(3,1).Value = "配液科室:"+ploc;
	for (i=1;i<=pagerows;i++){
		for (j=1;j<=cols;j++){
			currow=i+startRow-1
			xlsheet.Cells(currow,j).Borders(1).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(2).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(3).LineStyle = 0;
			xlsheet.Cells(currow,j).Borders(4).LineStyle = 0;
		}
	}
	currow=0;
	var sttdate="";
	var patname="";
	var arcname="";
	var freq="";
	var inst="";
	var dosage="";
	var dosunit=""
	var doctor="";
	var weight="";
	var ward=""
	for (i=1;i<=rowcount;i++){
		var cell=document.getElementById("selectz"+i)
		var audit=document.getElementById("auditstatusz"+i).innerText
		if ((cell.checked==true)&(audit=="审核拒绝")){
			if (currow==0){currow=startRow;}
			else {currow=currow+1}
			var obj=document.getElementById("ward"+"z"+i) ;
			if (obj) ward=obj.innerText;
			if(ward!=""){
				var ward1=ward.split("-");
				if(ward1.length>1){var ward=ward1[1]};
			}
			var obj=document.getElementById("sttdate"+"z"+i) ;
			if (obj) sttdate=obj.innerText;
			var obj=document.getElementById("paname"+"z"+i) ;
			if (obj) patname=obj.innerText;
			var obj=document.getElementById("arcimdesc"+"z"+i) ;
			if (obj) arcname=obj.innerText;
			var obj=document.getElementById("freq"+"z"+i) ;
			if (obj) freq=obj.innerText;
			var obj=document.getElementById("instr"+"z"+i) ;
			if (obj) inst=obj.innerText;
			var obj=document.getElementById("doseqty"+"z"+i) ;
			if (obj) dosage=obj.innerText;
			var obj=document.getElementById("doseunit"+"z"+i) ;
			if (obj) dosunit=obj.innerText;
			var obj=document.getElementById("useradd"+"z"+i) ;
			if (obj) doctor=obj.innerText;
			var obj=document.getElementById("weight"+"z"+i) ;
			if (obj) weight=obj.innerText;
			ward=ward.substring(0,8);
			xlsheet.Cells(currow,1).Value=sttdate;
			xlsheet.Cells(currow,2).Value=patname;
			xlsheet.Cells(currow,3).Value=arcname;
			xlsheet.Cells(currow,4).Value=freq;
			xlsheet.Cells(currow,5).Value=inst;
			xlsheet.Cells(currow,6).Value=dosage+dosunit;
			xlsheet.Cells(currow,7).Value=doctor;
			xlsheet.Cells(currow,8).Value=weight;
			xlsheet.Cells(currow,9).Value=ward;
		}
	}
	if (currow>0) {xlsheet.printout();}
    SetNothing(xlApp,xlBook,xlsheet);
	}
	catch(e)
	{
		alert(e.message);
		xlBook.Close (savechanges=false);
		xlApp.Quit();
	}
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



function StartDaTongDll()
{
	dtywzxUI(0,0,"");
}

function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
   return result;
}

function GetSinglePrescByDaTong()
{
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
 	var i;
    var ordstr="";
    var tmpmord="";
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objm=document.getElementById("mOeori"+"z"+i);
		    var mord=objm.value;
		    if ((tmpmord!="")&&(tmpmord!=mord))
		    {alert("只能选择单组液体!");return;}
		    var tmpmord=mord;
			var objx=document.getElementById("oeori"+"z"+i);
			var oeori=objx.value;
			if (ordstr==""){ordstr=oeori}
			else{ordstr=ordstr+"^"+oeori}
            
   		}	
 	}
 	//alert(ordstr)
 	if (ordstr!="")
 	{
	 	 //dtywzxUI(0,0,"");
         dtywzxUI(3,0,"");
         var objDaTongPresc=document.getElementById("mDaTongPresc");
		 if (objDaTongPresc) {var encmeth1=objDaTongPresc.value;} else {var encmeth1='';}
		 var myPrescXML=cspRunServerMethod(encmeth1,ordstr);
         myrtn=dtywzxUI(28676,1,myPrescXML);
         //alert(myrtn)
         var objPid=document.getElementById("tPid"+"z"+1);
         var pid=objPid.value;
         killTMPafterGetGetDaTong(pid)
         //dtywzxUI(1,0,"");
         
	 	}
 	
}
function GetDaTong()
{
	alert("暂未开放,需和第三方合理软件商联系")
	return;
    var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
    
    //dtywzxUI(0,0,"");
    dtywzxUI(3,0,"");
    var oeori="" ;
    var seqno=""
    var passordstr="" ;
    
    var objPid=document.getElementById("tPid"+"z"+1);
    var pid=objPid.value;
  
    var objtmp=document.getElementById("mListPassOrd");
    if (objtmp) {var encmeth=objtmp.value;} else {var encmeth='';}
    
    do 
       {
          var myrtn=""
	      //var passordstr=cspRunServerMethod(encmeth,pid,oeori);
	      var passordstr=cspRunServerMethod(encmeth,pid,seqno);
	      if (passordstr!="")
	      {
		      if (passordstr.indexOf("#")>-1)
		      {
			          dtywzxUI(3,0,"");
				      var  tmpstr=passordstr.split("#")
				      var  passrow=tmpstr[0];
				      var  ordstr=tmpstr[1];
				      var  seqno=passrow;
				      var objDaTongPresc=document.getElementById("mDaTongPresc");
					  if (objDaTongPresc) {var encmeth1=objDaTongPresc.value;} else {var encmeth1='';}
					  var myPrescXML=cspRunServerMethod(encmeth1,ordstr);
					  
					  //if (ordstr=="1088230||417"){ alert(ordstr)}
					  
					  myrtn=dtywzxUI(28676,1,myPrescXML);
					  
					  //if (ordstr=="1088230||417"){ alert(myrtn)}
					  
					  var ret=""
					  if (myrtn==0) {ret="正常"}
					  if (myrtn==1) {ret="一般问题"}
					  if (myrtn==2) {ret="严重问题"}
					  
					  
					  var obj=document.getElementById("tPassCheck"+"z"+passrow)
					  obj.innerText=ret
					  
			      	  var tmpordstr=ordstr.split("^")
		              var oeori=tmpordstr[0]
		              
		      }
		      
	      }
	      else
	      
	      { oeori="" } ;
		  

       }while (oeori!="")
	   killTMPafterGetGetDaTong(pid)
     //dtywzxUI(1,0,"");
}

function GetDaTongYDTS()
{
 	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var objx=document.getElementById("oeori"+"z"+row);
	var oeori=objx.value;
	if (oeori==""){return;}
	//dtywzxUI(0,0,"");
  dtywzxUI(3,0,"");
  var objDaTongPresc=document.getElementById("mDaTongYDTS");
  if (objDaTongPresc) {var encmeth1=objDaTongPresc.value;} else {var encmeth1='';}
	var myPrescXML=cspRunServerMethod(encmeth1,oeori);
	//myrtn=dtywzxUI(4108,0,myPrescXML);
  myrtn=dtywzxUI(12,0,myPrescXML);
  //dtywzxUI(1,0,"");
}

function killTMPafterGetGetDaTong(pid)
{
	var objClearDaTong=document.getElementById("mClearDaTongTmp");
	if (objClearDaTong) {var encmeth1=objClearDaTong.value;} else {var encmeth1='';}
	var ret=cspRunServerMethod(encmeth1,pid);
	
}


function setUnVisible()
{	
    
	var objnotaudit=document.getElementById("tNotAudit");	
	var objaupass=document.getElementById("aupass");
	var objrefuse=document.getElementById("refuse");
	var objbCancelPass=document.getElementById("bCancelPass");
	var objMedicinePresc=document.getElementById("MedicineInfo");
	var objDaTongPresc=document.getElementById("DaTongPresc");
	if(objnotaudit)
	{
		if(objnotaudit.checked==true){
			objDaTongPresc.disabled=false;
			objMedicinePresc.disabled=false;
			objaupass.disabled=false;
			objrefuse.disabled=false;
			objbCancelPass.disabled=true;
			}
	    else
		{
			objDaTongPresc.disabled=true;
			objaupass.disabled=true;
			objrefuse.disabled=true;
			objbCancelPass.disabled=false;
			objMedicinePresc.disabled=true;
		}
	}
}



///************Start 美康接口部分******************
///美康药品信息显示
function GetMedInfo(flag)
{
   //var str="<div id='service'"+" style="+"behavior: url('webservice.htc')"+"></div>"
	//document.write(str) 
   var oeoriobj=document.getElementById("oeori"+"z"+CurSelRow) ;
   var oeori=oeoriobj.value
   var obj=document.getElementById("mGetMedInfo");
   if (obj) {var encmeth=obj.value;} else {var encmeth='';}
   var medinfo=cspRunServerMethod(encmeth,oeori);
   
   var medarr=medinfo.split("^");
   var OrderARCIMCode=medarr[0];
   var OrderName=medarr[1];
   var OrderDoseUOM=medarr[2];
   var OrderInstrDesc=medarr[3];
   var OrderInstrCode=medarr[4];
   
   var dqi = new Params_GetDrugQueryInfo_In();
   dqi.DrugType = "USER_Drug" ;
   dqi.RouteType = "USER" ;
   dqi.DrugCode = OrderARCIMCode; 	//药品编码
   dqi.DrugName = OrderName;		//药品名称
   dqi.DoseUnit = OrderDoseUOM;		//给药单位
   dqi.RouteDesc = OrderInstrDesc;	//给药途径名称
   dqi.RouteID  = OrderInstrCode;	//给药途径编号和给药途径名称一样
   //self.parent.event=self.event
   McDrugQueryInfoModel = dqi;
   //alert(self.window.event.clientX);
   //self.parent.window.event.clientX=1
  // OnMouseOverPopInfoWindow(-2);
    if (flag==1)
    {
	   OnMouseOverPopInfoWindow(-2); 
    }
    
    if (flag==2)
    {
	   FuncDirections(); 
    }
		
}
function testMK1()
{
	
	MKXHZY1(1)
}


///美康相互作用
function MKXHZY1(Flag){
	var Orders="";
	var Para1=""
	
	var oeori=""
	var oeoriobj=document.getElementById("mOeori"+"z"+CurSelRow) ;
    if (oeoriobj)var oeori=oeoriobj.value
   
    if (oeori=="") {return};
    
    var obj=document.getElementById("mMKXHZY");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
    var ret=cspRunServerMethod(encmeth,oeori);
	 
    var TempArr=ret.split(String.fromCharCode(2));
    var PatInfo=TempArr[0];
    var MedCondInfo=TempArr[1];
    var AllergenInfo=TempArr[2];
    var OrderInfo=TempArr[3];
    
 
	var PatArr=PatInfo.split("^");
	var ppi = new Params_Patient_In();
	ppi.PatID = PatArr[0];			// 病人编码
	ppi.PatName = PatArr[1];		// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birth = PatArr[3];			// 出生年月
	ppi.UseTime = PatArr[4];		// 使用时间
	ppi.Height = PatArr[5];			// 身高
	ppi.Weight = PatArr[6];			// 体重
	ppi.VisitID = PatArr[7];		// 住院次数
	ppi.Department = PatArr[8];	    // 住院科室
	ppi.Doctor = PatArr[9];			// 医生
	ppi.OutTime = PatArr[10];		// 出院时间
	McPatientModel = ppi;
    
    //alert(ppi.PatID+","+ppi.PatName+","+ppi.Sex+","+ppi.Birth+","+ppi.UseTime+","+ppi.Height+","+ppi.Weight+","+ppi.VisitID+","+ppi.Department+","+ppi.Doctor+","+ppi.OutTime)	
    
    var arrayObj = new Array();
	var pri;
  
    var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
    McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++)
	{  
        //alert(OrderInfoArr[i]) 
	    var OrderArr=OrderInfoArr[i].split("^");
		 
        pri = new Params_Recipe_In();
				
		//传给core的?并且由core返回变灯的唯一编号?构造的灯div的id也应该和这个相关联
        pri.Index = OrderArr[0];

        pri.DrugCode = OrderArr[1]; 		//药品唯一码
        pri.DrugName = OrderArr[2]; 		//药品名称
        pri.SingleDose =OrderArr[3]; 	//每次用量
        
        pri.DoseUnit = OrderArr[4]; 		//给药单位
        pri.Frequency = OrderArr[5]; 	//用药频次(次/天)
        pri.StartDate = OrderArr[6]; 	//开始时间?格式yyyy-mm-dd
        pri.EndDate = OrderArr[7]; 		//结束时间?格式?yyyy-mm-dd
        pri.RouteDesc = OrderArr[8]; 	//给药途径名称
        pri.RouteID = OrderArr[9]; 		//给药途径编号?同给药途径名称
        pri.GroupTag = OrderArr[10]; 		//成组标记
        pri.IsTemporary = OrderArr[11]; //是否为临时医嘱  1-临时医嘱 0-长期医嘱
        pri.Doctor = OrderArr[12]; 			//医生姓名
        
        //alert(pri.Index+","+pri.DrugCode+","+pri.SingleDose+","+pri.DoseUnit+","+pri.Frequency+","+pri.StartDate+","+pri.EndDate+","+pri.RouteDesc+","+pri.RouteID+","+pri.GroupTag+","+pri.IsTemporary+","+pri.Doctor)	

                /*
				if (Flag==0){
								var obj=websys_getSrcElement(window.event);
								var id=obj.parentElement.id
								var TempArr=id.split("z");
								var Row=TempArr[1];
								var SeqNo=GetColumnData("seqno",1);	
								
		        	            if (pri.Index==SeqNo) pri.WarningTag = "1";
		                     }
		           */
        arrayObj[arrayObj.length] = pri;
	}
	McRecipeDataList = arrayObj;
    
    
	var arrayObj = new Array();
	var pal;
  
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++)
	{
		var AllergenArr=AllergenInfoArr[i].split("^");
        pal = new Params_Allergen_In();
        pal.Index = i; 						//过敏源处方顺序编号?以0开始的唯一索引号?
        pal.AllergenCode = AllergenArr[0]; 	//过敏源编码
        pal.AllergenDesc = AllergenArr[1]; 	//过敏源名称
        pal.AllergenType = AllergenArr[2]; 	//过敏源类型
        pal.Reaction = AllergenArr[3]; 			//过敏症状

        arrayObj[arrayObj.length] = pal;
	}
	//McAllergenDataList = arrayObj;
 
    //alert(pal.Index+","+pal.AllergenCode+","+pal.AllergenDesc+","+pal.AllergenType+","+pal.Reaction)	

 
	//病生状态类数组
	var arrayObj = new Array();
	var pmi;
 
    var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
    

	for(var i=0; i<MedCondInfoArr.length ;i++)
	{	
	    		
		var MedCondArr=MedCondInfoArr[i].split("^");
        pmi = new Params_MedCond_In();
        pmi.Index = i; 	//顺序编号?以0开始的唯一索引号?
        pmi.MedCondCode = MedCondArr[0]; 	//疾病编码
        pmi.MedCondDesc = MedCondArr[1]; 	//疾病名称
        pmi.MedCondType = MedCondArr[2]; 	//疾病类型
        pmi.StartDate = MedCondArr[3]; 		//开始时间
        pmi.StopDate = MedCondArr[4]; 			//结束时间
        pmi.VocabTypeCode = MedCondArr[5];	//疾病Vocab类型编码
        arrayObj[arrayObj.length] = pmi;
	}
	//McMedCondDataList = arrayObj;
	//WebServiceInitCheck();
    //alert(pmi.Index+","+pmi.MedCondCode+","+pmi.MedCondDesc+","+pmi.MedCondType+","+pmi.StartDate+","+pmi.StopDate+","+pmi.VocabTypeCode)	
	if (Flag==0) FuncSingleRecipeCheck(0);
    //alert("flag"+Flag)
	if (Flag==1) FuncRecipeCheck(0,2); //标准审查  FuncRecipeCheckNoLightDiv(0,2)    //
	
	//if (Flag==2) FuncRecipeCheck(0,1); //简洁模式审查
	//if (Flag==3) FuncRecipeCheck(7,2); //妊娠期审查
	//if (Flag==4) FuncRecipeCheck(5,2); //哺乳期审查

}

function testMK()
{
	alert("暂未开放,需和第三方合理软件商联系")
	return;
	var obj=document.getElementById("mMKXHZY");
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 	var oeori;
 	var tmpoeori="" ;
	var obj=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT")
	var cnt=getRowcount(obj)
 	var i;
	for (i=1;i<=cnt;i++)
 	{
		var obj=document.getElementById("select"+"z"+i);
		if (obj.checked)
		{
			var objx=document.getElementById("mOeori"+"z"+i) ;
			if (objx) oeori=objx.value ;
			if (oeori!=tmpoeori)
			{
				tmpoeori=oeori
				var retstr=cspRunServerMethod(encmeth,oeori);
				MKXHZY(retstr,2)    //lgl 简洁模式 只亮灯
			}
    		
   		}
 	}

}
///美康相互作用
function MKXHZY(retstr,Flag){
	var Orders="";
	var Para1=""
	//if ( typeof(CurSelRow) ==  "undefined") return; 

	//var oeoriobj=document.getElementById("mOeori"+"z"+CurSelRow) ;
    //var oeori=oeoriobj.value
 
    var TempArr=retstr.split(String.fromCharCode(2));
    var PatInfo=TempArr[0];
    var MedCondInfo=TempArr[1];
    var AllergenInfo=TempArr[2];
    var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	var ppi = new Params_Patient_In();
	ppi.PatID = PatArr[0];			// 病人编码
	ppi.PatName = PatArr[1];		// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birth = PatArr[3];			// 出生年月
	ppi.UseTime = PatArr[4];		// 使用时间
	ppi.Height = PatArr[5];			// 身高
	ppi.Weight = PatArr[6];			// 体重
	ppi.VisitID = PatArr[7];		// 住院次数
	ppi.Department = PatArr[8];	    // 住院科室
	ppi.Doctor = PatArr[9];			// 医生
	ppi.OutTime = PatArr[10];		// 出院时间
	McPatientModel = ppi;

    var arrayObj = new Array();
	var pri;
  
    var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
    McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++)
	{   
	    var OrderArr=OrderInfoArr[i].split("^");
		 
        pri = new Params_Recipe_In();
				
		//传给core的?并且由core返回变灯的唯一编号?构造的灯div的id也应该和这个相关联
        pri.Index = OrderArr[0];

        pri.DrugCode = OrderArr[1]; 		//药品唯一码
        pri.DrugName = OrderArr[2]; 		//药品名称
        pri.SingleDose = OrderArr[3]; 	//每次用量
        
        pri.DoseUnit = OrderArr[4]; 		//给药单位
        pri.Frequency = OrderArr[5]; 	//用药频次(次/天)
        pri.StartDate = OrderArr[6]; 	//开始时间?格式yyyy-mm-dd
        pri.EndDate = OrderArr[7]; 		//结束时间?格式?yyyy-mm-dd
        pri.RouteDesc = OrderArr[8]; 	//给药途径名称
        pri.RouteID = OrderArr[9]; 		//给药途径编号?同给药途径名称
        pri.GroupTag = OrderArr[10]; 		//成组标记
        pri.IsTemporary = OrderArr[11]; //是否为临时医嘱  1-临时医嘱 0-长期医嘱
        pri.Doctor = OrderArr[12]; 			//医生姓名

                /*
				if (Flag==0){
								var obj=websys_getSrcElement(window.event);
								var id=obj.parentElement.id
								var TempArr=id.split("z");
								var Row=TempArr[1];
								var SeqNo=GetColumnData("seqno",1);	
								
		        	            if (pri.Index==SeqNo) pri.WarningTag = "1";
		                     }
		           */
        arrayObj[arrayObj.length] = pri;
	}
	McRecipeDataList = arrayObj;
    
    
	var arrayObj = new Array();
	var pai;
	
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++)
	{
		var AllergenArr=AllergenInfoArr[i].split("^");
        pai = new Params_Allergen_In();
        pai.Index = i; 						//过敏源处方顺序编号?以0开始的唯一索引号?
        pai.AllergenCode = AllergenArr[0]; 	//过敏源编码
        pai.AllergenDesc = AllergenArr[1]; 	//过敏源名称
        pai.AllergenType = AllergenArr[2]; 	//过敏源类型
        pai.Reaction = AllergenArr[3]; 			//过敏症状

        arrayObj[arrayObj.length] = pai;
	}
	McAllergenDataList = arrayObj;

	//病生状态类数组
	var arrayObj = new Array();
	var pmi;
 
    var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));

	for(var i=0; i<MedCondInfoArr.length ;i++)
	{			
		var MedCondArr=MedCondInfoArr[i].split("^");
        pmi = new Params_MedCond_In();
        pmi.Index = i; 	//顺序编号?以0开始的唯一索引号?
        pmi.MedCondCode = MedCondArr[0]; 	//疾病编码
        pmi.MedCondDesc = MedCondArr[1]; 	//疾病名称
        pmi.MedCondType = MedCondArr[2]; 	//疾病类型
        pmi.StartDate = MedCondArr[3]; 		//开始时间
        pmi.StopDate = MedCondArr[4]; 			//结束时间
        pmi.VocabTypeCode = MedCondArr[5];	//疾病Vocab类型编码
        arrayObj[arrayObj.length] = pmi;
	}
	McMedCondDataList = arrayObj;
	
	if (Flag==0) FuncSingleRecipeCheck(0);
	if (Flag==1) FuncRecipeCheck(0,2); //标准审查
	if (Flag==2) FuncRecipeCheck(0,1); //简洁模式审查
	if (Flag==3) FuncRecipeCheck(7,2); //妊娠期审查
	if (Flag==4) FuncRecipeCheck(5,2); //哺乳期审查
}

function ChangeRowStyle()
{
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT") ;
	for (var i=0;i<objtbl.rows.length; i++) 
	{
	 var RowObj=objtbl.rows[i];
     var Id="OrderLightz1"
        if (i==0){
	        	//var str="<div id="+"service"+" style="+"behavior: url('webservice.htc')"+"></div>"
                
                //alert(str)
                //RowObj.cells[1].innerHTML=str;

        }
        else{
          if (!RowObj.cells[1].firstChild) {continue} 
		  var Id=RowObj.cells[1].firstChild.id;
		  var arrId=Id.split("z");
		  var objindex=arrId[1];
		  var objwidth=RowObj.cells[1].style.width;
		  var objheight=RowObj.cells[1].style.height;
		  var IMGId="ldi"+Id;
    
			/*
			1.RowObj.cells[i]本身是个对象,本身有Style属性,里面可以包含多个element(HIDDEN TableItem就全放在了一个Cell中)
			2.cells[j].firstChild是Cell里的第一个element,如果为label的话就没有type属性
			3.将element的类型改变,实际上是改变Cell的innerHTML,因为element.style是不允许改变的
            4.只有列不为Display only?不一定会有Style属性(可以参见网页源码),所以最好只将Display Only的列变为可编辑时候
              对innerHTML属性进行重新定义,否则容易造成列自动变为一个默认长度
            */
			if (arrId[0]=="OrderLight"){
				//var SeqNo=document.getElementById("seqno"+"z"+i).innerText ;
				var oeori=document.getElementById("oeori"+"z"+i).value;
                oeori2=oeori.replace("||",".")
				var str="<label id=\""+Id+"\" name=\""+Id+ "\"><div id=\"McRecipeCheckLight_" + oeori2 + "\" name=\"McRecipeCheckLight\" class=\"DdimRemark_null\"  onclick = \"MKXHZY1(1);\"></div>";
                RowObj.cells[1].innerHTML=str;     //lgl 没有走j循环 警示灯 必须是第一列
                //alert(RowObj.cells[1].innerHTML)
            
			}
        }
	}
	
}
function CreateHisRecipeDataList()
{
        var ppi = new Params_Patient_In();
        ppi.PatID = "Maya1122";		// 病人编码
        ppi.PatName = "老马";	    // 病人姓名
        ppi.Sex = "男";		        // 性别
        ppi.Birth = "2010-05-06";   // 出生年月
        ppi.UseTime = "";	        // 使用时间
        ppi.Height = "177";		    // 身高
        ppi.Weight = "77";		    // 体重
        ppi.VisitID = "1";	        // 住院次数
        ppi.Department = "";	    // 住院科室
        ppi.Doctor = "";		    // 医生
        ppi.OutTime = "";           // 出院时间
        McPatientModel = ppi;
        
        var arrayObj = new Array();
        var pri;
        for(var i=0; i<1;i++)
        {    
            pri = new Params_Recipe_In();
            
            pri.Index = "Recipe_0";
            pri.DrugCode = "810979920001011006511";pri.DrugType = "DrugName";
            pri.DrugName = "氟康唑片";
            pri.DoseForm = "";
            pri.Strength = "";
            pri.StrengthUnit = "G";
            pri.SingleDose = "1000";
            pri.DoseUnit = "G";
            pri.StartDate = "2010-1-1 10:00:00";
            pri.EndDate = "";
            pri.Frequency = "TID";
            pri.Duration = "";
            pri.RouteID = "127";pri.RouteType = "DIF";
            pri.RouteDesc = "口服";
            pri.DoseTypeID = "";
            pri.MedCondCode = "";
            pri.MedCondDesc = "";
            pri.VocabTypeCode = "";
            pri.MedCondType = "";
            pri.GroupTag = "1";
            pri.WarningTag = "";
            pri.IsTemporary = "0";
            pri.Doctor = "07/马彦";
            if(!document.getElementById("cbxSelectDrugType").checked)
            {//用户数据
                pri.DrugCode = "0301000379";pri.DrugType = "USER_Drug";
                pri.RouteID = "口服";pri.RouteType = "USER";
            }
            arrayObj[arrayObj.length] = pri;
        }
        McRecipeDataList = arrayObj;

}
    
function SelectRowHandler()
{
   CurSelRow=selectedRow(window)
   
  //var set = tkMakeServerCall("web.DHCSTKUTIL", "SetSession","PIVA.ADTPATID","123");
  // alert(set)
  
   
}
function tbDbClick(e)
{

 var i=selectedRow(window);
 if (!i) return;
 if (i<1) return;
  var obj=websys_getSrcElement(e);
  var selindex=obj.id;
  var ss;
  ss=selindex.split("z");

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="arcimdesc")
			 { 
	             var obj=document.getElementById("arcimdesc"+"z"+i);
				 if (obj) 
				 { 
				    GetMedInfo(2);
				 }
			 }
             
            if (ss[0]=="bed")
			 { 
	             var obj=document.getElementById("bed"+"z"+i);
				 if (obj) 
				 { 
				    GetMedInfo(1);
				 }
			 }
		 
	   }
	   
	  
}
///***********End 美康部分处理函数******************




document.body.onload=BodyLoadHandler;
