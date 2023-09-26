/// 
//名称	DHCPEOEItemStatus.js
//功能	
//组件	
//对象	
//创建	2007.07.30
//最后修改时间	
//最后修改人	
//完成

var TFORM="";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("GAdmList");
	if (obj) {
		obj.onchange=GAdmList_change;
		obj.onblur=GAdmList_blur;
	}
	
	obj=document.getElementById("GTAdmList");
	if (obj) {
		obj.onchange=GTAdmList_change;
		obj.onblur=GTAdmList_blur;
	}
	
	obj=document.getElementById("OEItemDesc");
	if (obj) {
		obj.onchange=OEItemDesc_change;
		obj.onblur=OEItemDesc_blur;
	}
	
	obj=document.getElementById("RegNo");
	if (obj) { obj.onkeydown=RegNo_keydown; }
	
	
	obj=document.getElementById("Find");
	if (obj){ obj.onclick=BFind_click; }

    obj=document.getElementById("BClear");
    if (obj) {obj.onclick=BClear_Click;}

	    //导出数据
	 obj=document.getElementById("BExport");
    if (obj) {obj.onclick=BExport_Click;}

	iniForm();
	Muilt_LookUp('GTAdmList'+'^'+'GAdmList'+'^'+'OEItemDesc');
}

function EndDate(){
   var s=""; 
 	var date = new Date(); 
    var y = date.getFullYear(); 
    var m = date.getMonth()+1; 
    var d = date.getDate(); 
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var s=y+"-"+m+"-"+d;
		}else if (dtformat=="DMY"){
			var s=d+"/"+m+"/"+y;
		} 
   return(s); 
}
//导出数据
function BExport_Click(){
	try{
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEItemStatus.xls';
	   
	    xlApp = new ActiveXObject("Excel.Application"); //固定
	    xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		
		var obj,iBeginDate="",iEndDate="";
		obj=document.getElementById("DateBegin");
		if (obj){ iBeginDate=obj.value; }
		obj=document.getElementById("DateEnd");
		if (obj){ iEndDate=obj.value; }
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		xlsheet.cells(1,1)=iBeginDate+"--"+iEndDate+"项目明细统计";
		
		var User=session['LOGON.USERID']
		var Rows=tkMakeServerCall("web.DHCPE.Report.OEItemStatus","GetItemStatusRows",User);
		
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.OEItemStatus","GetItemStatusData",User,i)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+2, iDayLoop+1)=DayData[iDayLoop];
			}

		} 
		xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(parseInt(Rows)+2,11)).Borders.LineStyle=1; 
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}

}

function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if ( 13==key) {
		 BFind_click();
	}
}

function BFind_click(){

    var obj;
	var iRegNo="",iName ="",iGAdmListDR="",iGTAdmListDR="",iOEItemDR="",iOEOrderStatus="",iOEItemStatus="",iDateBegin="",iDateEnd=""
	obj=document.getElementById("RegNo");
	if (obj){ iRegNo=obj.value; }
	obj=document.getElementById("Name");
	if (obj){ iName=obj.value; }
	obj=document.getElementById("GAdmListDR");
	if (obj){ iGAdmListDR=obj.value; }
	obj=document.getElementById("GTAdmListDR");
	if (obj){ iGTAdmListDR=obj.value; }
	obj=document.getElementById("OEItemDR");
	if (obj){ iOEItemDR=obj.value; }
	obj=document.getElementById("OEOrderStatus");
	if (obj){ iOEOrderStatus=obj.value; }
	obj=document.getElementById("OEItemStatus");
	if (obj){ iOEItemStatus=obj.value; }
	obj=document.getElementById("DateBegin");
	if (obj){ iDateBegin=obj.value; }
	obj=document.getElementById("DateEnd");
	if (obj){ iDateEnd=obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOEItemStatus"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&GAdmListDR="+iGAdmListDR
			+"&GTAdmListDR="+iGTAdmListDR
			+"&OEItemDR="+iOEItemDR
			+"&OEOrderStatus="+iOEOrderStatus
			+"&OEItemStatus="+iOEItemStatus
			+"&DateBegin="+iDateBegin
			+"&DateEnd="+iDateEnd
			; 
   location.href=lnk;

}

function BClear_Click(){
	var obj;
	obj=document.getElementById("RegNo");
	if (obj){ obj.value=""; }
	obj=document.getElementById("Name");
	if (obj){ obj.value=""; }
	obj=document.getElementById("GAdmList");
	if (obj){ obj.value=""; }
	obj=document.getElementById("GAdmListDR");
	if (obj){ obj.value=""; }
	obj=document.getElementById("GTAdmList");
	if (obj){ obj.value=""; }
	obj=document.getElementById("GTAdmListDR");
	if (obj){ obj.value=""; }
	obj=document.getElementById("OEItemDesc");
	if (obj){ obj.value=""; }
	obj=document.getElementById("OEItemDR");
	if (obj){ obj.value=""; }
	obj=document.getElementById("OEOrderStatus");
	if (obj){ obj.value=""; }
	obj=document.getElementById("OEItemStatus");
	if (obj){ obj.value=""; }
	obj=document.getElementById("DateBegin");
	if (obj){ obj.value=""; }
	obj=document.getElementById("DateEnd");
	if (obj){ obj.value=""; }
	
	obj=document.getElementById("OEOrderStatus_D");
	if (obj){ obj.checked=false; }
	obj=document.getElementById("OEOrderStatus_V");
	if (obj){ obj.checked=false; }
	obj=document.getElementById("OEOrderStatus_E");
	if (obj){ obj.checked=false; }
	obj=document.getElementById("OEItemStatus_PRE");
	if (obj){ obj.checked=false; }
	obj=document.getElementById("OEItemStatus_ADD");
	if (obj){ obj.checked=false; }
	
}

function iniForm(){
	var obj;
	
	// 预约
	obj=document.getElementById("OEItemStatus_PRE");
	if (obj){ obj.onclick=OEItemStatus_click; }
	
	// 加项
	obj=document.getElementById("OEItemStatus_ADD");
	if (obj){ obj.onclick=OEItemStatus_click; }
	
	obj=document.getElementById("OEItemStatus");
	if (obj && ''!=obj.value) { SetOEItemStatus(obj.value); }
	
	// 停止
	obj=document.getElementById("OEOrderStatus_D");
	if (obj){ obj.onclick=OEOrderStatus_click; }
	
	// 核实
	obj=document.getElementById("OEOrderStatus_V");
	if (obj){ obj.onclick=OEOrderStatus_click; }
	
	// 执行
	obj=document.getElementById("OEOrderStatus_E");
	if (obj){ obj.onclick=OEOrderStatus_click; }
	
	obj=document.getElementById("OEOrderStatus");
	if (obj && ''!=obj.value) { SetOEOrderStatus(obj.value); }	

	
	return;
	obj=document.getElementById("DateBegin");
	if (obj){
		obj.value='t';
		DateBegin_lookupSelect();
	}
	
	obj=document.getElementById("DateEnd");
	if (obj){
		obj.value='t';
		DateEnd_lookuphandler();
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function GetGTAdmList(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("GTAdmList");
	if (obj) { obj.value=aiList[4]; }
	
	obj=document.getElementById("GTAdmListDR");
	if (obj) { obj.value=aiList[1]; }
}


function GAdmList_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('GAdmList');
			if (obj) { obj.value=""; }
		//}
		//else { return false; }
}

function GAdmList_change() {

	var obj;

	obj=document.getElementById('GAdmListDR');
	if (obj) { obj.value="";}
}

function GTAdmList_blur() {
	return
	var obj;
	obj=document.getElementById('GTAdmList');
	if (obj && ""==obj.value) {
		obj=document.getElementById('GTAdmListDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function GTAdmList_change() {
		var obj;
		obj=document.getElementById('GTAdmListDR');
		if (obj) { obj.value=""; }
}


function GetGAdmList(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("GAdmList");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("GAdmListDR");
	if (obj) { obj.value=aiList[1]; }
}

function GetOEItem(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("OEItemDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("OEItemDR");
	if (obj) { obj.value=aiList[2]; }
}

function OEItemDesc_blur() {
	return
	var obj;
	obj=document.getElementById('OEItemDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function OEItemDesc_change() {
		var obj;
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
}


function GetOEOrderStatus() {
	var obj;
	var iStatus="";

	// 核实
	obj=document.getElementById("OEOrderStatus_V");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"V^"; }
	// 执行
	obj=document.getElementById("OEOrderStatus_E");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"E^"; }
	// 删除
	obj=document.getElementById("OEOrderStatus_D");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"D^"; }

	return iStatus;
}

function OEOrderStatus_click() {
	
	var obj;

	obj=document.getElementById('OEOrderStatus');
	if (obj) { obj.value=GetOEOrderStatus(); }
	
}

function SetOEOrderStatus(Status) {
	var obj;
	var value=Status;

	// 预约
	obj=document.getElementById("OEOrderStatus_V");
	if (obj) {
		if (value.indexOf("^V^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	// 加项
	obj=document.getElementById("OEOrderStatus_E");
	if (obj) {
		if (value.indexOf("^E^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// 删除
	obj=document.getElementById("OEOrderStatus_D");
	if (obj) {
		if (value.indexOf("^D^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

function GetOEItemStatus() {
	
	var obj;
	var iStatus="";

	// 预约
	obj=document.getElementById("OEItemStatus_PRE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PRE^"; }
	// 加项
	obj=document.getElementById("OEItemStatus_ADD");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ADD^"; }
	// 删除
	obj=document.getElementById("OEItemStatus_DEL");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"DEL^"; }

	return iStatus;

}

function OEItemStatus_click() {
	
	
	obj=document.getElementById('OEItemStatus');
	if (obj) { obj.value=GetOEItemStatus(); }
	
}
function SetOEItemStatus(Status) {
	var obj;
	var value=Status;

	// 预约
	obj=document.getElementById("OEItemStatus_PRE");
	if (obj) {
		if (value.indexOf("^PRE^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	// 加项
	obj=document.getElementById("OEItemStatus_ADD");
	if (obj) {
		if (value.indexOf("^ADD^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// 删除
	obj=document.getElementById("OEItemStatus_DEL");
	if (obj) {
		if (value.indexOf("^DEL^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
		
}

document.body.onload = BodyLoadHandler;