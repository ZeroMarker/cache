/**
 * FileName: dhcbill.opbill.epdep.refund.js
 * Anchor: ZhYW
 * Date: 2019-08-13
 * Description: 急诊留观退押金
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkRefableAmt: {    //校验退费金额
	    validator: function(value) {
		    return !GV.RefableAmt || (+value <= +GV.RefableAmt);
		},
		message: "金额不能超过可退金额"
	}
});

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initRefundMenu();
	initEPDepList();
});

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		focusNextEle(e.target.id);
		break;
	case 115: //F4
		readHFMagCardClick();
		break;
	case 118: //F7
		clearClick();
		break;
	case 120: //F9
		setValueById("refAmt", $("#refAmt").val());   //numberbox在光标未离开时getValue取不到值，故先赋值
		refundClick();
		break;
	default:
	}
}

function initRefundMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundClick();
		}
	});
	
	$HUI.linkbutton("#btn-calc", {
		onClick: function () {
			calcClick();
		}
	});
	
	//重打
	$HUI.linkbutton("#btn-reprint", {
		onClick: function () {
			reprintClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//退押金金额
	$HUI.numberbox("#accMLeft", {
		onChange: function(newValue, oldValue) {
			GV.RefableAmt = newValue;   //初始化为账户余额
		}
	});
		
	//支付方式
	$HUI.combobox("#payMode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "DEP";
		},
		onLoadSuccess: function(data) {
			$.each(data, function (index, item) {
				if (item.selected) {
					setValueById("requiredFlag", item.RPFlag);
					return false;
				}
			});
		},
		onSelect: function(rec) {
			setValueById("requiredFlag", rec.RPFlag);
		}
	});
	
	$HUI.combogrid("#admList", {
		panelWidth: 730,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'TAdmRowID',
		textField: 'TAdmRowID',
		columns: [[ {field: 'TAdmRowID', title: '就诊ID', width: 60},
					{field: 'TAdmLocDesc', title: '科室病区', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TAdmWardDesc;
							}
						}
					},
					{field: 'TAdmBedDesc', title: '床号', width: 50},
					{field: 'TAdmDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TAdmTime;
							}
						}
					},
					{field: 'TDisDate', title: '出院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.TDisTime;
							}
						}
					},
					{field: 'TStayState', title: '留观状态', width: 80},
					{field: 'TAdmInsType', title: '就诊费别', width: 80}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
			if (data.total == 1) {
				setValueById("admList", data.rows[0].TAdmRowID);
			}else {
				setValueById("admDate", "");
				setValueById("dept", "");
				setValueById("ward", "");
				setValueById("bedCode", "");
				setValueById("admReason", "");
				setValueById("refAmt", "");
				setValueById("accMRowId", "");
				setValueById("accMLeft", "");
				loadEPDepList();
			}
		},
		onSelect: function (index, row) {
			setAdmInfo(row);
		}
	});
	
	//退款原因
	$HUI.combobox("#refReason", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindRefReason&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
	
	getReceiptNo();
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	if (patientId != "") {
		getPatInfo();
	}
}

function getReceiptNo() {
	if (!CV.ReceiptType) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPBillEPAddDeposit",
		MethodName: "GetCurrentRecNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		var currNo = myAry[3];
		var title = myAry[4];
		var invoiceId = myAry[5];
		if (invoiceId) {
			setValueById("receiptNo", (title + "[" + currNo + "]"));
		}else {
			disableById("btn-refund");
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		getPatInfo();
	}
}

function initEPDepList() {
	var selectRowIndex = undefined;
	GV.EPDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '交款日期', field: 'Tdate', width: 100},
		           {title: '交款时间', field: 'Ttime', width: 80},
				   {title: '金额', field: 'Tamt', width: 100, align: 'right',
				  	 styler: function (value, row, index) {
						return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					 }
				   },
				   {title: '交款类型', field: 'Ttype', width: 80,
				   	styler: function (value, row, index) {
						return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					 }
				   },
				   {title: '收费员', field: 'Tuser', width: 80},
				   {title: '收据号', field: 'Treceiptsno', width: 150},
				   {title: '结账时间', field: 'Tjkdate', width: 150},
				   {title: '当时账户余额', field: 'Taccleft', width: 100, align: 'right'},
				   {title: '支付方式', field: 'Tpaymode', width: 80},
				   {title: '银行卡类型', field: 'Tbankcardtype', width: 100},
				   {title: '支票号', field: 'Tchequeno', width: 100},
				   {title: '银行', field: 'Tbank', width: 100},
				   {title: '支付单位', field: 'Tcompany', width: 100},
				   {title: '支票日期', field: 'Tchequedate', width: 100},
				   {title: '退款原因', field: 'Tbackreason', width: 100},
				   {title: '备注', field: 'Tremark', width: 100},
				   {title: 'AccPreRowID', field: 'AccPreRowID', hidden: true}
			]],
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.EPDepList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			if ((GV.RefPartFlag != "Y") && (row.Tamt > 0)) {
				setValueById("refAmt", row.Tamt);
			}
			if (row.AccPreRowID) {
				enableById("btn-reprint");
			}else {
				disableById("btn-reprint");
			}
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			if (GV.RefPartFlag != "Y") {
				setValueById("refAmt", "");
			}
			disableById("btn-reprint");
		}
	});
}

function loadEPDepList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEPAddDeposit",
		QueryName: "GetEPDepDetail",
		AccountID: getValueById("accMRowId"),
		USERID: "",
		FOOTID: ""
	};
	loadDataGridStore("accDepList", queryParams);
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (!patientNo) {
		return;
	}
	var encmeth = getValueById("GetEPMInfoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setPatInfo", "", patientNo, "", "", "", "");
}

function setPatInfo(str) {
	var myAry = str.split("^");
	if (!myAry[1]) {
		$.messager.popover({msg: "患者不存在", type: "info"});
		disableById("btn-refund");
		focusById("patientNo");
		return;
	}
	var stayFlag = myAry[24];
	if (stayFlag == "N") {
		$.messager.popover({msg: "该患者无留观就诊", type: "info"});
		focusById("patientNo");
		return;
	}
	setValueById("patientNo", myAry[0]);
	setValueById("patientId", myAry[1]);
	setValueById("patName", myAry[2]);
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetPatientInfo",
		patientId: getValueById("patientId")
	}, function(jsonObj) {
		setValueById("patName", jsonObj.PAPERName);
		setValueById("IDNo", jsonObj.PAPERID);
		setValueById("mobPhone", jsonObj.PAPERTelH);
	});
	loadAdmList();
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEPManageCLS",
		QueryName: "SearchSatyAdm",
		RegNo: "",
		PatientID: getValueById("patientId"),
		CardNo: "",
		CardVerify: "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 999999
	}
	loadComboGridStore("admList", queryParams);
}

function setAdmInfo(row) {
	setValueById("admDate", row.TAdmDate);
	setValueById("dept", row.TAdmLocDesc);
	setValueById("ward", row.TAdmWardDesc);
	setValueById("bedCode", row.TAdmBedDesc);
	setValueById("admReason", row.TAdmInsType);
	
	getEPMInfo(row.TAdmRowID);
}

/**
* 获取留观账号信息
*/
function getEPMInfo(adm) {
	if (!adm) {
		return;
	}
	//获取账户信息
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "getCurrAcountID",
		admId: adm
	}, function(rtn) {
		var myAry = rtn.split("^");
		var accMRowId = myAry[1];
		var accMLeft = myAry[2];
		switch(myAry[0]) {
		case "0":
			//判断是否允许部分退
			$.m({
				ClassName: "web.DHCOPBillEPManageCLS",
				MethodName: "GetAdmBillStatus",
				Adm: adm
			}, function(rtn) {
				if (rtn == "Y") {
					GV.RefPartFlag = "Y";
					setValueById("refAmt", accMLeft);
					enableById("refAmt");
				}else {
					/*
					GV.RefPartFlag = "N";
					disableById("refAmt");
					*/
				}
			});
			break;
		case "-1":
			$.messager.popover({msg: "就诊号错误", type: "info"});
			focusById("patientNo");
			break;
		default:
		}
		setValueById("accMRowId", accMRowId);
		setValueById("accMLeft", accMLeft);
		loadEPDepList();
	});
}

function focusNextEle(id) {
	var myIdx = -1;
	var inputAry = $("#accDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id]");
	inputAry.each(function(index, item) {
		if (this.id == id) {
			myIdx = index;
			return false;
		}
	});
	if (myIdx < 0) {
		return true;
	}
	var id = "";
	var $obj = "";
	var nextId = "";
	for (var i = (myIdx + 1); i < inputAry.length; i++) {
		id = inputAry[i].id;
		if (id == "patientNo") {
			continue;
		}
		$obj = $("#" + id);
		if ($obj.parents("tr").is(":hidden")) {
			continue;
		}
		if ($obj.is(":hidden")) {
			if ($obj.next("span").find("input").attr("readonly") == "readonly") {
				continue;
			}
			if ($obj.next("span").find("input").attr("disabled") == "disabled") {
				continue;
			}
		}else {
			if ($obj.attr("disabled") == "disabled") {
				continue;
			}
		}
		nextId = id;
		break;
	}
	if (nextId) {
		focusById(nextId);
		return false;
	}else {
		setTimeout(function() {
			focusById("btn-refund");
		}, 20);
		return false;
	}
	return true;
}

function refundClick() {
	if ($("#btn-refund").hasClass("l-btn-disabled")) {
		return;
	}
	checkRefData().then(function() {
		openEPDETPList().then(function (initPDRowId) {
		    refundEMDep(initPDRowId);
		});
	});
}

function refundEMDep(initPDRowId) {
	var refAmt = getValueById("refAmt");
	$.messager.confirm("确认", "退款额：<font style='color:red;'>" + refAmt + "</font> 元，是否确认退款?", function (r) {
		if (r) {
			var episodeId = getValueById("admList");
			var papmi = getValueById("patientId");
			var patientNo = getValueById("patientNo");
			var cardNo = getValueById("CardNo");
			
			var refReason = getValueById("refReason");
			var payMode = getValueById("payMode");
			var bankCardType = getValueById("bankCardType");
			var checkNo = getValueById("checkNo");
			var bank = getValueById("bank");
			var company = getValueById("company");
			var chequeDate = getValueById("chequeDate");
			var remark = getValueById("remark");
			var accPDType = "R";
			
			var str1 = episodeId + "^" + papmi + "^" + patientNo + "^" + cardNo + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + "";
			var str2 = initPDRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + "";
			str2 += "^" + refReason + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			str2 += "^" + company + "^" + chequeDate + "^" + remark + "^" + accPDType;
			str2 += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			str2 = str2.replace(/undefined/g, "");   //替换所有的undefined
			
			$.m({
				ClassName: "web.DHCOPBillEPAddDeposit",
				MethodName: "NewDeposit",
				str1: str1,
				str2: str2,
				refPartFlag: GV.RefPartFlag
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var emPDRowId = myAry[6];
					if (!getValueById("accMRowId")) {
						setValueById("accMRowId", emPDRowId.split("||")[0]);
					}
					var msg = "退款成功";
					var iconCls = "success";
					if (isCallPaySvr()) {
						//2020-01-25 ZhYW 第三方退费接口 DHCBillPayService.js
						var tradeType = "EPDEP";
						var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
						var rtnValue = RefundPayService(tradeType, initPDRowId, emPDRowId, "", refAmt, tradeType, expStr);
						if (rtnValue.ResultCode != 0) {
						    msg = "HIS退费成功，第三方退费失败：" + rtnValue.ResultMsg + "，错误代码：" + rtnValue.ResultCode + "，请补交易";
							iconCls = "error";
						}
					}
					$.messager.alert("提示", msg, iconCls, function() {
						emPreDepPrint(emPDRowId);
						reloadRefundMenu();
					});
					break;
				case "admerr":
					$.messager.alert("提示", "该患者非急诊流观患者", "info");
					break;
				case "epmerr":
					$.messager.alert("提示", "账户有误", "info");
					break;
				case "amterr":
					$.messager.alert("提示", "金额输入有误", "info");
					break;
				case "PayModeErr":
					$.messager.alert("提示", "支付方式为空", "info");
					break;
				default:
					$.messager.popover({msg: "退款失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

function checkRefData() {
	return new Promise(function (resolve, reject) {
		var bool = true;
		$(".validatebox-text").each(function(index, item) {
			if (!$(this).validatebox("isValid")) {
				bool = false;
				return false;
			}
		});
		if (!bool) {
			return;
		}
		var episodeId = getValueById("admList");
		if (!episodeId) {
			$.messager.popover({msg: "请选择就诊", type: "info"});
			return;
		}
		if (!isCallPaySvr()) {
			var refAmt = getValueById("refAmt");
			if (!refAmt) {
				$.messager.popover({msg: "请输入金额", type: "info"});
				focusById("refAmt");
				return;
			}
			if (!(refAmt > 0)) {
				$.messager.popover({msg: "金额输入错误", type: "info"});
				focusById("refAmt");
				return;
			}
			var accMLeft = getValueById("accMLeft");
			if (+refAmt > +accMLeft) {
				$.messager.popover({msg: "余额不足", type: "info"});
				focusById("refAmt");
				return;
			}
		}
		
		if (CV.ReceiptType && !getValueById("receiptNo")) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			return;
		}
		
		//急诊留观标志
		var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmStayStat", Adm: episodeId}, false);
		var stayFlag = rtn.split("^")[0];
		if (stayFlag != "Y") {
			$.messager.popover({msg: "不是急诊留观患者，不能交留观押金", type: "info"});
			return;
		}
		
		if (!getValueById("refReason")) {
			$.messager.popover({msg: "请选择<font color=red>退款原因</font>", type: "info"});
			focusById("refReason");
			return;
		}
		
		resolve();
	}).then(function() {
	    return openAppendDlg();
	});
}

function openAppendDlg() {
	return new Promise(function (resolve, reject) {
		$("#appendDlg").form("clear");
		if (getValueById("requiredFlag") != "Y") {
			return resolve();
		}
		$("#appendDlg").show();
		var dlgObj = $HUI.dialog("#appendDlg", {
			title: '附加项',
			iconCls: 'icon-w-plus',
			draggable: false,
			resizable: false,
			cache: false,
			modal: true,
			onBeforeOpen: function() {
				setValueById("chequeDate", getDefStDate(0));
				
				//银行卡类型
				$HUI.combobox("#bankCardType", {
					panelHeight: 'auto',
					url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankCardType&ResultSetType=array&JSFunName=GetBankCardTypeToHUIJson",
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 5
				});
				
				//银行
				$HUI.combobox("#bank", {
					panelHeight: 150,
					url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson",
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 5
				});
			},
			onOpen: function() {
				focusById("checkNo");
				var id = "";
				$("#appendDlg").find("input[id]").each(function(index, item) {
					if ($(this).is(":hidden")) {
						$(this).next("span").find("input").keydown(function(e) {
							id = $(this).parents("td").find("input")[0].id;
							var key = websys_getKey(e);
							if (key == 13) {
								_setNextFocus(id);
							}
						});
					}else {
						$(this).keydown(function(e) {
							var key = websys_getKey(e);
							if (key == 13) {
								_setNextFocus(this.id);
							}
						});
					}
				});
				
				function _setNextFocus(id) {
					var myIdx = -1;
					var inputAry = $("#appendDlg").find("input[id]"); 
					inputAry.each(function(index, item) {
						if (this.id == id) {
							myIdx = index;
							return false;
						}
					});
					if (myIdx < 0) {
						return;
					}
					var id = "";
					var $obj = "";
					var nextId = "";
					for (var i = (myIdx + 1); i < inputAry.length; i++) {
						id = inputAry[i].id;
						$obj = $("#" + id);
						if ($obj.parents("tr").is(":hidden")) {
							continue;
						}
						if ($obj.is(":hidden")) {
							if ($obj.next("span").find("input").attr("readonly") == "readonly") {
								continue;
							}
							if ($obj.next("span").find("input").attr("disabled") == "disabled") {
								continue;
							}
						}else {
							if ($obj.attr("disabled") == "disabled") {
								continue;
							}
						}
						nextId = id;
						break;
					}
					if (nextId) {
						focusById(nextId);
						return;
					}
					setTimeout(function() {
						focusById("btn-ok");
					}, 20);
				}
			},
			buttons: [{
						text: '确认',
						id: 'btn-ok',
						handler: function () {
							var bool = true;
							var id = "";
							$("#appendDlg label.clsRequired").each(function(index, item) {
								id = $($(this).parent().next().find("input"))[0].id;
								if (!id) {
									return true;
								}
								if (!getValueById(id)) {
									bool = false;
									focusById(id);
									$.messager.popover({msg: "请输入<font color=red>" + $(this).text() + "</font>", type: "info"});
									return false;
								}
							});
							if (!bool) {
								return;
							}
							dlgObj.close();
							resolve();
						}
					}, {
						text: '关闭',
						handler: function () {
							dlgObj.close();
						}
					}
				]
		});
	});
}

/**
* 第三方支付列表
*/
function openEPDETPList() {
    return new Promise(function (resolve, reject) {
	 	var initPDRowId = "";
	 	//只能全退时，取原Id
		if (GV.RefPartFlag != "Y") {
			var row = GV.EPDepList.getSelected();
			if (row && row.AccPreRowID) {
				initPDRowId = row.AccPreRowID;
			}
		}
		if (!isCallPaySvr()) {
			return resolve(initPDRowId);
		}
        $("#emPDETPDlg").show();
        var dlgObj = $HUI.dialog("#emPDETPDlg", {
            title: $("#payMode").combobox("getText") + "支付列表",
            iconCls: 'icon-w-list',
            draggable: false,
            resizable: false,
            modal: true,
            onOpen: function () {
                $HUI.datagrid("#emPDETPList", {
                    fit: true,
                    border: false,
                    striped: true,
                    singleSelect: true,
                    rownumbers: true,
                    pagination: true,
                    pageSize: 10,
                    columns: [[{field: 'ck', checkbox: true},
							   {title: '交款时间', field: 'Date', width: 150,
								formatter: function (value, row, index) {
									return value + " " + row.Time;
								}
							   },
							   {title: '金额', field: 'Amt', width: 80, align: 'right'},
							   {title: '支付方式', field: 'PayMDesc', width: 75},
							   {title: '收费员', field: 'UserName', hidden: true},
							   {title: '收据号', field: 'ReceiptNo', hidden: true},
							   {title: 'PDRowId', field: 'PDRowId', hidden: true},
							   {title: '可退金额', field: 'RefableAmt', width: 80, align: 'right',
                                styler: function (value, row, index) {
                                    return 'color: #21ba45;font-weight: bold;';
                                }
							   },
							   {title: 'ETPRowId', field: 'ETPRowId', hidden: true},
							   {title: '卡号/账户号', field: 'ETPPan', width: 100},
							   {title: '交易流水号', field: 'ETPRRN', width: 100},
							   {title: 'HIS订单号', field: 'ETPHISTradeNo', width: 100},
							   {title: '第三方订单号', field: 'ETPExtTradeNo', width: 100}
                        ]],
                    url: $URL,
                    queryParams: {
                        ClassName: "web.DHCOPBillEPAddDeposit",
                        QueryName: "QryEPDETPList",
                        accMId: getValueById("accMRowId"),
                        paymId: getValueById("payMode"),
                        hospId: PUBLIC_CONSTANT.SESSION.HOSPID
                    },
                    onDblClickRow: function (index, row) {
	                    var refAmt = getValueById("refAmt");
	                    setValueById("refAmt", (row.RefableAmt < refAmt) ? row.RefableAmt : refAmt);
                        GV.RefableAmt = row.RefableAmt; //给全局变量可退金额赋值，方便校验
                        initPDRowId = row.PDRowId;
                        dlgObj.close();
                    }
                });
            },
            onClose: function () {
                if (initPDRowId) {
                    return resolve(initPDRowId);
                }
            }
        });
    });
}

function reloadRefundMenu() {
	$("#remark").val("");
	$("#refAmt").numberbox("clear");
	$("#payMode, #refReason").combobox("reload");
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "getAccBalance",
		Accid: getValueById("accMRowId")
	}, function(accMLeft) {
		setValueById("accMLeft", accMLeft);
	});
	
	if (CV.ReceiptType) {
		getReceiptNo();
	}
	
	loadEPDepList();
}

function reprintClick() {
	if ($("#btn-reprint").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.EPDepList.getSelected();
	if (!row || !row.AccPreRowID) {
		$.messager.popover({msg: "请选择要补打的急诊留观押金记录", type: "info"});
		return;
	}
	if (row.Tamt > 0) {
		$.messager.popover({msg: "交款记录，请到【急诊留观交押金】界面补打", type: "info"});
		return;
	}
	var emPDRowId = row.AccPreRowID;
	var reprtFlag = 1;
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			emPreDepPrint(emPDRowId + "#" + reprtFlag);
		}
	});
}

function clearClick() {
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	setValueById("requiredFlag", "");
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	GV.RefableAmt = 0;
	$(".numberbox-f").numberbox("clear");
	$("#refAmt").numberbox("isValid");
	$("#payMode").combobox("reload");
	$("#admList").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadEPDepList();
	if (CV.ReceiptType) {
		getReceiptNo();
	}
}

function calcClick() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}

/**
* 是否调用第三方接口
*/
function isCallPaySvr() {
	var payMode = getValueById("payMode");
	var payCallInfo = $.m({ClassName: "DHCBILL.Common.DHCBILLCommon", MethodName: "GetCallModeByPayMode", PayMode: payMode}, false);
	var payCallAry = payCallInfo.split("^");
	var payCallFlag = payCallAry[0];
	return (payCallFlag != 0);
}