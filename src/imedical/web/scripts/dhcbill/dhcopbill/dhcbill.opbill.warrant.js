/**
 * FileName: dhcbill.opbill.warrant.js
 * Author: ZhYW
 * Date: 2018-07-11
 * Description: 急诊担保
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 1000000000;
		},
		message: $g("金额输入过大")
	}
});

$(function () {
	initQueryMenu();
	initWarrList();
});

function initQueryMenu() {
	setValueById("stDate", CV.DefDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-add, #btn-update", {
		onClick: function () {
			saveClick(this.id);
		}
	});
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadWarrList();
		}
	});

	$HUI.linkbutton("#btn-appList", {
		onClick: function () {
			appListClick();
		}
	});
	
	if (getValueById("ReqFlag") != "Y") {
		disableById("btn-appList");
	}
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
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

	$HUI.combobox("#warrStatus", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: $g('有效'), selected: true},
			   {value: 'N', text: $g('无效')}
		],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combogrid("#admList", {
		panelWidth: 420,
		panelHeight: 200,
		striped: true,
		fitColumns: true,
		delay: 300,
		idField: 'adm',
		textField: 'adm',
		columns: [[{field: 'adm', title: '就诊号', width: 60},
				   {field: 'admDate', title: '就诊时间', width: 150,
				    formatter: function(value, row, index) {
						return value + " " + row.admTime;
					}
				   },
				   {field: 'admDept', title: '就诊科室', width: 150,
					formatter: function(value, row, index) {
						var cls = "icon " + ((row.admType == "E") ? "icon-emergency" : "icon-outpatient");
						return value + "<span class=\"" + cls + "\"></span>";
					}
				  }
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid("clear");
			if (data.total == 1) {
				setValueById("admList", data.rows[0].adm);
			}else {
				if (!getValueById("PatientID")) {
					$(".patientInfo>[id]").text("");
					loadWarrList();
				}
				setValueById("EpisodeID", "");
			}
		},
		onSelect: function (index, row) {
			setValueById("EpisodeID", row.adm);
			setBannerPatPayInfo(row.adm);
			loadWarrList();
		}
	});
	
	//担保人
	$HUI.combobox("#warrtor", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QrySSUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
	
	//担保物
	$HUI.combobox("#warrItem", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryCredType&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onLoadSuccess: function(data) {
			$(this).combobox("clear");
		}
	});
	
	//担保原因
	$HUI.combobox("#warrReason", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCEMDocGuarantee&MethodName=reasonCombox&ResultSetType=array&hosp=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}
	
function appListClick() {
	var patientId = getValueById("PatientID");
	if (!patientId) {
		$.messager.popover({msg: "请先查询患者", type: "info"});
		return;
	}
	var url = "dhcem.gua.guarantee.csp?&GrossClass=" + getValueById("GrossClass") + "&PatientID=" + patientId;
	url += "&PatType=" + CV.PatType;
	websys_showModal({
		url: url,
		title: $g('申请列表'),
		iconCls: 'icon-w-edit',
		width: '90%',
		height: '90%',
		callbackFunc: function(episodeId) {
			setValueById("EpisodeID", episodeId);
			loadAdmList();
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
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case '-200':
		setValueById("PatientID", "");
		$.messager.alert("提示", "卡无效", "info", function() {
			$("#CardNo").focus();
		});
		break;
	case '-201':
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
		getPatInfo();
	}
}

function getPatInfo() {
	$("#admList").combogrid("clear");
	setValueById("EpisodeID", "");
	$.cm({
		ClassName: "web.DHCOPBillWarrant",
		MethodName: "GetPatInfo",
		patientNo: getValueById("patientNo"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (json) {
		setValueById("PatientID", json.PatientId);
		setValueById("patientNo", json.PatientNo);
		if (!(json.PatientId > 0)) {
			$.messager.popover({msg: "患者不存在", type: "info"});
		}
		setBannerPatInfo(json.PatientId);
		loadAdmList();
	});
}

function initWarrList() {
	GV.WarrList = $HUI.datagrid("#warrList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillWarrant",
		queryName: "FindWarrInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["warrDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["warrtorDR", "papmi", "warrId", "credTypeDR", "guarantId" ,"warrReaId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "warrTime") {
					cm[i].formatter = function (value, row, index) {
						return row.warrDate + " " + value;
					}
				}
				if (cm[i].field == "status") {
					cm[i].title = '是否有效';
					cm[i].formatter = function (value, row, index) {
						var color = (value == "Y") ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
					}
				}
				if (cm[i].field == "userName") {
					cm[i].title = '操作员';
				}
				if (cm[i].field == "remark") {
					cm[i].title = '备注';
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["warrTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function selectRowHandler(row) {
	setValueById("patientNo", row.regNo);
	setValueById("PatientID", row.papmi);
	setValueById("EpisodeID", row.adm);
	setValueById("stDate", row.warrDate);
	setValueById("endDate", row.warrEndDate);
	
	setValueById("warrAmt", row.warrAmt);
	
	var data = [{id: row.warrtorDR, name: row.warrtor, selected: true}];
	$("#warrtor").combobox("loadData", data);
	
	setValueById("remark", row.remark);
	setValueById("warrItem", row.credTypeDR);   //2022-09-14 Luan Zhenhui
	setValueById("warrStatus", row.status);
	setValueById("warrReason", row.warrReaId);
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCOPBillWarrant",
		QueryName: "FindAdmInfo",
		patientId: getValueById("PatientID"),
		episodeId: getValueById("EpisodeID"),
		sessionStr: getSessionStr()
	}
	loadComboGridStore("admList", queryParams);
}

function loadWarrList() {
	var queryParams = {
		ClassName: "web.DHCOPBillWarrant",
		QueryName: "FindWarrInfo",
		episodeId: getValueById("EpisodeID"),
		sessionStr: getSessionStr()
	};
	loadDataGridStore("warrList", queryParams);
}

function saveClick(btnId) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!episodeId) {
				$.messager.popover({msg: "请选择就诊", type: "info"});
				return reject();
			}
			var row = GV.WarrList.getSelected();
			if (btnId == "btn-update") {
				if (!row || !row.warrId) {
					$.messager.popover({msg: "请选择担保记录", type: "info"});
					return reject();
				}
				if (row.status == "N") {
					$.messager.popover({msg: "已失效的记录不能修改", type: "info"});
					return reject();
				}
				warrId = row.warrId;
				guarantId = row.guarantId;
			}else {
				if (warrStatus != "Y") {
					$.messager.popover({msg: "担保状态不能为无效", type: "info"});
					return reject();
				}
			}
			/*
			if (endDate == "") {
				$.messager.popover({msg: "急诊绿色通道需选择结束日期", type: "info"});
				return reject();
			}
			*/
			var bool = true;
			$(".validatebox-text").each(function(index, item) {
				if (!$(this).validatebox("isValid")) {
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			var id = "";
			$("label.clsRequired").each(function(index, item) {
				id = $($(this).parent().next().find("input"))[0].id;
				if (!id) {
					return true;
				}
				if (!getValueById(id)) {
					bool = false;
					$.messager.popover({msg: ("<font style=\"color:red;\">" + $(this).text() + "</font>" + $g("不能为空")), type: "info"});
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var msg = $g("担保") + "<font style=\"color:red;\">" + warrAmt + "</font> " + $g("元，是否确认？");
			if (warrId) {
				msg = $g("是否确认修改?");
			}
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _save = function() {
		return new Promise(function (resolve, reject) {
			var warrInfo = warrId + "&" + episodeId + "&" + stDate + "&" + endDate + "&" + warrtor + "&" + warrAmt + "&" + warrStatus;
			warrInfo += "&" +  remark + "&" + PUBLIC_CONSTANT.SESSION.USERID + "&" + CV.PatType + "&" + guarantId + "&" + warrItem;
			warrInfo += "&" + PUBLIC_CONSTANT.SESSION.HOSPID + "&" + reasonId;
			
			$.m({
				ClassName: "web.DHCOPBillWarrant",
				MethodName: "SaveWarrant",
				warrInfo: warrInfo
			}, function(rtn) {
				var myAry = rtn.split("^");
				$.messager.popover({msg: myAry[1], type: ((myAry[0] == 0) ? "success" : "error")});
				return (myAry[0] == 0) ? resolve() : reject();
			});
		});
	};
	
	var _success = function() {
		setBannerPatPayInfo(episodeId);
				
		$("#warrAmt").numberbox("clear");
		$("#warrtor").combobox("clear").combobox("loadData", []);
		setValueById("warrStatus", "Y");
		setValueById("warrItem", "");
		setValueById("stDate", CV.DefDate);
		setValueById("endDate", "");
		setValueById("remark", "");
        setValueById("warrReason", "");
        
		loadWarrList();
	};
	
	if ($("#" + btnId).linkbutton("options").disabled) {
		return;
	}
	$("#" + btnId).linkbutton("disable");

	var episodeId = getValueById("EpisodeID");
	var warrStatus = getValueById("warrStatus");
	var warrAmt = getValueById("warrAmt");
	var warrtor = getValueById("warrtor");
	var warrItem = getValueById("warrItem");
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var remark = getValueById("remark");
	var reasonId = getValueById("warrReason");  //2022-11-8 LUANZH
	var warrId = "";
	var guarantId = "";	
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_save)
		.then(function () {
			_success();
			$("#" + btnId).linkbutton("enable");
		}, function () {
			$("#" + btnId).linkbutton("enable");
		});
}

function clearClick() {
	setValueById("PatientID", "");
	setValueById("EpisodeID", "");
	focusById("CardNo");
	$(":text:not(.pagination-num,.combobox-f),textarea").val("");
	$(".numberbox-f").numberbox("clear");
	$("#warrtor").combobox("clear").combobox("loadData", []);
	setValueById("warrStatus", "Y");
	setValueById("stDate", CV.DefDate);
	setValueById("endDate", "");

	$("#admList").combogrid("clear");
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
	
	showPatSexBGImg();  //设置banner性别默认图片
}

/**
* 打印
*/
function printClick() {
	var row = GV.WarrList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择担保记录", type: "info"});
		return;
	}
	var warrStatus = row.status;
	if (warrStatus != "Y") {
		$.messager.popover({msg: "担保无效，不能打印", type: "info"});
		return;
	}
	
	var warrId = row.warrId;
	var fileName = "DHCBILL-OPBILL-DBD.rpx&warrId=" + warrId;
	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}