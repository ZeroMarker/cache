function BodyLoadHandler() {
	var obj = document.getElementById('udep');
	if (obj)
		obj.multiple = false;
	if (obj)
		obj.onchange = uDep_change;
	if (obj)
		obj.ondblclick = uDep_dbclick;
	var obj = document.getElementById('alldep');
	if (obj)
		obj.ondblclick = allDep_dbclick;
	
	var obj = document.getElementById('Badd');
	if (obj)
		obj.onclick = Badd_click;
	
	var obj = document.getElementById('Bdel');
	if (obj)
		obj.onclick = Bdel_click;
	var guse = websys_$("Ghuse");
	if (guse) {
		guse.onkeydown = GhuseLookuphandler;
	}
	var obj = document.getElementById('Bsave');
	if (obj)
		obj.onclick = Bsave_click;
	var obj = document.getElementById('LocNameDesc');
	//if (obj) obj.onchange = LocNameDesc_change;
	if (obj)  obj.onkeydown = LocNameDesc_keydown;
	/*var form = document.forms["fDHCRBResourceNurseUse"];
	var table = form.lastChild;
	createAuthorizationElement(table);
	var row = table.rows[1];
	for (var i = 0; i < row.cells.length; i++) {
		var cell = row.cells[i];
		if (cell.innerText == "") {
			var input = document.createElement("input");
			input.type = 'button';
			input.value = '保存为超级权限';
			input.id = 'superconfig';
			input.onclick = BSaveForSuper;
			//input.innerHTML=input.value;
			cell.appendChild(input);
			break;
		}
	}*/
}

function createAuthorizationElement(table) {
	var row = table.rows[0];
	if (row.cells.length > 0) {
		// rwo.cells
	}
	
}
function LocNameDesc_change() {
	BuildAllDeptList();
}
function LocNameDesc_keydown() {
	var key = websys_getKey(e);
	if (key == 13) {
		BuildAllDeptList();
	}
}
function uDep_dbclick() {
	Bdel_click();
}
function allDep_dbclick() {
	Badd_click();
}
function uDep_change() {
	ClearList('udoc');
	var obj = document.getElementById('udep');
	var selectObj = obj.options[obj.selectedIndex];
	if (selectObj) {
		var LocID = selectObj.value
	} else {
		var LocID = ''
	};
	if (LocID == "") {
		alert("请先选择一个科室");
		
		return false;
	}
	var obj = document.getElementById('useID');
	var userID = "";
	if (obj)
		userID = obj.value;
	if (userID == "") {
		alert("请先选择一个排班员");
		return false;
	}
	var GetDocMethod = document.getElementById('seldoc');
	if (GetDocMethod) {
		var encmeth = GetDocMethod.value
	} else {
		var encmeth = ''
	};

	var ret = cspRunServerMethod(encmeth, userID, LocID, "nurse");
	
	BuildList(ret, "udoc");
}

function Bsave_click() {
	//可排科室
	
	var tmp = document.getElementById('udep');
	var Item;
	if (tmp.selectedIndex != -1)
		Item = tmp.options[tmp.selectedIndex].value;
	if (tmp.selectedIndex == -1) {
		alert("请先选择一个排班科室");
		return false;
	}
	var useid = document.getElementById('useID').value;
	if (useid == "") {
		alert("请先选择一个排班员");
		return false;
	}
	var flag = 0
		var udoc = document.getElementById('udoc');
	for (var j = 0; j < udoc.length; ++j) {
		if (udoc.options[j].selected == true) {
			flag = 1
		}
	}
	if (flag == 0) {
		alert("请先选择排班医生");
	}
	
	var del = document.getElementById('del');
	if (del) {
		var encmeth = del.value
	} else {
		var encmeth = ''
	};
	if (encmeth != "") {
		var ret = cspRunServerMethod(encmeth, '', '', useid, Item, "nurse");
		if (ret != "0") {
			alert("删除原有数据错误");
			return false;
		}
		
	}
	
	var udoc = document.getElementById('udoc');		
	for (var j = 0; j < udoc.length; ++j) {
		if (udoc.options[j].selected == true) {
		    var docid = udoc.options[j].value;				
			//var NurseLicense = window.parent.NurseLicense;
			var NurseLicense = document.getElementById('NurseLicense');
			if (NurseLicense) {var encmeth = NurseLicense.value} else {var encmeth = ''};
			if (encmeth!="") {
				var insResult = cspRunServerMethod(encmeth, useid, Item, docid);
				if(insResult!=1) {
					alert("更新失败")
				}
			}
		}
	}
	
	alert("更新完成")
	////////////////
}

function Bdel_click() {
	
	var obj = document.getElementById('useID');
	var userID = "";
	if (obj)
		userID = obj.value;
	if (userID == "") {
		alert("请先选择一个排班员");
		return false;
	}
	var obj = document.getElementById('udep');
	var length = obj.length;
	
	for (i = length - 1; i >= 0; i--) {
		if (obj.options[i].selected) {
			if (!(confirm("确实要删除选中的科室吗?"))) {
				return false;
			}
			var value = obj.options[i].value;
			var text = obj.options[i].text;
			var del = document.getElementById('del');
			if (del) {
				var encmeth = del.value
			} else {
				var encmeth = ''
			};
			var ret = cspRunServerMethod(encmeth, '', '', userID, value, "nurse");
			
			if (ret != "0") {
				alert("删除原有数据错误");
				return false;
			}
			obj.remove(i);
			ClearList('udoc');
			AddList("alldep", text, value);
		}
	}
}

function Badd_click() {
	var obj = document.getElementById('useID');
	var userID = "";
	if (obj)
		userID = obj.value;
	if (userID == "") {
		alert("请先选择一个排班员")
		return false;
	}
	var obj = document.getElementById('alldep');
	var length = obj.length;
	for (i = length - 1; i >= 0; i--) {
		if (obj.options[i].selected) {
			var value = obj.options[i].value;
			var text = obj.options[i].text;
			obj.remove(i);
			AddList("udep", text, value);
		}
	}
}
function uselook(str) {
	if (str == "")
		return false;
	var obj = document.getElementById('useID');
	var tem = str.split("^");
	obj.value = tem[1];
	
	BuildAllDeptList();
	BuildUseDeptList();
	ClearList('udoc');
	
	var superConfig = tkMakeServerCall("web.DHCUserGroup", "IsSuperConfig", obj.value, "nurse");
	if (superConfig == 1) {
		websys_$("superconfig").value = "取消超级权限";
	}
}

function GhuseLookuphandler() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Ghuse_lookuphandler(window.event);
	}
	
}
function BuildUseDeptList() {
	var UserID = "",
	Desc = "";
	var obj = document.getElementById('useID');
	if (obj)
		UserID = obj.value;
	if (UserID == "") {
		alert("请先选择一个排班员")
		return false;
	}
	
	var ret = tkMakeServerCall("web.DHCUserGroup", "GetLocInfo", UserID, Desc, "USE", "nurse");
	BuildList(ret, "udep");
}
function BuildAllDeptList() {
	var UserID = "",
	Desc = "";
	var obj = document.getElementById('useID');
	if (obj)
		UserID = obj.value;
	if (UserID == "") {
		alert("请先选择一个排班员")
		return false;
	}
	var obj = document.getElementById('LocNameDesc');
	if (obj)
		Desc = obj.value;

	var encmeth = websys_$("GetLocInfoMethod")
		if (encmeth) {
			encmeth = encmeth.value;
			var ret = cspRunServerMethod(encmeth, UserID, Desc, "ALL", "nurse");
			BuildList(ret, "alldep");
		}
}
function BuildList(value, ElementName) {
	ClearList(ElementName);
	if (value == "")
		return false;
	var char1 = "\1";
	var char2 = "\2";
	var arr = value.split(char2);
	var i = arr.length;
	for (j = 0; j < i; j++) {
		var oneValue = arr[j];
		var oneArr = oneValue.split(char1);
		AddList(ElementName, oneArr[0], oneArr[1], oneArr[2]);
	}
}

function AddList(ElementName, value, text, Selected) {
	
	var obj = document.getElementById(ElementName);
	var length = obj.length;
	obj.options[length] = new Option(value, text);
	if (Selected == 1)
		obj.options[length].selected = true;
}
function ClearList(ElementName) {
	var obj = document.getElementById(ElementName);
	var length = obj.length
		for (i = length - 1; i >= 0; i--) {
			obj.remove(i);
		} //先清空
}
function BSaveForSuper() {
	useID = websys_$('useID')
		if (useID) {
			if (useID.value == "") {
				alert("请选择一个排班员");
				return;
			}
			
			var ret = tkMakeServerCall("web.DHCUserGroup", "SaveForSuper", useID.value, "nurse");
			alert("保存成功");
		}
}
document.body.onload = BodyLoadHandler;
