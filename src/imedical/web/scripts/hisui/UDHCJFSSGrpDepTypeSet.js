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
* ����
*/
function Add_Click() {
	var grpDr = getValueById("SSGrp");
	if (!grpDr) {
		DHCWeb_HISUIalert("��ȫ�鲻��Ϊ��");
		return;
	}
	var depTypeDr = getValueById("DEPTYPE");
	if (!depTypeDr) {
		DHCWeb_HISUIalert("Ѻ�����Ͳ���Ϊ��");
		return;
	}
	var deft = getValueById('Deft') ? "Y" : "N";
	
	//�ж��Ƿ����
	var hospId = getValueById("Hospital");
	var encmeth = getValueById('CheckGrp');
	var rtn = cspRunServerMethod(encmeth, grpDr, depTypeDr, deft, hospId);
	if (rtn == "0") {
		DHCWeb_HISUIalert(t['05']);
		return;
	}else if (rtn == "-1") {
		DHCWeb_HISUIalert("�ð�ȫ���Ѵ���Ĭ��ֵ!");
		return;
	}
	$.messager.confirm("��ʾ", "ȷ�ϱ��棿",function (r) {
		var encmeth = getValueById('getAdd');
		var rtn = cspRunServerMethod(encmeth, grpDr, depTypeDr, deft, hospId);
		if (rtn == "0") {
			$.messager.alert("��ʾ", t['03'], "success");
			Clear_Click();
		} else {
			$.messager.alert("��ʾ", t['02'] + ":" + rtn, "error");
			return;
		}
	});	
}

/**
* ɾ��
*/
function Delete_Click() {
	var row = $("#tUDHCJFSSGrpDepTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("��ѡ����Ҫɾ���ļ�¼.");
		return;
	}
	var rowId = row.rowid;
	$.messager.confirm("��ʾ", "�Ƿ�ȷ��ɾ��?",function (r) {
		if (r) {
			var encmeth = getValueById('getDel');
			var rtn = cspRunServerMethod(encmeth, rowId);
			if (rtn == "0") {
				$.messager.alert('��ʾ', 'ɾ���ɹ�', 'success');
				Clear_Click();
			}else {
				$.messager.alert('��ʾ', 'ɾ��ʧ�ܣ�' + rtn, 'error');
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
* ���� tangzf 2019-5-28
*/
function Update_Click() {
	var row = $("#tUDHCJFSSGrpDepTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("��ѡ����Ҫ�޸ĵļ�¼.");
		return;
	}
	var rowId = row.rowid;
	var grpDr = getValueById("SSGrp");
	if (!grpDr) {
		DHCWeb_HISUIalert("��ȫ�鲻��Ϊ��");
		return;
	}
	var depTypeDr = getValueById("DEPTYPE");
	if (!depTypeDr) {
		DHCWeb_HISUIalert("Ѻ�����Ͳ���Ϊ��");
		return;
	}
	var deft = getValueById("Deft") ? "Y" : "N";
	
	var hospId = getValueById("Hospital");
	var rtn = tkMakeServerCall("web.UDHCJFSSGrpDepTypeSet", "CheckInfoForUpdate", rowId, grpDr, depTypeDr, deft, hospId);
	if (rtn == "-1") {
		DHCWeb_HISUIalert("�����ظ������ͬ��¼");
		return;
	}else if (rtn == "-2") {
		DHCWeb_HISUIalert("�ð�ȫ���Ѵ���Ĭ��ֵ");
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFSSGrpDepTypeSet","UpdateInfo", rowId, grpDr, depTypeDr, deft);
	if (rtn == "0") {
		$.messager.alert("��ʾ", "�޸ĳɹ�", "success", function() {
			Clear_Click();
		});
	} else {
		DHCWeb_HISUIalert("�޸�ʧ�ܣ�" + rtn);
		return;
	}
}

function init_Layout(){
	DHCWeb_ComponentLayout();
}