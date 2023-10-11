/**
 * FileName: dhcbill.opbill.charge.patinfo.js
 * Author: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

$(function () {
	initPatInfoMenu();
});

function initPatInfoMenu() {
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
	
	//费别列表
	initInsTypeList();
	//就诊列表
	initAdmList();
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
	var accMRowId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		accMRowId = myAry[7];
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
	
	setValueById("accMRowId", accMRowId);
	if (patientId != "") {
		var admStr = "";
		setPatientDetail(patientId, admStr);
	}
}

function initInsTypeList() {
	var selectInsTypeRowIdx = undefined;
	GV.InsTypeList = $HUI.datagrid("#insTypeList", {
		fit: true,
		singleSelect: true,
		autoSizeColumn: false,
		showHeader: false,
		bodyCls: 'panel-header-gray',
		loadMsg: null,
		pageSize: 999999999,
		columns: [[{title: '费别', field: 'insType', width: 177},
				   {title: 'insTypeId', field: 'insTypeId', hidden: true},
				   {title: 'admSource', field: 'admSource', hidden: true},
				   {title: 'selected', field: 'selected', hidden: true}
			]],
		onLoadSuccess: function (data) {
			selectInsTypeRowIdx = undefined;
			if (data.total > 0) {
				//设置默认选中行
				setInsTypeListDefSelected(data.rows);
			}
			//费别加载成功之后加载就诊列表，防止因为异步导致加载不了医嘱
			loadAdmList();
		},
		onSelect: function(index, row) {
			if (selectInsTypeRowIdx === index) {
				return;
			}
			if (selectInsTypeRowIdx !== undefined) {
				refreshAdmInsCost();
				reloadOrdItmList();
				reloadCateList();
			}
			selectInsTypeRowIdx = index;
			selectInsTypeListRowHandler(row);
		}
	});
	GV.InsTypeList.getPanel().addClass("lines-no").find(".datagrid-view2 > .datagrid-header").removeClass("datagrid-header");
}

function reloadOrdItmList() {
	var adm = getValueById("episodeId");
	if (adm) {
		loadOrdItmList(adm);
	}
}

function reloadCateList() {
	var adm = getValueById("episodeId");
	if (adm) {
		loadCateList(adm);
	}
}

/**
* 设置费别grid默认选中行
*/
function setInsTypeListDefSelected(rows) {
	var defSelectIndex = 0;
	$.each(rows, function (index, row) {
		if (row.selected) {
			defSelectIndex = index;
			return false;
		}
	});
	GV.InsTypeList.selectRow(defSelectIndex);
}

function selectInsTypeListRowHandler(row) {	
	loadChargeInsType(row);  //加载结算费别
	
	getReceiptNo();   //通过费别取发票号
}

/**
* 结算全部就诊时，更新金额
*/
function refreshAdmInsCost() {
	if (CV.BillByAdmSelected) {
		return;
	}
	var admStr = getValueById("admStr");
	var insTypeId = getSelectedInsType();
	$.cm({
		ClassName: "web.DHCOPCashier",
		QueryName: "FindAdmDtlList",
		episodeIdStr: admStr,
		insTypeId: insTypeId,
		sessionStr: getSessionStr(),
		rows: 99999999
	}, function(data) {
		$.each(data.rows, function(index, row) {
			var rowIndex = GV.AdmList.getRowIndex(row.adm);
			if (!(rowIndex < 0)) {
				GV.AdmList.updateRow({
					index: rowIndex,
					row: {
						admTotalSum: Number(row.admTotalSum).toFixed(2),
						admDiscSum: Number(row.admDiscSum).toFixed(2),
						admPayOrSum: Number(row.admPayOrSum).toFixed(2),
						admPatSum: Number(row.admPatSum).toFixed(2)
					}
				});
			}
		});
	});
}

function initAdmList() {
	var selectAdmListRowIdx = undefined;
	GV.AdmList = $HUI.datagrid("#admList", {
		fit: true,
		fitColumns: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		loadMsg: null,
		pageSize: 999999999,
		idField: 'adm',
		columns: [[{title: 'adm', field: 'adm', hidden: true},
				   {title: '就诊日期', field: 'admDate', width: 90},
				   {title: 'admDeptDR', field: 'admDeptDR', hidden: true},
				   {title: '就诊科室', field: 'admDept', width: 110},
				   {title: 'admDocDR', field: 'admDocDR', hidden: true},
				   {title: '就诊医生', field: 'admDoc', width: 100},
				   {title: 'hasOrd', field: 'hasOrd', hidden: true},
				   {title: 'admTotalSum', field: 'admTotalSum', align: 'right', hidden: true},
				   {title: 'admDiscSum', field: 'admDiscSum', align: 'right', hidden: true},
				   {title: 'admPayOrSum', field: 'admPayOrSum', align: 'right', hidden: true},
				   {title: '金额', field: 'admPatSum', align: 'right', width: 80}
			]],
		onLoadSuccess: function (data) {
			setValueById("episodeId", "");
			GV.UnBillOrdObj = {};
			selectAdmListRowIdx = undefined;
			if (data.total == 0) {
				return;
			}
			var defSelectIndex = "";
			$.each(data.rows, function (index, row) {
				if (!row.adm) {
					return true;
				}
				
				GV.UnBillOrdObj[row.adm] = [];
				$.each(row.limitOrdStr.split("^"), function(index, item) {
					if (!item) {
						return true;
					}
					if (GV.UnBillOrdObj[row.adm].indexOf(item) == -1) {
						GV.UnBillOrdObj[row.adm].push(item);
					}
				});
				if ((row.admTotalSum > 0) && (defSelectIndex === "")) {
					defSelectIndex = index;
				}
			});
			GV.AdmList.selectRow(defSelectIndex || 0);
		},
		rowStyler:  function(index, row) {
			if (row.hasOrd == 1) {
				return "color: #FF0000;";
			}
		},
		onSelect: function(index, row) {
			if (selectAdmListRowIdx == index) {
				return;
			}
			selectAdmListRowIdx = index;
			selectAdmListRowHandler(row);
		}
	});
}

function selectAdmListRowHandler(row) {
	//切换ADM时要先保存医嘱
	var rtn = checkSaveOrder();
	if (!rtn) {
		$.messager.popover({msg: "请先保存医嘱", type: "info"});
		return false;
	}
	var patientId = getValueById("patientId");
	refreshBar(patientId, row.adm);
	displayInsTypeColor(row.adm);
	//这两句一定要放到保存医嘱之后
	setValueById("episodeId", row.adm);
	$("#admDoc").combobox("loadData", [{id: row.admDocDR, text: row.admDoc, selected: true}]);
	
	loadOrdItmList(row.adm);
	loadCateList(row.adm);
	
	loadInsuCombo();   //加载医疗类别、病种

	getAdmLimitOrdStr();
	
	isValidAdmOrd();
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			clearCardInfo();
			getPatInfo();
		}
	}
}

/**
* 清空卡信息
*/
function clearCardInfo() {
	setValueById("CardNo", "");
	setValueById("CardTypeNew", "");
	setValueById("CardTypeRowId", "");
	setValueById("accMRowId", "");
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (!patientNo) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPAPMIByNo",
		PAPMINo: patientNo,
		ExpStr: ""
	}, function(papmi) {
		if (!papmi) {
			$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
			focusById("patientNo");
		}
		var admStr = "";
		setPatientDetail(papmi, admStr);
	});
}

function setPatientDetail(papmi, admStr) {
	$(".change-content").empty();    //清空找零提示信息
	if ($("#insuDic").length > 0) {
		$("#insuDic").parents("td").prev().find("label").popover("destroy").removeClass("pseudo-hyper");
	}
	
	setValueById("patientId", papmi);
	if (!papmi) {
		clearBanner();
		clearAdmsRela();
		return;
	}
	
	setPatientInfo(papmi);
	
	if (!admStr) {
		admStr = getToAdmStr(papmi);
	}
	setValueById("admStr", admStr);
	if (!admStr) {
		refreshBar(papmi, "");
		$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
		$.messager.popover({msg: "该患者今天没有挂号", type: "info"});
		return;
	}
	
	loadInsTypeList(papmi);
}

function setPatientInfo(papmi) {
	//公费单位
	$("#healthCareProvider").combobox("clear");
	var careProvId = getPropValById("PA_Person", papmi, "PAPER_HCP_DR");
	if (careProvId > 0) {
		var careProv = getPropValById("CT_HealthCareProvider", papmi, "HCP_Desc");
		careProv = $.m({ClassName: "User.CTHealthCareProvider", MethodName: "GetTranByDesc", Prop: "HCPDesc", Desc: careProv, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		$("#healthCareProvider").combobox("loadData", [{id: careProvId, text: careProv, selected: true}]);
	}
	
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);    //患者登记号
		var arrearsAmt = myAry[21];
		if (arrearsAmt != 0) {
			$.messager.alert("提示", ($g("该患者") + "<font color=\"red\">" + $g("欠费") + arrearsAmt + "</font>" + $g("元") + "，" + $g("请提醒患者及时补缴欠款")), "warning");
		}
	});
}

function getToAdmStr(papmi) {
	return $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetToDayAdmStr", PAPMI: papmi, SessionStr: getSessionStr()}, false);
}

/**
* 加载结算费别
*/
function loadChargeInsType(row) {
	if ($("#chargeInsType").length == 0) {
		return;
	}
	$.cm({
		ClassName: "web.DHCOPCashier",
		QueryName: "QryChgInsTypeList",
		ResultSetType: "array",
		insTypeId: row.insTypeId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(data) {
		if (row.insTypeId && !$.hisui.getArrayItem(data, "insTypeId", row.insTypeId)) {
			var item = {insType: row.insType, insTypeId: row.insTypeId, admSource: row.admSource, selected: true};
			$.hisui.addArrayItem(data, "insTypeId", item);
		}
		$("#chargeInsType").combobox("clear").combobox("loadData", data);
	});
}

function loadInsTypeList(papmi) {
	var admStr = getValueById("admStr");
	var queryParams = {
		ClassName: "web.DHCOPCashier",
		QueryName: "QryPatPrescTypeList",
		papmi: papmi,
		episodeIdStr: admStr,
		sessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("insTypeList", queryParams);
}

function loadAdmList() {
	var admStr = getValueById("admStr");
	var insTypeId = getSelectedInsType();
	var queryParams = {
		ClassName: "web.DHCOPCashier",
		QueryName: "FindAdmDtlList",
		episodeIdStr: admStr,
		insTypeId: insTypeId,
		sessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("admList", queryParams);
}

/**
* 有医嘱的费别字体变色
*/
function displayInsTypeColor(adm) {
	if (!adm) {
		return;
	}
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetInsTypeIdStrOfHaveOrd",
		adm: adm,
		type: "ALL",
		sessionStr: getSessionStr()
	}, function(rtn) {
		var myAry = rtn.split("^");
		GV.InsTypeList.getPanel().find("div.datagrid-body tr").each(function() {
			var color = ($.inArray($(this).find("td[field='insTypeId'] div").text(), myAry) != -1) ? "#FF0000" : "#000000";
			$(this).css({"color": color});
		});
	});
}

function getAdmLimitOrdStr() {
	$.m({
		ClassName: "web.DHCOPCashier",
		MethodName: "GetSkinRtnFlag",
		AdmStr: getValueById("admStr"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == "Y") {
			$.messager.popover({msg: "患者有" + myAry[1], type: "alert"});
		}
	});
}

function getSelectedInsType() {
	var row = GV.InsTypeList.getSelected();
	return row ? row.insTypeId : "";
}

function getBillAdmStr() {
	return CV.BillByAdmSelected ? getValueById("episodeId") : getValueById("admStr");
}

function clearClick() {
	if ($("#btn-clear").hasClass("l-btn-disabled")) {
		return;
	}
	initFeeAll();
	$(".change-content").empty();    //清空找零提示信息
	if ($("#insuDic").length > 0) {
		$("#insuDic").parents("td").prev().find("label").popover("destroy").removeClass("pseudo-hyper");
	}
}

/**
* @method 验证医嘱数据合法性
* @param {String} admStr
* @author ZhYW
*/
function isValidAdmOrd() {
	var admStr = getBillAdmStr();
	$.m({
		ClassName: "web.DHCOPCashier",
		MethodName: "IsValidAdmOrd",
		admStr: admStr,
		unBillOrdStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.alert("提示", (myAry[1] || myAry[0]), "error", function () {
				disableById("btn-charge");
			});
		}
	});
}

/**
* 清除就诊相关信息
*/
function clearAdmsRela() {
	setValueById("episodeId", "");
	setValueById("admStr", "");
	$(".combobox-f").combobox("clear").combobox("loadData", []);
	if (GV.EditRowIndex) {
		GV.OEItmList.endEdit(GV.EditRowIndex);
  	}
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
}

/**
* 2022-10-17
* ZhYW
* 用于结算后获取尚存在未结算医嘱的费别，将该费别在费别列表中设置为默认
*/
function setToPayInsTypeSelected() {
	var admStr = getValueById("admStr");
	var insTypeId = getSelectedInsType();
	$.m({
		ClassName: "web.DHCOPCashier",
		MethodName: "GetToPayOrdInsTypeIdStr",
		episodeIdStr: admStr,
		type: "ALL",
		sessionStr: getSessionStr()
	}, function(rtn) {
		var myAry = rtn.split("^");
		if ($.inArray(insTypeId, myAry) != -1) {
			//当前选中费别下有未结算医嘱时，按当前费别刷新医嘱和分类
			reloadOrdItmList();
			reloadCateList();
			return;
		}
		GV.InsTypeList.getPanel().find("div.datagrid-body tr").each(function(index) {
			if ($.inArray($(this).find("td[field='insTypeId'] div").text(), myAry) != -1) {
				GV.InsTypeList.selectRow(index);
				return false;
			}
		});
	});
}