/// DHCOPBillHDDCNew.js

var m_SelectedRow = undefined;

$(function () {
	init_Layout();
	
	$HUI.linkbutton("#ADD", {
		onClick: function () {
			ADD_Click();
		}
	});
	
	$HUI.linkbutton("#Modfiy", {
		onClick: function () {
			Modfiy_Click();
		}
	});
	
	$HUI.linkbutton("#delete", {
		onClick: function () {
			delete_Click();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			Clear_OnClick();
		}
	});
	
	var tableName = "Bill_OP_HDDC";
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
			
			var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=OrderType&ResultSetType=array";
			$("#OrdType").combobox("clear").combobox("reload", url);
			
			url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew2&ResultSetType=array";
			$("#ORDReLoc, #ReCTLOC").combobox("clear").combobox("reload", url);
			
			var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew&ResultSetType=array";
			$("#CTLOC").combobox("clear").combobox("reload", url);
			
			$('#Find').click();
		}
	});
	
	//标本类型
	$HUI.combobox("#OrdType", {
		url: $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=OrderType&ResultSetType=array",
		editable: false,
		valueField: "TOrderTypeValue",
		textField: "TOrderTypeDesc",
		onBeforeLoad: function (param) {
			$.extend(param, {hospId: getValueById("Hospital")});
			return true;
		}
	});
	
	//科室类别
	$('#Locgroupflag').combobox({
		valueField: 'id',
		textField: 'text',
		data: [{
				"id": 'L',
				"text": "科室"
			}, {
				"id": 'G',
				"text": "科室组"
			}
		],
		onSelect: function (rec) {
			//根据类别加载科室
			var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew&ResultSetType=array";
			$("#CTLOC").combobox("clear").combobox("reload", url);
		}
	});
	
	//接收科室(导诊使用)
	$HUI.combobox("#ORDReLoc", {		
		valueField: "HIDDEN",
		textField: "Desc",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			$.extend(param, {
						HospId: getValueById("Hospital"),
						CTLOC: ""
					});
			return true;
		},
		onSelect: function (rec) {
			setValueById("ORDReLocID", rec.HIDDEN);
		}
	});
	
	//科室
	$HUI.combobox("#CTLOC", {
		url: $URL,
		valueField: "HIDDEN",
		textField: "Desc",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			$.extend(param, {
						CTLOC: "",
						Locgroupflag: getValueById("Locgroupflag"),
						HospId: getValueById("Hospital")
					});
			return true;
		},
		onSelect: function (rec) {
			setValueById("LOCDR", rec.HIDDEN);
		}
	});
	
	//接收科室(医生站使用)
	$HUI.combobox("#ReCTLOC", {
		valueField: "HIDDEN",
		textField: "Desc",
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			$.extend(param, {
						HospId: getValueById("Hospital"),
						CTLOC: ""
					});
			return true;
		},
		onSelect: function (rec) {
			setValueById('ReCTLOCID', rec.HIDDEN);
		}
	});
});

function ADD_Click() {
	var OrdType = getValueById('OrdType');
	if (OrdType == "") {
		DHCWeb_HISUIalert("请选择标本");
		return;
	}
	var Locgroupflag = getValueById('Locgroupflag');
	if (Locgroupflag == "") {
		DHCWeb_HISUIalert("请选择科室类别");
		return;
	}
	var LOCDR = getValueById('LOCDR');
	if (LOCDR == "") {
		DHCWeb_HISUIalert("请选择科室");
		return;
	}

	var BloodDis = getValueById('BloodDis');
	if (BloodDis == "") {
		DHCWeb_HISUIalert("采血地点必填");
		return;
	}
	
	$.messager.confirm("提示", "是否确认添加?", function (r) {
		if (r) {
			var ReCTLOCID = getValueById('ReCTLOCID');
			var ORDReLocID = getValueById('ORDReLocID');
			var CheckFlag = getValueById("CheckMR") ? 1: 0;
			var HospId = getValueById("Hospital");
			var rtnstr = tkMakeServerCall("web.DHCOPBillHDDC", "CheckLOCBloodDis", OrdType, LOCDR, CheckFlag, ORDReLocID, "", HospId);
			if (rtnstr == 1) {
				DHCWeb_HISUIalert("已存在默认值");
				return;
			}
			var myrtn = tkMakeServerCall("web.DHCOPBillHDDC", "AddHDDCDetailNew", LOCDR, OrdType, BloodDis, ReCTLOCID, CheckFlag, Locgroupflag, ORDReLocID, HospId);
			var rtn = myrtn.split("^")[0];
			if (rtn == 0) {
				setValueById("LOCDR", "");
				setValueById("BloodDis", "");
				$.messager.alert('提示', '添加成功', 'info', function () {
					$("#tDHCOPBillHDDCNew").datagrid("reload");
				});
			} else if (rtn == "-1005") {
				DHCWeb_HISUIalert("该科室分类已维护采血地点");
				return;
			} else {
				DHCWeb_HISUIalert("添加失败");
			}
		}
	});
}

function Modfiy_Click() {
	var row = $("#tDHCOPBillHDDCNew").datagrid("getSelected");
	if (!row || !row.RowID) {
		DHCWeb_HISUIalert("请选择需要修改的行");
		return;
	}
	var id = row.RowID;
	var OrdType = getValueById('OrdType');
	if (OrdType == "") {
		DHCWeb_HISUIalert("请选择标本");
		return;
	}
	var Locgroupflag = getValueById('Locgroupflag');
	if (Locgroupflag == "") {
		DHCWeb_HISUIalert("请选择科室类别");
		return;
	}
	var LOCDR = getValueById("LOCDR");
	if (LOCDR == "") {
		DHCWeb_HISUIalert("请选择科室");
		return;
	}
	var place = getValueById("BloodDis");
	if (place == "") {
		DHCWeb_HISUIalert("采血地点必填");
		return;
	}
	$.messager.confirm("提示", "是否确认修改?", function (r) {
		if (r) {
			var ReCTLOCID = getValueById("ReCTLOCID");
			var ORDReLocID = getValueById("ORDReLocID");
			var CheckFlag = getValueById("CheckMR") ? 1 : 0;
			var rtnstr = tkMakeServerCall("web.DHCOPBillHDDC", "CheckLOCBloodDis", OrdType, LOCDR, CheckFlag, ORDReLocID, id, getValueById("Hospital"));
			if (rtnstr == 1) {
				DHCWeb_HISUIalert("已存在默认值");
				return;
			}
			var rtn = tkMakeServerCall("web.DHCOPBillHDDC", "ModFiyHDDCDetailNew", LOCDR, OrdType, place, id, ReCTLOCID, CheckFlag, ORDReLocID);
			if (rtn == 0) {
				$.messager.alert('提示', '修改成功', 'info', function () {
					$("#tDHCOPBillHDDCNew").datagrid("reload");
				});
			} else {
				DHCWeb_HISUIalert("修改失败");
			}
		}
	});
}

function delete_Click() {
	var row = $("#tDHCOPBillHDDCNew").datagrid("getSelected");
	if (!row || !row.RowID) {
		DHCWeb_HISUIalert("没有选择需要删除的行");
		return;
	}
	var id = row.RowID;
	$.messager.confirm("确认", "是否确认删除？", function (r) {
		if (r) {
			var rtn = tkMakeServerCall("web.DHCOPBillHDDC", "DelHDDCDetail", id);
			if (rtn == 0) {
				DHCWeb_HISUIalert("删除成功");
				$("#tDHCOPBillHDDCNew").datagrid("reload");
			} else {
				DHCWeb_HISUIalert("删除失败");
			}
		}
	});
}

function SelectRowHandler(index, rowData) {
	if (index != m_SelectedRow) {
		var LocgroupflagID = rowData.TLocgroupflagID;
		$("#Locgroupflag").combobox("setValue", LocgroupflagID).combobox('disable')
		
		var LocSortingDR = rowData.TLocSortingDR;
		setValueById("LOCDR", LocSortingDR);

		var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew&ResultSetType=array";
		$("#CTLOC").combobox("clear").combobox("reload", url).combobox('disable').combobox("setValue", LocSortingDR);   //选中行以后 加载科室下拉combobox

		setValueById("ReCTLOCID", rowData.TReCTLOCID);
		setValueById("ReCTLOC", rowData.TReCTLOCID);      //接收科室(医生站使用)
		
		setValueById("ORDReLocID", rowData.TORDReLocID);
		setValueById("ORDReLoc", rowData.TORDReLocID);    //接收科室(导诊使用)

		setValueById("BloodDis", rowData.TBloodDis);

		setValueById("OrdType", rowData.myOrderType);

		setValueById("CheckMR", (rowData.TCheckFlag == "1"));
		m_SelectedRow = index;

	} else {
		$("#tDHCOPBillHDDCNew").datagrid("unselectRow", index);
		m_SelectedRow = undefined;
		$('.combobox-f:not(#Hospital)').combobox('clear').combobox('enable');
		$('#CTLOC').combobox('loadData', []);
		
		setValueById("LOCDR", "");
		setValueById("ReCTLOC", "");
		setValueById("ReCTLOCID", "");
		setValueById("BloodDis", "");
		setValueById("ORDReLoc", "");
		setValueById("ORDReLocID", "");
		setValueById("CheckMR", false);
	}
}

function Clear_OnClick() {
	$('.combobox-f:not(#Hospital)').combobox('clear').combobox('enable');
	$("#CTLOC").combobox("loadData", []);
	setValueById("CTLOC", "");
	setValueById("LOCDR", "");
	setValueById("ReCTLOC", "");
	setValueById("ReCTLOCID", "");
	setValueById("BloodDis", "");
	setValueById("ORDReLoc", "");
	setValueById("ORDReLocID", "");
	setValueById("CheckMR", false);
	$('#Find').click();
}

function init_Layout() {
	DHCWeb_ComponentLayout();
	$('.cklabel').find('label').css('margin-right', '0px');
	$('.UserTips').find('.messager-popover').css('margin-left', '10px');
}