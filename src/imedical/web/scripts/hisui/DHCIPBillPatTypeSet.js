/// DHCIPBillPatTypeSet.js

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	init_Layout();
	
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
	
	$HUI.linkbutton("#update", {
		onClick: function () {
			Update_Click();
		}
	});
	
	$HUI.linkbutton("#clear", {
		onClick: function () {
			Clear_Click();
		}
	});
	
	var tableName = "Bill_IP_GroupAdmRea";
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
			var url = $URL + "?ClassName=web.DHCIPBillPatTypeSet&QueryName=FindSSGRP&ResultSetType=array";
			$("#SSGrp").combobox("clear").combobox("reload", url);
			
			var url = $URL + "?ClassName=web.DHCIPBillPatTypeSet&QueryName=FindAdmReason&ResultSetType=array";
			$("#PatType").combobox("clear").combobox("reload", url);
			
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
		onChange: function (newValue , oldValue) {
			setValueById("UserGrp", (newValue || ""));
		}
	});
	
	$HUI.combobox("#PatType", {
		url: $URL,
		editable: false,
		valueField: "id",
		textField: "text",
		onBeforeLoad: function (param) {
			$.extend(param, {
						HospId: getValueById("Hospital")
					});
			return true;
		}
	});
});

//���
function Add_Click() {
	var grp = getValueById('SSGrp');
	var pattype = getValueById('PatType');
	var deft = getValueById('Deft') ? "Y" : "N";
	var billNotPrint = getValueById('BillNotPrint') ? "Y" : "N";
	
	if(!grp) {
		DHCWeb_HISUIalert("��ȫ�鲻��Ϊ��");
		return;
	}
	if(!pattype) {
		DHCWeb_HISUIalert("�������Ͳ���Ϊ��");
		return;
	}
	var hospId = getValueById("Hospital");
	//�ж��Ƿ����
	var encmeth = getValueById('CheckGrp');
	var rtn = cspRunServerMethod(encmeth, "", grp, pattype, deft, hospId);
	if (rtn == "1") {
		DHCWeb_HISUIalert("����Ϣ�Ѵ���");
		return;
	}else if(rtn == "2") {
		DHCWeb_HISUIalert("�ð�ȫ���Ѵ���Ĭ��ֵ");
		return;
	}
	$.messager.confirm("ȷ��", "ȷ�ϱ��棿", function (r) {
		if (r) {
			var encmeth = getValueById('getAdd');
			var rtn = cspRunServerMethod(encmeth, grp, pattype, deft, billNotPrint, hospId);
			if (rtn == "0") {
				$.messager.alert('��ʾ', '����ɹ�', 'success');
				$('#clear').click();
			 } else {
				DHCWeb_HISUIalert(t['02']);
			}
		}
	});
}

//ɾ��
function  Delete_Click() {
	var row = $("#tDHCIPBillPatTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("��ѡ��Ҫɾ���ļ�¼.");
		return;
	}
	
	$.messager.confirm("��ʾ", "�Ƿ�ȷ��ɾ��?",function (r) {
		if (r){
			var encmeth = getValueById('getDel');
			var rtn = cspRunServerMethod(encmeth, row.rowid);
			if (rtn == "0") {
				$.messager.alert('��ʾ', 'ɾ���ɹ�', 'success');
				$('#clear').click();
			}else {
				$.messager.alert('��ʾ', 'ɾ��ʧ�ܣ�' + rtn, 'error');
			}
		}
	});
}

function SelectRowHandler(index, rowData) {
	setValueById('SSGrp', rowData.grpDr);
	setValueById('PatType', rowData.admReaDr);
	setValueById('Deft', (rowData.def == "Y"));
	setValueById('BillNotPrint', (rowData.TBillNotPrint == 'Y'));
}

//���� wanghuicai
function Update_Click() {
	var row = $("#tDHCIPBillPatTypeSet").datagrid("getSelected");
	if (!row || !row.rowid) {
		DHCWeb_HISUIalert("��ѡ��Ҫ�޸ĵļ�¼");
		return;
	}
	var grp = getValueById('SSGrp');
	var pattype =getValueById('PatType');
	var deft = getValueById('Deft') ? "Y" : "N";
	var billNotPrint = getValueById('BillNotPrint') ? "Y" : "N";
	
	var hospId = getValueById("Hospital");
	
	var encmeth = getValueById('CheckGrp');
	var rtn = cspRunServerMethod(encmeth, row.rowid, grp, pattype, deft, hospId);
	if (rtn == "1") {
		DHCWeb_HISUIalert("����Ϣ�Ѵ���");
		return;
	}else if (rtn == "2") {
		DHCWeb_HISUIalert("�ð�ȫ���Ѵ���Ĭ��ֵ");
		return;
	}
	
	$.messager.confirm("ȷ��", "ȷ���޸ģ�", function (r) {
		if (r) {
			var encmeth = getValueById('UpdateEncrypt');
			var rtn = cspRunServerMethod(encmeth, row.rowid, grp, pattype, deft, billNotPrint);
			if (rtn == "0") {
				$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
				$('#clear').click();
			}else {
				$.messager.alert('��ʾ', '�޸�ʧ�ܣ�' + rtn, 'error');
			}
		}
	});
}

//add 2009-8-4
function Clear_Click() {
	$("#UserGrp").val("");
	$(".combobox-f:not(#Hospital)").combobox("clear");
	$(".checkbox-f").checkbox("uncheck");
	$("#Find").click();
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}