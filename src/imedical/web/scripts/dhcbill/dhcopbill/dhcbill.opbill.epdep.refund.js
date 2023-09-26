﻿/**
 * FileName: dhcbill.opbill.epdep.refund.js
 * Anchor: ZhYW
 * Date: 2019-08-13
 * Description: 急诊留观退押金
 */

var GV = {
	RefPartFlag: "Y"    //是否允许部分退标识("Y":能部分退 "N":不能部分退)
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
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
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	getReceiptNo();
		
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
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
		valueField: "CTPMRowID",
		textField: "CTPMDesc",
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
		var securityNo = "";
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
			setValueById("patientId", myAry[4]);
			setValueById("patientNo", myAry[5]);
			getPatInfo();
			break;
		case "-200":
			$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {
				total: 0,
				rows: []
			});
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientId", myAry[4]);
			setValueById("patientNo", myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
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
				setValueById("patientId", myAry[4]);
				setValueById("patientNo", myAry[5]);
				getPatInfo();
				break;
			case "-200":
				$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {
					total: 0,
					rows: []
				});
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			case "-201":
				setValueById("cardNo", myAry[1]);
				setValueById("patientId", myAry[4]);
				setValueById("patientNo", myAry[5]);
				getPatInfo();
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
				   {title: '支票日期', field: 'Tchequedate', width: 100},
				   {title: '退款原因', field: 'Tbackreason', width: 100},
				   {title: '备注', field: 'Tremark', width: 100},
				   {title: 'AccPreRowID', field: 'AccPreRowID', hidden: true}
			]],
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
			if (data.total == 0) {
				disableById("btn-refund");
			}else {
				enableById("btn-refund");
			}
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.EPDepList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			if ((GV.RefPartFlag != "Y") && (+row.Tamt > 0)) {
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
			var episodeId = getValueById("admList");
			var papmi = getValueById("patientId");
			var patientNo = getValueById("patientNo");
			var cardNo = getValueById("cardNo");
			
			//只能全退时，取原Id
			var initPreDepID = "";
			if (GV.RefPartFlag != "Y") {
				var row = GV.EPDepList.getSelected();
				if (row && GV.AccPreRowID) {
					initPreDepID = row.AccPreRowID;
				}
			}
			
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
			var str2 = initPreDepID + "^" + refAmt + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + "";
			str2 += "^" + refReason + "^" + payMode + "^" + bankCardType + "^" + checkNo + "^" + bank;
			str2 += "^" + company + "^" + chequeDate + "^" + remark + "^" + accPDType;
			str2 += "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			
			str2 = str2.replace(/undefined/g, "");   //替换所有的undefined
			
			$.m({
				ClassName: "web.DHCOPBillEPAddDeposit",
				MethodName: "NewDeposit",
				str1: str1,
				str2: str2,
				grp: PUBLIC_CONSTANT.SESSION.GROUPID,
				refPartFlag: GV.RefPartFlag
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var accPDRowId = myAry[6];
					emPreDepPrint(accPDRowId);
					if (!getValueById("accMRowId")) {
						setValueById("accMRowId", accPDRowId.split("||")[0]);
					}
					reloadRefundMenu();
					$.messager.alert("提示", "退款成功", "success");
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

function checkData() {
	var episodeId = getValueById("admList");
	if (!episodeId) {
		$.messager.popover({msg: "请选择就诊", type: "info"});
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
	var accMLeft = getValueById("accMLeft");
	if (+refAmt > +accMLeft) {
		$.messager.popover({msg: "账户余额不足", type: "info"});
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
	
	//急诊留观标志
	var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmStayStat", Adm: episodeId}, false);
	var stayFlag = rtn.split("^")[0];
	if (stayFlag != "Y") {
		$.messager.popover({msg: "不是急诊留观患者，不能交留观押金", type: "info"});
		return false;
	}
	
	if (!getValueById("refReason")) {
		$.messager.popover({msg: "请选择<font color=red>退款原因</font>", type: "info"});
		focusById("refReason");
		return false;
	}

	$("#appendDlg").form("clear");   //需要先清除对话框中表单值
	if (getValueById("requiredFlag") == "Y") {
		openAppendDlg();             //弹出其他必填项对话框
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
	$("#payMode, #refReason").combobox("reload");
	$.m({
		ClassName: "web.DHCOPBillEPManageCLS",
		MethodName: "getAccBalance",
		Accid: getValueById("accMRowId")
	}, function(accMLeft) {
		setValueById("accMLeft", accMLeft);
	});
	
	if (GV.ReceiptType) {
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
	if (+row.Tamt > 0) {
		$.messager.popover({msg: "交款记录，请到【急诊留观交押金】界面补打", type: "info"});
		return;
	}
	var accPDRowId = row.AccPreRowID;
	var reprtFlag = "1";
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			emPreDepPrint(accPDRowId + "#" + reprtFlag);
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
	$("#admList").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadEPDepList();
	if (GV.ReceiptType) {
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