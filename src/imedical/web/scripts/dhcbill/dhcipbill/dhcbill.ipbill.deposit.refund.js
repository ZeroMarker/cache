/**
 * FileName: dhcbill.ipbill.deposit.refund.js
 * Anchor: ZhYW
 * Date: 2019-07-06
 * Description: 住院押金退款
 */﻿

function initRefDepPanel() {
	initRefDepMenu();
	initRefDepList();
}

function initRefDepMenu() {
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundClick();
		}
	});
	
	$HUI.linkbutton("#btn-refReprint", {
		onClick: function () {
			refReprintClick();
		}
	});
	
	$HUI.linkbutton("#btn-transOPAcc", {
		onClick: function () {
			transOPAccClick();
		}
	});
	
	getRefRcptNo();
	
	if ($("#accPreRcptNo").length > 0) {
		getAccPreRcptNo();
	}
	
	//退费方式
	$HUI.combobox("#refMode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		disabled: (IPBILL_CONF.PARAM.RefDepModifyPayM != "Y"),
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "DEP";
			param.DefFlag = "N";
		}
	});
	
	//押金类型
	$HUI.combobox("#refDepositType", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onChange: function(newValue, oldValue) {
			loadRefDepList();
		}
	});
	
	//退款原因
	$HUI.combobox("#refReason", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCIPBillDeposit&QueryName=FindRefReason&ResultSetType=array",
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initRefDepList() {
	$HUI.datagrid("#refDepList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '收款时间', field: 'Tprtdate', width: 155,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.Tprttime;
					}
				   },
				   {title: '金额', field: 'Tpayamt', width: 100, align: 'right'},
				   {title: 'TPaymodeDR', field: 'TPaymodeDR', hidden: true},
				   {title: '支付方式', field: 'Tpaymode', width: 100},
				   {title: 'Tprtstatus', field: 'Tprtstatus', hidden: true},
				   {title: '收据状态', field: 'TStatus', width: 100,
				   	styler: function(value, row, index) {
						if (("^1^4^").indexOf("^" + row.Tprtstatus + "^") == -1) {
							return 'color: #FF0000;';
						}
					}
				   },
				   {title: 'TArrcpId', field: 'TArrcpId', hidden: true},
				   {title: '收据号', field: 'Trcptno', width: 120},
				   {title: '原收据号', field: 'TInitRcptNo', width: 120},
				   {title: 'TAddUserDR', field: 'TAddUserDR', hidden: true},
				   {title: '收款员', field: 'Tadduser', width: 100},   
				   {title: '账单号', field: 'Tarpbl', width: 80},
				   {title: 'Tadm', field: 'Tadm', hidden: true},
				   {title: 'Tprtrowid', field: 'Tprtrowid', hidden: true},
				   {title: 'TjkDR', field: 'TjkDR', hidden: true},
				   {title: '是否结账', field: 'Tjkflag', width: 80,
				   	formatter: function (value, row, index) {
					   	if (value) {
						   	return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					}
				   },
				   {title: 'TDepositTypeDR', field: 'TDepositTypeDR', hidden: true},
				   {title: '押金类型', field: 'TDepositType', width: 100},
				   {title: 'TInitPrtRowId', field: 'TInitPrtRowId', hidden: true},
				   {title: '结算状态', field: 'Tpaystatus', width: 80},
				   {title: '支票号', field: 'Tcardno', width: 100},
				   {title: '单位', field: 'Tcompany', width: 100},
				   {title: '银行', field: 'Tbank', width: 100},
				   {title: '是否到账', field: 'Tbbackflag', width: 80,
				    formatter: function (value, row, index) {
					   	if (value) {
							return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					}
				   },
				   {title: '到账时间', field: 'Tbbackdate', width: 150,
				    formatter: function (value, row, index) {
					   	if (value) {
							return value + " " + row.Tbbacktime;
						}
					}
				   },
				   {title: '退款原因', field: 'Trefreason', width: 100}
			]],
		onSelect: function(index, row) {
			if (row.Tprtrowid) {
				setValueById("refAmt", row.Tpayamt);
				var refModeExist = false;
				var refModeData = $("#refMode").combobox("getData");
				$.each(refModeData, function (index, item) {
					if (item.CTPMRowID == row.TPaymodeDR) {
						$("#refMode").combobox("setValue", row.TPaymodeDR);
						refModeExist = true;
						return false;
					}
				});
				if (!refModeExist) {
					refModeData.push({"CTPMRowID": row.TPaymodeDR, "CTPMDesc": row.Tpaymode});
					$("#refMode").combobox("loadData", refModeData).combobox("setValue", row.TPaymodeDR);
				}
			}
		}
	});
}

function refundClick() {
	var episodeId = getValueById("episodeId");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCBillPreIPAdmTrans", MethodName: "CheckRefDeposit", episodeId: episodeId}, false);
	if (+rtn == 1) {
		$.messager.popover({msg: "该患者的预住院医嘱存在有效医嘱，不能退押金", type: "info"});
		return;
	}else if (+rtn == 2) {
		$.messager.popover({msg: "该患者由预住院转入门诊的费用未结清，不能退押金", type: "info"});
		return;
	};
	var row = $("#refDepList").datagrid("getSelected");
	if (!row || !row.Tprtrowid) {
		$.messager.popover({msg: "请选择要退的押金", type: "info"});
		return;
	}
	if (row.Tarpbl) {
		$.messager.popover({msg: "该笔押金已结算，不允许退", type: "info"});
		return;
	}
	if (row.Tprtstatus != "1") {
		$.messager.popover({msg: "该笔押金已退款，不允许再退", type: "info"});
		return;
	}
	if ((IPBILL_CONF.PARAM.StrikeDepRequireRcpt == "Y") && !GV.RcptId) {
		if (row.TjkDR || (row.TAddUserDR != PUBLIC_CONSTANT.SESSION.USERID)) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			return;
		}
	}
	var refMode = getValueById("refMode");
	if (!refMode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return;
	}
	//判断是否是"押金转账"退款方式
	var transPayMId = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
	if (transPayMId == refMode) {
		$.messager.popover({msg: "不能以" + $("#refMode").combobox("getText") + "方式退款", type: "info"});
		return;
	}
	var refAmt = getValueById("refAmt");
	
	var depositId = row.Tprtrowid;
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	
	$.messager.confirm("确认", "退款额：<font style='color:red;'>" + refAmt + "</font> 元，是否确认退款?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCIPBillDeposit",
				MethodName: "RefundDeposit",
				initDepId: depositId,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				refReasonId: getValueById("refReason"),
				refModeId: getValueById("refMode"),
				expstr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					var newDepositId = myAry[1];					
					//第三方退费接口 start
					var tradeType = "DEP";
					var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" +PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^";
					var rtnValue = RefundPayService(tradeType, depositId, newDepositId, "", "", "", expStr);
					var msg = "退款成功";
					var iconCls = "success";
					if (rtnValue.rtnCode != "0") {
						msg = "HIS退款成功，第三方退款失败：" + rtnValue.rtnMsg + "，错误代码：" + rtnValue.rtnCode + "，请补交易";
						iconCls = "error";
					}
					//
					$.messager.alert("提示", msg, iconCls);
					$.cm({
						ClassName: "web.DHCBillCommon",
						MethodName: "GetClsPropValById",
						clsName: "User.dhcsfprintdetail",
						id: newDepositId
					}, function(jsonObj) {
						if (jsonObj.prtrcptno) {
							depositPrint(newDepositId + "#" + "");
						}
					});
					reloadRefDepPanel();
				}else {
					$.messager.popover({msg: "退款失败：" + myAry[1], type: "error"});
				}
			});
		}
	});
}

function initRefDepDoc() {
	$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#refRcptNo,#accPreRcptNo)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	getRefRcptNo();
}

function reloadRefDepPanel() {
	$("#refDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#refDepositType)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	refreshBar(getValueById("papmi"), getValueById("episodeId"));
	
	getRefRcptNo();
	loadRefDepList();
	
	if ($("#accPreRcptNo").length > 0) {
		getAccPreRcptNo();
	}
}

function getRefRcptNo() {
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetRcptNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.RcptId = myAry[0];
		var endNo = myAry[1];
		var currNo = myAry[2];
		var title = myAry[3];
		var leftNum = myAry[4];
		var tipFlag = myAry[6];
		if (GV.RcptId) {
			var receiptNo = title + "[" + currNo + "]";
			setValueById("refRcptNo", receiptNo);
			var color = "green";
			if ($("#refRcptNo").hasClass("newClsInvalid")) {
				$("#refRcptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == "1") {
				color = "red";
				$("#refRcptNo").addClass("newClsInvalid");
			}
			var content = "该号段可用票据剩余 <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> 张";
			$("#btn-refRcptTip").popover({cache: false, trigger: 'hover', content: content});
		}
	});
}

function getAccPreRcptNo() {
	$.m({
		ClassName: "web.UDHCAccAddDeposit",
		MethodName: "GetCurrentRecNo",
		userid: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[3]) {
			setValueById("accPreRcptNo", "[" + myAry[3] + "]");
		}
	});
}

function loadRefDepList() {
	var episodeId = getValueById("episodeId");
	if (episodeId) {
		var queryParams = {
			ClassName: "web.DHCIPBillDeposit",
			QueryName: "FindDeposit",
			adm: episodeId,
			depositType: getValueById("refDepositType")
		}
		loadDataGridStore("refDepList", queryParams);
	}
}

function refReprintClick() {
	var row = $("#refDepList").datagrid("getSelected");
	if (!row || !row.Tprtrowid) {
		$.messager.popover({msg: "请选择要补打的押金记录", type: "info"});
		return;
	}
	if (row.Tprtstatus != "3") {
		$.messager.popover({msg: "该笔押金非冲红状态，不能补打", type: "info"});
		return;
	}
	var recepitNo = row.Trcptno;
	if (!recepitNo) {
		$.messager.popover({msg: "票据号为空，不能补打", type: "info"});
		return;
	}
	var depositId = row.Tprtrowid;
	var reprtFlag = "Y";
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			depositPrint(depositId + "#" + reprtFlag);
		}
	});
}

function transOPAccClick() {
	var row = $("#refDepList").datagrid("getSelected");
	if (!row || !row.Tprtrowid) {
		$.messager.popover({msg: "请选择要转的押金记录", type: "info"});
		return;
	}
	var depositType = row.TDepositType;
	if (depositType != "住院押金") {
		$.messager.popover({msg: "非住院押金，不能转入门诊账户", type: "info"});
		return;
	}
	if (row.Tarpbl) {
		$.messager.popover({msg: "该笔押金已结算，不能转入门诊账户", type: "info"});
		return;
	}
	if (row.Tprtstatus != "1") {
		$.messager.popover({msg: "该笔押金已退款，不能转入门诊账户", type: "info"});
		return;
	}
	if ((IPBILL_CONF.PARAM.StrikeDepRequireRcpt == "Y") && !GV.RcptId) {
		if (row.TjkDR || (row.TAddUserDR != PUBLIC_CONSTANT.SESSION.USERID)) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			return;
		}
	}
	var transPayMId = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
	if (!transPayMId) {
		$.messager.popover({msg: "请维护转账支付方式，系统默认取支付方式代码为:DEPZZ", type: "info"});
		return;
	}
	var papmi = getValueById("papmi");
	if (!papmi) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PAPatMas", id: papmi}, false)
	var patientNo = jsonObj.PAPMIIPNo;
	var rtn = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "GetAccByPAPMINo", PAPMINo: patientNo, ExpStr: ""}, false);
	var myAry = rtn.split("^");
	var accMId = myAry[1];
	if (!accMId) {
		$.messager.popover({msg: "没有有效账户，不能转入门诊账户", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.UDHCAccAddDeposit", MethodName: "GetCurrentRecNo", userid: PUBLIC_CONSTANT.SESSION.USERID, type: ""}, false);
	var myAry = rtn.split("^");
	var accPreRcptNo = myAry[3];
	var accPreRcptType = myAry[5];
	if (accPreRcptType && !accPreRcptNo) {
		$.messager.popover({msg: "您没有可用门诊收据，请先领取收据", type: "info"});
		return;
	}
	var refAmt = getValueById("refAmt");
	$.messager.confirm("确认", "转账额：<font style='color:red;'>" + refAmt + "</font> 元，确认转入门诊账户?", function (r) {
		if (r) {
			var depositId = row.Tprtrowid;
			var depositStr = depositId + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + getValueById("refReason") + "^" + transPayMId;			
			var password = "";
			var accPreDepStr = accMId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + accPreRcptNo + "^" + "" + "^" + password + "^" + transPayMId + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^P" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			$.m({
				ClassName: "web.DHCBillDepConversion",
				MethodName: "DepositTransAcount",
				DepositStr: depositStr,
				AccPreDepStr: accPreDepStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch (myAry[0]) {
				case "0":
					var newDepositId = myAry[1];  //住院押金Id
					var accPreId = myAry[2];      //门诊预交金Id
					$.messager.alert("提示", "转入门诊账户成功", "success");
					$.cm({
						ClassName: "web.DHCBillCommon",
						MethodName: "GetClsPropValById",
						clsName: "User.dhcsfprintdetail",
						id: newDepositId
					}, function(jsonObj) {
						if (jsonObj.prtrcptno) {
							depositPrint(newDepositId + "#" + "");
						}
					});
					//打印门诊收据
					accPreDepPrint(accPreId);
					reloadRefDepPanel();
					break;
				default:
					$.messager.popover({msg: "转入门诊账户失败：" + myAry[0], type: "error"});
					break;
				}
			});
		}
	});
}