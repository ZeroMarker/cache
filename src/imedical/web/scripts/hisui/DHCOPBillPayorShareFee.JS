/// DHCOPBillPayorShareFee.js

function BodyLoadHandler() {
	var obj = document.getElementById("BFind");
	if (obj) {
		obj.onclick = BFind_Click;
	}

	var obj = document.getElementById("BPrint");
	if (obj) {
		obj.onclick = Print_Click;
	}
	var obj = document.getElementById("InsType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}

	var obj = document.getElementById("StatFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var obj = document.getElementById("test");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	init_Layout();
	InitDocument();
}

function DHCWebRep_ChangeListValue(ListName, val) {
	/*
	var obj = document.getElementById(ListName);
	for (var i = obj.options.length - 1; i >= 0; i--) {
		if (obj.options[i].value == val) {
			obj.selectedIndex = i;
		}
	}
	*/
}

function DHCWebRep_GetListTextValue(objName) {
	var myval = "";
	var obj = document.getElementById(objName);
	if (obj) {
		var myidx = obj.selectedIndex;
		if (myidx != -1) {
			myval = obj.options[myidx].text;
		}
	}
	return myval;
}

function InitDocument() {
	var obj = document.getElementById("StatFlag");
	if (obj) {
		DHCWebRep_ChangeListValue("StatFlag", obj.value);
	}
	var obj = document.getElementById("InsTypeHidden");
	if (obj) {
		DHCWebRep_ChangeListValue("InsType", obj.value);
	}
	InitOPCat();
}

function BFind_Click() {
	InitOPCat(); //
	
}

function InitOPCat() {
	var obj = document.getElementById("StatFlag");
	var encmeth = "";
	if (obj) {
		if (obj.value == "TAC") {
			encmeth = getValueById("getTarACCat");
		} else {
			encmeth = getValueById("getTarOCCat");
		}
	}
	var catinfo = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
	cattmp = catinfo.split("^");
	var objtbl =$('#tDHCOPBillPayorShareFee');
	var catnum = cattmp.length;

	for (var i = 1; i <= catnum; i++) {
		var ColName = "cat" + i;
		objtbl.datagrid("getColumnOption", "TCAT"+i).title = cattmp[i - 1];
		objtbl.datagrid("getColumnOption", "TCAT"+i).align = 'right';
	}
	for (var i = catnum + 1; i <= 27; i++) {
		HiddenTblColumn(objtbl, "TCAT" + i, i);    //隐藏
	}
	
	var StDate = getValueById("StDate");
	var StartTime = getValueById("StartTime");
	var EndDate = getValueById("EndDate");
	var EndTime = getValueById("EndTime");
	var UserRowId = "";
	var InsType = "";
	var StatFlag = "";
	var InsType = getValueById("PatTypeStat");
	var StatFlag = getValueById('StatFlag');
	var HospId = session['LOGON.HOSPID'];
	$("#tDHCOPBillPayorShareFee").datagrid({
		queryParams: $.extend($("#tDHCOPBillPayorShareFee").datagrid("options").queryParams, {StDate:StDate,StartTime:StartTime,EndDate:EndDate,EndTime:EndTime,StatFlag:StatFlag,PatTypeStat:InsType,UserRowId:UserRowId,HospId:HospId})
	});
	//$('#tDHCOPBillPayorShareFee').datagrid();      //重新加载 二次加载
}

function HiddenTblColumn(tbl, ColName, ColIdx) {
	$HUI.datagrid("#tDHCOPBillPayorShareFee").hideColumn(ColName);
}

function Print_Click() {
	$HUI.datagrid('#tDHCOPBillPayorShareFee').selectRow(0);
	var row = $HUI.datagrid('#tDHCOPBillPayorShareFee').getSelected();
	if (!row || !row.TTMPJID) {
		DHCWeb_HISUIalert("没有需要打印的数据");
		return;
	}
	var jid = row.TTMPJID;
	if (!jid) {
		return;
	}
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var CurDate = getValueById("CurDate");
	var StatFlag = getValueById('StatFlag');
	var fileName = "DHCBILL-OPBILL-PayorShareFee.rpx";
	fileName += "&TMPGID=" + jid + "&StartDate=" + StDate+ "&EndDate=" + EndDate + "&CatType=" + StatFlag + "&PrintDate=" + CurDate + "&HospId=" + session['LOGON.HOSPID'] ;
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function UnloadHandler() {
	var myEncrypt = DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID = DHCWebD_GetObjValue("TMPJID");
	if (myEncrypt != "") {
		var mytmp = cspRunServerMethod(myEncrypt, myTMPGID);
	}
}

function init_Layout(){
	DHCWeb_ComponentLayout();
	// 核算大类
	$HUI.combobox('#StatFlagText', {
       	valueField: 'rowid',
		textField: 'desc',
    	blurValidValue:true,
    	url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.DHCOPBillPayorShareFee';
			param.QueryName= 'QueryCatStatFlag';
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(data){
			document.getElementById('StatFlag').value=data.rowid;
		}
   	});
   	$HUI.combobox('#InsTypeText', {
       	valueField: 'rowid',
		textField: 'desc',
    	blurValidValue:true,
    	url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.DHCOPBillPayorShareFee';
			param.QueryName= 'QueryInstype';
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(data){
			document.getElementById('PatTypeStat').value=data.rowid;
		}
   	});
}
document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler
