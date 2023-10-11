/**
 * FileName: dhcbill.ipbill.patordfee.js
 * Author: ZhYW
 * Date: 2018-06-21
 * Description: 医嘱费用查询
 */

$(function () {
	initQueryMenu();
	initOrdItmList();
	initOEItmList();
	initTarItmList();
	
	//将链接过来的就诊号赋给episodeId
	if (GV.EpisodeID) {
		var admType = getPropValById("PA_Adm", GV.EpisodeID, "PAADM_Type");
		if (admType != "I") {
			$.messager.alert("提示", "非住院患者", "info");
			return;
		}
		getPatInfoByAdm(GV.EpisodeID);      //dhcbill.inpatient.banner.csp
	}
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});

	$HUI.linkbutton("#btn-bill", {
		onClick: function () {
			billClick();
		}
	});

	$HUI.linkbutton("#btn-execFind", {
		onClick: function () {
			loadOEItmList();
		}
	});

	$HUI.linkbutton("#btn-depDtl", {
		onClick: function () {
			depDtlClick();
		}
	});

	$HUI.linkbutton("#btn-feeDtl", {
		onClick: function () {
			feeDtlClick();
		}
	});

	$HUI.linkbutton("#btn-checkfee", {
		onClick: function () {
			checkFeeClick();
		}
	});

	$HUI.linkbutton("#btn-preInsuCharge", {
		onClick: function () {
			preInsuChargeClick();
		}
	});

	//清屏
    $HUI.linkbutton("#btn-clean", {
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

	//病案号回车查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	var $tb = $("#more-container");
	var _narrow = function () {
		$tb.find(".arrows-b-text").text($g("更多"));
		if(HISUIStyleCode == "lite") {
			$tb.find(".retract-l-up").removeClass("retract-l-up").addClass("spread-l-down");
		}else{
			$tb.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
		}
		$("tr.display-more-tr").slideUp("fast", setHeight(-120));
	}
	
	var _spread = function () {
		$tb.find(".arrows-b-text").text($g("收起"));
		if(HISUIStyleCode == "lite") {
			$tb.find(".spread-l-down").removeClass("spread-l-down").addClass("retract-l-up");
		}else{
			$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
		}
		$("tr.display-more-tr").slideDown("normal", setHeight(120));
	}
	
	if(HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	}
	
	if ($(window).height() > CV.OuterHeight) {
		if ($tb.find(".arrows-b-text").text() == $g("更多")) {
			_spread();
		}
	}
	
	$tb.click(function () {
		if ($tb.find(".arrows-b-text").text() == $g("更多")) {
			_spread();
		} else {
			_narrow();
		}
	});

	$HUI.combogrid("#episodeId", {
		panelWidth: 400,
		panelHeight: 200,
		fitColumns: true,
		editable: false,
		url: $URL + "?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindAdmList",
		idField: 'adm',
		textField: 'adm',
		mode: 'remote',
		columns: [[{field: 'adm', title: '就诊号', width: 60},
				   {field: 'admDate', title: '入院时间', width: 150,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.admTime;
					}
				   },
				   {field: 'admDept', title: '就诊科室', width: 120}
			]],
		onBeforeLoad: function (param) {
			param.patientId = GV.PatientID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onLoadSuccess: function(data) {
			if ($.hisui.indexOfArray(data.rows, "adm", GV.EpisodeID) == -1) {
				$(this).combogrid("clear");
				return;
			}
			$(this).combogrid("setValue", GV.EpisodeID);
		},
		onSelect: function(index, row) {
			loadOrdItmList();
		}
	});

	//医嘱大类
	$HUI.combobox("#ordCate", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryOrdCate&ResultSetType=array",
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	//医嘱项
	$HUI.combobox("#arcItm", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "BILL.COM.ItemMast";
				param.QueryName = "FindARCItmMast";
				param.ResultSetType = "array";
				var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				param.alias = param.q;
				param.sessionStr = sessionStr;
			}
		}
	});
	
	//接收科室
	$HUI.combobox("#recDept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		multiple: (CV.RecDeptMulti == 1),
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	//开单科室
	$HUI.combobox("#userDept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		multiple: (CV.UserDeptMulti == 1),
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});

	$HUI.combobox("#billStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: $g('全部')},
		       {value: '0', text: $g('未结算')},
		       {value: '1', text: $g('已结算')},
		       {value: '2', text: $g('未计费医嘱')}
		]
	});
	
	//收费项
	$HUI.combobox("#tarItm", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'rowid',
		textField: 'desc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "DHCBILLConfig.DHCBILLFIND";
				param.QueryName = "FindTarItem";
				param.ResultSetType = "array";
				param.alias = param.q;
				param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			}
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
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
		$.messager.alert("提示", "卡无效", "info", function () {
			$("#CardNo").focus();
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

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("medicareNo", "");
		getPatInfo();
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("patientNo", "");
		getPatInfo();
	}
}

function getPatInfo() {
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetPatCurrAdm",
		patientNo: getValueById("patientNo"),
		medicareNo: getValueById("medicareNo"),
		sessionStr: getSessionStr()
	}, function (episodeId) {
		GV.EpisodeID = episodeId;
		GV.PatientID = getPropValById("PA_Adm", episodeId, "PAADM_PAPMI_DR");
		$("#episodeId").combogrid("grid").datagrid("reload");
		getPatInfoByAdm(episodeId);   //dhcbill.inpatient.banner.csp
	});
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [],
		titleNoWrap: false,
		nowrap: false,
		frozenColumns: [[{title: '医嘱名称', field: 'TArcimDesc', width: 220}]],
		className: "web.DHCIPBillPatOrdFee",
		queryName: "FindOrdDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TArcimDesc", "TSttDate", "TAdm", "TArcim"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TSttTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TSttDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TBillQty", "TBillCondition"]) != -1) {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["TPriorty", "TNotBillNum", "TDrugTCQty", "TDocNatStdCode", "TPrescno", "TRecDeptName", "TUserDeptName"]) != -1) {
						cm[i].width = 120;
					}
					if ($.inArray(cm[i].field, ["TSttTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			GV.OrdItmList.autoMergeCells(['TArcimDesc']);    //合并相同列
			GV.OrdItmList.getPanel().find(".datagrid-view1 tr.datagrid-row[datagrid-row-index]").css({"color": "inherit", "background-color": "inherit"}); //让冻结列前景色和背景色从父元素继承
		},
		onSelect: function (index, row) {
			GV.TarItmList.loadData({total: 0, rows: []});  //清空收费项
			loadOEItmList();
		},
		rowStyler: function (index, row) {
			if (row.TNotBillNum > 0) {
				return "font-weight: bold; color: #FF0000";
			}
			if (row.TArcimDesc.endsWith($g("合计"))) {
				return "font-weight: bold";
			}
			if (row.TSeqNo.endsWith("小计")) {
				return "font-weight: bold; background-color: #CCFFFF;";
			}
		}
	});
}

function initOEItmList() {
	GV.OEItmList = $HUI.datagrid("#oeItmList", {
		fit: true,
		title: '医嘱相关执行记录',
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 10,
		toolbar: '#oeItmToolBar',
		className: "web.DHCIPBillPatOrdFee",
		queryName: "FindOrdExecInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TExecDate", "TExecStDate", "TBilled"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBilledDesc") {
					cm[i].styler = function (value, row, index) {
						if (row.TFreeChargeFlag == "Y") {
							return;
						}
						if ((row.TBilled == "TB") || ((row.TBilled == "B") && (row.TBillTotalAmt == 0))) {
							return "font-weight: bold; color: #FF0000";
						}
					}
				}
				if (cm[i].field == "TExecTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExecDate + " " + value;
					}
				}
				if (cm[i].field == "TExecStTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExecStDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TBillQty", "TBillCondition"]) != -1) {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["TDocNatStdCode", "TPrescno", "TRecDeptName", "TUserDeptName"]) != -1) {
						cm[i].width = 120;
					}
					if ($.inArray(cm[i].field, ["TExecTime", "TExecStTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		},
		onSelect: function (index, row) {
			loadTarItmList();
		}
	});
}

function initTarItmList() {
	GV.TarItmList = $HUI.datagrid("#tarItmList", {
		fit: true,
		title: '收费项',
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: true,
		pageSize: 999999999,
		toolbar: [],
		className: "web.DHCIPBillPatOrdFee",
		queryName: "FindTarInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TBillDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBillTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TBillDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TUomDesc"]) != -1) {
						cm[i].width = 50;
					}
					if ($.inArray(cm[i].field, ["TTarItmDesc", "TBillTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		}
	});
}

/**
 * 查询按钮点击事件
 * @method findClick
 * @author ZhYW
 */
function findClick() {
	//清空执行记录
	GV.OEItmList.options().pageNumber = 1;   //跳转到第一页
	GV.OEItmList.loadData({total: 0, rows: []});
	//清空收费项
	GV.TarItmList.loadData({total: 0, rows: []});
	loadOrdItmList();
}

/**
 * 重新加载明细grid
 * @method loadOrdItmList
 * @author ZhYW
 */
function loadOrdItmList() {
	var recDeptId = "";
	if ($("#recDept").combobox("options").multiple) {
		recDeptId = $("#recDept").combobox("getValues").join("^");
	}else {
		recDeptId = $("#recDept").combobox("getValue");
	}
	var userDeptId = "";
	if ($("#userDept").combobox("options").multiple) {
		userDeptId = $("#userDept").combobox("getValues").join("^");
	}else {
		userDeptId = $("#userDept").combobox("getValue");
	}
	var billStatus = getValueById("billStatus");
	var tarItmId = getValueById("tarItm") || "";
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var stTime = getValueById("stTime");
	var endTime = getValueById("endTime");
	var expStr = billStatus + "^" + tarItmId + "^" + stDate + "^" + endDate +
			 	 "^" + stTime + "^" + endTime;

	var queryParams = {
		ClassName: "web.DHCIPBillPatOrdFee",
		QueryName: "FindOrdDetail",
		episodeId: $("#episodeId").combogrid("getValue"),
		itmCateId: getValueById("ordCate") || "",
		arcimId: getValueById("arcItm") || "",
		recDeptId: recDeptId,
		userDeptId: userDeptId,
		sessionStr: getSessionStr(),
		expStr: expStr
	};
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * 加载执行记录grid
 * @method loadOEItmList
 * @author ZhYW
 */
function loadOEItmList() {
	var row = GV.OrdItmList.getSelected();
	var ordItm = (row && row.TOrdItm) ? row.TOrdItm : "";
	var queryParams = {
		ClassName: "web.DHCIPBillPatOrdFee",
		QueryName: "FindOrdExecInfo",
		ordItm: ordItm,
		stDate: getValueById("execStDate"),
		endDate: getValueById("execEndDate")
	};
	loadDataGridStore("oeItmList", queryParams);
}

/**
 * 加载收费项明细grid
 * @method loadTarItmList
 * @author ZhYW
 */
function loadTarItmList() {
	var row = GV.OEItmList.getSelected();
	var pboRowId = (row && row.TPBORowID) ? row.TPBORowID : "";
	var queryParams = {
		ClassName: "web.DHCIPBillPatOrdFee",
		QueryName: "FindTarInfo",
		pboRowId: pboRowId,
		rows: 99999999
	};
	loadDataGridStore("tarItmList", queryParams);
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $("#head-menu");
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

/**
 * 账单
 * @method billClick
 * @author ZhYW
 */
function billClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "就诊号为空", type: "info"});
		return;
	}
	var billed = getPropValById("PA_Adm", episodeId, "PAADM_BillFlag");
	if (billed == "Y") {
		$.messager.popover({msg: "已做财务结算，不能账单", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCIPBillPatOrdFee", MethodName: "GetMotherAdmByBabyAdm", episodeId: episodeId}, false);
	var myAry = rtn.split("^");
	var babyFlag = myAry[0];
	if (babyFlag == "true") {
		$.messager.popover({msg: "此患者为婴儿，不能账单", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", episodeId, PUBLIC_CONSTANT.SESSION.USERID, "", ClientIPAddress);
	var myAry = rtn.split("^");
	if (myAry[0] == 0) {
		$.messager.popover({msg: "账单成功", type: "success"});
		findClick();
		return;
	}
	$.messager.popover({msg: "账单失败：" + (myAry[1] || myAry[0]), type: "error"});
}

/**
 * 押金明细dialog
 * @method depDtlClick
 * @author ZhYW
 */
function depDtlClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "就诊号为空", type: "info"});
		return;
	}
	var depositTypeId = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
	var url = "dhcbill.ipbill.depositlist.csp?EpisodeID=" + episodeId + "&DepositType=" + depositTypeId;
	websys_showModal({
		url: url,
		title: $g('押金明细'),
		iconCls: "icon-w-list"
	});
}

/**
 * 费用明细查询
 * @method feeDtlClick
 * @author ZhYW
 */
function feeDtlClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "就诊号为空", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetValidPBInfo",
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		var num = myAry[0];
		var billId = myAry[1];
		var url = "";
		switch (num) {
		case "1":
			if (!billId) {
				$.messager.popover({msg: "账单号为空", type: "info"});
				break;
			}
			url = "dhcbill.ipbill.billdtl.csp?EpisodeID=" + episodeId + "&BillID=" + billId;
			websys_showModal({
				url: url,
				title: $g('费用明细'),
				iconCls: 'icon-w-list',
				width: '85%'
			});
			break;
		default:
			url = "dhcbill.ipbill.billselect.csp?EpisodeID=" + episodeId;
			websys_showModal({
				url: url,
				title: $g('账单列表'),
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * 医嘱费用核对
 * @method checkFeeClick
 * @author ZhYW
 */
function checkFeeClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "就诊号为空", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetValidPBInfo",
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		var num = myAry[0];
		var billId = myAry[1];
		var url = "";
		switch (num) {
		case "1":
			if (!billId) {
				$.messager.popover({msg: "账单号为空", type: "info"});
				break;
			}
			url = "dhcbill.ipbill.billorder.csp?EpisodeID=" + episodeId + "&BillID=" + billId;
			websys_showModal({
				url: url,
				title: $g('费用核对'),
				iconCls: 'icon-w-stamp',
				width: '90%'
			});
			break;
		default:
			url = "dhcbill.ipbill.billselect.csp?EpisodeID=" + episodeId;
			websys_showModal({
				url: url,
				title: $g('账单列表'),
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * 医保预结算
 * @method preInsuChargeClick
 * @author ZhYW
 */
function preInsuChargeClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "就诊号为空", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetUnPayedPBInfo",
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		var num = myAry[0];
		var billId = myAry[1];
		switch (num) {
		case "0":
			$.messager.popover({msg: "没有未结算的账单，不能预结算", type: "info"});
			break;
		case "1":
			if (!billId) {
				$.messager.popover({msg: "账单号为空", type: "info"});
				break;
			}
			var insTypeId = getPropValById("DHC_PatientBill", billId, "PB_PatInsType_DR");
			var nationalCode = getPropValById("PAC_AdmReason", insTypeId, "REA_NationalCode");
			if (!(nationalCode > 0)) {
				$.messager.popover({msg: "非医保患者，不能医保预结算", type: "info"});
				break;
			}
			InsuIPDividePre(0, PUBLIC_CONSTANT.SESSION.USERID, billId, nationalCode, insTypeId, "");
			break;
		default:
			$.messager.popover({msg: "患者有多个未结算的账单，不能医保预结算", type: "info"});
		}
	});
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	$("#InpatListDiv").data("AutoOpen", 0);
	GV.PatientID = patientId;
	GV.EpisodeID = episodeId;
	$("#episodeId").combogrid("grid").datagrid("reload");
	getPatInfoByAdm(GV.EpisodeID);      //dhcbill.inpatient.banner.csp
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$("#episodeId").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
	setValueById("stDate", "");
	setValueById("endDate","");
	setValueById("execStDate", "");
	setValueById("execEndDate","");
	setValueById("billStatus", "");
	GV.OrdItmList.loadData({total: 0, rows: []});
	GV.OEItmList.loadData({total: 0, rows: []});
	GV.TarItmList.loadData({total: 0, rows: []});
	if (!CV.EpisodeID){
		getPatInfoByAdm();
	}else{
		GV.PatientID=CV.PatientID;
		GV.EpisodeID=CV.EpisodeID;
		getPatInfoByAdm(GV.EpisodeID);
		$("#episodeId").combogrid("grid").datagrid("reload");
	}
}
