/**
 * FileName: dhcbill.opbill.accpinv.js
 * Author: ZhYW
 * Date: 2019-08-29
 * Description: 门诊集中打印发票
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	showBannerTip();
	initQueryMenu();
	initPayList();
	initCateList();
	initInvList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//读医保卡
	$HUI.linkbutton("#btn-readInsuCard", {
		onClick: function () {
			readInsuCardClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		disabled: true,
		onClick: function () {
			printClick();
		}
	});
	
	//跳号
	$HUI.linkbutton("#btn-skipNo", {
		onClick: function () {
			skipNoClick();
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
	
	$("#stDate, #endDate").datebox({
		onChange: function() {
			loadPayList();
		}
	});
	
	$(".spacing-ck>.checkbox-f[id]").checkbox({
		onCheckChange: function(e, value) {
			loadPayList();
		}
	});
	
	//患者类型
	$HUI.combobox("#patType", {
		panelHeight: 180,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryPatTypeForAccPINV&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID
		}
	});
	
	getReceiptNo();
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
		printClick();
		break;
	default:
	}
}

function initPayList() {
	GV.PayList = $HUI.datagrid("#payList", {
		fit: true,
		title: '支付列表',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: [],
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: [[{title: '结算ID', field: 'prtRowId', width: 80,
				    formatter: function (value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick=\"openDtlView(\'" + value + "\')\">" + value + "</a>";
						}
				   	}
				   },
				   {title: '费用总额', field: 'acount', align: 'right', width: 100},
				   {title: '支付日期', field: 'date', width: 100},
				   {title: '支付时间', field: 'time', width: 100},
				   {title: '操作员', field: 'usrName', width: 100},
				   {title: 'accPLRowId', field: 'accPLRowId', hidden: true},
				   {title: '支付方式', field: 'paymStr', width: 150},
				   {title: '支付号码', field: 'accPayNo', width: 130},
				   {title: '支付额', field: 'accPayAmt', hidden: true},
				   {title: '余额', field: 'accPayLeft', align: 'right', width: 100},
				   {title: '自付金额', field: 'patAmt', align: 'right', width: 100},
				   {title: '折扣金额', field: 'discAmt', align: 'right', width: 100},
				   {title: '记账金额', field: 'payorAmt', align: 'right', width: 100}
			]],
		onLoadSuccess: function (data) {
			if (data.total == 0) {
				$(this).datagrid("clearChecked");
			}else {
				$(this).datagrid("checkAll");
			}
		},
		onCheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onUncheck: function (rowIndex, rowData) {
			checkPayListHandler();
		},
		onCheckAll: function (rows) {
			checkPayListHandler();
		},
		onUncheckAll: function (rows) {
			checkPayListHandler();
		}
	});
}

function openDtlView(prtRowId) {
	var argObj = {
		invRowId: prtRowId,
		invType: "PRT"
	};
	BILL_INF.showOPChgOrdItm(argObj);
}

function initCateList() {
	GV.CateList = $HUI.datagrid("#cateList", {
		fit: true,
		title: '分类信息',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		singleSelect: true,
		rownumbers: true,
		remoteSort: false,
		showFooter: true,
		toolbar: [],
		pageSize: 99999999,
		columns: [[{title: '分类', field: 'cateDesc', width: 70},
				   {title: '金额',field: 'cateAmt', align: 'right', width: 70, sortable: true,
					   	sorter: function (a, b) {
						   	return ((a - b) > 0) ? 1 : -1;
						}
				   }
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCACPayList",
			QueryName: "FindCateList",
			prtRowIdStr: "",
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			totalFields: "cateAmt",
			totalFooter: "\"cateDesc\":" + "\"" + $g("合计") + "\"",
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			if (data.footer && (data.footer.length > 0)) {
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").css("visibility","visible");
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").text(data.total + 1);
			}
		}
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		width: 400,
		height: 180,
		fitColumns: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		rownumbers: true,
		pageSize: 999999999,
		columns: [[{title: 'errCode', field: 'errCode', hidden: true},
				   {title: 'insTypeDR', field: 'insTypeDR', hidden: true},
				   {title: '费别', field: 'insTypeDesc', width: 100},
				   {title: '金额', field: 'invAmt', width: 110, align: 'right'},
				   {title: 'invPrtValue', field: 'invPrtValue', hidden: true}
			]],
		onLoadSuccess: function(data) {
			$("#btn-print").linkbutton({disabled: (!(data.total > 0))});
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
		return;
	}
	$("#btn-readCard").linkbutton("toggleAble");
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

/**
 * 读医保卡
 */
function readInsuCardClick() {
	if ($("#btn-readInsuCard").linkbutton("options").disabled) {
		return;
	}
	$("#btn-readInsuCard").linkbutton("toggleAble");
	var rtn = InsuReadCard(0, PUBLIC_CONSTANT.SESSION.USERID, "", "", "00A^^^");
	var myAry = rtn.split("|");
	if (myAry[0] == 0) {
		var insuReadInfo = myAry[1];
		var insuReadAry = insuReadInfo.split("^");
		var insuCardNo = insuReadAry[1];	//医保卡号
		var credNo = insuReadAry[7];	    //身份证号
		$("#CardNo").val(credNo);
		if (credNo != "") {
			DHCACC_GetAccInfo("", credNo, "", "", magCardCallback);
		}
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
		setValueById("accMRowId", myAry[7]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
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
		setPatDetail(patientId);
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (!patientNo) {
		return;
	}
	var expStr = "";
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPAPMIByNo",
		PAPMINo: patientNo,
		ExpStr: expStr
	}, function(patientId) {
		if (!patientId) {
			setValueById("patientId", "");
			$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
			focusById("patientNo");
			return;
		}
		setPatDetail(patientId);
	});
}

function setPatDetail(patientId) {
	setValueById("patientId", patientId);
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: patientId,
		ExpStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		var patientNo = myAry[1];
		var patTypeId = myAry[7];   //患者类型Id
		var accMRowId = myAry[19];
		setValueById("patientNo", patientNo);
		setValueById("accMRowId", accMRowId);
		
		//设置患者类型选中
		var data = $("#patType").combobox("getData");
		var selItem = data.filter(function(item) {
			return patTypeId == item.value.split("^")[0];
		}).map(function(item) {
			return item.value;
		});
		setValueById("patType", (selItem[0] || data[0].value));
	});
	refreshBar(patientId, "");
	loadPayList();
}

function loadPayList() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		return;
	}
	var queryParams = {
		ClassName: "web.DHCACPayList",
		QueryName: "FindPatPayList",
		patientId: patientId,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		isRegInv: getValueById("regInvCK") ? "Y" : "N",
		isInsuDiv: getValueById("insuDivCK") ? "Y" : "N",
		isStayInv: getValueById("stayInvCK") ? "Y" : "N",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore("payList", queryParams);
}

function getReceiptNo() {
	$.m({
		ClassName: "web.udhcOPBillIF",
		MethodName: "ReadReceiptNO",
		UserDR: PUBLIC_CONSTANT.SESSION.USERID,
		GroupDR: "",      //这里不考虑安全组
		ExpStr: "F^^" + PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			var currNo = myAry[1];
			var rowId = myAry[2];
			var endNo = myAry[3];
			var title = myAry[4];
			var leftNum = myAry[5];
			var tipFlag = myAry[6];
			var receiptNo = title + "[" + currNo + "]";
			setValueById("receiptNo", receiptNo);
			var color = "green";
			if ($("#receiptNo").hasClass("newClsInvalid")) {
				$("#receiptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == 1) {
				color = "red";
				$("#receiptNo").addClass("newClsInvalid");
			}
			var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
			$("#btn-tip").popover({cache: false, trigger: 'hover', content: content});
			return;
		}
		disableById("btn-print");
		$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
	});
}

function getPrtRowIdStr() {
	return GV.PayList.getChecked().map(function (row) {
		return row.prtRowId;
	}).join("^");
}

function checkPayListHandler() {
	var prtRowIdStr = getPrtRowIdStr();
	loadCateList(prtRowIdStr);
	parseINVInfo(prtRowIdStr);
	$(".layout-panel-south .layout-panel-east").find(".numberbox-f[id]").numberbox("clear");   //清空打印面板numberbox的值
}

function loadCateList(prtRowIdStr) {
	var queryParams = {
		ClassName: "web.DHCACPayList",
		QueryName: "FindCateList",
		prtRowIdStr: prtRowIdStr,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		totalFields: "cateAmt",
		totalFooter: "\"cateDesc\":" + "\"" + $g("合计") + "\"",
		rows: 99999999
	}
	loadDataGridStore("cateList", queryParams);
}

function parseINVInfo(prtRowIdStr) {
	if (!prtRowIdStr) {
		GV.InvList.loadData({total: 0, rows: []});
		return;
	}
	delServerTMP();
	var isInsuDiv = getValueById("insuDivCK") ? 1: 0;      //医保已结算标识
	var isStayInv = getValueById("stayInvCK") ? "Y" : "N";
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
	expStr += "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + isStayInv + "^" + isInsuDiv + "^" + PUBLIC_CONSTANT.SESSION.LANGID;
	
	GV.InvList.loading();    //显示载入状态
	$.cm({
		ClassName: "web.UDHCAccPrtPayFoot",
		QueryName: "ParPrtToINVList",
		type: "GET",
		INVPrtStr: prtRowIdStr,
		ExpStr: expStr,
		rows: 99999999
	}, function(data) {
		GV.InvList.loaded();   //隐藏载入状态
		if (data.rows[0].errCode != 0) {
			$.messager.alert("提示", "分解发票错误：" + data.rows[0].errCode, "error");
			return;
		}
		GV.InvList.loadData(data);
		var invPrtValue = data.rows[0].invPrtValue;
		var myCID = invPrtValue.split("|")[5];   //进程号
		setValueById("CID", myCID);
	});
}

/**
* 清除临时global
* 2023-03-03 ZhYW 改为同步清除
*/
function delServerTMP() {
	var pid = getValueById("CID");
	if (pid > 0) {
		$.m({ClassName: "web.UDHCACINVColPrt", MethodName: "KillINVTMP", wantreturnval: 0, ID: pid}, false);
	}
	$.m({ClassName: "web.UDHCACINVColPrt", MethodName: "KTMP", wantreturnval: 0}, false);
}

/**
* 打印发票
*/
function printClick() {
	/*
	* 校验能否结算
	*/
	var _checkData = function() {
		return new Promise(function (resolve, reject) {
			if (GV.InvList.getRows().length == 0) {
				$.messager.popover({msg: "没有需要打印的发票", type: "info"});
				return reject();
			}
			if (!getValueById("CID")) {
				$.messager.popover({msg: "没有可打印数据", type: "info"});
				return reject();
			}
			if (!getValueById("receiptNo")) {
				$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfmPrint = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认打印发票？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	if ($("#btn-print").linkbutton("options").disabled) {
		return;
	}
	$("#btn-print").linkbutton("disable");
	
	var promise = Promise.resolve();
	promise
		.then(_checkData)
		.then(_cfmPrint)
		.then(accPayColPrt, function () {
			$("#btn-print").linkbutton("enable");
		});
}

function accPayColPrt() {
	/**
	* 医保结算
	*/
	var _insuDiv = function() {
		return new Promise(function (resolve, reject) {
			if (!isCallInsu) {
				return resolve();
			}
			var myYBHand = 0;
			var myStrikeFlag = "";
			var myInsuNo = "";
			var myCardType = "";
			var myYLLB = "";
			var myDicCode = "";
			var myDicDesc = "";//数据库连接串
			var myDYLB = "";
			var myChargeSource = "01";
			var myDBConStr = "";
			var myLeftAmt = "";
			var myMoneyType = "";
			var mySelPayMDR = "";
			var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
			myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + mySelPayMDR + "!" + myLeftAmt + "^" + myMoneyType;
			var CPPFlag = "Y";
			var myYBRtn = InsuOPDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myCID, GV.AdmSource, insTypeId, myYBExpStr, CPPFlag);
			if (myYBRtn != 0) {
				$.messager.alert("提示", "医保分解错误：" + myYBRtn, "error");
				return reject();
			}
			resolve();
		});
	};
	
	var _readInvListForYB = function() {
		return new Promise(function (resolve, reject) {
			var expStr = "^^^^^" + isInsuDiv;
			$.cm({
				ClassName: "web.UDHCAccPrtPayFoot",
				QueryName: "ReadInvListForYB",
				type: "GET",
				TMPGID: myCID,
				ExpStr: expStr,
				rows: 99999999
			}, function(data) {
				if (data.rows[0].errCode != 0) {
					$.messager.alert("提示", "打印时分解发票错误：" + data.rows[0].errCode, "error");
					return reject();
				}
				
				GV.InvList.loadData(data);    //重新载入发票信息
				var myYBSum = 0;
				var mySelfPaySum = 0;
				var myRefSum = 0;
				var myYBAccPaySum = 0;
				var myYBTCPaySum = 0;
				var myYBDBPaySum = 0;
				var prtColAry = [];
				$.each(data.rows, function(index, row) {
					var myVal = row.invPrtValue.replace(/\|/g, PUBLIC_CONSTANT.SEPARATOR.CH3).replace(/\#/g, PUBLIC_CONSTANT.SEPARATOR.CH4);
					prtColAry.push(myVal);
					var myListAry = myVal.split(PUBLIC_CONSTANT.SEPARATOR.CH3);
					var myAry3 = myListAry[3];
					var myAry33 = myAry3.split("^");
					myYBSum = Number(myYBSum).add(myAry33[0]).toFixed(2);
					mySelfPaySum = Number(mySelfPaySum).add(myAry33[1]).toFixed(2);
					myRefSum = Number(myRefSum).add(myAry33[2]).toFixed(2);
					var myAry4 = myListAry[4];
					var myAry44 = myAry4.split("^");
					myYBAccPaySum = Number(myYBAccPaySum).add(myAry44[1]).toFixed(2);
					myYBTCPaySum = Number(myYBTCPaySum).add(myAry44[2]).toFixed(2);
					myYBDBPaySum = Number(myYBDBPaySum).add(myAry44[3]).toFixed(2);
			    });
				var myINVSum = Number(myYBSum).add(mySelfPaySum).toFixed(2);
				setValueById("insuTotalSum", myYBSum);
				setValueById("selfPaySum", mySelfPaySum);
				setValueById("refundSum", myRefSum);
				setValueById("insuAccPaySum", myYBAccPaySum);
				setValueById("insuPaySum", myYBTCPaySum);
				setValueById("insuDBSum", myYBDBPaySum);
				setValueById("totalSum", myINVSum);
				
			  	prtColStr = prtColAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			  	
			    resolve();
			});
		});
	};
	
	/**
	* 失败时医保冲销
	*/
	var _insuDivStrike = function() {
		return new Promise(function (resolve, reject) {
			var insuRtn = "Y!";
			if (isCallInsu) {
				insuRtn = $.m({ClassName: "web.DHCOPINVCons", MethodName: "CheckAPIInsuData", TMPGID: myCID, ExpStr: ""}, false);
			}
			var insuAry = insuRtn.split("!");
			if (!prtColStr || (insuAry[0] != "Y")) {
				if (insuAry[1] != "") {
					$.each(insuAry[1].split("@"), function (index, val) {
						var myAry = val.split("^");
						var myYBHand = 0;
						var myInsuDivDR = myAry[0];
						var myInsuType = myAry[1];
						var myAdmSource = myAry[2];
						if (!myInsuDivDR) {
							return true;
						}
						var myYBExpStr = "^^^";
						var myCPPFlag = "Y";
						var outString = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myInsuDivDR, myAdmSource, myInsuType, myYBExpStr, myCPPFlag);
					});
				}
				$.messager.popover({msg: "请清屏后，重新读卡", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _saveInv = function() {
		return new Promise(function (resolve, reject) {
			var oldAPIRowID = "";
			var newInsType = "";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
			expStr += "^" + oldAPIRowID + "^" + isStayInv + "^" + isInsuDiv + "^" + newInsType;
			$.m({
				ClassName: "web.UDHCAccPrtPayFoot",
				MethodName: "APayColPrtUpdate",
				APINVInfo: prtColStr,
				UserDR: PUBLIC_CONSTANT.SESSION.USERID,
				AccMDR: accMRowId,
				PAPMIDR: patientId,
				ExpStr: expStr
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					delServerTMP();
					accPInvIdStr = myAry.slice(1).join("^");
					$.messager.alert("提示", "打印成功", "success", function() {
						clearDocWin(patientId);
						return resolve();
					});
					return;
				}
				$.messager.alert("提示", "打印失败：" + (myAry[1] || myAry[0]), "error");
				reject();
			});
		});
	};
	
	/**
	* 打印发票
	*/
	var _printInv = function() {
		accPInvPrint(accPInvIdStr);
	};
	
	var patType = getValueById("patType");
	var myAry = patType.split("^");
	GV.AdmSource = myAry[2];
	var insTypeId = myAry[3];    //取患者类型对照的默认费别
	
	var myCID = getValueById("CID");
	var accMRowId = getValueById("accMRowId");
	var patientId = getValueById("patientId");
	var isStayInv = getValueById("stayInvCK") ? "Y" : "N";
	var isInsuDiv = getValueById("insuDivCK") ? 1 : 0;
	
	var isCallInsu = isCallInsuDiv();
	
	var prtColStr = "";
	var accPInvIdStr = "";
	
	var promise = Promise.resolve();
	promise
		.then(_insuDiv)
		.then(_readInvListForYB)
		.then(_insuDivStrike)
		.then(_saveInv)
		.then(function() {
			_printInv();
			$("#btn-print").linkbutton("enable");
		}, function () {
			$("#btn-print").linkbutton("enable");
		});
}

/**
* 是否调用医保分解
*/
function isCallInsuDiv() {
	var bool = true;
	if ((CV.AccPINVYBConFlag == 0) || getValueById("selfPayCK")) {
		return false;
	}
	if (!(GV.AdmSource > 0)) {
		return false;
	}
	
	$(".spacing-ck>.checkbox-f[id]").each(function(index) {
		if ($(this).checkbox("getValue")) {
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return bool;
	}
	
	//ShangXuehao 2020-11-25  判断自付费用为0并且零费用调医保接口配置为0
	bool = GV.PayList.getChecked().some(function(item) {
		return (item.patAmt > 0) || (CV.ZeroAmtUseYBFlag == 1);
	});

	return bool;
}

function accPInvPrint(accPInvIdStr) {
	GV.AccPINVXMLName = CV.AccPINVXMLName;
	if (!GV.AccPINVXMLName) {
		return;
	}
	var myAry = accPInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			getXMLConfig(GV.AccPINVXMLName);
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.AccPINVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}

function clearDocWin(patientId) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCACPayList",
		MethodName: "GetNoPrintNum",
		patientId: patientId,
		expStr: expStr
	}, function(rtn) {
		if (rtn == 0) {
			initAllDoc();
			return;
		}
		initPartDoc();
	});
}

function initAllDoc() {
	focusById("CardNo");
	setValueById("patientId", "");
	setValueById("accMRowId", "");
	setValueById("CID", "");
	clearBanner();
	$(":text:not(.pagination-num,#receiptNo)").val("");
	$(".combobox-f").combobox("reload");
	$(".numberbox-f").numberbox("clear");
	$(".datebox-f").datebox("clear");
	$(".checkbox-f").checkbox("uncheck");
	showBannerTip();
	GV.PayList.loadData({total: 0, rows: []});
	getReceiptNo();
}

function initPartDoc() {
	GV.PayList.reload();
	getReceiptNo();
}

/**
* 清屏
*/
function clearClick() {
	initAllDoc();
}

/**
* 跳号
*/
function skipNoClick() {
	var argumentObj = {
		receiptType: "OP"
	};
	BILL_INF.showSkipInv(argumentObj).then(getReceiptNo);
}

/**
* 离开页面时清除临时global
*/
$(window).unload(function() {
	delSvrTMP4Beacon();
});

/**
* 离开页面时清除临时global
* 2023-03-03
* 新的chrome下，用visibilitychange事件替换unload事件
*/
document.addEventListener("visibilitychange", function() {
	if (document.hidden) {
		delSvrTMP4Beacon();
	}
});

/**
* 清除临时global(navigator.sendBeacon()发送ajax请求)
*/
function delSvrTMP4Beacon() {
	var pid = getValueById("CID");
	if (pid > 0) {
		$.cm({ClassName: "web.UDHCACINVColPrt", MethodName: "KillINVTMP", type: "BEACON", ID: pid, wantreturnval: 0});
	}
	$.cm({ClassName: "web.UDHCACINVColPrt", MethodName: "KTMP", type: "BEACON", wantreturnval: 0});
}