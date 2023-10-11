/**
 * FileName: dhcbill.capitalflow.js
 * Author: ZQB
 * Date: 2018-10-13
 * Description: ����������ҳ��
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //У�����ֵ
	    validator: function(value) {
		    return value < 1000000000;
		},
		message: $g("����������")
	}
});

$(function () {
	initQueryMenu();
	initTransList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadTransList();
		}
	});
	
	//����
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});
	
	//ɾ��
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	//����
	$HUI.linkbutton("#btn-receive", {
		onClick: function () {
			receiveClick();
		}
	});
	
	$HUI.combobox("#CapType", {
		panelHeight: 'auto',
		editable: false,
		data: [{id: 'I', text: $g('סԺ')},
		       {id: 'O', text: $g('����')}
		],
		valueField: 'id',
		textField: 'text',
		value: 'I',
		onChange: function(newValue, oldValue) {
			$('#BorrowUser').combobox("clear").combobox("reload");
		}
	});
	
	$HUI.combobox('#CapPayMode', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		editable: true,
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "DEP";
		},
		onLoadSuccess: function(data) {
			$.each(data, function (index, item) {
				if (item.CTPMCode == "CASH") {
					setValueById("CapPayMode", item.CTPMRowID);
					return false;
				}
			});
		},
		loadFilter: function(data) {
			var paymCodeAry = ["CASH", "ZP", "YHK"];
			data = data.filter(function (item) {
		   		return paymCodeAry.indexOf(item.CTPMCode) != -1;
		  	});
			return data;
		}
	});
	
	//�跽�շ�Ա
	$('#BorrowUser').combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		method: "GET",
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.invType = getValueById("CapType");
		}
	});

	$("#OptionType").combobox({
		panelHeight: 'auto',
		editable: true,
		valueField: 'id',
		textField: 'text',
		data: [{id: 'OUT', text: $g('���'), selected: true},
			   {id: 'IN', text: $g('����')}
		]
	});
}

function initTransList() {
	GV.TransList = $HUI.datagrid('#tTransList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCBillCapitalFlowLogic",
		queryName: "FindTransList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["CapDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["CapRowId", "CapFlag", "CapObjUsrDR", "CapinitCapDR", "CapJkDR", "CapComFlag", "CapInitCapDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "CapTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.CapDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "CapTime") {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams:  {
			ClassName: "web.DHCBillCapitalFlowLogic",
			QueryName: "FindTransList",
			StDate: getValueById("StDate"),
			EndDate: getValueById("EndDate"),
			CapType: getValueById("CapType"),        //O:����, I:סԺ
			CapPayMode:  getValueById("CapPayMode"),
			BorrowUser: getValueById("BorrowUser"),
			OptionType: getValueById("OptionType"), //�������� ����ת��
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if (row.CapComFlag == "N") {			
				return 'color: #FF0000;';    //δȷ�Ͻ���
			}
		}
	});
}

function loadTransList() {
	var queryParams = {
		ClassName: "web.DHCBillCapitalFlowLogic",
		QueryName: "FindTransList",
		StDate: getValueById("StDate"),
		EndDate: getValueById("EndDate"),
		CapType: getValueById("CapType") ,    //O:����, I:סԺ
		CapPayMode:  getValueById("CapPayMode"),
		BorrowUser: getValueById("BorrowUser"),
		OptionType: getValueById("OptionType"), //�������� ����ת��
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("tTransList", queryParams);
}

/**
* ���
*/
function addClick() {
	if (!checkData()) {
		return;
	}
	var BorrowUser = getValueById("BorrowUser");
	if (!BorrowUser) {
		$.messager.popover({msg: "�跽�û�����Ϊ��", type: "info"});
		return;
	}
	if (BorrowUser == PUBLIC_CONSTANT.SESSION.USERID) {
		$.messager.popover({msg: "��ǰ�û����ܺͽ跽�û�һ��", type: "info"});
		return;
	}
	var OptionType = getValueById("OptionType");
	if (OptionType == "IN") {
		$.messager.popover({msg: "Ŀǰ�������ý���������ѯѡ����Ӧ��¼[ȷ�Ͻ���]", type: "info"});
		return;
	}
	var Acount = getValueById("Acount");
	if (!(Acount > 0)) {
		$.messager.popover({msg: "����������", type: "info"});
		return;
	}
	var PayMode = getValueById("CapPayMode");
	if (!PayMode) {
		$.messager.popover({msg: "ת�跽ʽ����Ϊ��", type: "info"});
		return;
	}
	var msg = $g("�Ƿ�ȷ��") + $("#OptionType").combobox("getText") + "<font style=\"color:red;\">" + Acount + "</font>" + $g("Ԫ") + "��";
	$.messager.confirm("ȷ��", msg, function (r) {
		if (!r) {
			return;
		}
		var CapType = getValueById("CapType");    //ĿǰҽԺֻ����סԺ�������д��
		var insertInfo = PUBLIC_CONSTANT.SESSION.USERID + "^" + BorrowUser + "^" + OptionType + "^" + Acount + "^" + PayMode + "^" + CapType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$.m({
			ClassName: "web.DHCBillCapitalFlowLogic",
			MethodName: "InsertCapitalFlow",
			InsertInfo: insertInfo
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "ת��ɹ�", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "ת��ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}

/**
* ɾ��
*/
function deleteClick() {
	var row = GV.TransList.getSelected();
	if (!row || !row.CapRowId) {
		$.messager.popover({msg: "��ѡ����Ҫɾ���ļ�¼", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ��ɾ����", function (r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCBillCapitalFlowLogic",
			MethodName: "DeleteCapitalFlow",
			CapRowId: row.CapRowId,
			UserId: PUBLIC_CONSTANT.SESSION.USERID
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "ɾ���ɹ�", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "ɾ��ʧ�ܣ�������룺" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

/**
* ȷ�Ͻ���
*/
function receiveClick() {
	var row = GV.TransList.getSelected();
	if (!row || !row.CapRowId) {
		$.messager.popover({msg: "��ѡ����Ҫ���յļ�¼", type: "info"});
		return;
	}
	if ((row.CapFlag == "OUT") && (PUBLIC_CONSTANT.SESSION.USERID != row.CapObjUsrDR)) {
		$.messager.popover({msg: "ֻ����<font style=\"color:red;\">" + row.CapObjUsrName +"</font>����", type: "info"});
		return;
	}
	$.messager.confirm('ȷ��', '�Ƿ�ȷ�Ͻ��գ�', function (r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCBillCapitalFlowLogic",
			MethodName: "ComfirmCapitalFlow",
			CapRowId: row.CapRowId,
			UserId: PUBLIC_CONSTANT.SESSION.USERID
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "ȷ�ϳɹ�", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "ȷ��ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}