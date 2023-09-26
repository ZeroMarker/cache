/**
 * FileName: dhcbill.opbill.charge.patinfo.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

function initPatInfoPanel() {
	initPatInfoMenu();
}

function initPatInfoMenu() {
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
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
	
	//卡类型
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function (data) {
			var cardTypeRowId = getParam("CardTypeRowId");
			if (cardTypeRowId) {
				$.each(data, function(index, item) {
					var id = item.value.split("^")[0];
					if (id == cardTypeRowId) {
						$("#cardType").combobox("select", item.value);
						return false;
					}
				});
			}else {
				var cardType = getValueById($(this)[0].id);
				initReadCard(cardType);
			}
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
	
	//费别列表
	initInsTypeList();
	//就诊列表
	initAdmList();
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
			$("#cardNo").attr("readOnly", true);
			focusById("btn-readCard");
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
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
			setValueById("patientNo", myAry[5]);
			setValueById("accMRowId", myAry[7]);
			getPatInfo();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
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
			if((cardAccountRelation == "CA") || (cardAccountRelation == "CL")){
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "");
			}else {
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, securityNo, "PatInfo");
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("accMLeft", myAry[3]);
				setValueById("patientNo", myAry[5]);
				setValueById("accMRowId", myAry[7]);
				getPatInfo();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			case "-201":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function initInsTypeList() {
	var selectInsTypeRowIdx = undefined;
	GV.InsTypeList = $HUI.datagrid("#insTypeList", {
		fit: true,
		striped: false,
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
			var admStr = getValueById("admStr");
			loadAdmList(admStr);   //费别加载成功之后加载就诊列表，防止因为异步导致加载不了医嘱
			
			selectInsTypeRowIdx = undefined;
			if (data.total == 0) {
				return;
			}
			//设置默认选中行
			var defSelectIndex = 0;
			$.each(data.rows, function (index, row) {
				if (row.selected) {
					defSelectIndex = index;
					return false;
				}
			});
			GV.InsTypeList.selectRow(defSelectIndex);
		},
		onSelect: function(index, row) {
			if (selectInsTypeRowIdx == index) {
				return;
			}
			if (selectInsTypeRowIdx != undefined) {
				reloadOrdItmList();
			}
			selectInsTypeRowIdx = index;
			selectInsTypeListRowHandler(row);
		}
	});
	GV.InsTypeList.getPanel().addClass("lines-no").find(".datagrid-view2 > .datagrid-header").removeClass("datagrid-header");
	GV.InsTypeList.loadData({"rows": [], "total": 0});
}

function reloadOrdItmList() {
	var adm = getValueById("episodeId");
	if (adm) {
		GV.UnBillOrdObj[adm.toString()] = [];
		loadOrdItmList(adm);
	}
}

function selectInsTypeListRowHandler(row) {
	setValueById("admSource", row.admSource);
	//结算费别默认为选中的费别
	if ($("#chargeInsType").length > 0) {
		var myData = $("#chargeInsType").combobox("getData");
		if ($.hisui.indexOfArray(myData, "insTypeId", row.insTypeId) != -1) {
			$("#chargeInsType").combobox("setValue", row.insTypeId);
		}else {
			var item = {insType: row.insType, insTypeId: row.insTypeId, admSource:row.admSource};
			$.hisui.addArrayItem(myData, "insTypeId", item);
			$("#chargeInsType").combobox("loadData", myData).combobox("setValue", row.insTypeId);
		}
	}
	
	loadInsuCombo(row.insTypeId);   //加载医疗类别、病种
	
	var url = $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array" + "&InsType=" + row.insTypeId;
	$("#paymode").combobox("reload", url);
	
	getReceiptNo();   //重新通过费别加载支付方式
}

function initAdmList() {
	var selectAdmListRowIdx = undefined;
	GV.AdmList = $HUI.datagrid("#admList", {
		fit: true,
		striped: false,
		fitColumns: true,
		singleSelect: true,
		bodyCls: 'panel-header-gray',
		loadMsg: null,
		pageSize: 999999999,
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
				   {title: '金额', field: 'admPatSum', align: 'right', width: 80, formatter: formatAmt}
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
				GV.UnBillOrdObj[row.adm.toString()] = [];
				if ((row.admTotalSum > 0) && (defSelectIndex === "")) {
					defSelectIndex = index;
				}
			});
			GV.AdmList.selectRow(defSelectIndex || 0);
		},
		rowStyler:  function(index, row) {
			if (row.hasOrd) {
				return 'color: #FF0000;';
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
	
	GV.AdmList.loadData({"rows": [], "total": 0});
}

function selectAdmListRowHandler(row) {
	refreshBar(getValueById("papmi"), row.adm);
	displayInsTypeColor(row.adm);
	//在更换ADM时要先保存医嘱
	var rtn = saveOrdToServer();
	if (!rtn) {
		return;
	}
	//这两句一定要放到保存医嘱之后
	setValueById("episodeId", row.adm);
	$("#admDoc").combobox("loadData", [{"id": row.admDocDR, "text": row.admDoc}]).combobox("setValue", row.admDocDR);
	
	$("#paymode").combobox("reload");

	lockAdm(true);   //加锁
	
	loadOrdItmList(row.adm);
	
	getAdmLimitOrdStr();
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
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
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				focusById("patientNo");
			}
			var admStr = "";
			setPatientDetail(papmi, admStr);
		});
	}
}

function setPatientDetail(papmi, admStr) {
	lockAdm(false);    //释放前一个就诊锁
	
	setValueById("papmi", papmi);
	if (!papmi) {
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
	
	loadInsTypeList(papmi, admStr);
	
	if ($("#chargeInsType").length > 0) {
		initChargeInsType(papmi);
	}

	//调用平台组接口插入试管信息
	$.m({
		ClassName: "web.DHCOPAdmFind",
		MethodName: "GetOeditemInfoByAdm",
		admStr: admStr
	}, function(rtn) {
		if (+rtn == -1) {
			$.messager.alert("提示", "请手工录入试管费", "info");
		}
	});
}

function setPatientInfo(papmi) {
	//公费单位
	$("#healthCareProvider").combobox("clear");
	$.m({
		ClassName: "web.DHCOPCashier11",
		MethodName: "getContractCorporation",
		PatientID: papmi
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0]) {
			$("#healthCareProvider").combobox("loadData", [{"id": myAry[0], "text": myAry[1]}]).combobox("setValue", myAry[0]);
		}
	});
	
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: expStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		//这里获取患者信息banner
		setValueById("patientNo", myAry[1]);
		var arrearsAmt = myAry[21];
		if (+arrearsAmt) {
			$.messager.alert("提示", "该患者共欠费" + arrearsAmt + "元，请注意收款", "info");
			return;
		}
	});
}

function getToAdmStr(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID;
	return $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetToDayAdmStr", PatDr:papmi, ExpStr: expStr}, false);
}

/**
* 锁定/解锁就诊记录
* admAry:就诊记录数组
* isLock：true:加锁, false:解锁
* 返回值：true:有锁定adm, false:无锁定adm
*/
function lockAdm(isLock) {
	var admStr = getBillAdmStr();
	if (!admStr) {
		return false;
	}
	var lockType = "User.OEOrder";
	if (isLock) {
		var rtn = $.m({ClassName: "web.DHCBillLockAdm", MethodName: "LockAdm", admStr: admStr, lockType: lockType}, false);
		if (rtn != "") {
			rtn = rtn.replace(/\^/g, "\n");
			$.messager.popover({msg: rtn, type: "info"});
			disableById("btn-charge");
			return true;
		}
	} else {
		$.m({ClassName: "web.DHCBillLockAdm", MethodName: "UnLockAdm", admStr: admStr, lockType: lockType}, false);
	}
	if (!GV.DisableChargeBtn) {
		enableById("btn-charge");
	}
	return false;
}

function loadInsTypeList(papmi, admStr) {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: "web.DHCOPCashier",
		QueryName: "FindPatPrescTypeList",
		papmi: papmi,
		episodeIdStr: admStr,
		expStr: expStr,
		rows: 99999999
	}
	loadDataGridStore("insTypeList", queryParams);
}

function loadAdmList(admStr) {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: "web.DHCOPCashier",
		QueryName: "FindAdmDtlList",
		episodeIdStr: admStr,
		expStr: expStr,
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
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetInsTypeOfHaveOrd",
		adm: adm,
		type: "ALL",
		expStr: expStr
	}, function(desc) {
		$.each(GV.InsTypeList.getPanel().find('div.datagrid-body tr'), function(index, row) {
			if (new RegExp($(this).find("td[field='insType'] div").text(), "g").exec(desc) != null) {
				$(this).css({"color": "#FF0000"});
			}
		});
	});
}

/**
* 结算费别
*/
function initChargeInsType(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	$HUI.combobox("#chargeInsType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPCashier&QueryName=FindChargeInsTypeList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'insTypeId',
		textField: 'insType',
		onBeforeLoad: function(param) {
			param.papmi = papmi;
			param.insTypeId = "";
			param.expStr = expStr;
		},
		onSelect: function(rec) {
			setValueById("admSource", rec.admSource);
			loadInsuCombo(rec.insTypeId);
		}
	});
}

function getAdmLimitOrdStr() {
	var admStr = getValueById("admStr");
	$.m({
		ClassName: "web.DHCOPCashier",
		MethodName: "GetSkinRtnFlag",
		AdmStr: admStr,
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
	return (getValueById("billByAdmSelected") == "1") ? getValueById("episodeId") : getValueById("admStr");
}

function clearClick() {
	if ($("#btn-clear").hasClass("l-btn-disabled")) {
		return;
	}
	lockAdm(false); //就诊记录释放锁
	initFeeAll();
}