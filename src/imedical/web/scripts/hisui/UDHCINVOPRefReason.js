/// UDHCINVOPRefReason.js

$(function () {
	init_Layout();
	
	$HUI.linkbutton("#Add", {
		onClick: function () {
			Add_OnClick();
		}
	});

	$HUI.linkbutton("#Edit", {
		onClick: function () {
			Edit_OnClick();
		}
	});
	
	var tableName = "Bill_OP_RefInvReason";
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
			setValueById("hospId", (newValue || ""));
			ReLoadH();
		}
	});
});

function SelectRowHandler(index, rowData) {
	var myTCode = rowData.TCode;
	var myTDesc = rowData.TDesc;
	setValueById("Code", myTCode);
	setValueById("Desc", myTDesc);
}

function Add_OnClick() {
	var myStr = BuildStr("");
	if (!myStr) {
		return;
	}
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCINVOPReasonEdit",
				MethodName: "InsertReason",
				ReasonInfo: myStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.alert("提示", "保存成功", "success", function () {
						ReLoadH();
					});
				} else {
					$.messager.popover({msg: "保存失败：" + myAry[0], type: "error"});
				}
			});
		}
	});
}

function ReLoadH() {
	$('#tUDHCINVOPRefReason').datagrid('load', $.extend($('#tUDHCINVOPRefReason').datagrid("options").queryParams, {hospId: getValueById("hospId")}));
}

function Edit_OnClick() {
	var row = $("#tUDHCINVOPRefReason").datagrid("getSelected");
	if (!row || !row.TRowID) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	var myRowID = row.TRowID;
	var myStr = BuildStr(myRowID);
	if (!myStr) {
		return;
	}
	$.messager.confirm("确认", "确认修改？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCINVOPReasonEdit",
				MethodName: "EditReason",
				IRRRowID: myRowID,
				ReasonInfo: myStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.alert("提示", "修改成功", "success", function () {
						ReLoadH();
					});
				} else {
					$.messager.popover({msg: "修改失败：" + myAry[0], type: "error"});
				}
			});
		}
	});
}

function BuildStr(rowId) {
	var code = $.trim(getValueById("Code"));
	var desc = $.trim(getValueById("Desc"));
	if (!code) {
		$.messager.popover({msg: "代码不能为空", type: "info"});
		focusById("Code");
		return myStr;
	}
	if (!desc) {
		$.messager.popover({msg: "描述不能为空", type: "info"});
		focusById("Desc");
		return myStr;
	}
	var myStr= "";
	var myAry = [];
	myAry[0] = rowId;
	myAry[1] = code;
	myAry[2] = desc;
	myAry[3] = getValueById("hospId");
	var rtn = tkMakeServerCall("web.UDHCINVOPReasonEdit", "CheckRepeat", myAry[0], myAry[1], myAry[2], myAry[3]);
	if (rtn == 1) {
		$.messager.popover({msg: "代码不能重复", type: "info"});
		return myStr;
	} else if (rtn == 2) {
		$.messager.popover({msg: "描述不能重复", type: "info"});
		return myStr;
	}
	myStr = myAry.join("^");
	return myStr;
}

function init_Layout() {
	DHCWeb_ComponentLayout();
}
