/**
 * FileName: dhcbill.opbill.invQuery.js
 * Author: ZhYW
 * Date: 2018-10-13
 * Description: �����վݲ�ѯ
 */

$(function () {
	var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			loadConHospMenu();
		},
		onLoadSuccess: function(data){
			loadConHospMenu();
		}
	});
	
	initQueryMenu();
	initInvList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	$("#stTime").timespinner("setValue", "00:00:00");
	$("#endTime").timespinner("setValue", "23:59:59");

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//���Żس���ѯ�¼�
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//��Ʊ�س���ѯ�¼�
	$("#invNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadInvList();
		}
	});
	
	$HUI.combobox("#guser", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		mode: 'remote',
		method: 'GET',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
	
	$HUI.combobox("#invFlag", {
		panelHeight: 'auto',
		data: [{value: 'A', text: $g('����')},
			   {value: 'S', text: $g('���')}
			],
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combobox("#footFlag", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: $g('�ѽ�')},
			   {value: 'N', text: $g('δ��')}
			],
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	$HUI.combobox("#insTypeId", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	//2022-07-21 ZhYW �����Ƿ�Ӧ���շ�������
	$HUI.combobox("#isCESFlag", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: $g('��')},
			   {value: 'N', text: $g('��')}
			],
		valueField: 'value',
		textField: 'text'
	});
}

/**
* ZhYW
* ���ظ�ҽԺ�йصĲ�ѯԪ��
*/
function loadConHospMenu() {
	var hospId = $HUI.combogrid("#_HospUserList").getValue();
	
	var url = $URL + "?ClassName=web.udhcOPQUERY&QueryName=FindInvUser&ResultSetType=array&hospId=" + hospId;
	$("#guser").combobox("clear").combobox("reload", url);

	url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=" + hospId;
	$("#insTypeId").combobox("clear").combobox("reload", url);
}

/**
 * ����
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
		$.messager.alert("��ʾ", "����Ч", "info", function () {
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

function initInvList() {
	var toolbar = [{
			text: '����',
			iconCls: 'icon-export',
			handler: function () {
				exportClick();
			}
		}, {
			text: '��ӡ�嵥',
			iconCls: 'icon-print',
			handler: function () {
				printClick();
			}
		}, {
			text: '��ӡ�վ�֤��',
			iconCls: 'icon-print-arr-bo',
			handler: function () {
				prtInvProveClick();
			}
		}, {
			text: '�����ﵥ',
			iconCls: 'icon-reprint-inv',
			handler: function () {
				reprtDirectClick();
			}
		}
	];
	
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "web.udhcOPQUERY",
		queryName: "INVQUERY11",
		frozenColumns: [[{field: 'ck', checkbox: true}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TDate", "InvDate", "TParkDate", "AllowRefundDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["IsStayInv"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				
				if (cm[i].field == "TINVRowid") {
					cm[i].title = "������";
					cm[i].formatter = function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='orderDetail(" + JSON.stringify(row) + ")'>" + value + "</a>";
						}
					}
				}
				if ($.inArray(cm[i].field, ["TAbort", "TRefund", "THandin"]) != -1) {
					cm[i].formatter = function (value, row, index) {
						var color = (value == 1) ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == 1) ? $g("��") : $g("��")) + "</font>";
					}
				}
				if (cm[i].field == "TTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TDate + " " + value;
					}
				}
				if (cm[i].field == "InvTime") {
					cm[i].formatter = function (value, row, index) {
						return row.InvDate + " " + value;
					}
				}
				if (cm[i].field == "TParkTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TParkDate + " " + value;
					}
				}
				if (cm[i].field == "AllowRefundTime") {
					cm[i].formatter = function (value, row, index) {
						return row.AllowRefundDate + " " + value;
					}
				}
				if (cm[i].field == "CESFlag") {
					cm[i].formatter = function (value, row, index) {
						var color = (value == 1) ? "#21ba45" : "#f16e57";
						return (value == 1) ? ("<a href='javascript:;' onmouseover='showDataRetLog(this, " + JSON.stringify(row) + ")' style='text-decoration:underline;'>" + ("<font color=\"" + color + "\">" + $g("��") + "</font>") + "</a>") : ("<font color=\"" + color + "\">" + $g("��") + "</font>");
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TAbort", "TRefund", "THandin"]) != -1) {
						cm[i].width = 50;
					}
					if ($.inArray(cm[i].field, ["TTime", "InvTime", "TParkTime", "AllowRefundTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
			$.each(data.rows, function (index, row) {
				if ((row.TAbort == 1) || (row.TRefund == 1)) {
					GV.InvList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true; //�˷�Ʊ�ݲ��ܱ�ѡ��
				}
			});
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (GV.InvList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] div.datagrid-cell-check>input:checkbox").prop("disabled")) {
					GV.InvList.uncheckRow(index);
				}
			});
			if (!GV.InvList.getPanel().find(".datagrid-header-row input:checkbox")[0].checked) {
				GV.InvList.getPanel().find(".datagrid-header-row input:checkbox")[0].checked = true;
			}
		},
		onCheck: function(index, row) {
			if (GV.InvList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] div.datagrid-cell-check>input:checkbox").prop("disabled")) {
				GV.InvList.uncheckRow(index);
			}
		}
	});
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f").combobox("clear");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	$("#stTime").timespinner("setValue", "00:00:00");
	$("#endTime").timespinner("setValue", "23:59:59");
	GV.InvList.options().pageNumber = 1;   //��ת����һҳ
	GV.InvList.loadData({total: 0, rows: []});
	focusById("CardNo");
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.udhcOPQUERY",
		QueryName: "INVQUERY11",
		ReceipNO: getValueById("invNo"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		StDate: $("#stDate").datebox("getValue"),
		StTime: $("#stTime").timespinner("getValue"),
		EndDate: $("#endDate").datebox("getValue"),
		EndTime: $("#endTime").timespinner("getValue"),
		INVStatus: getValueById("invFlag") || "",
		UserId: getValueById("guser") || "",
		INVFootFlag: getValueById("footFlag") || "",
		CardNo: getValueById("CardNo"),
		PayModeId: getValueById("paymode") || "",
		InsTypeId: getValueById("insTypeId") || "",
		IsCESFlag: getValueById("isCESFlag") || "",
		HospId: $HUI.combogrid("#_HospUserList").getValue()
	};
	loadDataGridStore("invList", queryParams);
}

function orderDetail(row) {
	var argObj = {
		invRowId: row.TINVRowid,
		invType: row.TabFlag
	};
	BILL_INF.showOPChgOrdItm(argObj);
}

/**
 * ����
 */
function exportClick() {
	var fileName = "DHCBILL-OPBILL-SJMX.rpx" + "&ReceipNO=" + getValueById("invNo") + "&PatientNO=" + getValueById("patientNo");
	fileName += "&PatientName=" + getValueById("patName") + "&StDate=" + $("#stDate").datebox("getValue") + "&StTime=" + $("#stTime").timespinner("getValue");
	fileName += "&EndDate=" + $("#endDate").datebox("getValue") + "&EndTime=" + $("#endTime").timespinner("getValue");
	fileName += "&INVStatus=" + (getValueById("invFlag") || "") + "&UserId=" + (getValueById("guser") || "") + "&INVFootFlag=" + (getValueById("footFlag") || "");
	fileName += "&CardNo=" + getValueById("CardNo") + "&PayModeId=" + (getValueById("paymode") || "") + "&InsTypeId=" + (getValueById("insTypeId") || "");
	fileName += "&IsCESFlag=" + (getValueById("isCESFlag") || "") + "&HospId=" + $HUI.combogrid("#_HospUserList").getValue();
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * ��ӡ
 */
function printClick() {
	var invAry = [];
	$.each(GV.InvList.getChecked(), function (index, row) {
		var prtRowId = row.TINVRowid;
		var sFlag = row.TabFlag;
		var tmpStr = prtRowId + ":" + sFlag;
		invAry.push(tmpStr);
	});
	if (invAry.length == 0) {
		$.messager.popover({msg: "��ѡ����Ҫ��ӡ�ļ�¼", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCBillDtlListPrtLog",
		MethodName: "SavePrtLog",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: invAry.join("^")
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.alert({msg: ("������־ʧ�ܣ�" + (myAry[1] || myAry[0])), type: "info"});
			return;
		}
		var fileName = "{DHCBILL-OPBILL-FYQD.rpx(invStr=" + invAry.join("!") + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}

/**
 * ��ӡ�վ�֤��(��Ʊ��ʧ֤��)
 */
function prtInvProveClick() {
	var rows = GV.InvList.getChecked();
	if (rows.length == 0) {
		$.messager.popover({msg: "�빴ѡ��Ҫ��ӡ�ļ�¼", type: "info"});
		return;
	}
	if (rows.length > 1) {
		$.messager.popover({msg: "ֻ�ܹ�ѡһ����¼���д�ӡ", type: "info"});
		return;
	}
	var fileName = "DHCBILL-OPBILL-SJZM.rpx" + "&InvRowID=" + rows[0].TINVRowid + "&PRTFlag=" + rows[0].TabFlag;
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * �����ﵥ
 */
function reprtDirectClick() {
	var rows = GV.InvList.getChecked();
	if (rows.length == 0) {
		$.messager.popover({msg: "�빴ѡ��Ҫ��ӡ�ļ�¼", type: "info"});
		return;
	}
	if (rows.length > 1) {
		$.messager.popover({msg: "ֻ�ܹ�ѡһ����¼���д�ӡ", type: "info"});
		return;
	}
	var invRowId = rows[0].TINVRowid;
	var tabFlag = rows[0].TabFlag;
	var isStayInv = rows[0].IsStayInv;
	if (isStayInv == "Y") {
		$.messager.popover({msg: "�������۽����¼���ܴ�ӡ���ﵥ", type: "info"});
		return;
	}
	switch (tabFlag) {
	case "PRT":
		directPrint(invRowId);
		break;
	case "API":
		$.messager.confirm("ȷ��", "�˷�ƱΪ���д�ӡ��Ʊ���Ƿ�ȷ�ϴ�ӡ��", function(r) {
			if (!r) {
				return;
			}
			$.m({
				ClassName: "web.DHCOPBILLOrdDirectList",
				MethodName: "GetPrtRowId",
				apiRowId: invRowId
			}, function(rtn) {
				var myAry = rtn.split("^");
				$.each(myAry, function(index, item) {
					directPrint(item);
				});
			});
		});
		break;
	default:
	}
}

/**
 * ZhYW
 * 2022-07-21
 * Ӧ���շ�ϵͳ���ݻش���־��Ϣ
*/
function showDataRetLog($this, row) {
	if (row.CESFlag != 1) {
		return;
	}
	var prtRowId = row.TINVRowid;
	var json = $.cm({ClassName: "BILL.CES.COM.Log", MethodName: "GetCESImportLogInfo", tableName: "DHC_INVPRT", rowId: prtRowId}, false);
	var content = "<table>"
					+ "<tr>"
					+ 	"<td><lable style='color:#666'>" + $g("�ͻ��˻����룺") + "</lable>"
					+ 	"<lable style='color:#000'>" + json.clientCode + "</lable></td>"
					+ "</tr>"
					+ "<tr>"
					+ 	"<td><lable style='color:#666'>" + $g("�ͻ���λ�ã�") + "</lable>"
					+ 	"<lable style='color:#000'>" + json.clientLocation + "</lable></td>"
					+ "</tr>"
					+ "<tr>"
					+ 	"<td><lable style='color:#666'>" + $g("����Ա��") + "</lable>"
					+ 	"<lable style='color:#000'>" + json.userName + "</lable></td>"
					+ "</tr>"
					+ "<tr>"
					+ 	"<td><lable style='color:#666'>" + $g("�ش�ʱ�䣺") + "</lable>"
					+ 	"<lable style='color:#000'>" + (json.logDate + " " + json.logTime) + "</lable></td>"
					+ "</tr>"
				+ "</table>";
	$($this).popover({
		trigger: 'hover',
		content: content
	}).popover("show");
}