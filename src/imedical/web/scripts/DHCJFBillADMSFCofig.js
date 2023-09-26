/// DHCJFBillADMSFCofig.js
var TconRowid = "";
function BodyLoadHandler() {
	var obj = document.getElementById("Add");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("Del");
	if (obj) {
		obj.onclick = Del_click;
	}
	var obj = document.getElementById("clear");
	if (obj) {
		obj.onclick = clear_click;
	}
	var obj = document.getElementById("UP");
	if (obj) {
		obj.onclick = UP_click;
	}
}

function Add_click() {
	var admconcode = DHCWebD_GetObjValue('admconcode');
	var admcondesc = DHCWebD_GetObjValue("admcondesc");
	var admconval = DHCWebD_GetObjValue("admconval");
	if (websys_trim(admconcode) == "") {
		alert("请输入代码");
		return;
	}
	if (websys_trim(admcondesc) == "") {
		alert("请输入描述");
		return;
	}
	if (websys_trim(admconval) == "") {
		alert("请输入类型(缩写).");
		return;
	}
	var encmeth = DHCWebD_GetObjValue('ins');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval);
	if (ReturnValue == 0) {
		alert("保存成功");
		clear_click();
		Find_click();
	} else {
		if (ReturnValue == -1) {
			alert("此发票类型已经存在.");
			return;
		} else {
			alert("保存失败.");
			return;
		}
	}
}

function Del_click() {
	if (TconRowid == "") {
		alert("选择删除的行");
		return;
	} else {
		var encmeth = DHCWebD_GetObjValue('delect');
		var ReturnValue = cspRunServerMethod(encmeth, TconRowid);
		if (ReturnValue == 0) {
			alert("删除成功");
			clear_click();
			Find_click();
		} else {
			if (ReturnValue == "OPINV") {
				alert("默认门诊发票类型不允许删除");
				return;
			}
			if (ReturnValue == "IPINV") {
				alert("默认住院发票类型不允许删除");
				return;
			}
			if (ReturnValue == "RINV") {
				alert("默认挂号发票类型不允许删除");
				return;
			}
			alert("记录可能不存在或已被删除, 删除失败！");
			clear_click();
		}
	}
}

function SelectRowHandler() {
	var selectrow = DHCWeb_GetRowIdx(window);
	var admconcode = DHCWeb_GetColumnData('Tadmcode', selectrow);
	var admcondesc = DHCWeb_GetColumnData('Tadmcondesc', selectrow);
	var admconval = DHCWeb_GetColumnData('Tadmconval', selectrow);
	TconRowid = DHCWeb_GetColumnData('TconRowid', selectrow);
	DHCWebD_SetObjValueB('admconcode', admconcode);
	DHCWebD_SetObjValueB('admcondesc', admcondesc);
	DHCWebD_SetObjValueB('admconval', admconval);
}

function clear_click() {
	DHCWebD_SetObjValueB('admconcode', '');
	DHCWebD_SetObjValueB('admcondesc', '');
	DHCWebD_SetObjValueB('admconval', '');
}

function UP_click() {
	if (TconRowid == "") {
		alert("选择更新的内容");
	}
	var admconcode = DHCWebD_GetObjValue('admconcode');
	var admcondesc = DHCWebD_GetObjValue("admcondesc");
	var admconval = DHCWebD_GetObjValue("admconval");
	if (websys_trim(admconcode) == "") {
		alert("请输入代码");
		return;
	}
	if (websys_trim(admcondesc) == "") {
		alert("请输入描述");
		return;
	}
	if (websys_trim(admconval) == "") {
		alert("请输入类型(缩写).");
		return;
	}
	var encmeth = DHCWebD_GetObjValue('update');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval, TconRowid);
	if (ReturnValue == 0) {
		alert("更新成功");
		clear_click();
		Find_click();
	}
}

document.body.onload = BodyLoadHandler;
