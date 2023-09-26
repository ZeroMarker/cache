/// DHCJFAgeConfig.js
var selFlag = 0;        //判断是更新还是添加，1标识更新，0标识添加
var updateRowId = "";

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	stValObj = document.getElementById("startVal");
	endValObj = document.getElementById("endVal");
	stUomObj = document.getElementById("startUom");
	endUomObj = document.getElementById("endUom");
	stUomDrObj = document.getElementById("startUomDr");
	endUomDrObj = document.getElementById("endUomDr");
	displayValObj = document.getElementById("displayVal");
	dispUomDrObj = document.getElementById("dispUomDr");
	stOperator = document.getElementById("operator1");
	endOperator = document.getElementById("operator2");
	if (stOperator && stOperator.type == "select-multiple") {
		stOperator.size = 1;
		stOperator.multiple = false;
		//stOperator.options[0] = new Option(">",">");
		stOperator.options[0] = new Option(">=", ">=");
		stOperator.disabled = true;
		stOperator.readOnly = true;
	} else {
		stOperator.value = ">=";
		stOperator.style.width = 40;
		stOperator.disabled = true;
		stOperator.readOnly = true;
	}

	if (endOperator && endOperator.type == "select-multiple") {
		endOperator.size = 1;
		endOperator.multiple = false;
		endOperator.options[0] = new Option("<", "<");
		//endOperator.options[1] = new Option("<=","<=");
		endOperator.disabled = true;
		endOperator.readOnly = true;
	} else {
		endOperator.value = "<";
		endOperator.style.width = 40;
		endOperator.disabled = true;
		endOperator.readOnly = true;
	}
	var addObj = document.getElementById("Add");
	if (addObj) {
		addObj.onclick = addClick;
	}
	var updateObj = document.getElementById("Update");
	if (updateObj) {
		updateObj.onclick = updateClick;
	}
	var deleteObj = document.getElementById("Delete");
	if (deleteObj) {
		deleteObj.onclick = deleteClick;
	}
	initDoc();
}

function initDoc() {
	if (stValObj) {
		stValObj.disabled = true;
		stValObj.readOnly = true;
	}
	if (stUomObj) {
		stUomObj.disabled = true;
		stUomObj.readOnly = true;
	}
	var startRtn = tkMakeServerCall("web.UDHCJFAgeConfig", "getLastValStr");
	var rtnStr = startRtn.split("^");
	if (rtnStr[0] == 0) {
		var stValRtn = rtnStr[1];
		var stUomRtn = rtnStr[3];
		var stUomDrRtn = rtnStr[2];
		stValObj.value = stValRtn;
		stUomObj.value = stUomRtn;
		stUomDrObj.value = stUomDrRtn;
	} else {
		alert(rtnStr[0] + "初始化失败...");
	}
}

//add hu 14.4.1
//添加配置数据
function addClick() {
	if (selFlag == 1) {
		alert("不能添加相同值的数据，请刷新页面后重新添加.");
		return;
	}
	var validateRtn = validatePageVal();
	if (!validateRtn) {
		return;
	}
	var stValStrs = stOperator.value + "^" + stValObj.value + "^" + stUomDrObj.value;
	var endValStrs = endOperator.value + "^" + endValObj.value + "^" + endUomDrObj.value;
	var dispValStrs = dispUomDrObj.value;
	var validateRtn = validateBgVal(stValStrs, endValStrs);
	if (!validateRtn) {
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFAgeConfig", "INSERT", stValStrs, endValStrs, dispValStrs, Guser);
	if (rtn == 0) {
		alert("添加成功.");
		Find_click();
		//window.location.reload();
	} else {
		alert(rtn + "添加失败.");
	}
}

function updateClick() {
	if (selFlag == 0) {
		alert("请选择要更新的记录.");
		return;
	}
	if (updateRowId == "") {
		alert("请选择要更新的记录.");
		return;
	}
	var validateRtn = validatePageVal();
	if (!validateRtn) {
		return;
	}
	var stValStrs = stOperator.value + "^" + stValObj.value + "^" + stUomDrObj.value;
	var endValStrs = endOperator.value + "^" + endValObj.value + "^" + endUomDrObj.value;
	var dispValStrs = dispUomDrObj.value;
	var validateRtn = validateBgVal(stValStrs, endValStrs);
	if (!validateRtn) {
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFAgeConfig", "UpdateConfig", stValStrs, endValStrs, dispValStrs, updateRowId, Guser);
	if (rtn == 0) {
		alert("更新成功.");
		Find_click();
		//window.location.reload();
	} else if (rtn == "-501") {
		alert(rtn + "更新的ID不存在,更新失败");
	} else if (rtn == "-102") {
		alert(rtn + "更新失败,结束值大于下一个结束值.")
	} else {
		alert(rtn + "更新失败.");
	}
}

function deleteClick() {
	if (selFlag == 0) {
		alert("请选择要删除的记录.");
		return;
	}
	if (updateRowId == "") {
		alert("请选择要删除的记录.");
		return;
	}
	var validateRtn = validatePageVal();
	if (!validateRtn) {
		return;
	}
	var stValStrs = stOperator.value + "^" + stValObj.value + "^" + stUomDrObj.value;
	var endValStrs = endOperator.value + "^" + endValObj.value + "^" + endUomDrObj.value;
	var dispValStrs = dispUomDrObj.value;
	var validateRtn = validateBgVal(stValStrs, endValStrs);
	if (!validateRtn) {
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFAgeConfig", "DeleteConfig", stValStrs, endValStrs, dispValStrs, updateRowId, Guser);
	if (rtn == 0) {
		alert("删除成功.");
		Find_click();
		//window.location.reload();
	} else if (rtn == "-501") {
		alert(rtn + "删除的ID不存在删除失败.");
	} else {
		alert(rtn + "删除失败.");
	}
}

function validateBgVal(stValStrs, endValStrs) {
	var bgValRtn = true; //验证值
	var valRtn = tkMakeServerCall("web.UDHCJFAgeConfig", "judge", stValStrs, endValStrs);
	switch (valRtn) {
	case "-100":
		alert("选择的单位不存在.");
		bgValRtn = false;
		break;
	case "-101":
		alert("选择的单位不存在.");
		bgValRtn = false;
		break;
	case "-102":
		alert("开始值大于结束值");
		bgValRtn = false;
		break;
	case "-103":
		alert("单位错误");
		bgValRtn = false;
		break;
	}
	return bgValRtn;
}

function validatePageVal() {
	var pattern = new RegExp("^[0-9]+$");
	if ((!pattern.test(stValObj.value)) || (stValObj.value > 365)) {
		alert("开始值请输入有效数字");
		return false;
	}
	if ((!pattern.test(endValObj.value)) || (endValObj.value > 365)) {
		alert("结束值请输入有效数字");
		return false;
	}
	if (stUomDrObj.value == "") {
		alert("请选择开始单位");
		return false;
	}

	if (endUomDrObj.value == "") {
		alert("请选择结束单位");
		return false;
	}
	if (dispUomDrObj.value == "") {
		alert("请选择显示值");
		return false;
	}
	return true;
}

function setEndVal(value) {
	var str = value.split("^");
	if (endUomObj) {
		endUomObj.value = str[1];
	}
	if (endUomDrObj) {
		endUomDrObj.value = str[0];
	}
}

function setDisplayVal(value) {
	var str = value.split("^");
	var displayValObj = document.getElementById("displayVal");
	var dispUomDrObj = document.getElementById("dispUomDr");
	if (displayValObj) {
		displayValObj.value = str[1];
	}
	if (dispUomDrObj) {
		dispUomDrObj.value = str[0];
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	var selectrow = rowobj.rowIndex;
	if (!selectrow) {
		return;
	}
	var SelRowObj = document.getElementById('TstartValz' + selectrow);
	stValObj.value = SelRowObj.innerText;
	var SelRowObj = document.getElementById('TstartUomz' + selectrow);
	stUomObj.value = SelRowObj.innerText;
	var stUomDrRtn = tkMakeServerCall("web.DHCJFUOMSET", "getUomId", stUomObj.value);
	stUomDrObj.value = stUomDrRtn;
	var SelRowObj = document.getElementById('TendValz' + selectrow);
	endValObj.value = SelRowObj.innerText;
	var SelRowObj = document.getElementById('TendUomz' + selectrow);
	endUomObj.value = SelRowObj.innerText;
	var endUomDrRtn = tkMakeServerCall("web.DHCJFUOMSET", "getUomId", endUomObj.value);
	endUomDrObj.value = endUomDrRtn;
	var SelRowObj = document.getElementById('TdisplayValz' + selectrow);
	displayValObj.value = SelRowObj.innerText;
	var disUomDrRtn = tkMakeServerCall("web.DHCJFUOMSET", "getUomId", displayValObj.value);
	dispUomDrObj.value = disUomDrRtn;
	var SelRowObj = document.getElementById('TrowIdz' + selectrow);
	updateRowId = SelRowObj.innerText;
	selFlag = 1;          //判断是更新还是添加
}

document.body.onload = BodyLoadHandler;
