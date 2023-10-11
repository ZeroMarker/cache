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
		data: [{value: 'I', text: 'סԺ'},
			   {value: 'O', text: '����'},
			   {value: 'R', text: '�Һ�'}
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
	    $.messager.popover({msg: "��ѡ���շ����", type: "info"});
		return;
	}
    var FareTypeVal = getValueById("FareType");
    if (!FareTypeVal) {
	    $.messager.popover({msg: "��ѡ���վ�����", type: "info"});
		return;
	}
    var UseDeptVal = getValueById("UseDept");
    if (!UseDeptVal) {
	    $.messager.popover({msg: "��ѡ��Ӧ������", type: "info"});
		return;
	}
    var PrintTempVal = getValueById("PrintTemp");
	if (!PrintTempVal) {
        $.messager.popover({msg: "������ģ������", type: "info"});
		return;
	}
	//�ж��Ƿ����  add zhli  17.9.26
	var rtn = tkMakeServerCall('web.DHCOPBillReasonRefInv', 'CheckInfo', AdmReasonDrVal, FareTypeVal, UseDeptVal, hospId);
	if (rtn == 1){
		$.messager.popover({msg: "��������ظ�����", type: "info"});
	    return;
	}
	$.messager.confirm('��ʾ', 'ȷ�ϱ��棿', function (r) {
		if (!r) {
			return;
		}
		var encmeth = getValueById('Insert');
	    var myrtn = cspRunServerMethod(encmeth, AdmReasonDrVal, FareTypeVal, UseDeptVal, PrintTempVal, hospId);
		if (myrtn == 0) {
			$.messager.popover({msg: "����ɹ�", type: "success"});
	        $('#BtFind').click();
	        return;
		}
		$.messager.popover({msg: "����ʧ��", type: "error"});
	});
}

function deleteClick() {
	var row = $("#tDHCOPBillReasonRefInv").datagrid("getSelected");
	if (!row || !row.TRowid) {
		$.messager.popover({msg: "��ѡ����Ҫɾ���ļ�¼", type: "info"});
		return;
	}
    $.messager.confirm('��ʾ', 'ȷ��ɾ��������¼��', function (r) { 
        if (!r) {
	        return;
        }
    	var encmeth = getValueById('Delete');
        var myrtn = cspRunServerMethod(encmeth, row.TRowid);
        if (myrtn == 0){
            $.messager.popover({msg: "ɾ���ɹ�", type: "success"});
            $('#BtFind').click();
            return;
        }
        $.messager.popover({msg: "ɾ��ʧ��", type: "error"});
    });
}

function init_Layout() {
	DHCWeb_ComponentLayout();	
}