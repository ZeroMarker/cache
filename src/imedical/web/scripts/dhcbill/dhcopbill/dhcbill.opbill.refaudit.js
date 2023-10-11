/**
 * FileName: dhcbill.opbill.refaudit.js
 * Author: ZhYW
 * Date: 2018-11-14
 * Description: �����˷����
 */

$(function () {
	initQueryMenu();
	initInvList();
	for (var i = 1, len = getTabsLength(); i <= len; i++) {
		initOrdItmList(i);
	}
});

function initQueryMenu() {
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);

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
		invNoKeydown(e);
	});

	var $tb = $("#more-container");
	if(HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$("#more-container").click(function () {
		var t = $(this);
		if (t.find(".arrows-b-text").text() == $g("����")) {
			t.find(".arrows-b-text").text($g("����"));
			var ui = (HISUIStyleCode == "lite") ? "l" : "b";
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("����"));
			var ui = (HISUIStyleCode == "lite") ? "l" : "b";
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});
	
	$HUI.tabs("#audit-tabs", {
		onSelect: function(title, index) {
			loadOrdItmList();
		}
	});
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
 * ��Ʊ�Żس���ѯ
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CheckInvIsReqByInvNo",
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == 0) {
				$.messager.alert("��ʾ", "�÷�Ʊ�����ڻ�δ������.", "info");
				return;
			}
			loadInvList();
		});
	}
}

/**
 * ����layout�߶�
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout:eq(1)");
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
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillRefundRequest",
		queryName: "FindReqInvInfo",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //�����鿪ʼλ������һ��
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["prtRowId", "invFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.prtDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "prtTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				$(this).datagrid("checkAll");
			}else {
				$(this).datagrid("clearChecked");
			}
		},
		onCheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onUncheck: function (rowIndex, rowData) {
			loadDefTabContent();
		},
		onCheckAll: function (rows) {
			loadDefTabContent();
		},
		onUncheckAll: function (rows) {
			loadDefTabContent();
		}
	});
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindReqInvInfo",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		receiptNo: getValueById("invNo"),
		patientNo: getValueById("patientNo"),
		patientName: getValueById("patName"),
		chargeUser: getValueById("userName"),
		sessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

function initOrdItmList(index) {
	var toolbar = [];
	if (index == 1) {
		toolbar = [{
				text: '���',
				iconCls: 'icon-stamp-pass',
				handler: function () {
					auditClick();
				}
			}
		];
	}
	if (index == 3) {
		toolbar = [{
				text: '�������',
				iconCls: 'icon-stamp-cancel',
				handler: function () {
					cancelClick();
				}
			}
		];
	};
	
	$HUI.datagrid("#ordItmList-" + index, {
		fit: true,
		border: false,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: toolbar,
		columns: [getOrdItmColumns(index)],
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		},
		onCheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			ctrlMedItm(index, row);
		},
		onUncheck: function (index, row) {
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			ctrlMedItm(index, row);
		}
	});
}

function loadOrdItmList() {
	var invStr = getCheckedInvStr();
	var index = getSelTabIndex();
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: (index == 2) ? "FindOrdItm" : "FindIOASubInfo",
		invStr: invStr,
		auditFlag: getAuditFlag(),
		sessionStr: getSessionStr(),
		rows: 999999999
	}
	loadDataGridStore("ordItmList-" + index, queryParams);
}

/**
 * ���
 */
function auditClick() {
	var invSubStr = getCheckedInvSubStr();
	if (!invSubStr) {
		$.messager.popover({msg: "�빴ѡ��Ҫ��˵�ҽ��", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�����? ", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "RefundAudit",
			invSubStr: invSubStr,
			sessionStr: getSessionStr()
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: myAry[1], type: "success"});
				ordItmListObj().reload();
				return;
			}
			$.messager.popover({msg: myAry[1], type: "info"});
		});
	});
}

/**
 * �������
 */
function cancelClick() {
	var invSubStr = getCheckedInvSubStr();
	if (!invSubStr) {
		$.messager.popover({msg: "�빴ѡ��Ҫ������˵�ҽ��", type: "info"});
		return;
	}
	$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ������? ", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CancelAudit",
			invSubStr: invSubStr,
			sessionStr: getSessionStr()
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: myAry[1], type: "success"});
				ordItmListObj().reload();
				return;
			}
			$.messager.popover({msg: myAry[1], type: "info"});
		});
	});
}

/**
 * ȡ��ѡ�е�Ʊ��Id��
 */
function getCheckedInvStr() {
	return GV.InvList.getChecked().map(function(row) {
		return row.prtRowId + ":" + row.invFlag;
	}).join("^");
}

/**
 * ���Ʋ�ҩ�������˷�
 */
function ctrlMedItm(index, row) {
	var ordCateType = row.ordCateType;
	if (ordCateType != "R") {
		return;
	}
	var oeori = row.oeori;
	var prescNo = row.prescNo;
	var phdicId = row.phdicId;
	var isCNMedItem = row.isCNMedItem;    //��ҩ��ʶ(0:����; 1:��)
	var isOweDrug = row.isOweDrug;        //Ƿҩ��ʶ(0:Ƿҩ; 1:��Ƿҩ)
	
	var checked = getOrdItmRowChecked(index);
	var rows = ordItmListObj().getRows();

	//1.���Ʋ�ҩ�������˷�
	if (isCNMedItem == 1) {
		$.each(rows, function (idx, r) {
			if (index == idx) {
				return true;
			}
			if (prescNo != r.prescNo) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//2.����Ƿҩҽ���������˷�
	if (isOweDrug == 0) {
		$.each(rows, function (idx, r) {
			if (isOweDrug != r.isOweDrug) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (prescNo != r.prescNo) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//3.���ƾ�����Һҽ��
	if (checked) {
		$.each(rows, function (idx, r) {
			if (r.phdicId) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	if (!phdicId) {
		//δ��ҩ��¼ȡ����ѡʱ�����м�¼������ѡ
		$.each(rows, function (idx, r) {
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
		return;
	}
	
	//�ѷ�ҩ��ȡ����ѡʱ���ж��Ƿ���������ѡ�еķ�ҩ��¼�����ޣ���ȡ����ѡ����δ����¼
	var disp = 0;
	$.each(rows, function (idx, r) {
		if (!r.phdicId) {
			return true;
		}
		if (index == idx) {
			return true;
		}
		if (oeori != r.oeori) {
			return true;
		}
		if (getOrdItmRowChecked(idx)) {
			disp = 1;
			return false;
		}
	});
	if (disp == 1) {
		//��������ѡ�еķ�ҩ��¼ʱ���˳�
		return;
	}
	$.each(rows, function (idx, r) {
		if (r.phdicId) {
			return true;
		}
		if (index == idx) {
			return true;
		}
		if (oeori != r.oeori) {
			return true;
		}
		setOrdItmRowChecked(idx, checked);
	});
}

/**
 * ��ȡҽ����ϸdatagrid��ѡ/����ѡ״̬
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelRowIndex = index;
	if (checked) {
		ordItmListObj().checkRow(index);
	}else {
		ordItmListObj().uncheckRow(index);
	}
	GV.SelRowIndex = undefined;
}

/**
 * ��ȡ��ѡ��datagrid������
 */
function getCheckedInvSubStr() {
	return ordItmListObj().getChecked().map(function(row) {
		return row.invSubId;
	}).join("^");
}

/**
 * ����ҽ����ϸdatagrid��ѡ/����ѡ״̬
 */
function getOrdItmRowChecked(index) {
	return ordItmListObj().getPanel().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(":checked");
}

/**
 * ��ȡѡ�е�tabs����
 */
function getSelTabIndex() {
	var tabsObj = $HUI.tabs("#audit-tabs");
	return tabsObj.getTabIndex(tabsObj.getSelected());
}

/**
 * ����Ĭ�ϵ�tabs����
 */
function loadDefTabContent() {
	var index = 1;
	$HUI.tabs("#audit-tabs").select(index);   //����ѡ��
	loadOrdItmList();
}

/**
 * ��ȡ��ǰҽ����ϸgrid����
 */
function ordItmListObj() {
	return $HUI.datagrid("#ordItmList-" + getSelTabIndex());
}

/**
 * ��ȡ��ǰҽ����ϸgrid����
 */
function getTabsLength() {
	return $("table[id^='ordItmList']").length;
}

/**
 * ��ȡ��ǰtabs�µ���˱�ʶ
 */
function getAuditFlag() {
	var index = getSelTabIndex();
	var auditFlag = "";
	switch (index) {
	case 1:
		auditFlag = "U";
		break;
	case 3:
		auditFlag = "A";
		break;
	default:
	}
	return auditFlag;
}

/**
 * ��ȡҽ��������
 */
function getOrdItmColumns(index) {
	var columns = [{field: 'ck', checkbox: true},
				   {title: 'ҽ��', field: 'arcimDesc', width: 220},
				   {title: '��������', field: 'reqQty', width: 80},
				   {title: '��λ', field: 'packUom', width: 60},
				   {title: '���', field: 'reqAmt', align: 'right', width: 60},
				   {title: '������', field: 'prescNo', width: 130},
				   {title: '���տ���', field: 'recDept', width: 100},
				   {title: '������', field: 'reqUserName', width: 90},
				   {title: '����ʱ��', field: 'reqDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.reqTime;
					}
				   },
				   {title: '�˷�ԭ��', field: 'reqReason', width: 80},
				   {title: '�����', field: 'auditUserName', width: 80},
				   {title: '���ʱ��', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: 'ҽ��ID', field: 'oeori', width: 70},
				   {title: 'reqFlag', field: 'reqFlag',  hidden: true},
				   {title: 'invSubId', field: 'invSubId', hidden: true},
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: 'phdicId', field: 'phdicId', hidden: true},
				   {title: 'isCNMedItem', field: 'isCNMedItem', hidden: true},
				   {title: 'isOweDrug', field: 'isOweDrug', hidden: true}];
				   
	switch (index) {
	case 1:
		var hideColAry = ["auditUserName", "auditDate"];    //����ʾ����
		columns = columns.filter(function(item) {
			return hideColAry.indexOf(item.field) == -1;
		});
		break;
	case 2:
		columns = [{title: 'ҽ��', field: 'arcimDesc', width: 220},
				   {title: '����', field: 'billQty', width: 80},
				   {title: '��������', field: 'alreadyReqQty', width: 80},
				   {title: '��λ', field: 'packUom', width: 60},
				   {title: '���', field: 'billAmt', align: 'right', width: 60},
				   {title: '������', field: 'prescNo', width: 130},
				   {title: '���տ���', field: 'recDept', width: 100},
				   {title: 'ִ�����', field: 'execInfo', width: 160},
				   {title: '�����', field: 'auditUserName', width: 80},
				   {title: '���ʱ��', field: 'auditDate', width: 155,
					formatter: function (value, row, index) {
						return value + ' ' + row.auditTime;
					}
				   },
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: 'ҽ��ID', field: 'oeori', width: 70}]
		break;
	default:
	}
	return columns;
}

/**
 * ����
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);
	GV.InvList.load({
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindReqInvInfo",
		stDate: "",
		endDate: "",
		receiptNo: "",
		patientNo: "",
		patientName: "",
		chargeUser: "",
		sessionStr: getSessionStr()
	});
	$HUI.tabs("#audit-tabs").select(1);   //����ѡ��
	for (var i = 1, len = getTabsLength(); i <= len; i++) {
		$("#ordItmList-" + i).datagrid("loadData", {
			total: 0,
			rows: []
		});
	}
}
