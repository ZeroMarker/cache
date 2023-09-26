/// DHCST.PIVA.STATARRAGE
/// 静脉配液中心-排药统计

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
		var objsdo = document.getElementById("tOrdStDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tOrdEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = eddate;
		}
		/*
		var objst = document.getElementById("tStartTime");
		if (objst){
			if (objst.value=="") objst.value = "00:00";
		}
		var objet = document.getElementById("tEndTime");
		if (objet){
			if (objet.value=="") objet.value = "23:59";
		}
		*/
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATARRAGE");
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
	if (obj) obj.onclick= FindClick;
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	var obj=document.getElementById("bPrint");
	if (obj) obj.onclick=PrintClick;
	
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
	
	
	
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
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
	var tblobj=document.getElementById("tDHCST_PIVA_STATARRAGE");
	if (tblobj) if (tblobj.rows.length-1!=0)
	{
		alert("请先清空数据后,再录入单号查询!")  
		document.getElementById("bClear").focus()
		return
	}
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
	ReloadWinow();
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
	/* 20080917 可以不选择病区进行统计
	var objward=document.getElementById("tWardID");
	if (objward.value=="") {
		alert(t['NO_WARD']);
		return false;
	}
	*/
	return true ;
}

///打印事件

function PrintClick()
{
	var pro=GetPsNumberPro(); ///是否单独执行

	var pogstring="";prtpog=""
	var tblobj=document.getElementById("tDHCST_PIVA_STATARRAGE");
	if (tblobj) if (tblobj.rows.length-1==0) {alert("没有打印数据!");return;}
    if (!confirm("确认打印吗")) return;
   
    var pid=0;
    var pidobj=document.getElementById("tbPIDz"+1);
    if (pidobj) pid=pidobj.value;
    
    var pog="";
    do {
			    var obj=document.getElementById("mGetArrData");
				if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
				var result=cspRunServerMethod(encmeth,pid,pog);
				pog=result
				
				if (pog!="")
				
				{
							var saveerr=0
							if (pro=="N") var saveerr=SavaData(pid,pog);   //执行排药状态
							//alert(pog)
							//alert(saveerr)
							if (saveerr==0)
							{
									if (pogstring=="")
									{
										pogstring=pog ;
									}
									else
									{
										pogstring=pogstring+"^"+pog ;
									}
							}
							
							if (prtpog=="")
							{
								prtpog=pog ;				
							}
							else
							{
								prtpog=prtpog+"^"+pog ;
							}
							
				}
				
	 
    }while (pog!="");
    
    if (pogstring=="") { pogstring=prtpog ;}
    
    //alert(pogstring)
    
    if (pogstring!="")      //打印排药单
    {
	    PrintArrData(pid,pogstring);
	  
    }
    
	CspRunClearAfterSave(pid);

	FindClick();
	
}
function GetPsNumberPro()
{
	var locid="";
	var objlocid = document.getElementById("tPLocID");
	if (objlocid) locid = objlocid.value;
	var psnumber="30";	//zhouyg 20151013 排药状态统一为30
    var obj=document.getElementById("mGetPsNumberPro");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var pro=cspRunServerMethod(encmeth,locid,psnumber);
	return pro;	
}

///打印排药单
function PrintArrData(pid,pogstring)
{
	           
        var cnt=GetPrtArrDataCount(pid,pogstring);
        if (cnt==0) {return;}
	    var startRow=5;
		var cols=4;
		var pagerows=30;
		var prnpath=getPrnPath();
		var Template=prnpath+"DHCST_PIVA_STATARR.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
		var hospname=getHospName();
		var ward=""
		var obj=document.getElementById("tWard") ;
		if (obj) ward=obj.value;
		if (ward!=""){
			if (ward.indexOf("-")>=0){
				var ward1=ward.split("-");
				var ward=ward1[1];
			}
		}
		
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
		var objst = document.getElementById("tStartTime");
		if (objst){
				if (objst.value=="") {objst.value = "00:00"};
				var st=objst.value 
			}
		var objet = document.getElementById("tEndTime");
			if (objet){
				if (objet.value=="") {objet.value = "23:59"};
				var et=objet.value 
			}
		var grp="";
		var objgrp = document.getElementById("tLocGrp");
		if (objgrp){var grp=objgrp.value;}
		var ptype="";
		var objtype = document.getElementById("tOecType");
		if (objtype){
			var ptype=objtype.value;
			if (ptype=="6") {ptype="抗微生物药"}
			if (ptype=="7") {ptype="抗肿瘤药"}
			if (ptype=="OTHER") {ptype="其它"}
		}
		var pivalocobj=document.getElementById("tPLoc");
		var pivalocdesc=""
		if (pivalocobj){
			pivalocdesc=pivalocobj.value;
			if (pivalocdesc.indexOf("-")>=0){
				pivalocdesc=pivalocdesc.split("-")[1];
			}
		}
		xlsheet.Cells(1,1).Value =hospname+pivalocdesc+"配液排药单"
		xlsheet.Cells(2,1).Value ="病区:"+ward+"    "+"科室组:"+grp+"    "+"配液分类:"+ptype+"    "+"日期:"+(sd)+" "+st+"至"+(ed)+" "+et;
		xlsheet.Cells(3,1).Value ="批次:"+batno+"    优先级:"+prio+"    打印单号:"+printno+"    打印人:"+session['LOGON.USERNAME']+"    打印日期:"+getPrintDateTime() //+formatDate2(getPrintDate())+" "+getPrintTime();
		for (i=1;i<=pagerows;i++){
			for (j=1;j<=cols;j++){
				currow=i+startRow-1
				xlsheet.Cells(currow,j).Borders(1).LineStyle = 0;
				xlsheet.Cells(currow,j).Borders(2).LineStyle = 0;
				xlsheet.Cells(currow,j).Borders(3).LineStyle = 0;
				xlsheet.Cells(currow,j).Borders(4).LineStyle = 0;
			}
		}



       for (h=1;h<=cnt;h++)
       {

            var retval=ListPrtArrData(pid,h) 
			currow=h+startRow-1
			var tmparr=retval.split("^")
			var qty=tmparr[4];
			var itmdesc=tmparr[2];
			var uom=tmparr[3];
			var stkbin=tmparr[0];
			xlsheet.Cells(currow,1).Value=h;
			xlsheet.Cells(currow,2).Value=itmdesc;
			xlsheet.Cells(currow,3).Value=qty;
			xlsheet.Cells(currow,4).Value=uom;
			xlsheet.Cells(currow,5).Value=stkbin;

	   }

	   xlsheet.printout();
       SetNothing(xlApp,xlBook,xlsheet);
       
       window.setInterval("Cleanup();",1); 
		
	
	
	
}

///获取打印记录数
function GetPrtArrDataCount(pid,pogstring)
{
	var obj=document.getElementById("mGetPrtArrData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var cnt=cspRunServerMethod(encmeth,pid,pogstring);
	return cnt;
}

///获取打印记录
function ListPrtArrData(pid,i)
{
	var obj=document.getElementById("mListPrtArrData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var retval=cspRunServerMethod(encmeth,pid,i);
	return retval;
	
}

///保存数据
function SavaData(pid,pog)
{
	
	var psnumber="30";
	var obj=document.getElementById("mSaveArrData");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,pid,pog,psnumber);
	return ret;
	
}

///保存数据后清除临时数据
function CspRunClearAfterSave(pid)
{
	var obj=document.getElementById("ClearTMP");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,pid);
	
}

///之前的打印备分
function PrintClickOld()
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
	var objtbl=document.getElementById("t"+"DHCST_PIVA_STATARRAGE");
	
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
	var ward=""
	var obj=document.getElementById("tWard") ;
	if (obj) ward=obj.value;
	if (ward!="")
	{
	var ward1=ward.split("-");
	var ward=ward1[1];
	}
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
	var objst = document.getElementById("tStartTime");
	if (objst){
			if (objst.value=="") {objst.value = "00:00"};
			var st=objst.value 
		}
	var objet = document.getElementById("tEndTime");
		if (objet){
			if (objet.value=="") {objet.value = "23:59"};
			var et=objet.value 
		}
	var grp="";
	var objgrp = document.getElementById("tLocGrp");
	if (objgrp){var grp=objgrp.value;}
	var ptype="";
	var objtype = document.getElementById("tOecType");
	if (objtype){
		var ptype=objtype.value;
		if (ptype=="6") {ptype="抗微生物药"}
		if (ptype=="7") {ptype="抗肿瘤药"}
		if (ptype=="OTHER") {ptype="其它"}
		}

	///
	xlsheet.Cells(1,1).Value =hospname+"配液排药单"
	xlsheet.Cells(2,1).Value ="病区:"+ward+"    "+"科室组:"+grp+"    "+"配液分类:"+ptype+"    "+"日期:"+(sd)+" "+st+"至"+(ed)+" "+et;
	xlsheet.Cells(3,1).Value ="批次:"+batno+"    优先级:"+prio+"    打印单号:"+printno+"    打印人:"+session['LOGON.USERNAME']+"    打印日期:"+getPrintDateTime() //+formatDate2(getPrintDate())+" "+getPrintTime();
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
		var obj=document.getElementById("tbStkbin"+"z"+i) ;
		if (obj) stkbin=obj.innerText;
		//var tmpitm=itmdesc.split("(")
		//itmdesc=tmpitm[0];
		xlsheet.Cells(currow,1).Value=i;
		xlsheet.Cells(currow,2).Value=itmdesc;
		xlsheet.Cells(currow,3).Value=qty;
		xlsheet.Cells(currow,4).Value=uom;
		xlsheet.Cells(currow,5).Value=stkbin;
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
	var hospname=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	return hospname;
}
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
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


function Cleanup()  
{   
    window.clearInterval("");        
}



function ReloadWinow()
{	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.STATARRAGE" ;
	location.href=lnk;
}


document.body.onload=BodyLoadHandler;