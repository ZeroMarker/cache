/// UDHCJFSSGrpDepTypeSet.js
var CurRow = 0, Str1 = "", Str2 = "";
function BodyLoadHandler() {
	var obj = document.getElementById('Add');
	if (obj) {
		obj.onclick = Add_Click;
	}

	var obj = document.getElementById('Delete');
	if (obj) {
		obj.onclick = Delete_Click;
	}
	var obj = document.getElementById('Find');
	if (obj) {
		obj.onclick = Find_OnClick;
	}
}

//添加
function Add_Click() {
	if (Str1 == "") {
		alert(t['01']);
		return;
	}
	if (Str2 == "") {
		alert(t['01']);
		return;
	}
	var deft = DHCWebD_GetObjValue('Deft') ? "Y" : "N";
	//判断是否存在
	var encmeth = DHCWebD_GetObjValue('CheckGrp');
	var rst1 = cspRunServerMethod(encmeth, Str1, Str2, deft);
	if (rst1 == 0) {
		alert(t['05']);
		return;
	}
	if (rst1 == "-1") {
		alert("该安全组已存在默认值!");
		return;
	}
	//添加
	var encmeth = DHCWebD_GetObjValue('getAdd');
	var rst = cspRunServerMethod(encmeth, Str1, Str2, deft);
	if (rst == 0) {
		alert(t['03']);
		DHCWebD_SetObjValueB('UserGrp', '');
		Find_click();
	} else {
		alert(t['02']);
		return;
	}
}

//删除
function Delete_Click() {
	var encmeth = DHCWebD_GetObjValue('getDel');
	var rowid = "";
	if (CurRow == 0) {
		alert(t['04']);
		return;
	}
	if (window.confirm('确定要删除吗')) {
		var ObjRoeId = DHCWeb_GetColumnData('rowid', CurRow);
		var rst = cspRunServerMethod(encmeth, ObjRoeId);
		DHCWebD_SetObjValueB('UserGrp', '');
		Find_click();
	}
}

function SelectRowHandler() {
	var Row = DHCWeb_GetRowIdx(window);
	if (Row == CurRow) {
		CurRow = 0;
		return;
	} else {
		CurRow = Row;
	}
}

//得到值
function GetGrpRowId(Value) {
	var TmpStr = Value.split("^");
	Str1 = TmpStr[1];
	DHCWebD_SetObjValueB('UserGrp', TmpStr[1]);
}

function GetDepTypeRowId(Value) {
	var TmpStr = Value.split("^");
	Str2 = TmpStr[1];
}

function Find_OnClick() {
	var grp = DHCWebD_GetObjValue('SSGrp');
	if (grp == "") {
		DHCWebD_SetObjValueB('UserGrp', '');
	}
	Find_click();
}

document.body.onload = BodyLoadHandler
