/**
 * FileName: dhcbill.ipbill.dischQuery.js
 * Author: LJJ
 * Date: 2018-06-04
 * Description: 出院患者查询
 */

$(function () {
	initQueryMenu();
	initAdmList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAdmList();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});
	
	//打印清单
	$HUI.linkbutton('#btn-printDtl', {
		onClick: function () {
			printDtlClick();
		}
	});
	
	//医保住院结算明细 2022-11-10 LUANZH
	$HUI.linkbutton("#btn-insu", {
		onClick: function () {
			printInsuClick();
		}
	});
	
	$("#patientNo").keydown(function(e) {
		patientNoKeydown(e);
	});
	
	$HUI.combobox("#ward", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		value: PUBLIC_CONSTANT.SESSION.WARDID,
		blurValidValue: true,
		defaultFilter: 5,
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

	$HUI.combobox("#dept", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		multiple: (CV.DeptMulti == 1),
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

	$HUI.combobox("#doctor", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "web.DHCBillOtherLB";
				param.QueryName = "QryDoctor";
				param.ResultSetType = "array";
				param.desc = param.q;
				param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID
			}
		}
	});
	
	$HUI.combobox("#insType", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	$HUI.combobox("#admStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data:[{value: 'Nur', text: $g('护士确认'), selected: true},
		      {value: 'Doc', text: $g('医生确认')},
			  {value: 'Admit', text: $g('当前在院')},
		      {value: 'Pay', text: $g('财务结算')}
		     ]
	});
	
	//诊断
	$HUI.combobox("#diagnos", {
		panelHeight: 180,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'HIDDEN',
		textField: 'desc',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "web.DHCMRDiagnos";
				param.QueryName = "LookUpWithAlias";
				param.ResultSetType = "array";
				param.desc = param.q;
			}
		}
	});
	
	//医保登记标识
	$HUI.combobox("#insuReg", {
		panelHeight: 'auto',
		valueField: 'value',
		textField: 'text',
		data: [{value: 'N', text: $g('未登记')},
		      {value: 'Y', text: $g('已登记')}
		     ]
	});
}

function initAdmList() {
	GV.DischAdmList = $HUI.datagrid("#dischAdmList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: 'web.UDHCJFDischQuery',
		queryName: 'QryDisChgPatList',
		frozenColumns: [[{field: 'TPatientNo', title: '登记号', width: 100},
						 {field: 'TMrNo', title: '病案号', width: 80},
						 {field: 'TPatName', title: '患者姓名', width: 80}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPatientNo", "TMrNo", "TPatName", "TWard", "TAdmDate", "TDischDate", "TMedDischDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TEpisodeID", "TPatientID", "TBillID", "TPayDate", "TPayTime"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TMRDiagnos") {
					cm[i].showTip = true;
				}
				if (cm[i].field == "TDept") {
					cm[i].title = '科室病区';
					cm[i].showTip = true;
					cm[i].formatter = function (value, row, index) {
						return value + " " + row.TWard;
					}
				}
				if (cm[i].field == "TAdmTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TAdmDate + " " + value;
					}
				}
				if (cm[i].field == "TDischTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TDischDate + " " + value;
					}
				}
				if (cm[i].field == "TMedDiscTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TMedDischDate + " " + value;
					}
				}
				if (cm[i].field == "TRemain") {
					cm[i].styler = function(value, row, index) {
						if (value < 0) {
							return 'background-color:#ffee00; color:red;';
						}
					};
				}
				if (cm[i].field == "TIsInsuReg") {
					cm[i].formatter = function (value, row, index) {
						if (value) {
							var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TSex", "TAge", "TBed"]) != -1) {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["TAdmTime", "TDischTime", "TMedDiscTime"]) != -1) {
						cm[i].width = 155;
					}
					if (cm[i].field == "TDept") {
						cm[i].width = 160;
					}
					if (cm[i].field == "TMRDiagnos") {
						cm[i].width = 180;
					}
				}
				if (cm[i].field == "PersonId") {
					cm[i].width = 180;
					cm[i].hidden = false;
				}
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(index, row);
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			$.m({
				ClassName: "web.UDHCJFBaseCommon",
				MethodName: "regnocon",
				PAPMINo: $(e.target).val()
			},function(patientNo) {
				$(e.target).val(patientNo);
				loadAdmList();
			});
		}
	}
}

function loadAdmList() {
	var deptId = "";
	if ($("#dept").combobox("options").multiple) {
		deptId = $("#dept").combobox("getValues").join("^");
	}else {
		deptId = $("#dept").combobox("getValue");
	}
	var wardId = getValueById("ward");
	var docId = getValueById("doctor");
	var insTypeId = getValueById("insType");
	var bed = getValueById("bedNo");
	var diagId = getValueById("diagnos");
	var isInsuReg = getValueById("insuReg");
	var expStr = deptId + "!" + wardId + "!" + docId + "!" + insTypeId + "!" + bed + "!" + diagId + "!" + isInsuReg;
	
	var queryParams = {
		ClassName: "web.UDHCJFDischQuery",
		QueryName: "QryDisChgPatList",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		PatientNo: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		MedicareNo: getValueById("medicareNo"),
		AdmStatus: getValueById("admStatus"),
		ExpStr: expStr,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("dischAdmList", queryParams);
}

function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var deptId = "";
	if ($("#dept").combobox("options").multiple) {
		deptId = $("#dept").combobox("getValues").join("^");
	}else {
		deptId = $("#dept").combobox("getValue");
	}
	var wardId = getValueById("ward");
	var patientNo = getValueById("patientNo");
	var patName = getValueById("patName");
	var medicareNo = getValueById("medicareNo");
	var docId = getValueById("doctor");
	var insTypeId = getValueById("insType");
	var bed = getValueById("bedNo");
	var admStatus = getValueById("admStatus");
	var diagId = getValueById("diagnos");
	var isInsuReg = getValueById("insuReg");
	var expStr = deptId + "!" + wardId + "!" + docId + "!" + insTypeId + "!" + bed + "!" + diagId + "!" + isInsuReg;
	
	var fileName = "DHCBILL-IPBILL-CYHZTJ.rpx" + "&StDate=" + stDate + "&EndDate=" + endDate;
	fileName += "&PatientNo=" + patientNo + "&PatientName=" + patName + "&MedicareNo=" + medicareNo;
	fileName += "&AdmStatus=" + admStatus + "&ExpStr=" + expStr + "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function printDtlClick() {
	var row = GV.DischAdmList.getSelected();
	if (!row) {
		return;
	}
	var adm = row.TEpisodeID;
	if (!adm) {
		$.messager.popover({msg: '请选择患者', type: 'info'});
		return;
	}
	var billId = row.TBillID;
	if (billId != "") {
		showBillDtl(adm, billId);
		return;
	}
	$.m({
		ClassName: "web.UDHCJFDischQuery",
		MethodName: "JudgeBillNum",
		PAADMRowID: adm
	}, function (rtn) {
		var myAry = rtn.split("^");
		var billNum = myAry[0];
		var billId = myAry[1];
		if (billNum == 1) {
			billClick(billId);
			return;
		}
		if (billNum > 1) {
			showBillDtl(adm);
		}
	});
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f:not(#admStatus)").combobox("clear");
	$("#admStatus").combobox("setValue", "Nur");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.DischAdmList.options().pageNumber = 1;   //跳转到第一页
	GV.DischAdmList.loadData({total: 0, rows: []});
}

function selectRowHandler(index, row) {
	var menuWin = websys_getMenuWin();
	if (menuWin && menuWin.MainClearEpisodeDetails) {
		menuWin.MainClearEpisodeDetails();
	}
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = row.TEpisodeID;
		frm.PatientID.value = row.TPatientID;
	}
}

function billClick(billId) {
	var row = GV.DischAdmList.getSelected();
	if (!row || !row.TEpisodeID) {
		return;
	}
	var adm = row.TEpisodeID;
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "Bill",
		EpisodeID: adm,
		UserRowID: PUBLIC_CONSTANT.SESSION.USERID,
		BillNo: billId,
		ComputerName: ClientIPAddress
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			showBillDtl(adm, billId);
			return;
		}
		$.messager.popover({msg: ($g("账单失败：") + (myAry[1] || myAry[0])), type: "error"});
	});
}

function showBillDtl(adm, billId) {
	if (!billId) {
		var url = "dhcbill.ipbill.billselect.csp?EpisodeID=" + adm;
		websys_showModal({
			url: url,
			title: '账单列表',
			iconCls: 'icon-w-list',
			height: 400,
			width: 800
		});
		return;
	}
	
	var url = "dhcbill.ipbill.billdtl.csp?EpisodeID=" + adm + "&BillID=" + billId;
	websys_showModal({
		url: url,
		title: '费用明细',
		iconCls: 'icon-w-list',
		width: '85%'
	});
}

/**
* 医保住院结算明细
*/
function printInsuClick() {
	var row = GV.DischAdmList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择患者', type: 'info'});
		return;
	}
	var adm = row.TEpisodeID;
	var billId = row.TBillID;
	var fileName = "DHCINSU.IP.DivideSubByAdm.rpx" + "&admDr=" + adm + "&QchrgitmLv00A=" +  "" + "&BillDr=" + billId + "&InsuKey=" + "" + "&TarItemKey" + "";
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
    DHCCPM_RQPrint(fileName, width, height);
}
