/**
 * FileName: dhcbill.capitalflow.js
 * Author: ZQB
 * Date: 2018-10-13
 * Description: 往来借款管理页面
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 1000000000;
		},
		message: $g("金额输入过大")
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
	
	//新增
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});
	
	//删除
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	//接收
	$HUI.linkbutton("#btn-receive", {
		onClick: function () {
			receiveClick();
		}
	});
	
	$HUI.combobox("#CapType", {
		panelHeight: 'auto',
		editable: false,
		data: [{id: 'I', text: $g('住院')},
		       {id: 'O', text: $g('门诊')}
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
	
	//借方收费员
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
		data: [{id: 'OUT', text: $g('借出'), selected: true},
			   {id: 'IN', text: $g('借入')}
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
			CapType: getValueById("CapType"),        //O:门诊, I:住院
			CapPayMode:  getValueById("CapPayMode"),
			BorrowUser: getValueById("BorrowUser"),
			OptionType: getValueById("OptionType"), //操作类型 借入转出
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if (row.CapComFlag == "N") {			
				return 'color: #FF0000;';    //未确认接收
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
		CapType: getValueById("CapType") ,    //O:门诊, I:住院
		CapPayMode:  getValueById("CapPayMode"),
		BorrowUser: getValueById("BorrowUser"),
		OptionType: getValueById("OptionType"), //操作类型 借入转出
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore("tTransList", queryParams);
}

/**
* 添加
*/
function addClick() {
	if (!checkData()) {
		return;
	}
	var BorrowUser = getValueById("BorrowUser");
	if (!BorrowUser) {
		$.messager.popover({msg: "借方用户不能为空", type: "info"});
		return;
	}
	if (BorrowUser == PUBLIC_CONSTANT.SESSION.USERID) {
		$.messager.popover({msg: "当前用户不能和借方用户一致", type: "info"});
		return;
	}
	var OptionType = getValueById("OptionType");
	if (OptionType == "IN") {
		$.messager.popover({msg: "目前不能运用借入类别，请查询选择相应记录[确认接收]", type: "info"});
		return;
	}
	var Acount = getValueById("Acount");
	if (!(Acount > 0)) {
		$.messager.popover({msg: "金额输入错误", type: "info"});
		return;
	}
	var PayMode = getValueById("CapPayMode");
	if (!PayMode) {
		$.messager.popover({msg: "转借方式不能为空", type: "info"});
		return;
	}
	var msg = $g("是否确认") + $("#OptionType").combobox("getText") + "<font style=\"color:red;\">" + Acount + "</font>" + $g("元") + "？";
	$.messager.confirm("确认", msg, function (r) {
		if (!r) {
			return;
		}
		var CapType = getValueById("CapType");    //目前医院只用于住院，先入参写死
		var insertInfo = PUBLIC_CONSTANT.SESSION.USERID + "^" + BorrowUser + "^" + OptionType + "^" + Acount + "^" + PayMode + "^" + CapType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$.m({
			ClassName: "web.DHCBillCapitalFlowLogic",
			MethodName: "InsertCapitalFlow",
			InsertInfo: insertInfo
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "转借成功", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "转借失败：" + (myAry[1] || myAry[0]), type: "error"});
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
* 删除
*/
function deleteClick() {
	var row = GV.TransList.getSelected();
	if (!row || !row.CapRowId) {
		$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认删除？", function (r) {
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
				$.messager.popover({msg: "删除成功", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "删除失败，错误代码：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

/**
* 确认接收
*/
function receiveClick() {
	var row = GV.TransList.getSelected();
	if (!row || !row.CapRowId) {
		$.messager.popover({msg: "请选择需要接收的记录", type: "info"});
		return;
	}
	if ((row.CapFlag == "OUT") && (PUBLIC_CONSTANT.SESSION.USERID != row.CapObjUsrDR)) {
		$.messager.popover({msg: "只能由<font style=\"color:red;\">" + row.CapObjUsrName +"</font>接收", type: "info"});
		return;
	}
	$.messager.confirm('确认', '是否确认接收？', function (r) {
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
				$.messager.popover({msg: "确认成功", type: "success"});
				loadTransList();
				return;
			}
			$.messager.popover({msg: "确认失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}