/// UDHCOPINSPMRef.js

$(function () {
	init_Layout();

	$HUI.linkbutton("#Add", {
		onClick: function () {
			Add_OnClick();
		}
	});

	$HUI.linkbutton("#BDelete", {
		onClick: function () {
			Del_OnClick();
		}
	});

	$HUI.combobox("#INSType", {
		valueField: "id",
		textField: "text",
		defaultFilter: 4
	});

	$HUI.combobox("#PMDesc", {
		url: $URL + "?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array",
		valueField: "CTPM_RowId",
		textField: "CTPM_Desc",
		defaultFilter: 4
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
			var url = $URL + "?ClassName=web.UDHCOPPACCONPayModeEdit&QueryName=ReadAdmReason&ResultSetType=array&HospId=" + newValue;
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

function Del_OnClick() {
	var row = $("#tUDHCOPINSPMRef").datagrid("getSelected");
	if (!row || !row.TRowID) {
		$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
		return;
	}
	var encmeth = getValueById("DelEncrypt");
	if (encmeth != "") {
		$.messager.confirm('提示', "确认删除?", function (r) {
			if (r) {
				var myrtn = cspRunServerMethod(encmeth, row.TRowID);
				var myary = myrtn.split("^");
				if (myary[0] == "0") {
					$.messager.alert("提示", "删除成功", "success", function () {
						ReLoadH();
					});
				} else {
					$.messager.alert("提示", "删除失败", "error");
				}
			}
		});
	}
}

function Add_OnClick() {
	var myINSType = getValueById("INSType");
	if (!myINSType) {
		$.messager.popover({msg: "请选择费别", type: "info"});
		return;
	}
	var myPMRowID = getValueById("PMDesc");
	if (!myPMRowID) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return;
	}
	var myHospID = getValueById("Hospital");

	var encmeth = getValueById("AddEncrypt");
	if (encmeth != "") {
		$.messager.confirm('提示', "确认保存?", function (r) {
			if (r) {
				var myrtn = cspRunServerMethod(encmeth, myINSType, myPMRowID, myHospID);
				var myary = myrtn.split("^");
				if (myary[0] == "0") {
					$.messager.alert("提示", "保存成功", "success", function () {
						ReLoadH();
					});
				} else {
					$.messager.alert("提示", "保存失败", "error");
				}
			}
		});
	}
}

function ReLoadH() {
	$('#tUDHCOPINSPMRef').datagrid('load', $.extend($('#tUDHCOPINSPMRef').datagrid("options").queryParams, {HospId: getValueById("HospId")}));
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}
