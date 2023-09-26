/**
 * FileName: dhcbill.opbill.emergtrans2ip.js
 * Anchor: 
 * Date: 
 * Description: 门急诊转住院
 */

var GV = {
	OrdItmColumns: [{field: 'ck', checkbox: true},
					{title: '医嘱', field: 'arcimDesc', width: 160,
						formatter: function (value, row, index) {
							if (row.cantTransArc) {
								return "<a onmouseover='showCantTransReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
							}else {
								return value;
							}
						}
					},
					{title: '金额', field: 'totalAmt', align: 'right', width: 80},
					{title: '单价', field: 'price', align: 'right', width: 80},
					{title: '数量', field: 'billQty', width: 50},
					{title: '单位', field: 'packUom', width: 60},
					{title: 'execCode', field: 'execCode', hidden: true},
					{title: '执行状态', field: 'execDesc', width: 70,
						styler: function(value, row, index) {
							if (row.execCode == "0") {
								return 'background-color:#ffee00; color:red;';
							}
						}
					},
					{title: 'prescNo', field: 'prescNo', hidden: true},
					{title: '接收科室', field: 'recDept', width: 100},
					{title: '医嘱日期', field: 'ordSttDate', width: 100},
					{title: 'oeitm', field: 'oeitm', hidden: true},
					{title: 'pboRowId', field: 'pboRowId',hidden: true},
					{title: 'adm', field: 'adm', hidden: true},
					{title: 'accPayInvId', field: 'accPayInvId', hidden: true},
					{title: '发票号', field: 'invNo', width: 100},
					{title: '结算时间', field: 'prtDate', width: 150,
						formatter: function (value, row, index) {
							return value + " " + row.prtTime;
						}
					},
					{title: 'prtId', field: 'prtId', hidden: true},
					{title: 'prtFlag', field: 'prtFlag', hidden: true},
					{title: '发票状态', field: 'invFlag', width: 80},
					{title: 'ociId', field: 'ociId', hidden: true},
					{title: 'cantTransArc', field: 'cantTransArc', hidden: true}
			]
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	
	initQueryMenu();
	
	initOrdItmList();
	initOCIItmList();
	
});

function initQueryMenu() {
	focusById("receiptNo");
	
	$HUI.linkbutton("#btn-findRcpts", {
		onClick: function () {
			findRcptsClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});	
	
	$HUI.linkbutton("#btn-trans", {
		onClick: function () {
			transClick();
		}
	});
	
	$HUI.linkbutton("#btn-return", {
		onClick: function () {
			returnClick();
		}
	});
		
	$("#receiptNo").keydown(function (e) {
		receiptNoKeydown(e);
	});
	
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		editable: false,
		method: 'GET',
		idField: 'admId',
		textField: 'admId',
		data: [],
		columns: [[{field: 'admDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
						}
					},
					{field: 'admDept', title: '科室病区', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admWard;
							}
						}
					},
					{field: 'admBed', title: '床号', width: 50},
					{field: 'disDate', title: '出院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.disTime;
							}
						}
					},
					{field: 'admStatus', title: '就诊状态', width: 80},
					{field: 'admReason', title: '就诊费别', width: 80},
					{field: 'admId', title: '就诊ID', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
			if (data.total == 1) {
				setValueById("admList", data.rows[0].admId);
			}
		},
		onSelect: function (index, row) {
			setValueById("admDate", row.admDate);
			setValueById("admReason", row.admReason);
		},
		onChange: function(newValue, oldValue) {
			loadOCIItmList();
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#rcptsDlg").is(":hidden")) {
		return;
	}
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
			setValueById("patientNo", myAry[5]);
			loadInvList();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			loadInvList();
			break;
		default:
		}
	} catch (e) {
	}
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindAdmList",
		papmi: getValueById("papmi"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("admList", queryParams);
}

function findRcptsClick() {
	$("#rcptsDlg").show();
	var dlgObj = $HUI.dialog("#rcptsDlg", {
		title: '收据查询',
		iconCls: 'icon-w-find',
		draggable: false,
		resizable: false,
		cache: false,
		modal: true,
		onBeforeOpen: function() {
			//读卡
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
			
			$HUI.linkbutton("#btn-ok", {
				onClick: function () {
					var rows = GV.InvList.getChecked();
					if (rows.length == 0) {
						$.messager.popover({msg: "请选择需要转入的发票记录", type: "info"});
						return;
					}
					getPatInfo();
					var invAry = [];
					$.each(GV.InvList.getChecked(), function (index, row) {
						var tmpStr = row.invRowId + ":" + row.invType;
						invAry.push(tmpStr);
					});
					var invStr = invAry.join("^");
					loadOrdItmList(invStr);
					dlgObj.close();
				}
			});
			
			//卡号回车查询事件
			$("#cardNo").keydown(function (e) {
				cardNoKeydown(e);
			});
			
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
			initInvList();
		},
		onClose: function() {
			$("#rcptsDlg").form("clear");
			GV.InvList.options().url = null;
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
		readHFMagCardClick();
		break;
	case 119: //F8
		findClick();
		break;
	default:
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
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				loadInvList();
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
				loadInvList();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	var invAry = [];
	$.each(GV.InvList.getChecked(), function (index, row) {
		var tmpStr = row.invRowId + ":" + row.invFlag;
		invAry.push(tmpStr);
	});
	var invStr = invAry.join("^");
	return invStr;
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

function findClick() {
	if ($("#rcptsDlg").is(":hidden")) {
		return;
	}
	var patientNo = getValueById("patientNo");
	var cardNo = getValueById("cardNo");
	if (!patientNo && !cardNo) {
		$.messager.popover({msg: "请先输入登记号或刷卡查询患者", type: "info"});
		return;
	}
	setValueById("receiptNo", "");
	
	loadInvList();
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		striped: true,
		border: false,
		fitColumns: true,
		data: [],
		rownumbers: true,
		pageSize: 9999999,
		columns: [[{title:'ck', field: 'ck', checkbox: true},
				   {title: 'papmi', field: 'papmi', hidden: true},
				   {title: '登记号', field: 'patNo', width: 120},
				   {title: '患者姓名', field: 'patName', width: 90},
				   {title: 'invRowId', field: 'invRowId', hidden: true},
				   {title: '发票号', field: 'invNo', width: 120},
				   {title: '费用总额', field: 'totalAmt', align: 'right', width: 90},
				   {title: '自付金额', field: 'patShareAmt', align: 'right', width: 90},
				   {title: '收费员', field: 'userName', width: 70},
				   {title: '收费时间', field: 'invDate', width: 155,
					formatter: function(value, row, index) {
						if (value) {
							return value + " " + row.invTime;
						}
					}
				   },
				   {title: 'invType', field: 'invType', hidden: true}
			]]
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindOPBillINV",
		stDate: getValueById("stDate"),
		endDate:  getValueById("endDate"),
		receiptNo: getValueById("receiptNo"),
		patientNo: getValueById("patientNo"),
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("invList", queryParams);
}

function receiptNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		$.cm({
			ClassName: "web.DHCOPBillEmergTrans2IP",
			MethodName: "GetRecepitInfo",
			recepitNo: $(e.target).val(),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (jsonObj) {
			setPatInfo(jsonObj);
			if (jsonObj.success == "0") {
				var invStr = jsonObj.invRowId + ":" + jsonObj.invType;
				loadOrdItmList(invStr);
			}else {
				GV.OrdItmList.loadData({total: 0, rows: []});
				GV.OCIItmList.loadData({total: 0, rows: []});
			}
		});
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("patientNo", "");
		getPatInfo();
	}
}

function getPatInfo() {
	$.cm({
		ClassName: "web.DHCOPBillEmergTrans2IP",
		MethodName: "GetPatInfo",
		patientNo: getValueById("patientNo"),
		medicareNo: getValueById("medicareNo"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(jsonObj) {
		setPatInfo(jsonObj);
	});
}

function setPatInfo(json) {
	var papmi = "";
	var medicareNo = "";
	var patName = "";
	var sex = "";
	var age = "";
	var admDate = "";
	var admReason = "";
	if (json.success == "0") {
		papmi = json.papmi;
		medicareNo = json.medicareNo;
		patName = json.patName;
		sex = json.sex;
		age = json.age;
	}else {
		$.messager.popover({msg: json.msg, type: "info"});
	}
	setValueById("papmi", papmi);
	setValueById("medicareNo", medicareNo);
	setValueById("patName", patName);
	setValueById("sex", sex);
	setValueById("age", age);
	setValueById("admDate", admDate);
	setValueById("admReason", admReason);
	
	GV.OCIItmList.loadData({total: 0, rows: []});
	loadAdmList();
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		pageSize: 999999999,
		data: [],
		columns: [GV.OrdItmColumns],
		onLoadSuccess: function(data) {
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				var disableRow = false;
				if ((row.prtFlag != "N") || (row.execCode == "0")) {
					disableRow = true;
					hasDisabledRow = true;
				}
				$("#ordItmList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = disableRow;			
			});
			$("#ordItmList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		rowStyler:  function(index, row) {
			if (row.prtFlag != "N") {
				return 'color: #FF0000;';
			}
		},
		onCheck: function(index, row) {
			enableById("btn-trans");
		},
		onCheckAll: function(rows) {
			if (rows.length > 0) {
				enableById("btn-trans");
			}
		},
		onUncheckAll: function(rows) {
			disableById("btn-trans");
		}
	});
}

function loadOrdItmList(invStr) {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindOrdItm",
		invStr: invStr,
		rows: 999999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

function showCantTransReason(that, row) {
	$(that).popover({
		title: '不可转入住院原因',
		trigger: 'hover',
		content: "医嘱子类：<font style='color:red'>" + row.cantTransArc + "</font> " + "配置不可转入住院"
	}).popover("show");
}

function initOCIItmList() {
	GV.OCIItmList = $HUI.datagrid("#ociItmList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		pageSize: 999999999,
		data: [],
		columns: [GV.OrdItmColumns],
		onLoadSuccess: function(data) {
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.prtFlag != "N") {
					hasDisabledRow = true;
				}
				$("#ociItmList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = (row.prtFlag != "N");
			});
			$("#ociItmList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		rowStyler:  function(index, row) {
			if (row.prtFlag != "N") {
				return 'color: #FF0000;';
			}
		},
		onCheck: function(index, row) {
			enableById("btn-return");
		},
		onCheckAll: function(rows) {
			if (rows.length > 0) {
				enableById("btn-return");
			}
		},
		onUncheckAll: function(rows) {
			disableById("btn-return");
		}
	});
}

/**
* 转入
*/
function transClick() {
	if ($("#btn-trans").hasClass("l-btn-disabled")) {
		return;
	}
	var papmi = getValueById("papmi");
	if (!papmi) {
		$.messager.popover({msg: "住院患者不存在", type: "info"});
		return;
	}
	var episodeId = getValueById("admList");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者住院就诊", type: "info"});
		return;
	}
	var confirmFlag = $.m({ClassName: "web.UDHCJFBillDetailOrder", MethodName: "GetCodingFlagByAdm", Adm: episodeId}, false);
	if (confirmFlag == "Y") {
		$.messager.popover({msg: "住院就诊已经做财务审核，请先撤销审核后再转入", type: "info"});
		return;
	}
	var rows = GV.OrdItmList.getChecked();
	if (rows.length == 0) {
		$.messager.popover({msg: "请选择需要转入的医嘱明细", type: "info"});
		return;
	}
	
	var ordItmAry = [];
	$.each(rows, function (index, row) {
		var tmpStr = row.oeitm + "^" + row.prtId + "^" + row.accPayInvId;
		ordItmAry.push(tmpStr);
	});
	var ordItmInfo = ordItmAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		
	$.messager.confirm("确认", "是否确认转入住院?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCOPBillEmergTrans2IP",
				MethodName: "EmergTrans2IP",
				ordItmInfo: ordItmInfo,
				inEpisodeId: episodeId,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.alert("提示", "转入成功，请注意给患者退门诊费用", "success");
					$.each(rows, function (index, row) {
						var rowIndex = GV.OrdItmList.getRowIndex(row);
						GV.OrdItmList.deleteRow(rowIndex);
					});
					GV.OCIItmList.load();
				}else {
					$.messager.popover({msg: "转入失败：" + myAry[1], type: "error"});
				}
			});
		}
	});
}

/**
* 撤回
*/
function returnClick() {
	if ($("#btn-return").hasClass("l-btn-disabled")) {
		return;
	}
	var rows = GV.OCIItmList.getChecked();
	if (rows.length == 0) {
		$.messager.popover({msg: "请选择需要撤回的医嘱明细", type: "info"});
		return;
	}
	
	var ociIdAry = [];
	$.each(rows, function (index, row) {
		ociIdAry.push(row.ociId);
	});
	var ociIdStr = ociIdAry.join("^");	
	$.messager.confirm("确认", "是否确认撤回?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCOPBillEmergTrans2IP",
				MethodName: "IPTrans2Emerg",
				ociIdStr: ociIdStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.popover({msg: "撤回成功", type: "success"});
					$.each(rows, function (index, row) {
						GV.OrdItmList.appendRow(row);
					});
					GV.OCIItmList.load();
				}else {
					$.messager.popover({msg: "撤回失败：" + myAry[1], type: "error"});
				}
			});
		}
	});
}

function loadOCIItmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindOCIList",
		episodeId: getValueById("admList"),
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("ociItmList", queryParams);
}

function clearClick() {
	$(".datagrid-f").datagrid("loadData", {
		total: 0,
		rows: []
  	});
  	setValueById("papmi", "");
  	$(":text:not(.pagination-num)").val("");
  	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
  	});
}