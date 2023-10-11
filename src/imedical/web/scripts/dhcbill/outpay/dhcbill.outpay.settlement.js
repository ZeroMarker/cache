/**
 * FileName: dhcbill.outpay.settlement.js
 * Author: Lxy
 * Date: 2022-12-12
 * Description: 门诊外院报销结算
 */

var papmidr = ""
var PBODType = CV.PBODType

$(function() {
	showBannerTip();
	initQueryMenu();
	InvList();
	initDate();
	initRange();
	initReason();
	initChargeMenu();
});

//日期初始化
function initDate() {
	var startDate = getDefStDate(-30);
	var endDate = getDefStDate(0);
	$('#startDate').datebox('setValue', startDate);
	$('#endDate').datebox('setValue', endDate);
}

//发票范围下拉框
function initRange() {
	$('#invRange').combobox({
		valueField: 'code',
		textField: 'text',
		blurValidValue: true,
		panelHeight: "auto",
		editable: false,
		data: [{
			code: '',
			text: $g('全部'),
			selected: true
		}, {
			code: 'N',
			text: $g('本院')
		}, {
			code: 'Y',
			text: $g('外院')
		}]
	});
}

//结算费别下拉框
function initReason() {
	$('#admReason').combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		mode: 'remote',
		method: 'GET',
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function(rec) {
			setValueById("admSource", rec.admsource)
			loadInsuCombo(rec.id);
		}
	});
}

function initChargeMenu() {
	//医疗类别
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: "cCode",
		textField: "cDesc",
		blurValidValue: true,
		defaultFilter: 4
	});

	getReceiptNo();
}
/**
 * 通过医保类型代码加载医疗类别、病种
 */
function loadInsuCombo(insTypeId) {
	//获取医保类型代码
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetDicByCodeAndInd",
		SysType: "AdmReasonDrToDLLType",
		Code: insTypeId,
		Ind: 6,
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(insuTypeCode) {
		//医疗类别
		var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Code=&OPIPFlag=OP&Type=AKA130" + insuTypeCode + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$("#insuAdmType").combobox("clear").combobox("reload", url);
	});

}

//当前发票号
function getReceiptNo() {
	var prtInvFlag = "";
	var fairType = "F";
	var insType = $('#admReason').combobox('getValue')
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + prtInvFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + fairType + "^" + insType + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var encmeth = getValueById("GetOPReceiptNoEncrypt");
	var rtn = cspRunServerMethod(encmeth, "setReceiptNo", "", expStr);
	if (rtn != 0) {
		disableById("btn-settlement");
		$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
	}
}

function setReceiptNo(rtn) {
	var myAry = rtn.split("^");
	var currNo = myAry[0];
	var rowId = myAry[1];
	var leftNum = myAry[2];
	var endNo = myAry[3];
	var title = myAry[4];
	var tipFlag = myAry[5];
	if (rowId) {
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
		$("#btn-tip").show().popover({
				placement: 'bottom-left',
				cache: false,
				trigger: 'hover',
				content: content
			});
	}
}

function initQueryMenu() {
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function(e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function(e) {
		patientNoKeydown(e);
	});
}

//查询点击
function findClick() {
	var promise = new Promise(function(resolve, reject) {
		var patientNo = getValueById("patientNo");
		if (patientNo != "") {
			getPatInfo();
		} else {
			var cardNo = getValueById("CardNo");
			if (cardNo != "") {
				DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
			}
		}
		setTimeout(function() {
			resolve('success');
		}, 500);
	});
	promise.then(function(res) {
		QueryInvListList();
	});

}


//查询发票数据
function QueryInvListList() {
	var queryParams = {
		ClassName: 'BILL.OUTPAY.BL.InvPrtCtl',
		QueryName: 'InvListQuery',
		StaDate: getValueById('startDate'),
		EndDate: getValueById('endDate'),
		PAPMIDR: papmidr,
		InvRange: $('#invRange').combobox('getValue'),
		HospDr: session['LOGON.HOSPID']
	}
	loadDataGridStore('InvList', queryParams);
}

function InvList() {
	$('#InvList').datagrid({
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pagination: false,
		rownumbers: true,
		columns: [
			[{
					title: 'ck',
					field: 'ck',
					checkbox: true
				},
				{
					title: $g('明细'),
					field: 'ShowIndexValue',
					width: 100,
					align: 'center',
					formatter: function(value, row, index) {
						var btn = '<a href="#"  onclick="InvDetail(\'' + row["InvPrtRowId"] + '' + "|" + '' + row["OutInvFlag"] + '\')">' + $g("明细") + '</a>';
						return btn;
					}
				},
				{
					field: 'InvPrtRowId',
					title: 'rowid',
					width: 180,
					hidden: true
				},
				{
					field: 'InvNo',
					title: '发票号',
					width: 200
				},
				{
					field: 'InvSum',
					title: '总金额',
					width: 100,
					align: 'right'
				},
				{
					field: 'OptUserDesc',
					title: '发票录入人',
					width: 200
				},
				{
					field: 'sfDate',
					title: '发票录入时间',
					width: 200
				},
				{
					field: 'OutInvFlag',
					title: '是否外院发票',
					width: 200,
					formatter: function(value, row, index) {
						if (value) {
							return (value == 'Y') ? ('<font color="#21ba45">' + $g('是') + '</font>') : ('<font color="#f16e57">' + $g('否') + '</font>');
						}
					}
				}
			]
		],
		onBeforeLoad:function(data){
			data.rows = "9999999";
			return data;
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
	DHCACC_GetAccInfo7(magCardCallback);
	findClick();
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		findClick();
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	setValueById("accMRowId", myAry[1]);
	switch (myAry[0]) {
		case "0":
			setValueById("CardNo", myAry[1]);
			patientId = myAry[4];
			setValueById("patientNo", myAry[5]);
			setValueById("accMRowId", myAry[7]);
			setValueById("CardTypeRowId", myAry[8]);
			break;
		case "-200":
			$.messager.alert($g("提示"), $g("卡无效"), "info", function() {
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
		findClick();
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({
					msg: $g("登记号错误，请重新输入"),
					type: "info"
				});
				focusById("patientNo");
			} else {
				papmidr = papmi;
				setPatDetail(papmi);
			}
		});
	}
}

function setPatDetail(papmi) {
	papmidr = papmi;
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		var myPatientNo = myAry[1];
		var myPatType = myAry[7];
		var myAccMRowId = myAry[19];
		setValueById("patientNo", myPatientNo);
	});
	refreshBar(papmi, "");
}

//清屏
function clear_Click() {
	initDate();
	showBannerTip();
	$("#invRange").combobox("setValue", "");
	$("#admReason").combobox("setValue", "");
	$("#patientNo").val("");
	$("#CardNo").val("");
	$("#CardTypeNew").val("");
	$("#InvList").datagrid('loadData', []);
}

//结算
function InvSettlement() {
	var rows = $('#InvList').datagrid('getChecked');
	var InvStr = ""
	var payamt = 0
	if (rows.length > 0) {
		for (var i = 0; i < rows.length; i++) {
			InvStr += rows[i].InvPrtRowId + "|" + rows[i].OutInvFlag + "!";
			payamt += parseFloat(rows[i].InvSum)
		}
	}
	InvStr = InvStr.substring(0, InvStr.length - 1)
	payamt = payamt.toFixed(3) * 1000 / 1000
	var AdmSource = getValueById("admSource");
	var InsTypeDR = $('#admReason').combobox('getValue')
	if (InsTypeDR == "") {
		$.messager.alert($g('提示'), $g('结算费别不能为空'), 'error');
		return;
	}
	$.m({
		ClassName: "BILL.OUTPAY.BL.ChargeCtl",
		MethodName: "CheckChargeInsType",
		InvStr: InvStr,
		InvInsTypeDR: InsTypeDR
	}, function(rtn) {
		if ((rtn.indexOf("-") != -1)) {
			$.messager.alert($g("提示"), $g("结算错误:医保审核费别与结算费别不一致,请重新审核"), "error");
			return;
		} else {
			$.messager.confirm($g("确认"), $g("是否确认结算？"), function(res) {
				if (!res) {
					return;
				}
				$.m({
					ClassName: "BILL.OUTPAY.BL.ChargeCtl",
					MethodName: "ChargePre",
					InvStr: InvStr,
					InsTypeDR: InsTypeDR,
					ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					if ((rtn.indexOf("-") != -1)) {
						$.messager.popover({
							msg: rtn,
							type: 'error'
						});
					} else {
						if (InsTypeDR == 1) {
							$.m({
								ClassName: "BILL.OUTPAY.BL.ChargeCtl",
								MethodName: "ChargeComplete",
								InvPrtRowid: rtn,
								InsTypeDR: InsTypeDR,
								PayModeInfo: 1 + "^" + payamt,
								ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + CV.RequiredInvFlag
							}, function(res) {
								if ((res.indexOf("-") != -1)) {
									$.messager.popover({
										msg: res,
										type: 'error'
									});
								} else {
									$.messager.popover({
										msg: $g("操作成功！"),
										type: 'success'
									});
									getReceiptNo();
									findClick();
									billPrintTask(rtn);
									//billOutpayEInvoiceOP(rtn);
									return;
								}
							});
						} else {
							var myYBHand = "0";
							var myStrikeFlag = "N";
							var myInsuNo = "";
							var myCardType = "";
							var myYLLB = getValueById("insuAdmType");
							var accMRowId = getValueById("accMRowId");
							var myDicCode = "";
							var myDicDesc = "";
							var myDYLB = "";
							var myChargeSource = "01";
							var myDBConStr = ""; //数据库连接串
							var myMoneyType = "";
							var selPaymId = "";
							var myLeftAmt = "";
							var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
							myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
							var myYBRtn = InsuOPOutPayDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, rtn, AdmSource, InsTypeDR, myYBExpStr)
							if (myYBRtn.split("^")[0] != 0) {
								$.messager.alert($g("提示"), $g("医保收费错误：" + myYBRtn), "error");
								return;
							}
							$.m({
								ClassName: "BILL.OUTPAY.BL.ChargeCtl",
								MethodName: "ChargeComplete",
								InvPrtRowid: rtn,
								InsTypeDR: InsTypeDR,
								PayModeInfo: 1 + "^" + myYBRtn.split("^")[2],
								ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + CV.RequiredInvFlag
							}, function(res) {
								if ((res.indexOf("-") != -1)) {
									$.messager.popover({
										msg: res,
										type: 'error'
									});
									var myInsuDivStr = tkMakeServerCall("BILL.OUTPAY.BL.ChargeCtl", "GetOutPayInsuDivInfo",rtn);
			                        var myAry = myInsuDivStr.split("^");
		                            var myInsDivDR = myAry[0];
			                        var myInsType = myAry[1];
			                        var myAdmSource = myAry[2];
									var myYBHand = "0";
									var myStrikeFlag = "N";
									var myInsuNo = "";
									var myCardType = "";
									var myYLLB = getValueById("insuAdmType");
									var accMRowId = getValueById("accMRowId");
									var myDicCode = "";
									var myDicDesc = "";
									var myDYLB = "";
									var myChargeSource = "01";
									var myDBConStr = ""; //数据库连接串
									var myMoneyType = "";
									var selPaymId = "";
									var myLeftAmt = "";
									var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
									myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
									var myYBRtn = InsuOPOutPayDivideStrike(Handle, UserId, myInsDivDR, myAdmSource, myInsType, myYBExpStr)
									if (myYBRtn.split("^")[0] != 0) {
										$.messager.alert($g("提示"), $g("医保撤销错误：" + myYBRtn), "error");
										return;
									} else {
										$.m({
											ClassName: "BILL.OUTPAY.BL.ChargeCtl",
											MethodName: "Refund",
											InvPrtRowid: rtn,
											ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
										}, function(res) {
											if ((res.indexOf("-") != -1)) {
												$.messager.popover({
													msg: res,
													type: 'error'
												});
											} else {
												$.messager.popover({
													msg: $g("操作成功！"),
													type: 'success'
												});
												findClick();
												return;
											}
										});
									}
								} else {
									$.messager.popover({
										msg: $g("操作成功！"),
										type: 'success'
									});
							        getReceiptNo();
									findClick();
									billPrintTask(rtn);
									//billOutpayEInvoiceOP(rtn); //结算确认完成后,调用电子发票开具接口
									return;
								}
							});
						}
					}
				});
			});
		}
	});
}

//明细
function InvDetail(InvStr) {
	var AdmReasonDr = $('#admReason').combobox('getValue')
	if (AdmReasonDr == "") {
		$.messager.alert($g('提示'), $g('结算费别不能为空'), 'error');
		return;
	}
	var url = "dhcbill.outpay.invdetail.csp?InvStr=" + InvStr + '&PBODType=' + PBODType + '&AdmReasonDr=' + AdmReasonDr;
	websys_showModal({
		url: url,
		iconCls: 'icon-w-list',
		title: $g("发票明细"),
		width: 1100,
		height: 500
	});
}

//审核
function InsuProcess() {
	var rows = $('#InvList').datagrid('getChecked');
	var InvStr = ""
	if (rows.length > 0) {
		for (var i = 0; i < rows.length; i++) {
			InvStr += rows[i].InvPrtRowId + "|" + rows[i].OutInvFlag + "!";
		}
	}
	InvStr = InvStr.substring(0, InvStr.length - 1);
	if (InvStr == "") {
		$.messager.alert($g('提示'), $g('请选择发票记录'), 'error');
		return;
	}
	var AdmReasonDr = $('#admReason').combobox('getValue')
	if (AdmReasonDr == "") {
		$.messager.alert($g('提示'), $g('结算费别不能为空'), 'error');
		return;
	}
	var url = "dhcbill.outpay.insuprocess.csp?InvStr=" + InvStr + '&PBODType=' + PBODType + '&AdmReasonDr=' + AdmReasonDr;
	websys_showModal({
		url: url,
		iconCls: 'icon-w-list',
		title: $g("审核明细"),
		width: 1100,
		height: 500
	});
}

/**
 * Creator: suhuide
 * CreatDate: 2021-12-02
 * Desc: 确认完成后调用电子发票开具业务
 */
function billOutpayEInvoiceOP(prtInvIdStr) {
	var tradeType = "OUTOP"; //业务类型
	//1操作员ID^2安全组^3科室^4院区)
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			var eInvFlg = JudgeEInvFlag(tradeType, expStr);
			if (eInvFlg == "Y") { //是否开具电子发票 Y:开具 N:不开具
				var eInvRtn = EInvoieService(tradeType, id, "", expStr);
				if (eInvRtn.ResultCode != 0) {
					$.messager.alert("提示", eInvRtn.ResultMsg + ",请到电子票据补交易界面操作.", "error");
				}
			}
		}
	});
}

//打印发票
function billPrintTask(prtInvIdStr) {
	GV.INVXMLName = CV.INVXMLName;
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
			getXMLConfig(GV.INVXMLName);
			return;
		}
		invPrint(prtInvIdStr);
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
			var prtInfo = tkMakeServerCall("BILL.OUTPAY.BL.ChargeCtl", "GetOutPayPrtData","xmlPrintFun", id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, "INVPrtFlag2007");
			//var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, "INVPrtFlag2007");
		}
	});
}