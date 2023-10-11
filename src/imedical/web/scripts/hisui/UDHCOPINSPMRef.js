/// UDHCOPINSPMRef.js

$(function () {
	init_Layout();

	$HUI.linkbutton("#Add", {
		onClick: function () {
			addClick();
		}
	});

	$HUI.linkbutton("#BDelete", {
		onClick: function () {
			deleteClick();
		}
	});

	$HUI.combobox("#INSType", {
		panelHeight: 180,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});

	$HUI.combobox("#PMDesc", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	var tableName = "Bill_OP_AdmReaPayMode";
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
		onLoadSuccess: function (data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function (newValue, oldValue) {
			setValueById("HospId", newValue);
			var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=" + newValue;
			$("#INSType").combobox("clear").combobox("reload", url);
			ReLoadH();
		}
	});
});

function SelectRowHandler(index, rowData) {
	var selectrow = index;
	var myTCode = rowData.TINSType;
	var myTDesc = rowData.TPMDesc;
	var myTRowID = rowData.TRowID;
	var myTINSTypeRowID = rowData.TINSTypeRowID;
	var myTPMRowID = rowData.TPMRowID;
	setValueById("INSType", myTINSTypeRowID);
	setValueById("PMDesc", myTPMRowID);
}

function deleteClick() {
	var row = $("#tUDHCOPINSPMRef").datagrid("getSelected");
	if (!row || !row.TRowID) {
		$.messager.popover({msg: "��ѡ����Ҫɾ���ļ�¼", type: "info"});
		return;
	}
	var encmeth = getValueById("DelEncrypt");
	if (encmeth != "") {
		$.messager.confirm('��ʾ', "ȷ��ɾ��?", function (r) {
			if (!r) {
				return;
			}
			var myrtn = cspRunServerMethod(encmeth, row.TRowID);
			var myary = myrtn.split("^");
			if (myary[0] == 0) {
				$.messager.alert("��ʾ", "ɾ���ɹ�", "success", function () {
					ReLoadH();
				});
				return;
			}
			$.messager.alert("��ʾ", "ɾ��ʧ��", "error");
		});
	}
}

function addClick() {
	var myINSType = getValueById("INSType");
	if (!myINSType) {
		$.messager.popover({msg: "��ѡ��ѱ�", type: "info"});
		return;
	}
	var myPMRowID = getValueById("PMDesc");
	if (!myPMRowID) {
		$.messager.popover({msg: "��ѡ��֧����ʽ", type: "info"});
		return;
	}
	var myHospID = getValueById("Hospital");

	var encmeth = getValueById("AddEncrypt");
	if (encmeth != "") {
		$.messager.confirm('��ʾ', "ȷ�ϱ���?", function (r) {
			if (!r) {
				return;
			}
			var myrtn = cspRunServerMethod(encmeth, myINSType, myPMRowID, myHospID);
			var myary = myrtn.split("^");
			if (myary[0] == 0) {
				$.messager.alert("��ʾ", "����ɹ�", "success", function () {
					ReLoadH();
				});
				return;
			}
			$.messager.alert("��ʾ", "����ʧ��", "error");
		});
	}
}

function ReLoadH() {
	$('#tUDHCOPINSPMRef').datagrid('load', $.extend($('#tUDHCOPINSPMRef').datagrid("options").queryParams, {HospId: getValueById("HospId")}));
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}
