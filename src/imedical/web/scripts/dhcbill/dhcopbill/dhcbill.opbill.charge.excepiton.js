/**
 * FileName: dhcbill.opbill.charge.excepiton.js
 * Anchor: ZhYW
 * Date: 2019-08-28
 * Description: �����շ��쳣����
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
	
	//���Żس���ѯ�¼�
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//������
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
 * ����
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
			$.messager.alert("��ʾ", "����Ч", "info", function () {
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
					$.messager.alert("��ʾ", "����Ч", "info", function () {
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
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
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
		columns: [[{title: '�ǼǺ�', field: 'TPatientNO', width: 100},
				   {title: '��������', field: 'TPapmiName', width: 80},
				   {title: '�ѱ�', field: 'TInsTypeDesc', width: 80},
				   {title: 'Ԥ��ʱ��', field: 'TDisplayPrtDate', width: 150,
				   	formatter: function (value, row, index) {
						return value + " " + row.TDisplayPrtTime;
					}
				   },
				   {title: '�շ�Ա', field: 'TPrtUserName', width: 70},
				   {title: '�ܽ��', field: 'TTotalAmt', align: 'right', width: 80},
				   {title: '�Ը����', field: 'TPatientShare', align: 'right', width: 80},
				   {title: '֧����ʽ', field: 'TPayMStr', width: 130},
				   {title: '�쳣����', field: 'TExceptionDesc', width: 160},
				   {title: '����', field: 'TOperation', align: 'center', width: 90,
				   	formatter: function (value, row, index) {
					   	var btnHtml = "";
					   	if (+value == 1) {
						   	btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='����' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
						}else if (+value == 2) {
							btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='���' onclick='completeClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
						}else {
							btnHtml = "<a href='javascript:;' class='datagrid-cell-img' title='����' onclick='cancelClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
							btnHtml += "<a href='javascript:;' class='datagrid-cell-img' title='���' onclick='completeClick(" + JSON.stringify(row) + ")' style='margin-left: 10px;'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png'/></a>";
						}
					   	return btnHtml;
					}
				   },
				   {title: '��ƱID', field: 'TPrtRowId', width: 80,
				   	formatter: function (value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "', '" + row.TabFlag + "\')\">" + value + "</a>";
						}
				   	}
				   },
				   {title: 'TabFlag', field: 'TabFlag', hidden: true},
				   {title: '�ۿ۽��', field: 'TDiscAmount', align: 'right', width: 80},
				   {title: '���˽��', field: 'TPayorShare', align: 'right', width: 80},
				   {title: 'ҽ������ID', field: 'TPRTInsDivDR', width: 80},
				   {title: 'TPAPMIDR', field: 'TPAPMIDR', hidden: true},
				   {title: 'TAccMDR', field: 'TAccMDR', hidden: true},
				   {title: '����', field: 'TPatLevel', hidden: true},
				   {title: '�ܼ�', field: 'TEncryptLevel', hidden: true}
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
		title: 'ҽ����ϸ',
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
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
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
* ����
*/
function cancelClick(row) {
	var prtRowId = row.TPrtRowId;
	var jsonObj = getINVPRTJsonObj(prtRowId);
	if (jsonObj.PRTFlag != "TP") {
		$.messager.popover({msg: "��Ԥ����״̬�����ܳ���", type: "info"});
		return;
	}
	if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
		var isTimeOut = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "CheckIsTimeOut", prtRowId: prtRowId}, false);
		if (isTimeOut == "N") {
			$.messager.popover({msg: "��ԭ��Ʊ�շ�Ա�����ܳ���", type: "info"});
			return;
		}
	}

	var accMRowId = row.TAccMDR;
	$.messager.confirm("ȷ��", row.TExceptionDesc + "���Ƿ�ȷ�ϳ�����", function(r) {
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
		//����ҽ������
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
			$.messager.popover({msg: "ҽ����Ʊ��Ʊ���󣬲����˷ѣ�����ϵ����Ա", type: "info"});
			return;
		}
	}
	
	//HIS���ݻع�
	var rtn = DHCWebOPYB_DeleteHISData(prtRowId, "");
	if (rtn == "0") {
		$.messager.alert("��ʾ", "�����ɹ�", "success", function() {
			$("#TPInvList").datagrid("reload");
		});
	} else {
		$.messager.alert("��ʾ", "����ʧ�ܣ�" + rtn, "error");
	}
}

/**
* ȷ�����
*/
function completeClick(row) {
	var prtRowId = row.TPrtRowId;
	var jsonObj = getINVPRTJsonObj(prtRowId);
	if (jsonObj.PRTFlag != "TP") {
		$.messager.popover({msg: "��Ԥ����״̬��������ɽ���", type: "info"});
		return;
	}
	if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
		$.messager.popover({msg: "��ԭ��Ʊ�շ�Ա��������ɽ���", type: "info"});
		return;
	}
	
	var accMRowId = row.TAccMDR;
	$.messager.confirm("ȷ��", row.TExceptionDesc + "���Ƿ���ɽ��㣿", function(r) {
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
	
	//var paymAry = getPaymAry(prtRowId);   //��ȡ��Ʊ֧����ʽ��Ϣ
	//var isPayment = paymAry[0];   //�Ƿ����֧��
	//var paymDR = paymAry[1];      //֧����ʽRowId
	//var paymCode = paymAry[2];    //֧����ʽCode
	
	if (!insuDivId && (+admSource > 0)) {
		var isYBCharge = $.m({ClassName: "web.DHCBillCons11", MethodName: "CheckYBCharge", prtRowID: prtRowId}, false);
		if (+isYBCharge != 0) {
			$.messager.alert("��ʾ", "ҽ������ɹ��������·�Ʊ��ʧ�ܣ����������ȷ�����", "info");
			return;
		}
		var myYBHand = "";
		var myCPPFlag = "";
		var strikeFlag = "S";    //���ﴫ��"S"����ҽ������ʧ��ʱ��ɾ����Ʊ��¼
		var insuNo = "";
		var cardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var chargeSource = "01";
		var DBConStr = "";       //���ݿ����Ӵ�
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
			$.messager.alert("��ʾ", "ҽ��ȡ������ɹ�����HISϵͳȡ������ʧ��", "error");
			return;
		}
	}
	
	//��������̨����
	//	ע�������˷����յ��·�Ʊ�Ƿ񵯳�������̨���棬��Ҫ�ٿ��ǣ�Ĭ���ȶ�������
	var cardNo = getValueById();
	var cardTypeId = getValueById("cardType").split("^")[0];
	var episodeIdStr = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowId}, false);
	var url = "dhcbill.opbill.checkout.csp?insTypeId=" + insType + "&typeFlag=FEE" + "&prtRowIdStr=" + prtRowId;
	url += "&accMRowId=" +accMRowId +  + "&episodeIdStr=" + episodeIdStr;
	url += "&patientId=" + patientId + "&cardNo=" + cardNo + "&cardTypeId=" + cardTypeId;
	websys_showModal({
		url: url,
		title: '����̨-�����շ��쳣����',
		iconCls: 'icon-w-card',
		height: 650,
		width: 1000,
		closable: false,
		callbackFunc: function(returnVal) {
			var code = returnVal.code;
			var message = returnVal.message;
			var accMRowId = returnVal.accMRowId;
			setValueById("accMRowId", accMRowId);  //���������δ��������������̨���˿�֧��
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
	
	var paymAry = getPaymAry(prtRowId);   //��ȡ��Ʊ֧����ʽ��Ϣ
	var isPayment = paymAry[0];   //�Ƿ����֧��
	var paymDR = paymAry[1];      //֧����ʽRowId
	var paymCode = paymAry[2];    //֧����ʽCode
	
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
			var msg = "ȷ����ɳɹ�";
			var iconCls = "success";
			if (oldPrtRowId) {
				//���õ������˷ѽӿ�  DHCBillPayService.js
				var tradeType = "OP";
				var refundAmt = "";
				var strikeRowId= $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "GetStrikInvRowId", prtRowId: oldPrtRowId}, false);
				var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^";
				var rtnValue = RefundPayService(tradeType, oldPrtRowId, strikeRowId, prtRowId, refundAmt, "OP", expStr);
				var msg = "�˷ѳɹ�";
				if (rtnValue.rtnCode != "0") {
					msg = "HISȷ����ɳɹ����������˷�ʧ�ܣ�" + rtnValue.rtnMsg + "��������룺" + rtnValue.rtnCode + "���벹����";
					iconCls = "error";
				}
			}
			$.messager.alert("��ʾ", msg, iconCls);
			$("#TPInvList").datagrid("reload");
			//��ӡ
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
			//�շѴ���ӡ���ﵥ
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
			//����ʵ�ʷ�Ʊ���շ�������ģ������
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //�˴�ֻ�޸ĵ���ģ��, ����Ҫ�޸�PrtXMLName
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
	$(".datebox-f").datebox("setValue", "");   //��������ڣ���ֹ��̨��������
	loadTPInvList();
	
	setValueById("stDate", GV.DefStDate);
	setValueById("endDate", getDefStDate(0));
	
	setValueById("userName", PUBLIC_CONSTANT.SESSION.USERNAME);
}

/**
* ��ȡ�˻����
*/
function getAccMBalance(accMRowId) {
	var accMLeft = "";
	if (accMRowId) {
		accMLeft = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
	}
	return accMLeft;
}

/**
* ��ȡ֧����ʽ��Ϣ
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
