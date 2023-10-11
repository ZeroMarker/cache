/// DHCOPBillHDDCNew.js

var m_SelectedRow = undefined;

$(function () {
	init_Layout();
	
	$HUI.linkbutton("#ADD", {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.linkbutton("#Modfiy", {
		onClick: function () {
			updateClick();
		}
	});
	
	$HUI.linkbutton("#delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			clearClick();
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
			
			$(".combobox-f:not(#Hospital)").combobox("clear").combobox("enable");
			$(".checkbox-f").checkbox("uncheck");
			setValueById("BloodDis", "");

			var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=OrderType&ResultSetType=array";
			$("#OrdType").combobox("reload", url);
			
			url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew2&ResultSetType=array";
			$("#ORDReLoc, #ReCTLOC").combobox("reload", url);
			
			var url = $URL + "?ClassName=web.DHCOPBillHDDC&QueryName=FindCTLocNew&ResultSetType=array";
			$("#CTLOC").combobox("reload", url);
			
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
		data: [{id: 'L', text: '科室'},
			   {id: 'G', text: '科室组'}
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
		defaultFilter: 5,
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
		defaultFilter: 5,
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
		defaultFilter: 5,
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

function addClick() {
	var OrdType = getValueById('OrdType');
	if (OrdType == "") {
		$.messager.popover({msg: "请选择标本", type: "info"});
		return;
	}
	var Locgroupflag = getValueById('Locgroupflag');
	if (Locgroupflag == "") {
		$.messager.popover({msg: "请选择科室类别", type: "info"});
		return;
	}
	var LOCDR = getValueById('LOCDR');
	if (LOCDR == "") {
		$.messager.popover({msg: "请选择科室", type: "info"});
		return;
	}

	var BloodDis = getValueById('BloodDis');
	if (BloodDis == "") {
		$.messager.popover({msg: "采血地点必填", type: "info"});
		return;
	}
	
	$.messager.confirm("提示", "是否确认添加?", function (r) {
		if (!r) {
			return;
		}
		var ReCTLOCID = getValueById('ReCTLOCID');
		var ORDReLocID = getValueById('ORDReLocID');
		var CheckFlag = getValueById("CheckMR") ? 1: 0;
		var HospId = getValueById("Hospital");
		var rtnstr = tkMakeServerCall("web.DHCOPBillHDDC", "CheckLOCBloodDis", OrdType, LOCDR, CheckFlag, ORDReLocID, "", HospId);
		if (rtnstr == 1) {
			$.messager.popover({msg: "已存在默认值", type: "info"});
			return;
		}
		var myrtn = tkMakeServerCall("web.DHCOPBillHDDC", "AddHDDCDetailNew", LOCDR, OrdType, BloodDis, ReCTLOCID, CheckFlag, Locgroupflag, ORDReLocID, HospId);
		var rtn = myrtn.split("^")[0];
		if (rtn == 0) {
			setValueById("LOCDR", "");
			setValueById("BloodDis", "");
			$.messager.alert('提示', '添加成功', 'success', function () {
				$("#tDHCOPBillHDDCNew").datagrid("reload");
			});
			return;
		} 
		if (rtn == -1005) {
			$.messager.popover({msg: "该科室分类已维护采血地点", type: "info"});
			return;
		}
		$.messager.popover({msg: "添加失败", type: "error"});
	});
}

function updateClick() {
	var row = $("#tDHCOPBillHDDCNew").datagrid("getSelected");
	if (!row || !row.RowID) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	var id = row.RowID;
	var OrdType = getValueById('OrdType');
	if (OrdType == "") {
		$.messager.popover({msg: "请选择标本", type: "info"});
		return;
	}
	var Locgroupflag = getValueById('Locgroupflag');
	if (Locgroupflag == "") {
		$.messager.popover({msg: "请选择科室类别", type: "info"});
		return;
	}
	var LOCDR = getValueById("LOCDR");
	if (LOCDR == "") {
		$.messager.popover({msg: "请选择科室", type: "info"});
		return;
	}
	var place = getValueById("BloodDis");
	if (place == "") {
		$.messager.popover({msg: "采血地点必填", type: "info"});
		return;
	}
	$.messager.confirm("提示", "是否确认修改?", function (r) {
		if (!r) {
			return;
		}
		var ReCTLOCID = getValueById("ReCTLOCID");
		var ORDReLocID = getValueById("ORDReLocID");
		var CheckFlag = getValueById("CheckMR") ? 1 : 0;
		var rtnstr = tkMakeServerCall("web.DHCOPBillHDDC", "CheckLOCBloodDis", OrdType, LOCDR, CheckFlag, ORDReLocID, id, getValueById("Hospital"));
		if (rtnstr == 1) {
			$.messager.popover({msg: "已存在默认值", type: "info"});
			return;
		}
		var rtn = tkMakeServerCall("web.DHCOPBillHDDC", "ModFiyHDDCDetailNew", LOCDR, OrdType, place, id, ReCTLOCID, CheckFlag, ORDReLocID);
		if (rtn == 0) {
			$.messager.alert('提示', '修改成功', 'success', function () {
				$("#tDHCOPBillHDDCNew").datagrid("reload");
			});
			return;
		}
		$.messager.popover({msg: "修改失败", type: "error"});
	});
}

function deleteClick() {
	var row = $("#tDHCOPBillHDDCNew").datagrid("getSelected");
	if (!row || !row.RowID) {
		$.messager.popover({msg: "没有选择需要删除的行", type: "info"});
		return;
	}
	var id = row.RowID;
	$.messager.confirm("确认", "是否确认删除？", function (r) {
		if (!r) {
			return;
		}
		var rtn = tkMakeServerCall("web.DHCOPBillHDDC", "DelHDDCDetail", id);
		if (rtn == 0) {
			$.messager.alert('提示', '删除成功', 'success', function () {
				$("#tDHCOPBillHDDCNew").datagrid("reload");
			});
			return;
		}
		$.messager.popover({msg: "删除失败", type: "error"});
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

		setValueById("CheckMR", (rowData.TCheckFlag == 1));
		m_SelectedRow = index;

	} else {
		$("#tDHCOPBillHDDCNew").datagrid("unselectRow", index);
		m_SelectedRow = undefined;
		$(".combobox-f:not(#Hospital)").combobox("clear").combobox("enable");
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

function clearClick() {
	$(".combobox-f:not(#Hospital)").combobox("clear").combobox("enable");
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