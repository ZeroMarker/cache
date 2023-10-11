/**
 * FileName: dhcbill.opbill.emergtrans2ip.js
 * Author: ZhYW
 * Date: 2019-07-16
 * Description: 门急诊转住院
 */

var GV = {
	ReBillFlag: 0,
	FrozenColumns: [{field: 'ck', checkbox: true},
					{title: '医嘱', field: 'arcimDesc', width: 160,
						formatter: function (value, row, index) {
							if (row.cantTransArc) {
								return "<a onmouseover='showCantTransReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
							}
							return value;
						}
					}
		],
	Columns: [{title: '金额', field: 'totalAmt', align: 'right', width: 80},
			  {title: '自付金额', field: 'patShareAmt', hidden: true},
			  {title: '单价', field: 'price', align: 'right', width: 80},
			  {title: '数量', field: 'billQty', width: 50},
		      {title: '基本单位', field: 'baseUom', width: 70},
		      {title: 'execCode', field: 'execCode', hidden: true},
			  {title: '执行状态', field: 'execDesc', width: 70,
				styler: function(value, row, index) {
					if (row.execCode == 0) {
						return 'background-color:#ffee00; color:red;';
					}
				}
			  },
			  {title: 'prescNo', field: 'prescNo', hidden: true},
			  {title: '接收科室', field: 'recDept', width: 100},
			  {title: '医嘱时间', field: 'ordSttTime', width: 150,
				formatter: function (value, row, index) {
					return row.ordSttDate + " " + value;
				}
			  },
			  {title: 'pboRowId', field: 'pboRowId',hidden: true},
			  {title: 'adm', field: 'adm', hidden: true},
			  {title: 'accPayInvId', field: 'accPayInvId', hidden: true},
			  {title: '发票号', field: 'invNo', width: 100},
			  {title: '结算时间', field: 'prtTime', width: 150,
				formatter: function (value, row, index) {
					return row.prtDate + " " + value;
				}
			  },
			  {title: 'prtId', field: 'prtId', hidden: true},
			  {title: 'prtFlag', field: 'prtFlag', hidden: true},
			  {title: '发票状态', field: 'invFlag', width: 80},
			  {title: '医嘱ID', field: 'oeitm', width: 80},
			  {title: 'ociId', field: 'ociId', hidden: true},
			  {title: 'cantTransArc', field: 'cantTransArc', hidden: true}
		]
};

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	
	initQueryMenu();
	
	initOrdItmList();
	initOCIItmList();
	initInvList();
});

function initQueryMenu() {	
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
		
	$("#receiptNo").focus().keydown(function (e) {
		receiptNoKeydown(e);
	});
	
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		editable: false,
		method: 'GET',
		idField: 'admId',
		textField: 'admId',
		columns: [[{field: 'admDate', title: '入院时间', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
						}
					},
					{field: 'admDept', title: '科室病区', width: 180,
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
			setValueById("admTime", (row.admDate + " " + row.admTime));
			setValueById("admReason", row.admReason);
		},
		onChange: function(newValue, oldValue) {
			loadOCIItmList();
		}
	});
	
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
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});
	
	$("#wPatientNo").keydown(function (e) {
		wPatientNoKeydown(e);
	});
	//病案号
	$("#wMedicareNo").keydown(function (e) {
		wMedicareNoKeydown(e);
	});
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindAdmList",
		patientId: getValueById("patientId"),
		sessionStr: getSessionStr()
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
		buttons: [{
					text: '确认',
					iconCls: 'icon-w-ok',
					handler: function () {
						var invStr = getCheckedInvStr();
						if (invStr == "") {
							$.messager.popover({msg: "请选择需要转入的发票记录", type: "info"});
							return;
						}
						loadOrdItmList(invStr);
						
						getPatInfo(getValueById("wPatientNo"));
						dlgObj.close();
					}
				}
			],
		onClose: function() {
			$("#rcptsDlg").form("clear");
			GV.InvList.loadData({total: 0, rows: []});
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
	case 119: //F8
		e.preventDefault();
		findClick();
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
	if ($("#rcptsDlg").is(":hidden")) {
		return;
	}
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
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
		setValueById("wPatientNo", myAry[5]);
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
		setValueById("wPatientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	if (patientId != "") {
		loadInvList();
	}
}

function wPatientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			wGetPatInfo(patientNo);
		});
	}
}

function wMedicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("wPatientNo", "");
		wGetPatInfo("");
	}
}
function wGetPatInfo(patientNo) {
	$.cm({
		ClassName: "web.DHCOPBillEmergTrans2IP",
		MethodName: "GetPatInfo",
		patientNo: patientNo,
		medicareNo: getValueById("wMedicareNo"),
		sessionStr: getSessionStr()
	}, function(json) {
		wSetPatInfo(json);
	});
}

function wSetPatInfo(json) {
	var wMedicareNo = "";
	var wPatientNo = "";
	if (json.success == 0) {
		wPatientNo = json.patientNo;
		wMedicareNo = json.medicareNo;
	}else {
		$.messager.popover({msg: json.msg, type: "info"});
	}
	setValueById("wMedicareNo", wMedicareNo);
	setValueById("wPatientNo", wPatientNo);
	
	loadInvList();
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	var invAry = [];
	$.each(GV.InvList.getChecked(), function (index, row) {
		var tmpStr = row.invRowId + ":" + row.invType;
		invAry.push(tmpStr);
	});
	var invStr = invAry.join("^");
	return invStr;
}

function findClick() {
	if ($("#rcptsDlg").is(":hidden")) {
		return;
	}
	var patientNo = getValueById("wPatientNo");
	var cardNo = getValueById("CardNo");
	var wMedicareNo = getValueById("wMedicareNo");
	if (!patientNo && !cardNo&& !wMedicareNo) {
		$.messager.popover({msg: "请先输入登记号/病案号或刷卡查询患者", type: "info"});
		return;
	}
	if (!patientNo && !cardNo&& wMedicareNo) {
		setValueById("wPatientNo", "");
		wGetPatInfo("");
		return;
	}
	loadInvList();
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		fitColumns: true,
		rownumbers: true,
		pageSize: 9999999,
		className: "web.DHCOPBillEmergTrans2IP",
		queryName: "FindOPBillINV",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["invDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["select", "papmi", "invRowId", "prtRowId", "invType", "cant2Msg"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "userName") {
					cm[i].title = "收费员";
				}
				if (cm[i].field == "invTime") {
					cm[i].formatter = function(value, row, index) {
						return row.invDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "invTime") {
						cm[i].width = 160;
					}
				}
			}
		},
		rowStyler: function(index, row) {
			if (row.select == 0) {
				return 'color: #A9A9A9;';
			}
		},
		onLoadSuccess: function (data) {
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.select == 0) {
					hasDisabledRow = true;
					GV.InvList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "]>td>div:not(.datagrid-cell-rownumber,.datagrid-cell-check)").mouseover(function() {
						$(this).popover({
							title: $g('不能转入住院原因'),
							trigger: 'hover',
							content: row.cant2Msg
						}).popover("show");
					});
					GV.InvList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true; //退费票据不能被选中
				}
			});
			//有disabled行时,表头也disabled
			GV.InvList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onCheck: function(index, row) {
			if (row.select == 0) {
				GV.InvList.uncheckRow(index);
			}
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (row.select == 0) {
					GV.InvList.uncheckRow(index);
				}
			});
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindOPBillINV",
		stDate: getValueById("stDate"),
		endDate:  getValueById("endDate"),
		patientNo: getValueById("wPatientNo"),
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
			sessionStr: getSessionStr()
		}, function (data) {
			setPatInfo(data);
			if (data.success == 0) {
				var invStr = data.invRowId + ":" + data.invType;
				loadOrdItmList(invStr);
				return;
			}
			GV.OrdItmList.loadData({total: 0, rows: []});
			GV.OCIItmList.loadData({total: 0, rows: []});
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
		getPatInfo("");
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		setValueById("medicareNo", "");
		getPatInfo($(e.target).val());
	}
}

function getPatInfo(patientNo) {
	$.cm({
		ClassName: "web.DHCOPBillEmergTrans2IP",
		MethodName: "GetPatInfo",
		patientNo: patientNo,
		medicareNo: getValueById("medicareNo"),
		sessionStr: getSessionStr()
	}, function(json) {
		setPatInfo(json);
	});
}

function setPatInfo(json) {
	var patientId = "";
	var medicareNo = "";
	var patientNo = "";
	var patName = "";
	var sex = "";
	var age = "";
	var admTime = "";
	var admReason = "";
	if (json.success == 0) {
		patientId = json.patientId;
		patientNo = json.patientNo;
		medicareNo = json.medicareNo;
		patName = json.patName;
		sex = json.sex;
		age = json.age;
	}else {
		$.messager.popover({msg: json.msg, type: "info"});
	}
	setValueById("patientId", patientId);
	setValueById("medicareNo", medicareNo);
	setValueById("patientNo", patientNo);
	setValueById("patName", patName);
	setValueById("sex", sex);
	setValueById("age", age);
	setValueById("admTime", admTime);
	setValueById("admReason", admReason);
	
	loadAdmList();
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		border: false,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		pageSize: 999999999,
		frozenColumns: [GV.FrozenColumns],
		columns: [GV.Columns],
		onLoadSuccess: function(data) {
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				var disableRow = false;
				if ((row.prtFlag != "N") || (row.execCode == 0)) {
					disableRow = true;
					hasDisabledRow = true;
				}
				GV.OrdItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = disableRow;			
			});
			GV.OrdItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		rowStyler: function(index, row) {
			if (row.prtFlag != "N") {
				return 'color: #FF0000;';
			}
			if (row.execCode == 0) {
				return 'color: #A9A9A9;';
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

function showCantTransReason($this, row) {
	$($this).popover({
		title: $g('不可转入住院原因'),
		trigger: 'hover',
		content: "医嘱子类：<font style='color:red'>" + row.cantTransArc + "</font> " + $g("配置不可转入住院")
	}).popover("show");
}

function initOCIItmList() {
	GV.OCIItmList = $HUI.datagrid("#ociItmList", {
		fit: true,
		border: false,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		pageSize: 999999999,
		frozenColumns: [GV.FrozenColumns],
		columns: [GV.Columns],
		onLoadSuccess: function(data) {
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.prtFlag != "N") {
					hasDisabledRow = true;
				}
				GV.OCIItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = (row.prtFlag != "N");
			});
			GV.OCIItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
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
	var _validate = function() {
		return new Promise(function(resolve, reject){
			var patientId = getValueById("patientId");
			if (!patientId) {
				$.messager.popover({msg: "住院患者不存在", type: "info"});
				return reject();
			}
			episodeId = getValueById("admList");
			if (!episodeId) {
				$.messager.popover({msg: "请选择患者住院就诊", type: "info"});
				return reject();
			}
			var confirmFlag = $.m({ClassName: "web.UDHCJFBillDetailOrder", MethodName: "GetCodingFlagByAdm", Adm: episodeId}, false);
			if (confirmFlag == "Y") {
				$.messager.popover({msg: "住院就诊已经做财务审核，请先撤销审核后再转入", type: "info"});
				return reject();
			}
			if ((CV.IsNeedRefOPInv == 1) && (!(CV.RefundMode > 0))) {
				$.messager.popover({msg: ($g("请先在支付方式字典中维护支付方式：") + "<font color=\"red\">" + "急诊转入" + "</font>"), type: "info"});
				return reject();
			}
			if (rows.length == 0) {
				$.messager.popover({msg: "请选择需要转入的医嘱明细", type: "info"});
				return reject();
			}
			
			var invJsonObj = {};
			var bool = true;
			var tmpStr = "";
			var invVal = "";
			$.each(rows, function (index, row) {
				if (row.accPayInvId) {
					invJsonObj = getPersistClsObj("User.DHCAccPayINV", row.accPayInvId);
					if (invJsonObj.APIFlag != "N") {
						bool = false;
						return false;
					}
					invVal = row.accPayInvId + ":" + "API";
				}else {
					invJsonObj = getPersistClsObj("User.DHCINVPRT", row.prtId);
					if (invJsonObj.PRTFlag != "N") {
						bool = false;
						return false;
					}
					invVal = row.prtId + ":" + "PRT";
				}
				//将发票记录push到数组
				if ($.inArray(invVal,invIdAry) == -1) {
					invIdAry.push(invVal);
				}
				tmpStr = row.oeitm + "^" + row.prtId + "^" + row.accPayInvId;
				ordItmAry.push(tmpStr);
			});
			if (!bool) {
				$.messager.popover({msg: "该发票已退费，费用不能转入住院", type: "info"});
				return reject();
			}
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function(resolve, reject) {
			var msg = "是否确认转入住院？";
			if (CV.IsNeedRefOPInv == 1) {
				msg = "转入住院后将不能撤回，是否确认转入？";
			}
			$.messager.confirm("确认", $g(msg), function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _trans = function() {
		return new Promise(function(resolve, reject) {
			var ordItmInfo = ordItmAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			$.m({
				ClassName: "web.DHCOPBillEmergTrans2IP",
				MethodName: "EmergTrans2IP",
				ordItmInfo: ordItmInfo,
				inEpisodeId: episodeId,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					return resolve();
				}
				$.messager.alert("提示", "转入失败：" + (myAry[1] || myAry[0]), "error");
				reject();
			});
		});
	};
	
	/**
	* 门诊退费+充住院押金
	*/
	var _refOPInvAmtToIPDep = function() {
		return new Promise(function(resolve, reject) {
			var _tfn = function() {
				if (CV.IsNeedRefOPInv != 1) {
					return resolve();
				}
				if (invIdAry.length == 0) {
					return resolve();
				}
				var currValue = invIdAry.shift();  //删除第一项，获取数组第一项的值
				invRefund(currValue).then(function () {
					transRefAmt2IPDep(currValue).then(function () {
				        _tfn();    //递归
				    }, function () {
						_delOrdItmList();
					    $.messager.alert("提示", "转入成功，但充住院押金失败", "error");
				        reject();
				    });
				}, function() {
					_delOrdItmList();
					$.messager.alert("提示", "转入成功，但退门诊费用失败", "error");
			        reject();
			    });
			};
			
			_tfn();
		});
	};
	
	var _delOrdItmList = function() {
		return new Promise(function(resolve, reject) {
			$.each(rows, function (index, row) {
				var rowIndex = GV.OrdItmList.getRowIndex(row);
				GV.OrdItmList.deleteRow(rowIndex);
			});
			GV.OCIItmList.load();
			return resolve();
		});
	};
	
	var _success = function() {
		var msg = "转入成功";
		if (CV.IsNeedRefOPInv != 1) {
			msg += "，请注意给患者退门诊费用";
		}else {
			$("#receiptNo").val().focus();
			GV.OrdItmList.loadData({total: 0, rows: []});
		}
		$.messager.alert("提示", msg, "success");
	};

	if ($("#btn-trans").linkbutton("options").disabled) {
		return;
	}
	$("#btn-trans").linkbutton("disable");
	
	var episodeId = "";
	var ordItmAry = [];
	var invIdAry = [];
	var rows = GV.OrdItmList.getChecked();
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_trans)
		.then(_refOPInvAmtToIPDep)
		.then(_delOrdItmList)
		.then(function() {
			_success();
			$("#btn-trans").linkbutton("enable");
		}, function() {
			$("#btn-trans").linkbutton("enable");
		});
}

/**
* 撤回
*/
function returnClick() {
	var _validate = function() {
		return new Promise(function(resolve, reject){
			if (rows.length == 0) {
				$.messager.popover({msg: "请选择需要撤回的医嘱明细", type: "info"});
				return reject();
			}
			var ociIdAry = [];
			$.each(rows, function (index, row) {
				ociIdAry.push(row.ociId);
			});
			ociIdStr = ociIdAry.join("^");
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function(resolve, reject){
			$.messager.confirm("确认", "是否确认撤回?", function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _return = function() {
		return new Promise(function(resolve, reject) {
			$.m({
				ClassName: "web.DHCOPBillEmergTrans2IP",
				MethodName: "IPTrans2Emerg",
				ociIdStr: ociIdStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					return resolve();
				}
				$.messager.popover({msg: "撤回失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};

	var _success = function() {
		$.messager.popover({msg: "撤回成功", type: "success"});
		$.each(rows, function (index, row) {
			GV.OrdItmList.appendRow(row);
		});
		GV.OCIItmList.load();
	};

	if ($("#btn-return").linkbutton("options").disabled) {
		return;
	}
	$("#btn-return").linkbutton("disable");

	var rows = GV.OCIItmList.getChecked();
	var ociIdStr = "";

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_return)
		.then(function() {
			_success();
			$("#btn-return").linkbutton("enable");
		}, function() {
			$("#btn-return").linkbutton("enable");
		});
}

function loadOCIItmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEmergTrans2IP",
		QueryName: "FindOCIList",
		episodeId: $("#admList").combogrid("getValue"),
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("ociItmList", queryParams);
}

function clearClick() {
	focusById("receiptNo");
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
  	setValueById("patientId", "");
  	$(":text:not(.pagination-num)").val("");
  	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
  	});
}

function invRefund(invStr) {
	return new Promise(function (resolve, reject) {
		var myAry = invStr.split(":");
		var invId = myAry[0];
		var invFlag = myAry[1];
		if (invFlag == "API") {
			return accInvRefSaveInfo(invId).then(function() {
		        resolve();
		    }, function() {
		        reject();
		    });
		}
		return invRefSaveInfo(invId).then(function() {
	        resolve();
	    }, function() {
	        reject();
	    });
	});
}

/**
* 普通发票退费
*/
function invRefSaveInfo(prtRowId) {
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.alert("提示", "配置不连接医保，请检查门诊系统参数配置", "info", function() {
					 reject();
				});
				return;
			}
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
			var leftAmt = "";
			var moneyType = "";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
			myExpStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, myExpStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.alert("提示", ("医保退费失败，错误代码：" + rtn), "info", function() {
					 reject();
				});
				return;
			}
			var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: prtRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
			var myAry = insuInfo.split("!");
			if (myAry[0] != "Y") {
				$.messager.alert("提示", ("医保退费失败，请稍后重退" + myAry[0]), "info", function() {
					 reject();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* HIS退费
	*/
	var _refund = function () {
		return new Promise(function (resolve, reject) {
			var sFlag = (!invJsonObj.PRTDHCINVPRTRDR && (invJsonObj.PRTUsr == PUBLIC_CONSTANT.SESSION.USERID)) ? "A" : "S";
			var expStr = "N" + "^" + invRequireFlag + "^^^" + accPInvId;
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "RefundReceipt",
				INVPRTRowid: prtRowId,
				rUser: PUBLIC_CONSTANT.SESSION.USERID,
				sFlag: sFlag,
				StopOrdStr: stopOrdStr,
				NInvPay: patPayAmt,
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				RebillFlag: rebillFlag,
				ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
				RPayModeDR: CV.RefundMode,
				NewInsType: "",
				myExpStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					chargeErrorTip("refundError", rtn);
					return reject();
				}
				newPrtRowId = myAry[1] || "";    //新票RowId
				strikeRowId = myAry[2] || "";    //负票RowId
				refInvFlag = myAry[3] || "N";
				return resolve();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.alert("提示", "配置不连接医保，请检查门诊系统参数配置", "warning", function() {
					reject();
				});
				return;
			}
			if (!(insuDivId > 0)) {
				return resolve();
			}
			//ShangXuehao 2020-11-26 如果自付费用为0并且费用为0不调医保返回false
			var zeroAmtUseYB = ((patPayAmt > 0) || (CV.ZeroAmtUseYBFlag == 1));
			if (!zeroAmtUseYB) {
				return resolve();
			}
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
			var DBConStr = "";         //数据库连接串
			var moneyType = "";
			var selPaymId = "";
			var accMRowId = "";
			var leftAmt = "";
			if (refModeCode != "CPP") {
				myCPPFlag = "NotCPPFlag";
			}else {
				leftAmt = getAccMLeft();
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, admSource, insTypeId, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				var msg = "医保" + ((myAry[0] == "YBCancle") ? "取消结算" : "结算失败") + "，HIS将按自费完成收费";
				$.messager.alert("提示", msg, "warning", function() {
					return resolve();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* 确认完成
	*/
	var _complete = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();    //没用新发票记录时按成功返回
			}
			//2020-06-02 Lid 获取新发票支付方式列表
			var myPayInfo = "";
			if (newPrtRowId > 0) {
				myPayInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: prtRowId, strikeRowId: strikeRowId, prtRowId: newPrtRowId, refundPayMode: CV.RefundMode}, false);
			}
			//调用确认完成方法
			var newInsType = "";
			var accMRowId = "";
			var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
			myExpStr += "^" + invRequireFlag + "^" + "" + "^" + "" + "^" + "" + "^" + "";
			myExpStr += "^" + newInsType;
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: insTypeId,
				PrtRowIDStr: newPrtRowId,
				SFlag: 1,
				OldPrtInvDR: prtRowId,
				ExpStr: myExpStr,
				PayInfo: myPayInfo
			}, false);
			if (rtn != 0) {
				chargeErrorTip("completeError", rtn);
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* 确认完成成功
	*/
	var _success = function() {
		return new Promise(function (resolve, reject) {
			if (refInvFlag == "Y") {
				billPrintTask(strikeRowId);
			}
			billPrintTask(newPrtRowId);
			return resolve();
		});
	};
	
	var invJsonObj = getPersistClsObj("User.DHCINVPRT", prtRowId);
	if (invJsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能退费", type: "info"});
		return false;
	}
	var invRequireFlag = (invJsonObj.PRTINVPrintFlag == "P") ? "Y" : "N";
	var patShareAmt = invJsonObj.PRTPatientShare;
	var insTypeId = invJsonObj.PRTInsTypeDR;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var insuDivId = invJsonObj.PRTInsDivDR;
	var accPInvId = invJsonObj.PRTACCPINVDR;
	
	var refundOrdStr = getRefOrderStr(prtRowId + ":" + "PRT");
	var invOrderAry = refundOrdStr.split(PUBLIC_CONSTANT.SEPARATOR.CH3);
	var stopOrdStr = invOrderAry[1];
	var rebillFlag = invOrderAry[2];
	var refundAmt = invOrderAry[3];
	
	var patPayAmt = Number(patShareAmt).sub(refundAmt).toFixed(2);  //重收金额
	
	var pmJsonObj = getPersistClsObj("User.CTPayMode", CV.RefundMode);
	var refModeCode = pmJsonObj.CTPMCode;
	
	var newPrtRowId = "";
	var strikeRowId = "";    //负票RowId
	var refInvFlag = "";
	
	var promise = Promise.resolve();
	return promise
		.then(_insuPark)
		.then(_refund)
		.then(_insuDiv)
		.then(_complete)
		.then(_success);
}

/**
* 卡支付发票退费
*/
function accInvRefSaveInfo(prtRowId) {
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.AccPINVYBConFlag != 1) {
				$.messager.alert("提示", "配置不连接医保，请检查门诊系统参数配置", "warning", function() {
					 reject();
				});
				return;
			}
			var myYBHand = "0";
			var myExpStr = "^^^^";
			var CPPFlag = "Y";
			var rtn = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, admSource, insTypeId, myExpStr, CPPFlag);
			if (rtn != 0) {
				$.messager.alert("提示", ("医保退费失败，错误代码：" + rtn), "error", function() {
					 reject();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* HIS退费
	*/
	var _refund = function () {
		return new Promise(function (resolve, reject) {
			var autoFlag = invJsonObj.APIAutoYBFlag;
			var sFlag = (!invJsonObj.APIINVRepDR && (invJsonObj.APIPUserDR == PUBLIC_CONSTANT.SESSION.USERID)) ? "A" : "S";
			var myExpStr = "^^^^^" + autoFlag + "^" + "";
			var rtn = $.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "AccPayINVRefund",
				APIRowID: prtRowId,
				PRTOrdStr: refundOrdStr,
				rUser: PUBLIC_CONSTANT.SESSION.USERID,
				sFlag: sFlag,
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
				RPayModeDR: CV.RefundMode,
				RefPaySum: "",
				RebillFlag: GV.ReBillFlag,
				ExpStr: myExpStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.alert("提示", ("退费失败：" + (myAry[1] || myAry[0])), "error", function() {
						reject();
					});
					return;
				}
				newPrtRowId = myAry[1];
				pid = myAry[2];				
				return resolve();
			});
		});
	};
		
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(pid > 0)) {
				return resolve();
			}
			if (CV.AccPINVYBConFlag != 1) {   //配置了不连接医保
				return resolve();
			}
			if (!(insuDivId > 0)) {
				return resolve();
			}
			//ShangXuehao 2020-11-26 如果自付费用为0并且费用为0不调医保返回false
			var zeroAmtUseYB = ((patPayAmt > 0) || (CV.ZeroAmtUseYBFlag == 1));
			if (!zeroAmtUseYB) {
				return resolve();
			}
			var myYBHand = "0";
			var myCPPFlag = "Y";
			var strikeFlag = "N";
			var insuNo = "";
			var cardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";        //数据库连接串
			var leftAmt = "";
			var moneyType = "";
			var selPaymId = "";
			var insType = "";
			var admSource = "";
			var accMRowId = "";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = InsuOPDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, pid, admSource, insType, myExpStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.alert("提示", "医保分解失败：" + rtn, "error", function() {
					reject();
				});
				return;
			}
			var rtn = $.m({ClassName: "web.UDHCAccPrtPayFoot", MethodName: "UpdateAPIForYBDiv", TMPGID: pid, ExpStr: ""}, false);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.alert("提示", "更新医保的支付方式失败：" + rtn, "error", function() {
					reject();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* 退费完成
	*/
	var _success = function() {
		return new Promise(function (resolve, reject) {
			if (newPrtRowId > 0) {
				accPInvPrint(newPrtRowId);
			}
			return resolve();
		});
	};
	
	var refundOrdStr = getRefOrderStr(prtRowId + ":" + "API");
	
	var invJsonObj = getPersistClsObj("User.DHCAccPayINV", prtRowId);
	var insTypeId = invJsonObj.APIInsTypeDR;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	
	var insuDivId = invJsonObj.APIInsDivDR;

	var newPrtRowId = "";
	var pid = "";
	
	var promise = Promise.resolve();
	return promise
		.then(_insuPark)
		.then(_refund)
		.then(_insuDiv)
		.then(_success);
}

/**
* 获取发票退费医嘱串
*/
function getRefOrderStr(invStr) {
	var myAry = invStr.split(":");
	var invId = myAry[0];
	var invFlag = myAry[1];
	GV.ReBillFlag = 0;
	var refInvOrdObj = {};
	$.each(GV.OrdItmList.getRows(), function (index, row) {
		var myInvId = (invFlag == "API") ? row.accPayInvId : row.prtId;
		if (myInvId != invId) {
			return true;
		}
		refInvOrdObj[row.prtId] = refInvOrdObj[row.prtId] || "";
		if (getOrdItmRowChecked(index)) {
			if (!refInvOrdObj[row.prtId]) {
				refInvOrdObj[row.prtId] = row.oeitm;
			}else {
				refInvOrdObj[row.prtId] = refInvOrdObj[row.prtId] + "^" + row.oeitm;
			}
			refInvOrdObj[row.prtId + "REFSUM"] = Number(refInvOrdObj[row.prtId + "REFSUM"] || 0).add(row.patShareAmt).toFixed(2);
		}else {
			GV.ReBillFlag = 1;
			refInvOrdObj[row.prtId + "REBILLFLAG"] = 1;
		}
	});
	
	var myAry = [];
	var reg = /[a-z]/i;
	var str;
	$.each(refInvOrdObj, function (key, value) {
		if (reg.test(key)) {
			return true;
		}
		str = key + PUBLIC_CONSTANT.SEPARATOR.CH3 + value;
		str += PUBLIC_CONSTANT.SEPARATOR.CH3 + (refInvOrdObj[key + "REBILLFLAG"] || 0);
		str += PUBLIC_CONSTANT.SEPARATOR.CH3 + (refInvOrdObj[key + "REFSUM"] || 0);
		myAry.push(str);
	});
	
	return myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return GV.OrdItmList.getPanel().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(":checked");
}

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
				if (myPrtXMLName) {
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
			getXMLConfig(GV.INVXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
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

/**
* 将门诊退费的自费退费金额充值到住院押金
*/
function transRefAmt2IPDep(invStr) {
	return new Promise(function (resolve, reject) {
		$.m({
			ClassName: "web.DHCOPBillEmergTrans2IP",
			MethodName: "TransRefAmt2IPDep",
			invStr: invStr,
			sessionStr: getSessionStr()
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				return reject();
			}
			var depRowId = myAry[1] || "";
			if (depRowId) {
				depositPrint(depRowId + "#" + "");
			}
			resolve();
		});
	});
}
