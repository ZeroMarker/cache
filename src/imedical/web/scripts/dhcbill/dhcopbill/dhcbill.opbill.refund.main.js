/**
 * FileName: dhcbill.opbill.refund.main.js
 * Author: ZhYW
 * Date: 2019-04-23
 * Description: 门诊退费
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initRefundMenu();
	initOrdItmList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById("auditFlag", CV.DefAuditFlag);

	//读卡
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
	
	//查询
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});
	
	//原号重打
	$HUI.linkbutton("#btn-reprt", {
		onClick: function () {
			reprtClick();
		}
	});
	
	//过号重打
	$HUI.linkbutton("#btn-passNoReprt", {
		onClick: function () {
			passNoReprtClick();
		}
	});
	
	//补调医保
	$HUI.linkbutton("#btn-reInsuDivide", {
		onClick: function () {
			reInsuDivideClick();
		}
	});
	
	//撤销留观结算
	$HUI.linkbutton("#btn-cancleStayCharge", {
		onClick: function () {
			cancleStayChargeClick();
		}
	});
	
	//清屏
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//退费
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundInvClick();
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

	//发票回车查询事件
	$("#invNo").keydown(function (e) {
		invNoKeydown(e);
	});
	
	var $tb = $("#more-container");
	if (HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$tb.click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "l" : "b";
		if (t.find(".arrows-b-text").text() == $g("更多")) {
			t.find(".arrows-b-text").text($g("收起"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("更多"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});

	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPBillRefund&QueryName=FindInvUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
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
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 119: //F8
		e.preventDefault();
		loadInvList();
		break;
	default:
	}
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
		loadInvList();
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
			loadInvList();
		});
	}
}

/**
 * 发票号回车查询
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "CheckInvIsValid",
				recepitNo: $(e.target).val(),
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "该发票号不存在", type: "info"});
					return;
				}
				loadInvList();
			});
		}
	}
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout-panel-west .layout:eq(0)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-tr").show();
	} else {
		$("tr.display-more-tr").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillRefund",
		queryName: "FindOPBillINV",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate", "invDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["invRowId", "prtRowId", "invFlag", "hasRefOrd"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "userName") {
					cm[i].title = "收费员";
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.prtDate + " " + value;
					}
				}
				if (cm[i].field == "invTime") {
					cm[i].formatter = function (value, row, index) {
						return row.invDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["prtTime", "invTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			if (data.total == 1) {
				GV.InvList.selectRow(0);
			}else {
				clearRefPanel();
			}
		},
		rowStyler: function (index, row) {
			if (row.hasRefOrd == 1) {
				return "background-color:" + CV.RefInvRowBgClr + ";color:" + CV.RefInvRowClr + ";";
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function selectRowHandler(row) {
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	GV.InvRequireFlag = row.invNo ? "Y" : "N";     //集中打印发票在普通退费界面部分退费时，也需要打印发票
	
	if ((invFlag == "API") && prtRowId) {      //集中打印发票自动撤销时按小条查询发票信息
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	
	//+2022-03-29 ZhYW 判断是否做了直接退费审核，配置"部分退费按全退后再收费界面重收"时，当作已审核
	GV.IsDirRefAudited = (CV.IsRefedReChrg == 1) ? CV.IsRefedReChrg : isDirectRefAudit(invRowId, invFlag);
	if (GV.IsDirRefAudited == 1) {
		//直接退费审核过的发票，全部退费，退费金额取发票的自付金额
		setValueById("refundAmt", row.patShareAmt);
		setValueById("factRefundAmt", row.patShareAmt);
	}
	
	loadOrdItmList();
	
	var invStr = invRowId + ":" + invFlag;
	getPaymList(invStr);
	getReceiptInfo(invStr);
}

/**
* 获取支付方式信息
*/
function getPaymList(invStr) {
	$.m({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetInvPayModeList",
		invStr: invStr
	}, function(rtn) {
		if (!rtn) {
			return;
		}
		var invPMAry = rtn.split("#");
		setValueById("invPayment", ((invPMAry[0] > 1) ? "Y" : "N"));
		var paymAry = invPMAry[1] ? invPMAry[1].split("^") : [];
		var myPMAry = [];
		var paymHtml = "<table>";
		$.each(paymAry, function (index, item) {
			myPMAry = item.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
			paymHtml += "<tr>";
			paymHtml += "<td class='paym-desc'>";
			paymHtml += myPMAry[0] + "：";
			paymHtml += "</td>";
			paymHtml += "<td class='paym-amt'>";
			paymHtml += myPMAry[1];
			paymHtml += "</td>";
			paymHtml += "</tr>";
		});
		paymHtml += "</table>";
		$("#paymList").html(paymHtml);
	});
}

/**
* 获取票据信息
*/
function getReceiptInfo(invStr) {
	$.cm({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetReceiptInfo",
		invStr: invStr,
		userId: PUBLIC_CONSTANT.SESSION.USERID
	}, function (json) {
		if (!json) {
			return;
		}
		disablePageBtn();
		setValueById("patientId", json.patientId);
		setValueById("accMRowId", json.accMRowId);
		setValueById("accMLeft", json.accMLeft);
		setValueById("insTypeId", json.insTypeId);
		setValueById("insuDivId", json.insuDivId);
		setValueById("stayInvFlag", json.stayInvFlag);
		setValueById("insuPayAmt", json.insuPayAmt);
		setValueById("refBtnFlag", json.refBtnFlag);
		setValueById("autoFlag", json.autoFlag);
		
		loadNewInsType(json.insTypeId);
		loadInsuCombo(json.insTypeId);  //加载医疗类别、病种
				
		loadRefundModeData(json.invPaymDR);   //2022-09-14 ZhYW 加载退费方式
		
		if (json.prtFlag != "N") {
			var msg = "该记录已" + ((json.prtFlag == "A") ? "作废" : ((json.prtFlag == "S") ? "红冲" : ""));
			$.messager.popover({msg: msg, type: "info"});
			return;
		}

		if (!json.insuDivId) {
			enableById("btn-reInsuDivide");
		}
		enableById("btn-reprt");
		enableById("btn-passNoReprt");
		
		if (json.stayInvFlag == "Y") {
			enableById("btn-cancleStayCharge");
			return;    //急诊留观的撤销留观结算后重新结算，不能在此退费
		}
		
		if (json.writeOffFlag == "Y") {
			disableById("btn-reInsuDivide");   //非卡支付的不能补掉医保接口
			$.messager.alert("提示", "若需退费，请先撤销集中打印发票", "info");
			return;    //需撤销集中打印发票的，不能在此退费
		}
		
		switch(json.refBtnFlag) {
		case "A":
			if (CV.AbortFlag != 1) {
				$.messager.popover({msg: "该安全组没有作废权限，请检查【安全组功能配置】", type: "info"});
			}else {
				enableById("btn-refund");
			}
			break;
		case "S":
			if (CV.RefundFlag != 1) {
				$.messager.popover({msg: "该安全组没有红冲权限，请检查【安全组功能配置】", type: "info"});
			}else {
				enableById("btn-refund");
			}
			break;
		default:
		}
	});
}

/**
* 加载新费别
*/
function loadNewInsType(insTypeId) {
    $.cm({
        ClassName: "web.DHCOPCashier",
        QueryName: "QryChgInsTypeList",
        ResultSetType: "array",
        insTypeId: insTypeId,
        hospId: PUBLIC_CONSTANT.SESSION.HOSPID
    }, function (data) {
        if (insTypeId && !$.hisui.getArrayItem(data, "insTypeId", insTypeId)) {
            var jsonObj = getPersistClsObj("User.PACAdmReason", insTypeId);
            var insType = $.m({ClassName: "User.PACAdmReason", MethodName: "GetTranByDesc", Prop: "READesc", Desc: jsonObj.READesc, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
            var item = {insType: insType, insTypeId: insTypeId, admSource: jsonObj.REAAdmSource, selected: true};
            $.hisui.addArrayItem(data, "insTypeId", item);
        }
      	$("#newInsType").combobox("clear").combobox("loadData", data);
    });
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOPBillINV",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("guser"),
		receiptNo: getValueById("invNo"),
		patientNo: getValueById("patientNo"),
		auditFlag: getValueById("auditFlag") ? 1 : 0,
		sessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

/**
* 初始化退费面板
*/
function initRefundMenu() {
	$("#item-tip").show();   //显示支付信息
	
	//退费方式
	$("#refundMode").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc'
	});
	
	$("#newInsType").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'insTypeId',
		textField: 'insType',
		onSelect: function(rec) {
			loadInsuCombo(rec.insTypeId);
		}
	});
	
	//医疗类别
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'cCode',
		textField: 'cDesc',
		blurValidValue: true,
		defaultFilter: 5
	});

	//病种
	$HUI.combobox("#insuDic", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'DiagCode',
		textField: 'DiagDesc',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initOrdItmList() {
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: [],
		className: "web.DHCOPBillRefund",
		queryName: "FindOrdItm",
		frozenColumns: [[{field: 'ck', checkbox: true},
		           		 {title: '医嘱', field: 'arcimDesc', width: 180,
			           	  	formatter: function (value, row, index) {
								if (row.cantRefReason) {
									return "<a onmouseover='showCantRefReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
								}
								return value;
						  	}
		           		 }
			]],
		onColumnsLoad: function(cm) {
			cm.unshift({title: '退费部位', field: 'repPartTar', align: 'center'});   //往数组开始位置增加一项
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["arcimDesc", "packUom", "cantRefReason"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["refQty", "refAmt", "auditFlag", "disabled", "select", "isAppRep", "isCNMedItem", "pboRowId", "prtId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "repPartTar") {
					cm[i].formatter = function (value, row, index) {
						//检查申请单全部执行时不能退
						if ((row.isAppRep == "Y") && (row.disabled == "N")) {
							return "<a href='javascript:;' class='editCls' onclick='openPartWinOnClick(" + index + ")'></a>";
						}
					};
				}
				if (cm[i].field == "billQty") {
					cm[i].title = "数量/单位";
					cm[i].formatter = function (value, row, index) {
						return value + "/" + row.packUom;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "repPartTar") {
						cm[i].width = 80;
					}
					if (cm[i].field == "prescNo") {
						cm[i].width = 130;
					}
					if (cm[i].field == "execInfo") {
						cm[i].width = 160;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(".editCls").linkbutton({text: $g("部位")});
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.disabled == "Y") {
					hasDisabledRow = true;
					GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
					if (row.select == 1) {
						GV.OEItmList.checkRow(index);
					}
				}
			});
			//有disabled行时，表头也disabled
			GV.OEItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onCheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			if (!canCheck(row)) {
				GV.OEItmList.uncheckRow(index);
			} else {
				controlCNMedItm(index, row);
				calcRefAmt();
			}
		},
		onUncheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			controlCNMedItm(index, row);
			calcRefAmt();
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (!canCheck(row)) {
					GV.OEItmList.uncheckRow(index);
				}
			});
			calcRefAmt();
		},
		onUncheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if ((row.disabled == "Y") && (row.select == 1)) {
					GV.OEItmList.checkRow(index);
				}
			});
			calcRefAmt();
		}
	});
}

/**
 * 判断行能否被勾选
 */
function canCheck(row) {
	if (row.select == 1) {
		return true;
	}
	if (row.disabled == "Y") {
		return false;
	}
	if ((row.isAppRep == "Y") && !row.refRepPart) {
		return false;
	}
	return true;
}

/**
* 新版检查申请单获取部位
*/
function openPartWinOnClick(index) {
	var invRow = GV.InvList.getSelected();
	if (!invRow) {
		return;
	}
	var prtFlag = "";
	if (invRow.invFlag == "API") {
		prtFlag = getPropValById("DHC_AccPayINV", invRow.invRowId, "API_Flag");
	}else {
		prtFlag = getPropValById("DHC_INVPRT", invRow.invRowId, "PRT_Flag");
	}
	if (prtFlag != "N") {
		var msg = "该发票已" + ((prtFlag == "A") ? "作废" : ((prtFlag == "S") ? "红冲" : "")) + "，不能选择部位";
		$.messager.popover({msg: msg, type: "info"});
		return;
	}
	
	var row = GV.OEItmList.getRows()[index];
	var oeori = row.oeori;
	var pboRowId = row.pboRowId;
	var oldRefRepPart = row.refRepPart || "";   //已经勾选的部位
	var url = "dhcapp.repparttarwin.csp?oeori=" + oeori + "&refRepPart=" + oldRefRepPart;
	websys_showModal({
		url: url,
		title: '部位列表',
		width: 640,
		height: 400,
		callBackFunc: function(rtnValue) {
			var arReqItmIdStr = rtnValue.split("!!").map(function (item) {
			        return item.split("^")[0];
			    }).join("!!");
			row.refRepPart = arReqItmIdStr;    //多部位检查申请单退费部位RowId串
	
			if (arReqItmIdStr != "") {
				var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "UpdateExaReqFlag", oeitm: oeori, arReqItmIdStr: arReqItmIdStr}, false);
				if (rtn != 0) {
					$.messager.popover({msg: "更新检查申请部位表退费申请状态失败：" + rtn, type: "error"});
					return;
				}
			}
			
			setOrdItmRowChecked(index, (arReqItmIdStr != ""));
			
			//新版检查申请单全退/部分退标识
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "IsAllRefundRepPart",
				oeitm: oeori
			}, function(refPartFlag) {
				GV.OEItmList.setFieldValue({index: index, field: "refQty", value: refPartFlag});   //0:全部或未退，1:部分退
			});
			
			//计算按部位退费金额
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "GetRepPartRefAmt",
				oeitm: oeori,
				pbo: pboRowId,
				arReqItmIdStr: arReqItmIdStr
			}, function (repPartAmt) {
				GV.OEItmList.setFieldValue({index: index, field: "refAmt", value: repPartAmt});
				calcRefAmt();
			});
		}
	});
}

/**
 * 计算退费金额
 */
function calcRefAmt() {
	var refSum = GV.OEItmList.getChecked().reduce(function (total, row) {
        return Number(total).add(row.refAmt).toFixed(2);
    }, 0);
    setValueById("ordRefundAmt", refSum);   //医嘱退费金额
    //+2022-03-29 ZhYW 直接退费审核过的发票，全部退费，退费金额不需要根据医嘱计算
	if (GV.IsDirRefAudited == 0) {
		setValueById("refundAmt", refSum);
		setValueById("factRefundAmt", refSum);
	}
}

function loadOrdItmList() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invStr = row.invRowId + ":" + row.invFlag;
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOrdItm",
		invStr: invStr,
		rows: 999999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * 控制草药按处方退费
 */
function controlCNMedItm(index, row) {
	var prescNo = row.prescNo;
	var isCNMedItem = row.isCNMedItem;
	if ((prescNo == "") || (isCNMedItem != 1)) {
		return;
	}
	var rows = GV.OEItmList.getRows();
	$.each(rows, function (idx, row) {
		if ((index == idx) || (prescNo != row.prescNo)) {
			return true;
		}
		setOrdItmRowChecked(idx, getOrdItmRowChecked(index));
	});
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelOrdRowIdx = index;
	if (checked) {
		GV.OEItmList.checkRow(index);
	} else {
		GV.OEItmList.uncheckRow(index);
	}
	delete GV.SelOrdRowIdx;
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return GV.OEItmList.getPanel().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(":checked");
}

/**
* 原号重打
*/
function reprtClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReprt();
	}else {
		invReprt();
	}
}

/**
* 过号重打
*/
function passNoReprtClick() {
	var _validate = function() {
		return new Promise(function(resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				$.messager.popover({msg: "请选择需要过号重打的发票记录", type: "info"});
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			invNo = row.invNo;
			if (!invNo) {
				$.messager.popover({msg: "没有打印发票，不能过号重打", type: "info"});
				return reject();
			}
			var prtFlag = "";
			var prtUserDR = "";
			var prtReportsDR = "";
			if (invFlag == "API") {
				var jsonObj = getPersistClsObj("User.DHCAccPayINV", invRowId);
				prtFlag = jsonObj.APIFlag;
				prtUserDR = jsonObj.APIPUserDR;
				prtReportsDR = jsonObj.APIINVRepDR;
			}else {
				var jsonObj = getPersistClsObj("User.DHCINVPRT", invRowId);
				prtFlag = jsonObj.PRTFlag;
				prtUserDR = jsonObj.PRTUsr;
				prtReportsDR = jsonObj.PRTDHCINVPRTRDR;
			}
			if (prtFlag != "N") {
				$.messager.popover({msg: "该发票已退费，不能过号重打", type: "info"});
				return reject();
			}
			if (prtUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人打印的发票，不能过号重打", type: "info"});
				return reject();
			}
			if (prtReportsDR > 0) {
				$.messager.popover({msg: "已做日结的发票，不能过号重打", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function(resolve, reject) {
			$.messager.confirm("确认", $g("是否确认将发票") + "【<font color='red'>" + invNo + "</font>】" + $g("过号重打? "), function(r) {
				return r ? resolve() : reject();
			});
		});
	};

	/**
	 * 过号重打
	*/
	var _passRePrint = function() {
		return new Promise(function(resolve, reject) {
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "PassNoRePrint",
				invRowId: invRowId,
				invFlag: invFlag,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "过号重打成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "过号重打失败: " + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};

	/**
	* 过号重打成功后打印发票
	*/
	var _success = function () {
		if (invFlag == "API") {
			accPInvPrint(invRowId);
		}else {
			billPrintTask(invRowId);
		}
	};

	if ($("#btn-passNoReprt").linkbutton("options").disabled) {
		return;
	}
	$("#btn-passNoReprt").linkbutton("disable");
	
	var invRowId = "";
	var invFlag = "";
	var invNo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_passRePrint)
		.then(function() {
			_success();
			$("#btn-passNoReprt").linkbutton("enable");
		}, function () {
			$("#btn-passNoReprt").linkbutton("enable");
		});
}

/**
* 补调医保
*/
function reInsuDivideClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReInsuDivide();
	}else {
		invReInsuDivide();
	}
}

/**
* 撤销留观结算
*/
function cancleStayChargeClick() {
	if ($("#btn-cancleStayCharge").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "PRT") {
		cancleStayCharge();
	}
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f").combobox("clear");
	$("#refundMode").combobox("loadData", []);
	$("#guser").combobox("reload");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById("auditFlag", CV.DefAuditFlag);
	GV.InvList.options().pageNumber = 1;   //跳转到第一页
	GV.InvList.loadData({total: 0, rows: []});
	clearRefPanel();
}

/**
 * 清除退费Panel内容
 */
function clearRefPanel() {
	$(".combobox-f:not(#guser,#refundMode)").combobox("clear").combobox("loadData", []);
	$(".numberbox-f").numberbox("setValue", 0);
	$("#refundMode").combobox("clear").combobox("loadData", []);
	$("#paymList").html("");
	$(".datagrid-f:not(#invList)").datagrid("loadData", {
		total: 0,
		rows: []
	});
	disablePageBtn();
}

/**
* 作废/红冲
*/
function refundInvClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "API") {
		accInvRefSaveInfo();
	}else {
		invRefSaveInfo();
	}
}

function disablePageBtn() {
	disableById("btn-refund");
	disableById("btn-reprt");
	disableById("btn-passNoReprt");
	disableById("btn-reInsuDivide");
	disableById("btn-cancleStayCharge");
}

/**
* 加载医疗类别、病种
*/
function loadInsuCombo(insTypeId) {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invFlag = row.invFlag;
	if ((invFlag == "API") && row.prtRowId) {
		invFlag = "PRT";
	}
	var CPPFlag = (invFlag == "API") ? "Y" : "";
	var strikeFlag = "S";
	var insuDivId = getValueById("insuDivId");
	var expStr = "OP" + "^" + CPPFlag + "^" + strikeFlag + "^" + insuDivId;
	//医疗类别
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryMedType&ResultSetType=array&AdmReaId=" + insTypeId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;  
	$("#insuAdmType").combobox("clear").combobox("reload", url);
	
	//病种
	var patientId = getValueById("patientId");
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryChronic&ResultSetType=array&AdmReaId=" + insTypeId + "&PapmiDr=" + patientId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;
	$("#insuDic").combobox("clear").combobox("reload", url);
}

/**
* 泡芙提示不可退费原因
*/
function showCantRefReason($this, row) {
	if (GV.IsDirRefAudited == 1) {
		return;   //做了直接退费审核的不显示不可退费原因
	}
	$($this).popover({
		title: '<font color="#FF0000">' + row.arcimDesc + '</font>' + $g("不可退费原因"),
		trigger: 'hover',
		content: row.cantRefReason
	}).popover("show");
}

function getRefInfoHTML(invStr) {
	var html = "";
	var jsonObj = $.cm({ClassName: "web.DHCOPBillRefund", MethodName: "GetRefundInfo", invStr: invStr}, false);
	if ((jsonObj.code == 0) && (jsonObj.refPatSum != 0)) {
		setValueById("factRefundAmt", jsonObj.refSelfSum);
		
		html += "<p class=\"fail-Cls\">" + "退费金额为：" + jsonObj.refPatSum + "元</p>";
		if (jsonObj.refmodeStr) {
			var begSign = "";
			var endSign = "";
			var refmodeAry = jsonObj.refmodeStr.split(",");
			$.each(refmodeAry, function(index, item) {
				begSign = (index == 0) ? "（" : "";
				endSign = (index == (refmodeAry.length - 1)) ? "）" : "";
				item = item.replace(/收/, "<a class=\"succ-Cls\">收</a>") + "元";
				html += "<p class=\"fail-Cls\">" + begSign + item + endSign + "</p>";
			});
		}
	}
	return html;
}

/**
* 获取账户余额
*/
function getAccMLeft() {
	var accMRowId = getValueById("accMRowId");
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false) : "";
}

/**
* 判断是否有已审核但未撤销执行的不能退费医嘱
*/
function hasNoCancelAuditOrd() {
	var bool = false;
	$.each(GV.OEItmList.getRows(), function (index, row) {
		if (row.auditFlag != "Y") {
			return true;
		}
		if (row.disabled != "Y") {
			return true;
		}
		if (getOrdItmRowChecked(index)) {
			return true;
		}
		bool = true;
		return false;
	});
	return bool;
}

/**
* 判断是否做了直接退费审核
*/
function isDirectRefAudit(invId, invType) {
	return $.m({ClassName: "BILL.OP.BL.DirectRefundAudit", MethodName: "CheckIsAudited", invId: invId, invType: invType}, false)
}

/**
* 点"退费"按钮时，判断是否是过号重打
*/
function isPassNoReChg() {
	if (GV.ReBillFlag == 0) {
		return false;
	}
	if (GV.OEItmList.getChecked().length > 0) {
		return false;
	}
	return true;
}

/**
* 2022-09-14
* ZhYW
* 获取加载退费方式combobox的url
*/
function loadRefundModeData(paymId) {
	$.cm({
		ClassName: "web.UDHCOPGSConfig",
		QueryName: "QryGSContraRefPMList",
		ResultSetType: "array",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID,
		TypeFlag: "REF",
		CfgCode: "OPCHRG.OPRefd.TFZFFSYSFZFFSDZ",
		PayMID: paymId
	}, function(data) {
		$("#refundMode").combobox("loadData", data);
	});
};

/**
* 2022-11-22
* ZhYW
* 医保收费跨月是否能退费
*/
function isAllowedRefInsuDiffMth(invId, invType) {
	return ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedRefInsuDiffMth", prtRowId: invId, invType: invType}, false) == 1);
}

/**
* 2023-04-04
* ZhYW
* 医保住院患者是否允许门诊部分退费
*/
function isAllowedIPPatPartRef(patientId) {
	return ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedIPPatPartRef", patientId: patientId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}
