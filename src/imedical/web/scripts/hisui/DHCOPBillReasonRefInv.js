/// DHCOPBillReasonRefInv.js

$(function() {
	init_Layout();
	
	$HUI.linkbutton("#BtAdd", {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.linkbutton("#BtDelete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	$HUI.combobox("#AdmReasondesc", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});
	
	$HUI.combobox("#FareType", {
		panelHeight: 120,
		url: $URL + "?ClassName=web.DHCOPBillReasonRefInv&QueryName=InvType&ResultSetType=array",
		editable: false,
		valueField: "value",
		textField: "text"
	});
	
	$HUI.combobox("#UseDept", {
		panelHeight: 120,
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: 'I', text: '住院'},
			   {value: 'O', text: '门诊'},
			   {value: 'R', text: '挂号'}
			  ]
	});
	
	var tableName = "Bill_Com_AdmReaInvType";
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
			setValueById("hospId", newValue);
			var url = $URL + "?ClassName=web.DHCOPBillReasonRefInv&QueryName=ReadAdmReason&ResultSetType=array&HospId=" + newValue;
			$("#AdmReasondesc").combobox("clear").combobox("reload", url);
			$('#BtFind').click();
		}
	});
});

function addClick() {
	var hospId = getValueById("hospId");
    var AdmReasonDrVal = getValueById("AdmReasondesc");
    if (!AdmReasonDrVal) {
	    $.messager.popover({msg: "请选择收费类别", type: "info"});
		return;
	}
    var FareTypeVal = getValueById("FareType");
    if (!FareTypeVal) {
	    $.messager.popover({msg: "请选择收据类型", type: "info"});
		return;
	}
    var UseDeptVal = getValueById("UseDept");
    if (!UseDeptVal) {
	    $.messager.popover({msg: "请选择应用类型", type: "info"});
		return;
	}
    var PrintTempVal = getValueById("PrintTemp");
	if (!PrintTempVal) {
        $.messager.popover({msg: "请输入模板名称", type: "info"});
		return;
	}
	//判断是否存在  add zhli  17.9.26
	var rtn = tkMakeServerCall('web.DHCOPBillReasonRefInv', 'CheckInfo', AdmReasonDrVal, FareTypeVal, UseDeptVal, hospId);
	if (rtn == 1){
		$.messager.popover({msg: "不能添加重复数据", type: "info"});
	    return;
	}
	$.messager.confirm('提示', '确认保存？', function (r) {
		if (!r) {
			return;
		}
		var encmeth = getValueById('Insert');
	    var myrtn = cspRunServerMethod(encmeth, AdmReasonDrVal, FareTypeVal, UseDeptVal, PrintTempVal, hospId);
		if (myrtn == 0) {
			$.messager.popover({msg: "保存成功", type: "success"});
	        $('#BtFind').click();
	        return;
		}
		$.messager.popover({msg: "保存失败", type: "error"});
	});
}

function deleteClick() {
	var row = $("#tDHCOPBillReasonRefInv").datagrid("getSelected");
	if (!row || !row.TRowid) {
		$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
		return;
	}
    $.messager.confirm('提示', '确认删除该条记录？', function (r) { 
        if (!r) {
	        return;
        }
    	var encmeth = getValueById('Delete');
        var myrtn = cspRunServerMethod(encmeth, row.TRowid);
        if (myrtn == 0){
            $.messager.popover({msg: "删除成功", type: "success"});
            $('#BtFind').click();
            return;
        }
        $.messager.popover({msg: "删除失败", type: "error"});
    });
}

function init_Layout() {
	DHCWeb_ComponentLayout();	
}