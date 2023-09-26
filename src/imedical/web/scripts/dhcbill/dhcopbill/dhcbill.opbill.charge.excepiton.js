/**
 * FileName: dhcbill.opbill.charge.excepiton.js
 * Anchor: ZhYW
 * Date: 2019-08-28
 * Description: 门诊收费异常处理
 */
 
var GV = {
	DefStDate: ""
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initTPInvList();
});

function initQueryMenu() {
	$.m({
		ClassName: "web.DHCOPBillChargExcepiton",
		MethodName: "GetStartDate",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(stDate) {
		GV.DefStDate = stDate;
		setValueById("stDate", GV.DefStDate);
	});
	setValueById("endDate", getDefStDate(0));
	
	setValueById("userName", PUBLIC_CONSTANT.SESSION.USERNAME);
	
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadTPInvList();
		}
	});
	
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
	
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
	
	getCFByGRowID();
}

function getCFByGRowID() {
	$.m({
		ClassName: "web.UDHCOPGSConfig",
		MethodName: "ReadCFByGRowID",
		type: "GET",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.RequiredInvFlag = (myAry[4] == "1") ? "Y" : "N";
		GV.INVXMLName = myAry[10];
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById('cardType');
		var cardTypeDR = cardType.split('^')[0];
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
			setValueById("patientNo", myAry[5]);
			setPatInfo(myAry[4]);
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			setPatInfo(myAry[4]);
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
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split('^');
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				setPatInfo(myAry[4]);
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById('cardNo');
					});
				}, 300);
				break;
			case "-201":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				setPatInfo(myAry[4]);
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
			$("#cardNo").attr('readOnly', false);
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

function initTPInvList() {
	GV.TPInvList = $HUI.datagrid("#TPInvList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '登记号', field: 'TPatientNO', width: 100},
				   {title: '患者姓名', field: 'TPapmiName', width: 80},
				   {title: '费别', field: 'TInsTypeDesc', width: 80},
				   {title: '预结时间', field: 'TDisplayPrtDate', width: 150,
				   	formatter: function (value, row, index) {
						return value + " " + row.TDisplayPrtTime;
					}
				   },
				   {title: '收费员', field: 'TPrtUserName', width: 70},
				   {title: '总金额', field: 'TTotalAmt', align: 'right', width: 80},
				   {title: '自付金额', field: 'TPatientShare', align: 'right', width: 80},
				   {title: '支付方式', field: 'TPayMStr', width: 130},
				   {title: '异常描述', field: 'TExceptionDesc', width: 160},
				   {title: '操作', field: 'TOperation', align: 'center', width: 90,
				   	formatter: function (value, row, index) {
					   	var btnHtml = "";
					   	if (+value == 1) {
						   	btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='撤销' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
						}else if (+value == 2) {
							btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='完成' onclick='completeClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
						}else {
							btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='撤销' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
							btnHtml += "<a href='javascript:;' class='datagrid-cell-img' title='完成' onclick='completeClick(" + JSON.stringify(row) + ")' style='margin-left: 10px;'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
						}
					   	return btnHtml;
					}
				   },
				   {title: '发票ID', field: 'TPrtRowId', width: 80,
				   	formatter: function (value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "', '" + row.TabFlag + "\')\">" + value + "</a>";
						}
				   	}
				   },
				   {title: 'TabFlag', field: 'TabFlag', hidden: true},
				   {title: '折扣金额', field: 'TDiscAmount', align: 'right', width: 80},
				   {title: '记账金额', field: 'TPayorShare', align: 'right', width: 80},
				   {title: '医保结算ID', field: 'TPRTInsDivDR', width: 80},
				   {title: 'TPAPMIDR', field: 'TPAPMIDR', hidden: true},
				   {title: 'TAccMDR', field: 'TAccMDR', hidden: true},
				   {title: '级别', field: 'TPatLevel', hidden: true},
				   {title: '密级', field: 'TEncryptLevel', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function orderDetail(prtRowId, invType) {
	var url = "dhcbill.opbill.invoeitm.csp?&invRowId=" + prtRowId + "&invType=" + invType;
	websys_showModal({
		url: url,
		title: '医嘱明细',
		iconCls: 'icon-w-list'
	});
}

function loadTPInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillChargExcepiton",
		QueryName: "QueryTPInv",
		StartDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		ChargeUser: getValueById("userName"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		CardNo: getValueById("cardNo"),
		SessionStr: getSessionStr()
	};
	loadDataGridStore("TPInvList", queryParams);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: $(e.target).val()
		}, function (papmi) {
			if (papmi) {
				setPatInfo(papmi);
			}else {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				focusById($(e.target));
			}
		});
	}
}

function setPatInfo(papmi) {
	if (!papmi) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
		setValueById("patName", myAry[2]);
		
		loadTPInvList();
	});
}

/**
* 撤销
*/
function cancelClick(row) {
	var prtRowId = row.TPrtRowId;
	var jsonObj = getINVPRTJsonObj(prtRowId);
	if (jsonObj.PRTFlag != "TP") {
		$.messager.popover({msg: "非预结算状态，不能撤销", type: "info"});
		return;
	}
	if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
		var isTimeOut = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "CheckIsTimeOut", prtRowId: prtRowId}, false);
		if (isTimeOut == "N") {
			$.messager.popover({msg: "非原发票收费员，不能撤销", type: "info"});
			return;
		}
	}

	var accMRowId = row.TAccMDR;
	$.messager.confirm("确认", row.TExceptionDesc + "，是否确认撤销？", function(r) {
		if(r) {
			rollbackData(prtRowId, accMRowId);
		}
	});
}

function rollbackData(prtRowId, accMRowId) {
	var jsonObj = getINVPRTJsonObj(prtRowId);
	var insuDivId = jsonObj.PRTInsDivDR;
	var insType = jsonObj.PRTInsTypeDR;
	if (insuDivId) {
		//撤销医保结算
		var admSource = getAdmReasonJsonObj(insType).REAAdmSource;
		var myYBHand = "";
		var myCPPFlag = "";
		var strikeFlag = "S";
		var insuNo = "";
		var cardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var chargeSource = "01";
		var leftAmt = getAccMBalance(accMRowId);
		var moneyType = "";
		var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
		myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
		myExpStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
		var myYBRtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insType, myExpStr, myCPPFlag);
		if (myYBRtn != "0") {
			$.messager.popover({msg: "医保发票冲票错误，不能退费，请联系管理员", type: "info"});
			return;
		}
	}
	
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	if (rtn == "0") {
		$.messager.alert("提示", "撤销成功", "success", function() {
			$("#TPInvList").datagrid("reload");
		});
	} else {
		$.messager.alert("提示", "撤销失败：" + rtn, "error");
	}
}

/**
* 确认完成
*/
function completeClick(row) {
	var prtRowId = row.TPrtRowId;
	var jsonObj = getINVPRTJsonObj(prtRowId);
	if (jsonObj.PRTFlag != "TP") {
		$.messager.popover({msg: "非预结算状态，不能完成结算", type: "info"});
		return;
	}
	if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
		$.messager.popover({msg: "非原发票收费员，不能完成结算", type: "info"});
		return;
	}
	
	var accMRowId = row.TAccMDR;
	$.messager.confirm("确认", row.TExceptionDesc + "，是否完成结算？", function(r) {
		if(r){
			completeCharge(prtRowId, accMRowId);
		}
	});
}

function completeCharge(prtRowId, accMRowId) {
	var jsonObj = getINVPRTJsonObj(prtRowId);
	var fairType = jsonObj.PRTFairType;
	var insType = jsonObj.PRTInsTypeDR;
	var oldPrtRowId = jsonObj.PRTOldINVDR;
	var insuDivId = jsonObj.PRTInsDivDR;
	var patientId = jsonObj.PRTPAPMIDR;
	var admSource = getAdmReasonJsonObj(insType).REAAdmSource;
	
	//var paymAry = getPaymAry(prtRowId);   //获取发票支付方式信息
	//var isPayment = paymAry[0];   //是否多种支付
	//var paymDR = paymAry[1];      //支付方式RowId
	//var paymCode = paymAry[2];    //支付方式Code
	
	if (!insuDivId && (+admSource > 0)) {
		var isYBCharge = $.m({ClassName: "web.DHCBillCons11", MethodName: "CheckYBCharge", prtRowID: prtRowId}, false);
		if (+isYBCharge != 0) {
			$.messager.alert("提示", "医保结算成功，但更新发票表失败，请更正后再确认完成", "info");
			return;
		}
		var myYBHand = "";
		var myCPPFlag = "";
		var strikeFlag = "S";    //这里传入"S"，让医保结算失败时不删除发票记录
		var insuNo = "";
		var cardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var chargeSource = "01";
		var DBConStr = "";       //数据库连接串
		var moneyType = "";
		var selPaymId = (isPayment == "N") ? paymDR : "";
		var leftAmt = getAccMBalance(accMRowId);
		if (paymCode != "CPP") {
			leftAmt = "";
			myCPPFlag = "NotCPPFlag";
		}
		var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
		myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
		myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
		var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, prtRowId, admSource, insType, myExpStr, myCPPFlag);
		var myYBAry = myYBRtn.split("^");
		if (myYBAry[0] == "YBCancle") {
			return;
		}
		if (myYBAry[0] == "HisCancleFailed") {
			$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
			return;
		}
	}
	
	//弹出收银台界面
	//	注：对于退费再收的新发票是否弹出出收银台界面，需要再考虑？默认先都弹出。
	var cardNo = getValueById();
	var cardTypeId = getValueById("cardType").split("^")[0];
	var episodeIdStr = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowId}, false);
	var url = "dhcbill.opbill.checkout.csp?insTypeId=" + insType + "&typeFlag=FEE" + "&prtRowIdStr=" + prtRowId;
	url += "&accMRowId=" +accMRowId +  + "&episodeIdStr=" + episodeIdStr;
	url += "&patientId=" + patientId + "&cardNo=" + cardNo + "&cardTypeId=" + cardTypeId;
	websys_showModal({
		url: url,
		title: '收银台-门诊收费异常处理',
		iconCls: 'icon-w-card',
		height: 650,
		width: 1000,
		closable: false,
		callbackFunc: function(returnVal) {
			var code = returnVal.code;
			var message = returnVal.message;
			var accMRowId = returnVal.accMRowId;
			setValueById("accMRowId", accMRowId);  //解决主界面未读卡，但在收银台用了卡支付
			if (code){
				var payMList = message;
				completeCharge2(prtRowId, payMList, accMRowId);	
			}else {
				
			}
		}
	});
}

function completeCharge2(prtRowId, payMList, accMRowId){
	var jsonObj = getINVPRTJsonObj(prtRowId);
	var fairType = jsonObj.PRTFairType;
	var insType = jsonObj.PRTInsTypeDR;
	var oldPrtRowId = jsonObj.PRTOldINVDR;
	
	var paymAry = getPaymAry(prtRowId);   //获取发票支付方式信息
	var isPayment = paymAry[0];   //是否多种支付
	var paymDR = paymAry[1];      //支付方式RowId
	var paymCode = paymAry[2];    //支付方式Code
	
	var sFlag = (!oldPrtRowId) ? "0" : "1";
	var actualMoney = "";
	var change = "";
	var roundErr = "";
	var newInsType = "";
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID;
	expStr += "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	expStr += "^" + accMRowId;
	expStr += "^" + GV.RequiredInvFlag;
	expStr += "^" + fairType;
	expStr += "^" + actualMoney;
	expStr += "^" + change;
	expStr += "^" + roundErr;
	expStr += "^" + newInsType;

	$.m({
		ClassName: "web.DHCOPBillChargExcepiton",
		MethodName: "CompleteCharge",
		CallFlag: 4,
		Guser: PUBLIC_CONSTANT.SESSION.USERID,
		InsTypeDR: insType,
		PrtRowIDStr: prtRowId,
		SFlag: sFlag,
		OldPrtInvDR: oldPrtRowId,
		ExpStr: expStr,
		PayInfo: payMList
	}, function(rtn) {
		if (rtn == "0") {
			var msg = "确认完成成功";
			var iconCls = "success";
			if (oldPrtRowId) {
				//调用第三方退费接口  DHCBillPayService.js
				var tradeType = "OP";
				var refundAmt = "";
				var strikeRowId= $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "GetStrikInvRowId", prtRowId: oldPrtRowId}, false);
				var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^";
				var rtnValue = RefundPayService(tradeType, oldPrtRowId, strikeRowId, prtRowId, refundAmt, "OP", expStr);
				var msg = "退费成功";
				if (rtnValue.rtnCode != "0") {
					msg = "HIS确认完成成功，第三方退费失败：" + rtnValue.rtnMsg + "，错误代码：" + rtnValue.rtnCode + "，请补交易";
					iconCls = "error";
				}
			}
			$.messager.alert("提示", msg, iconCls);
			$("#TPInvList").datagrid("reload");
			//打印
			if (getINVPRTJsonObj(prtRowId).PRTINVPrintFlag == "P") {
				billPrintTask(prtRowId);
			}
		}else {
			chargeErrorTip("completeError", rtn);
			return;
		}
	});	
}

function getINVPRTJsonObj(prtRowId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: prtRowId}, false);
}

function getAdmReasonJsonObj(insTypeId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: insTypeId}, false);
}

function billPrintTask(prtInvIdStr) {
	var myOldXmlName = GV.INVXMLName;
	$.m({
		ClassName: "web.UDHCOPGSPTEdit",
		MethodName: "GetPrtListByGRowID",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		PrtType: "CP"
	}, function(rtn) {
		var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
		if (myAry[0] == "Y") {
			billPrintList(myAry[1], prtInvIdStr);
			GV.INVXMLName = myOldXmlName;
			getXMLConfig(GV.INVXMLName);
		} else {
			invPrint(prtInvIdStr);
			//收费处打印导诊单
			$.m({
				ClassName: "web.DHCBillInterface", 
				MethodName: "GetPrtGuideFlag",
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function(rtn) {
				if (rtn == "F") {
					directPrint(prtInvIdStr);
				}
			});
		}
		GV.INVXMLName = myOldXmlName;
	});
}

function billPrintList(prtTaskStr, prtInvIdStr) {
	var myTListAry = prtTaskStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.each(myTListAry, function(index, myTStr) {
		if (myTStr) {
			var myAry = myTStr.split("^");
			var myPrtXMLName = myAry[0];
			GV.INVXMLName = myPrtXMLName;
			var myClassName = myAry[1];
			var myMethodName = myAry[2];
			if ((myAry[3] == "") || (myAry[3] == "XML")) {
				if (myPrtXMLName != "") {
					getXMLConfig(myPrtXMLName);
					commBillPrint(prtInvIdStr, myClassName, myMethodName);
				}
			}
		}
	});
}

function commBillPrint(prtInvIdStr, className, methodName) {
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, myExpStr);
		}
	});
}

function invPrint(prtInvIdStr) {
	if (!GV.INVXMLName) {
		return;
	}
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			//根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$("#cardType").combobox("reload");
	$(".datebox-f").datebox("setValue", "");   //先清空日期，防止后台加载数据
	loadTPInvList();
	
	setValueById("stDate", GV.DefStDate);
	setValueById("endDate", getDefStDate(0));
	
	setValueById("userName", PUBLIC_CONSTANT.SESSION.USERNAME);
}

/**
* 获取账户余额
*/
function getAccMBalance(accMRowId) {
	var accMLeft = "";
	if (accMRowId) {
		accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
	}
	return accMLeft;
}

/**
* 获取支付方式信息
*/
function getPaymAry(prtRowId) {
	var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "GetPrtPayMInfo", prtRowId: prtRowId}, false);
	var myAry = rtn.split("#");
	var isPayment = "N";
	var paymDR = "";
	var paymCode = "";
	if (+myAry[0] > 1) {
		isPayment = "Y";
	}else {
		var paym1Str = myAry[1].split("^")[0];
		var paym1Ary = paym1Str.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
		paymDR = paym1Ary[0];
		paymCode = paym1Ary[1];
	}
	var paymAry = [isPayment, paymDR, paymCode];
	return paymAry;
}
