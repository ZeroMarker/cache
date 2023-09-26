/**
 * FileName: dhcbill.opbill.accdep.refund.js
 * Anchor: ZhYW
 * Date: 2019-07-29
 * Description: 门诊预交金退款
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initRefundMenu();
	initAccDepList();
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
	
	$HUI.linkbutton("#btn-trans2IPDep", {
		onClick: function () {
			trans2IPDepClick();
		}
	});
	
	$HUI.linkbutton("#btn-voidInvNo", {
		onClick: function () {
			altVoidInvClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	if (GV.DisablePatientNo) {
		$("#patientNo").prop("disabled", GV.DisablePatientNo).css({"font-weight": "bold"});
	}
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
		
	getReceiptNo();
	
	if ($("#depRcptNo").length > 0) {
		getIPDepRcptNo();
	}
	if ($("#admList").length > 0) {
		initAdmList();
	}
	
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
	
	//支付方式
	$HUI.combobox("#payMode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
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
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
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
	try {
		var cardType = getValueById("cardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("cardNo", myAry[1]);
			setValueById("accMLeft", myAry[3]);
			setValueById("patientId", myAry[4]);
			setValueById("patientNo", myAry[5]);
			setValueById("accMRowId", myAry[7]);
			getPatInfo();
			break;
		case "-200":
			setValueById("accMRowId", "");
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("accMRowId", "");
			$.messager.alert("提示", "账户无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		default:
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadAccPreDepList();
		});
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("cardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("cardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var cardAccountRelation = cardTypeAry[24];
			var securityNo = "";
			var myRtn = "";
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")) {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "");
			}else {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("accMLeft", myAry[3]);
				setValueById("patientId", myAry[4]);
				setValueById("patientNo", myAry[5]);
				setValueById("accMRowId", myAry[7]);
				getPatInfo();
				break;
			case "-200":
				setValueById("accMRowId", "");
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			case "-201":
				setValueById("accMRowId", "");
				setTimeout(function () {
					$.messager.alert("提示", "账户无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("btn-readCard");
			$("#cardNo").attr("readOnly", false);
			focusById("cardNo");
		} else {
			enableById("btn-readCard");
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
		}
	} catch (e) {
	}
}

function getReceiptNo() {
	if (!GV.ReceiptType) {
		return;
	}
	$.m({
		ClassName: "web.UDHCAccAddDeposit",
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
			$.messager.popover({msg: "没有可用收据，请先领取", type: "info"});
			disableById("btn-refund");
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("accMRowId", "");
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			var encmeth = getValueById("GetAccMInfoEncrypt");
			cspRunServerMethod(encmeth, "setAccMInfo", "", patientNo, "", "", "", "", "", PUBLIC_CONSTANT.SESSION.HOSPID);
		});
	}
}

function setAccMInfo(str) {
	var myAry = str.split("^");
	if (!myAry[1]) {
		$.messager.popover({msg: "患者不存在", type: "info"});
		focusById("patientNo");
		return;
	}
	if ((myAry[3] != "N") || !myAry[14]) {
		$.messager.popover({msg: "没有有效账户", type: "info"});
		focusById("patientNo");
		return;
	}
	setValueById("patientNo", myAry[0]);
	setValueById("patientId", myAry[1]);
	setValueById("cardNo", myAry[4]);
	setValueById("accMLeft", myAry[6]);
	setValueById("accMRowId", myAry[14]);
	getPatInfo();
}

function initAccDepList() {
	var selectRowIndex = undefined;
	GV.AccDepList = $HUI.datagrid("#accDepList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '交款日期', field: 'Tdate', width: 100},
		           {title: '交款时间', field: 'Ttime', width: 80},
				   {title: '金额', field: 'Tamt', width: 100, align: 'right',
				  	 styler: function (value, row, index) {
						if (row.Tamt >= 0) {
							return 'color: #21ba45;font-weight: bold;';
						}else {
							return 'color: #f16e57;font-weight: bold;';
						}
					 }
				   },
				   {title: '交款类型', field: 'Ttype', width: 80,
				   	styler: function (value, row, index) {
						if (row.Tamt >= 0) {
							return 'color: #21ba45;font-weight: bold;';
						}else {
							return 'color: #f16e57;font-weight: bold;';
						} 
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
				   {title: '账户号', field: 'Tpayaccno', width: 100},
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
				GV.AccDepList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			if (row.AccPreRowID) {
				enableById("btn-reprint");
			}else {
				disableById("btn-reprint");
			}
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			disableById("btn-reprint");
		}
	});
}

function loadAccPreDepList() {
	var queryParams = {
		ClassName: "web.UDHCAccAddDeposit",
		QueryName: "AccDepDetail",
		AccountID: getValueById("accMRowId"),
		USERID: "",
		FOOTID: "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("accDepList", queryParams);
}

function getPatInfo() {
	var papmi = getValueById("patientId");
	if (!papmi) {
		return;
	}
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetPatientInfo",
		patientId: papmi
	}, function(jsonObj) {
		setValueById("patName", jsonObj.PAPERName);
		setValueById("IDNo", jsonObj.PAPERID);
		setValueById("mobPhone", jsonObj.PAPERTelH);
	});
		
	if (getValueById("accMRowId")) {
		loadAdmList();
		loadAccPreDepList();
	}
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCBillDepConversion",
		QueryName: "QueryIPAdmByAccountID",
		AccountID: getValueById("accMRowId"),
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("admList", queryParams);
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
		setTimeout("focusById('btn-refund')", 20);
		return false;
	}
	return true;
}

function refundClick() {
	if ($("#btn-refund").hasClass("l-btn-disabled")) {
		return;
	}	
	if (!checkData()) {
		return;
	}
	refundAccDep();
}

function refundAccDep() {
	var refAmt = getValueById("refAmt");
	$.messager.confirm("确认", "退款额：<font style='color:red;'>" + refAmt + "</font> 元，是否确认退款?", function (r) {
		if (r) {
			var password = "";
			var accMRowId = getValueById("accMRowId");
			var receiptNo = "";
			var refReason = getValueById("refReason");
			var payMode = getValueById("payMode");
			var bankCardType = getValueById("bankCardType");
			var checkNo = getValueById("checkNo");
			var bank = getValueById("bank");
			var company = getValueById("company");
			var payAccNo = getValueById("payAccNo");
			var chequeDate = getValueById("chequeDate");
			var remark = getValueById("remark");
			var accPDType = "R";

			var accPDStr = accMRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + receiptNo + "^" + refReason;
			accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
			accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			accPDStr = accPDStr.replace(/undefined/g, "");   //替换所有的undefined
			
			$.m({
				ClassName: "web.UDHCAccAddDeposit",
				MethodName: "NewDeposit",
				AccPDStr: accPDStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var accPDRowId = myAry[6];
					$.messager.alert("提示", "退款成功", "success");
					accPreDepPrint(accPDRowId);
					reloadRefundMenu();
					break;
				case "passerr":
					$.messager.alert("提示", "密码验证失败", "info");
					break;
				case "amterr":
					$.messager.alert("提示", "金额输入有误", "info");
					break;
				case "accerr":
					$.messager.alert("提示", "账户有误", "info");
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

function checkData() {
	var accMRowId = getValueById("accMRowId");
	if (!accMRowId) {
		$.messager.popover({msg: "账户不存在", type: "info"});
		return false;
	}
	
	var refAmt = getValueById("refAmt");
	if (!refAmt) {
		$.messager.popover({msg: "请输入金额", type: "info"});
		focusById("refAmt");
		return false;
	}
	if (!(+refAmt > 0)) {
		$.messager.popover({msg: "金额输入错误", type: "info"});
		focusById("refAmt");
		return false;
	}
	
	var payMode = getValueById("payMode");
	if (!payMode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return false;
	}
	
	if (GV.ReceiptType && !getValueById("receiptNo")) {
		$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
		return false;
	}
	
	$("#appendDlg").form("clear");   //需要先清除对话框中表单值
	if (getValueById("requiredFlag") == "Y") {
		openAppendDlg();             //弹出其他必填项对话框
		return false;
	}
	
	var cardNo = getValueById("cardNo");
	var cardType = getValueById("cardType");
	var cardTypeAry = cardType.split("^");
	var cardTypeDR = cardTypeAry[0]; 
	var checkRtn = DHCACC_CheckMCFPay(refAmt, cardNo, "", cardTypeDR);
	var myAry = checkRtn.split("^");
	var checkSuccess = false;
	switch(myAry[0]) {
	case "0":
		checkSuccess = true;
		break;
	case "-204":
		$.messager.popover({msg: "密码验证失败", type: "info"});
		break;
	case "-205":
		$.messager.popover({msg: "账户余额不足", type: "info"});
		break;
	case "-206":
		$.messager.popover({msg: "卡号和账户不匹配", type: "info"});
		break;
	case "-208":
		checkSuccess = true;
		break;
	default:
	}
	if (!checkSuccess) {
		return false;
	}
	
	return true;
}


function openAppendDlg() {
	$("#appendDlg").show();
	var dlgObj = $HUI.dialog("#appendDlg", {
		title: '附加项',
		iconCls: 'icon-w-plus',
		draggable: false,
		resizable: false,
		cache: false,
		modal: true,
		onBeforeOpen: function() {
			$("#appendDlg").form("clear");
			setValueById("chequeDate", getDefStDate(0));
			
			//银行卡类型
			$HUI.combobox("#bankCardType", {
				panelHeight: 'auto',
				url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankCardType&ResultSetType=array&JSFunName=GetBankCardTypeToHUIJson",
				method: 'GET',
				valueField: 'id',
				textField: 'text',
				blurValidValue: true,
				defaultFilter: 4,
			});
			
			//银行
			$HUI.combobox("#bank", {
				panelHeight: 150,
				url: $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson",
				method: 'GET',
				valueField: 'id',
				textField: 'text',
				blurValidValue: true,
				defaultFilter: 4
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
				}else {
					setTimeout("focusById('btn-ok')", 20);
					return;
				}
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
						refundAccDep();
						dlgObj.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						dlgObj.close();
					}
				}
			]
	});
}

function reloadRefundMenu() {
	$("#remark").val("");
	$("#refAmt").numberbox("clear");
	$("#payMode").combobox("reload");
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetClsPropValById",
		clsName: "User.DHCAccManager",
		id: getValueById("accMRowId")
	}, function(jsonObj) {
		setValueById("accMLeft", jsonObj.AccMBalance);
	});
	if (GV.ReceiptType) {
		getReceiptNo();
	}
	loadAccPreDepList();
}

function reprintClick() {
	if ($("#btn-reprint").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.AccDepList.getSelected();
	if (!row || !row.AccPreRowID) {
		$.messager.popover({msg: "请选择要补打的预交金记录", type: "info"});
		return;
	}
	if (+row.Tamt > 0) {
		$.messager.popover({msg: "预交金交款记录，请到【预交金交款】界面补打", type: "info"});
		return;
	}
	var accPDRowId = row.AccPreRowID;
	var reprtFlag = "1";
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			accPreDepPrint(accPDRowId + "#" + reprtFlag);
		}
	});
}

function clearClick() {
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	setValueById("requiredFlag", "");
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
	$("#cardType, #payMode").combobox("reload");
	loadAccPreDepList();
	if (GV.ReceiptType) {
		getReceiptNo();
	}
	if ($("#depRcptNo").length > 0) {
		getIPDepRcptNo();
	}
	if ($("#admList").length > 0) {
		$("#admList").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
	}
}

function getIPDepRcptNo() {
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetRcptNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.RcptId = myAry[0];
		GV.EndNo = myAry[1];
		GV.CurrNo = myAry[2];
		GV.Title = myAry[3];
		if (GV.RcptId) {
			setValueById("depRcptNo", (GV.Title + "[" + GV.CurrNo + "]"));
		}
	});
}

function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 490,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'RowID',
		textField: 'RowID',
		lazy: true,
		data: [],
		columns: [[{field: 'RowID', title: 'RowID', hidden: true},
				   {field: 'AdmNo', title: 'AdmNo', hidden: true},
				   {field: 'PatNo', title: 'PatNo', hidden: true},
				   {field: 'PatName', title: 'PatName', hidden: true},
		           {field: 'AdmDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.AdmTime;
							}
						}
					},
					{field: 'AdmDep', title: '科室病区', width: 180,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.AdmWard;
							}
						}
					},
					{field: 'AdmBed', title: '床号', width: 50},
					{field: 'AdmStatus', title: '就诊状态', width: 80}				
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
		}
	});
}

function trans2IPDepClick() {
	var accMRowId = getValueById("accMRowId");
	if (!accMRowId) {
		$.messager.popover({msg: "账户不存在", type: "info"});
		return;
	}
	var episodeId = getValueById("admList");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者住院就诊", type: "info"});
		return;
	}
	
	var refAmt = getValueById("refAmt");
	if (!refAmt) {
		$.messager.popover({msg: "请输入金额", type: "info"});
		focusById("refAmt");
		return;
	}
	if (!(+refAmt > 0)) {
		$.messager.popover({msg: "金额输入错误", type: "info"});
		focusById("refAmt");
		return;
	}

	if (GV.ReceiptType && !getValueById("receiptNo")) {
		$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
		return;
	}
	
	var cardNo = getValueById("cardNo");
	var cardType = getValueById("cardType");
	var cardTypeAry = cardType.split("^");
	var cardTypeDR = cardTypeAry[0]; 
	var checkRtn = DHCACC_CheckMCFPay(refAmt, cardNo, "", cardTypeDR);
	var myAry = checkRtn.split("^");
	var checkSuccess = false;
	switch(myAry[0]) {
	case "0":
		checkSuccess = true;
		break;
	case "-204":
		$.messager.popover({msg: "密码验证失败", type: "info"});
		break;
	case "-205":
		$.messager.popover({msg: "账户余额不足", type: "info"});
		break;
	case "-206":
		$.messager.popover({msg: "卡号和账户不匹配", type: "info"});
		break;
	case "-208":
		checkSuccess = true;
		break;
	default:
	}
	if (!checkSuccess) {
		return;
	}
	var depRcptNo = getValueById("depRcptNo");
	if (!depRcptNo){
		$.messager.popover({msg: "没有可用的住院押金票据，请先领取", type: "info"});
		return;
	}
	var payMode = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZPayModeID"}, false);
	if (!payMode) {
		$.messager.popover({msg: "请维护转账支付方式，系统默认取支付方式代码为:DEPZZ", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: episodeId}, false);
	var disChStatus = rtn.split("^")[3];
	if (disChStatus == "护士办理出院") {
		if (IPBILL_CONF.PARAM.DischgPayDep == "N") {
			$.messager.popover({msg: "该患者已做最终结算，不能转押金", type: "info"});
			return;
		}else {
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PAAdm", id: episodeId}, false);
			if (jsonObj.PAADMBillFlag == "Y") {
				$.messager.popover({msg: "该患者已做财务结算，不能转押金", type: "info"});
				return;
			}
		}
	}
	var rtn = $.m({ClassName: "web.DHCBillDepConversion", MethodName: "GetDEPZZDepTypeID"}, false);
	var depTypeId = rtn.split("^")[0];

	var refAmt = getValueById("refAmt");
	$.messager.confirm("确认", "转账额：<font style='color:red;'>" + refAmt + "</font> 元，确认转入住院押金?", function (r) {
		if (r) {
			var password = "";
			var accMRowId = getValueById("accMRowId");
			var refAmt = getValueById("refAmt");
			var receiptNo = "";
			var refReason = getValueById("refReason");
			var bankCardType = "";
			var checkNo = "";
			var bank = "";
			var company = "";
			var payAccNo = "";
			var chequeDate = "";
			var remark = getValueById("remark");
			var accPDType = "R";

			var accPDStr = accMRowId + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + receiptNo + "^" + refReason;
			accPDStr += "^" + password + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			accPDStr += "^" + company + "^" + payAccNo + "^" + chequeDate + "^" + remark + "^" + accPDType;
			accPDStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			var bankBranch = "";
			var transferFlag = "";
			var depStr = depTypeId + "^" + refAmt + "^" + payMode + "^" + company + "^" + bank;
			depStr += "^" + checkNo + "^" + payAccNo + "^" + episodeId + "^" + GV.CurrNo + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
			depStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + GV.EndNo + "^" + GV.Title + "^" + bankBranch + "^" + remark;
			depStr += "^" + password + "^" + GV.RcptId + "^" + transferFlag + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			$.m({
				ClassName: "web.DHCBillDepConversion",
				MethodName: "AcountTransDeposit",
				RefAcountstr: accPDStr,
				AddDepositStr: depStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var accPDRowId = myAry[1];
					var depositId = myAry[2];
					$.messager.alert("提示", "转账成功", "success");
					accPreDepPrint(accPDRowId);
					depositPrint(depositId);
					reloadRefundMenu();
					getIPDepRcptNo();
					break;
				default:
					$.messager.popover({msg: "转账失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

/**
 * 门诊预交金跳号
 */
function altVoidInvClick() {
	var receiptType = "OD";
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + receiptType;
	websys_showModal({
		width: 520,
		height: 227,
		iconCls: 'icon-skip-no',
		title: '门诊预交金跳号',
		url: url,
		onClose: function() {
			getReceiptNo();
		}
	});
}

function calcClick() {
	var iHeight = 400;
	var iWidth = 800;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum=";
	websys_createWindow(lnk, "udhcOPCashExpCal", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
}