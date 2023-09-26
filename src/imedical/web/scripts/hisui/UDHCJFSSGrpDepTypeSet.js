/// UDHCJFSSGrpDepTypeSet.js

$(function () {
	init_Layout();

	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	
	$HUI.linkbutton("#Add", {
		onClick: function () {
			Add_Click();
		}
	});
	
	$HUI.linkbutton("#Delete", {
		onClick: function () {
			Delete_Click();
		}
	});
	
	$HUI.linkbutton("#Update", {
		onClick: function () {
			Update_Click();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			Clear_Click();
		}
	});
	
	var tableName = "Bill_IP_GroupDepType";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: session['LOGON.HOSPID']
	}, false);
	$("#Hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			setValueById("HospId", newValue);
			var url = $URL + "?ClassName=web.UDHCJFSSGrpDepTypeSet&QueryName=FindSSGRP&ResultSetType=array";
			$("#SSGrp").combobox("clear").combobox("reload", url);

			$("#Find").click();
		}
	});
	
	$HUI.combobox("#SSGrp", {
		valueField: "rowid",
		textField: "group",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			$.extend(param, {
						SSGrp: "",
						HospId: getValueById("Hospital")
					});
			return true;
		},
		onSelect: function (rec) {
			setValueById("UserGrp", rec.rowid);
		},
		onChange: function (newVal , oldVal) {
			if (!newVal) {
				setValueById("UserGrp", "");
			}
		}
	});
	
	$HUI.combobox("#DEPTYPE", {
		editable: false,
		url: $URL + "?ClassName=web.UDHCJFSSGrpDepTypeSet&QueryName=FindDepType&ResultSetType=array",
		valueField: "rowid",
		textField: "type"
	});
});

/**
* 新增
*/
function Add_Click() {
	var grpDr = getValueById("SSGrp");
	if (!grpDr) {
		DHCWeb_HISUIalert("安全组不能为空");
		return;
	}
	var depTypeDr = getValueById("DEPTYPE");
	if (!depTypeDr) {
		DHCWeb_HISUIalert("押金类型不能为空");
		return;
	}
	var deft = getValueById('Deft') ? "Y" : "N";
	
	//判断是否存在
	var hospId = getValueById("Hospital");
	var encmeth = getValueById('CheckGrp');
	var rtn = cspRunServerMethod(encmeth, grpDr, depTypeDr, deft, hospId);
	if (rtn == "0") {
		DHCWeb_HISUIalert(t['05']);
		return;
	}else if (rtn == "-1") {
		DHCWeb_HISUIalert("该安全组已存在默认值!");
		return;
	}
	$.messager.confirm("提示", "确认保存？",function (r) {
		var encmeth = getValueById('getAdd');
		var rtn = cspRunServerMethod(encmeth, grpDr, depTypeDr, deft, hospId);
		if (rtn == "0") {
			$.messager.alert("提示", t['03'], "success");
			Clear_Click();
		} else {
			$.messager.alert("提示", t['02'] + ":" + rtn, "error");
			return;
		}
	});	
}

/**
* 删除
*/
function Delete_Click() {
	var row = $("#tUDHCJFSSGrpDepTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("请选择需要删除的记录.");
		return;
	}
	var rowId = row.rowid;
	$.messager.confirm("提示", "是否确认删除?",function (r) {
		if (r) {
			var encmeth = getValueById('getDel');
			var rtn = cspRunServerMethod(encmeth, rowId);
			if (rtn == "0") {
				$.messager.alert('提示', '删除成功', 'success');
				Clear_Click();
			}else {
				$.messager.alert('提示', '删除失败：' + rtn, 'error');
			}
		}
	}) 
}

function SelectRowHandler(index, rowData) {
	setValueById("UserGrp", rowData.grpDr);
	setValueById("SSGrp", rowData.grpDr);
	setValueById("DEPTYPE", rowData.depTypeDr);
	setValueById("Deft", (rowData.def == "Y"));
}

function Clear_Click() {
	setValueById("UserGrp", "");
	$(".combobox-f:not(#Hospital)").combobox("clear");
	$(".checkbox-f").checkbox("uncheck");
	$("#Find").click();
}

/**
* 更新 tangzf 2019-5-28
*/
function Update_Click() {
	var row = $("#tUDHCJFSSGrpDepTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("请选择需要修改的记录.");
		return;
	}
	var rowId = row.rowid;
	var grpDr = getValueById("SSGrp");
	if (!grpDr) {
		DHCWeb_HISUIalert("安全组不能为空");
		return;
	}
	var depTypeDr = getValueById("DEPTYPE");
	if (!depTypeDr) {
		DHCWeb_HISUIalert("押金类型不能为空");
		return;
	}
	var deft = getValueById("Deft") ? "Y" : "N";
	
	var hospId = getValueById("Hospital");
	var rtn = tkMakeServerCall("web.UDHCJFSSGrpDepTypeSet", "CheckInfoForUpdate", rowId, grpDr, depTypeDr, deft, hospId);
	if (rtn == "-1") {
		DHCWeb_HISUIalert("不能重复添加相同记录");
		return;
	}else if (rtn == "-2") {
		DHCWeb_HISUIalert("该安全组已存在默认值");
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFSSGrpDepTypeSet","UpdateInfo", rowId, grpDr, depTypeDr, deft);
	if (rtn == "0") {
		$.messager.alert("提示", "修改成功", "success", function() {
			Clear_Click();
		});
	} else {
		DHCWeb_HISUIalert("修改失败：" + rtn);
		return;
	}
}

function init_Layout(){
	DHCWeb_ComponentLayout();
}