/**
 * FileName: dhcbill.ipbill.preipadmtrans.js
 * Author: ZhYW
 * Date: 2018-06-30
 * Description: 预住院转门诊/住院
 */

$(function () {
	initQueryMenu();
	initPreIPAdmList();
});

function initQueryMenu() {
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	
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
	$("#CardNo").keydown(function (e) {
		cardNoKeydown(e);
	}).prop("disabled", (CV.EpisodeID > 0));

	//登记号回车查询事件
	$("#patientNo").focus().keydown(function (e) {
		patientNoKeydown(e);
	}).prop("disabled", (CV.EpisodeID > 0));

	//当前病区
	$HUI.combobox("#curWard", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindWard&ResultSetType=array',
		editable: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		disabled: ((CV.EpisodeID > 0) || (CV.IsDaySurgeryLoc != "Y")),
		value: (CV.IsDaySurgeryLoc != "Y") ? PUBLIC_CONSTANT.SESSION.WARDID : "",
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	//科室
	$HUI.combobox("#dept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindDept&ResultSetType=array',
		editable: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function(rec) {
			var url = $URL + "?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindLinkedWard&ResultSetType=array&docIPBookId=&deptId=" + rec.id;
			$("#ward").combobox("clear").combobox("reload", url);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				$("#ward").combobox("clear");
			}
		}
	});

	$HUI.combobox("#ward", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text'
	});
}

function initPreIPAdmList() {
	var toolbar = [{
			id: 'M',
			text: $g('转门诊'),
			iconCls: 'icon-outpatient',
			handler: function () {
				transClick("O", "");
			}
		}, {
			id: 'Z',
			text: $g('转住院'),
			iconCls: 'icon-inpatient',
			handler: function () {
				transClick("I", "");
			}
		}, {
			id: 'C',
			text: $g('转常规手术'),
			iconCls: 'icon-pat-opr',
			handler: function () {
				transClick("I", "Y");
			}
		}, {
			id: 'MZSH',
			text: $g('转门诊审核'),
			iconCls: 'icon-stamp',
			handler: function () {
				auditClick("O", "");
			}
		}, {
			id: 'ZYSH',
			text: '转住院审核',
			iconCls: 'icon-stamp',
			handler: function () {
				auditClick("I", "");
			}
		}, {
			id: 'CSH',
			text: '转常规手术审核',
			iconCls: 'icon-stamp',
			handler: function () {
				auditClick("I", "Y");
			}
		}, {
			id: 'CXSH',
			text: $g('撤销审核'),
			iconCls: 'icon-stamp-cancel',
			handler: function () {
				cancelAuditClick();
			}
		}
	];
	
	if (CV.ToolParamAry.length > 0) {
		toolbar = toolbar.filter(function(item) {
			return ($.inArray(item.id, CV.ToolParamAry) != -1);
		});
	}
	
	GV.PreIPAdmList = $HUI.datagrid("#preIPAdmList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "web.DHCBillPreIPAdmTrans",
		queryName: "FindAdmInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["AdmDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["DocIPBookId", "Adm", "PatientId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "AdmTime") {
					cm[i].formatter = function (value, row, index) {
						return row.AdmDate + " " + value;
					}
				}
				if (cm[i].field == "AuditFlag") {
					cm[i].formatter = function (value, row, index) {
						var color = (value == "Y") ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "AdmTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBillPreIPAdmTrans",
			QueryName: "FindAdmInfo",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			wardId: getValueById("curWard") || "",
			patientId: getValueById("patientId"),
			episodeId: CV.EpisodeID,
			sessionStr: getSessionStr()
		},
		onSelect: function (index, row) {
			setEprMenuForm(row.Adm, row.PatientId);
			if (row.DocIPBookId) {
				$.m({
					//调用接口获取住院证上的科室和病区
					ClassName: "web.DHCDocIPBookNew",
					MethodName: "GetBookMesage",
					BookID: row.DocIPBookId
				}, function (rtn) {
					var myAry = rtn.split("^");
					setValueById("dept", myAry[13]);
					var url = $URL + "?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindLinkedWard&ResultSetType=array&docIPBookId=" + row.DocIPBookId + "&deptId=";
					$("#ward").combobox("clear").combobox("reload", url);
				});
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
	case '0':
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		break;
	case '-200':
		$.messager.alert("提示", "卡无效", "info", function() {
			focusById("CardNo");
		});
		break;
	case '-201':
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		break;
	default:
	}
	
	setValueById("patientId", patientId);
	if (patientId != "") {
		loadPreIPAdmList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}else {
		setValueById("patientId", "");
	}
}

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	patientNo = getFormatRegNo(patientNo);
	setValueById("patientNo", patientNo);
	var patientId = getPatientIdByRegNo(patientNo);
	setValueById("patientId", patientId);
	if (!(patientId > 0)) {
		$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
		$("#patientNo").val().focus();
		return;
	}
	loadPreIPAdmList();
}

/**
* 格式化登记号
*/
function getFormatRegNo(patientNo) {
	return (patientNo != "") ? $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "regnocon", PAPMINo: patientNo}, false) : "";
}

/**
* 根据登记号查询患者主索引
*/
function getPatientIdByRegNo(patientNo) {
	return (patientNo != "") ? $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetPAPMIByNo", PAPMINo: patientNo, ExpStr: ""}, false) : "";
}

function findClick() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		getPatInfo();
	}else {
		loadPreIPAdmList();
	}
}

function loadPreIPAdmList() {
	var queryParams = {
		ClassName: "web.DHCBillPreIPAdmTrans",
		QueryName: "FindAdmInfo",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		wardId: getValueById("curWard") || "",
		patientId: getValueById("patientId"),
		episodeId: CV.EpisodeID,
		sessionStr: getSessionStr()
	};
	loadDataGridStore("preIPAdmList", queryParams);
}

/**
 * 转门诊审核
 */
function auditClick(transType, norOperFlag) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.PreIPAdmList.getSelected();
			if (!row || !row.Adm) {
				$.messager.popover({msg: "请选择预住院就诊记录", type: "info"});
				return reject();
			}
			adm = row.Adm;
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("确认要转") + $g(typeDesc) + $g("审核") + "？"), function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _isMedOrdDisp = function() {
		return new Promise(function (resolve, reject) {
			if (transType != "O") {
				return resolve();
			}
			var isDisped = isMedOrdDisp(adm, 0);
			if (isDisped) {
				$.messager.alert("提示", "患者医嘱中有处方未发药，需发药或撤销医嘱后才能转门诊", "info");
				return reject();
			}
			var isDisped = isMedOrdDisp(adm, 1);
			if (isDisped) {
				$.messager.confirm("确认", "患者医嘱中包含已发药医嘱，若需退药，请退药后再进行转门诊操作，转门诊后将无法退药，是否继续？" , function (r) {
					return r ? resolve() : reject();
				});
				return;
			}
			resolve();
		});
	};

	var _audit = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCBillPreIPAdmTrans",
				MethodName: "Audit",
				episodeId: adm,
				transType: transType,
				norOperFlag: norOperFlag,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == 0) ? "success" : "error";
				$.messager.alert("提示", msg, type, function () {
					return (success == 0) ? resolve() : reject();
				});
			});
		});
	};

	var _success = function() {
		GV.PreIPAdmList.reload();
	};

	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var typeDesc = (transType == "O") ? "门诊" : ((norOperFlag == "Y") ? "常规手术" : "住院");
	
	var adm = "";
	
	var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_isMedOrdDisp)
			.then(_audit)
			.then(function() {
				_success();
				$this.prop("disabled", false);
			}, function () {
				$this.prop("disabled", false);
			});
}

/**
 * 撤销审核
 */
function cancelAuditClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.PreIPAdmList.getSelected();
			if (!row || !row.Adm) {
				$.messager.popover({msg: "请选择已审核的预住院就诊记录", type: "info"});
				return reject();
			}
			adm = row.Adm;
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认要撤销审核？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCBillPreIPAdmTrans",
				MethodName: "CancelAudit",
				episodeId: adm
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == 0) ? "success" : "error";
				$.messager.alert("提示", msg, type, function () {
					return (success == 0) ? resolve() : reject();
				});
			});
		});
	};

	var _success = function () {
		GV.PreIPAdmList.reload();
	};

	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);

	var adm = "";

	var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_cancel)
			.then(function() {
				_success();
				$this.prop("disabled", false);
			}, function () {
				$this.prop("disabled", false);
			});
}

/**
 * 转门诊/住院
 */
function transClick(transType, norOperFlag) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.PreIPAdmList.getSelected();
			if (!row || !row.Adm) {
				$.messager.popover({msg: "请选择预住院就诊记录", type: "info"});
				return reject();
			}
			adm = row.Adm;
			resolve();
		});
	};

	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("确认转") + $g(typeDesc) + "？"), function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _isMedOrdDisp = function() {
		return new Promise(function (resolve, reject) {
			if (transType != "O") {
				return resolve();
			}
			var isDisped = isMedOrdDisp(adm, 0);
			if (isDisped) {
				$.messager.alert("提示", "患者医嘱中有处方未发药，需发药或撤销医嘱后才能转门诊", "info");
				return reject();
			}
			var isDisped = isMedOrdDisp(adm, 1);
			if (isDisped) {
				$.messager.confirm("确认", "患者医嘱中包含已发药医嘱，若需退药，请退药后再进行转门诊操作，转门诊后将无法退药，是否继续？" , function (r) {
					return r ? resolve() : reject();
				});
				return;
			}
			resolve();
		});
	};

	var _trans = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCBillPreIPAdmTrans",
				MethodName: "AdmTrans",
				episodeId: adm,
				transType: transType,
				deptId: getValueById("dept"),
				wardId: getValueById("ward"),
				norOperFlag: norOperFlag,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == 0) ? "success" : "error";
				$.messager.alert("提示", msg, type, function () {
					return (success == 0) ? resolve() : reject();
				});
			});
		});
	};
	
	var _success = function() {
		clearEprMenuForms();          //转后清头菜单传值
		GV.PreIPAdmList.reload();
	};

	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var typeDesc = (transType == "O") ? "门诊" : ((norOperFlag == "Y") ? "常规手术" : "住院");
	
	var adm = "";

	var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_isMedOrdDisp)
			.then(_trans)
			.then(function() {
				_success();
				$this.prop("disabled", false);
			}, function () {
				$this.prop("disabled", false);
			});
}

function setEprMenuForm(episodeId, patientId) {
	var menuWin = websys_getMenuWin();
	if (menuWin && menuWin.MainClearEpisodeDetails) {
		menuWin.MainClearEpisodeDetails();
	}
	var frm = dhcsys_getmenuform();
	if (frm) {
		if (frm.EpisodeID) {
			frm.EpisodeID.value = episodeId;
		}
		if (frm.PatientID) {
			frm.PatientID.value = patientId;
		}
	}
}

function clearEprMenuForms() {
	var menuWin = websys_getMenuWin();
	if (menuWin && menuWin.MainClearEpisodeDetails) {
		menuWin.MainClearEpisodeDetails();
		return;
	}
	var frm = dhcsys_getmenuform();
	if (frm) {
		if (frm.EpisodeID) {
			frm.EpisodeID.value = "";
		}
		if (frm.PatientID) {
			frm.PatientID.value = "";
		}
	}
}

/**
 * 判断就诊对应的药品医嘱的发药状态
 * isDisped:0:查询未发药，1:查询已发药
 */
function isMedOrdDisp(adm, isDisped) {
	return $.m({ClassName: "web.DHCBillPreIPAdmTrans", MethodName: "ChkMedOrdDisp", adm: adm, isDisped: isDisped}, false) == 1;
}