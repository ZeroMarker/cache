/**
 * FileName: dhcbill.opbill.refund.main.js
 * Author: ZhYW
 * Date: 2019-04-23
 * Description: �����˷�
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initQueryMenu();
	initInvList();
	initRefundMenu();
	initOrdItmList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById("auditFlag", CV.DefAuditFlag);

	//����
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//��ҽ����
	$HUI.linkbutton("#btn-readInsuCard", {
		onClick: function () {
			readInsuCardClick();
		}
	});
	
	//��ѯ
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});
	
	//ԭ���ش�
	$HUI.linkbutton("#btn-reprt", {
		onClick: function () {
			reprtClick();
		}
	});
	
	//�����ش�
	$HUI.linkbutton("#btn-passNoReprt", {
		onClick: function () {
			passNoReprtClick();
		}
	});
	
	//����ҽ��
	$HUI.linkbutton("#btn-reInsuDivide", {
		onClick: function () {
			reInsuDivideClick();
		}
	});
	
	//�������۽���
	$HUI.linkbutton("#btn-cancleStayCharge", {
		onClick: function () {
			cancleStayChargeClick();
		}
	});
	
	//����
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//�˷�
	$HUI.linkbutton("#btn-refund", {
		onClick: function () {
			refundInvClick();
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
	if (HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$tb.click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "l" : "b";
		if (t.find(".arrows-b-text").text() == $g("����")) {
			t.find(".arrows-b-text").text($g("����"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("����"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});

	//����Ա
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPBillRefund&QueryName=FindInvUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
}

/**
 * ��ݼ�
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		readHFMagCardClick();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 119: //F8
		e.preventDefault();
		loadInvList();
		break;
	default:
	}
}

/**
 * ����
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
 * ��ҽ����
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
		var insuCardNo = insuReadAry[1];	//ҽ������
		var credNo = insuReadAry[7];	    //���֤��
		$("#CardNo").val(credNo);
		if (credNo != "") {
			DHCACC_GetAccInfo("", credNo, "", "", magCardCallback);
		}
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

/**
 * ��Ʊ�Żس���ѯ
 */
function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "CheckInvIsValid",
				recepitNo: $(e.target).val(),
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "�÷�Ʊ�Ų�����", type: "info"});
					return;
				}
				loadInvList();
			});
		}
	}
}

/**
 * ����layout�߶�
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout-panel-west .layout:eq(0)");
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
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillRefund",
		queryName: "FindOPBillINV",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate", "invDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["invRowId", "prtRowId", "invFlag", "hasRefOrd"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "userName") {
					cm[i].title = "�շ�Ա";
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.prtDate + " " + value;
					}
				}
				if (cm[i].field == "invTime") {
					cm[i].formatter = function (value, row, index) {
						return row.invDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["prtTime", "invTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			if (data.total == 1) {
				GV.InvList.selectRow(0);
			}else {
				clearRefPanel();
			}
		},
		rowStyler: function (index, row) {
			if (row.hasRefOrd == 1) {
				return "background-color:" + CV.RefInvRowBgClr + ";color:" + CV.RefInvRowClr + ";";
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function selectRowHandler(row) {
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	GV.InvRequireFlag = row.invNo ? "Y" : "N";     //���д�ӡ��Ʊ����ͨ�˷ѽ��沿���˷�ʱ��Ҳ��Ҫ��ӡ��Ʊ
	
	if ((invFlag == "API") && prtRowId) {      //���д�ӡ��Ʊ�Զ�����ʱ��С����ѯ��Ʊ��Ϣ
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	
	//+2022-03-29 ZhYW �ж��Ƿ�����ֱ���˷���ˣ�����"�����˷Ѱ�ȫ�˺����շѽ�������"ʱ�����������
	GV.IsDirRefAudited = (CV.IsRefedReChrg == 1) ? CV.IsRefedReChrg : isDirectRefAudit(invRowId, invFlag);
	if (GV.IsDirRefAudited == 1) {
		//ֱ���˷���˹��ķ�Ʊ��ȫ���˷ѣ��˷ѽ��ȡ��Ʊ���Ը����
		setValueById("refundAmt", row.patShareAmt);
		setValueById("factRefundAmt", row.patShareAmt);
	}
	
	loadOrdItmList();
	
	var invStr = invRowId + ":" + invFlag;
	getPaymList(invStr);
	getReceiptInfo(invStr);
}

/**
* ��ȡ֧����ʽ��Ϣ
*/
function getPaymList(invStr) {
	$.m({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetInvPayModeList",
		invStr: invStr
	}, function(rtn) {
		if (!rtn) {
			return;
		}
		var invPMAry = rtn.split("#");
		setValueById("invPayment", ((invPMAry[0] > 1) ? "Y" : "N"));
		var paymAry = invPMAry[1] ? invPMAry[1].split("^") : [];
		var myPMAry = [];
		var paymHtml = "<table>";
		$.each(paymAry, function (index, item) {
			myPMAry = item.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
			paymHtml += "<tr>";
			paymHtml += "<td class='paym-desc'>";
			paymHtml += myPMAry[0] + "��";
			paymHtml += "</td>";
			paymHtml += "<td class='paym-amt'>";
			paymHtml += myPMAry[1];
			paymHtml += "</td>";
			paymHtml += "</tr>";
		});
		paymHtml += "</table>";
		$("#paymList").html(paymHtml);
	});
}

/**
* ��ȡƱ����Ϣ
*/
function getReceiptInfo(invStr) {
	$.cm({
		ClassName: "web.DHCOPBillRefund",
		MethodName: "GetReceiptInfo",
		invStr: invStr,
		userId: PUBLIC_CONSTANT.SESSION.USERID
	}, function (json) {
		if (!json) {
			return;
		}
		disablePageBtn();
		setValueById("patientId", json.patientId);
		setValueById("accMRowId", json.accMRowId);
		setValueById("accMLeft", json.accMLeft);
		setValueById("insTypeId", json.insTypeId);
		setValueById("insuDivId", json.insuDivId);
		setValueById("stayInvFlag", json.stayInvFlag);
		setValueById("insuPayAmt", json.insuPayAmt);
		setValueById("refBtnFlag", json.refBtnFlag);
		setValueById("autoFlag", json.autoFlag);
		
		loadNewInsType(json.insTypeId);
		loadInsuCombo(json.insTypeId);  //����ҽ����𡢲���
				
		loadRefundModeData(json.invPaymDR);   //2022-09-14 ZhYW �����˷ѷ�ʽ
		
		if (json.prtFlag != "N") {
			var msg = "�ü�¼��" + ((json.prtFlag == "A") ? "����" : ((json.prtFlag == "S") ? "���" : ""));
			$.messager.popover({msg: msg, type: "info"});
			return;
		}

		if (!json.insuDivId) {
			enableById("btn-reInsuDivide");
		}
		enableById("btn-reprt");
		enableById("btn-passNoReprt");
		
		if (json.stayInvFlag == "Y") {
			enableById("btn-cancleStayCharge");
			return;    //�������۵ĳ������۽�������½��㣬�����ڴ��˷�
		}
		
		if (json.writeOffFlag == "Y") {
			disableById("btn-reInsuDivide");   //�ǿ�֧���Ĳ��ܲ���ҽ���ӿ�
			$.messager.alert("��ʾ", "�����˷ѣ����ȳ������д�ӡ��Ʊ", "info");
			return;    //�賷�����д�ӡ��Ʊ�ģ������ڴ��˷�
		}
		
		switch(json.refBtnFlag) {
		case "A":
			if (CV.AbortFlag != 1) {
				$.messager.popover({msg: "�ð�ȫ��û������Ȩ�ޣ����顾��ȫ�鹦�����á�", type: "info"});
			}else {
				enableById("btn-refund");
			}
			break;
		case "S":
			if (CV.RefundFlag != 1) {
				$.messager.popover({msg: "�ð�ȫ��û�к��Ȩ�ޣ����顾��ȫ�鹦�����á�", type: "info"});
			}else {
				enableById("btn-refund");
			}
			break;
		default:
		}
	});
}

/**
* �����·ѱ�
*/
function loadNewInsType(insTypeId) {
    $.cm({
        ClassName: "web.DHCOPCashier",
        QueryName: "QryChgInsTypeList",
        ResultSetType: "array",
        insTypeId: insTypeId,
        hospId: PUBLIC_CONSTANT.SESSION.HOSPID
    }, function (data) {
        if (insTypeId && !$.hisui.getArrayItem(data, "insTypeId", insTypeId)) {
            var jsonObj = getPersistClsObj("User.PACAdmReason", insTypeId);
            var insType = $.m({ClassName: "User.PACAdmReason", MethodName: "GetTranByDesc", Prop: "READesc", Desc: jsonObj.READesc, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
            var item = {insType: insType, insTypeId: insTypeId, admSource: jsonObj.REAAdmSource, selected: true};
            $.hisui.addArrayItem(data, "insTypeId", item);
        }
      	$("#newInsType").combobox("clear").combobox("loadData", data);
    });
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOPBillINV",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("guser"),
		receiptNo: getValueById("invNo"),
		patientNo: getValueById("patientNo"),
		auditFlag: getValueById("auditFlag") ? 1 : 0,
		sessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

/**
* ��ʼ���˷����
*/
function initRefundMenu() {
	$("#item-tip").show();   //��ʾ֧����Ϣ
	
	//�˷ѷ�ʽ
	$("#refundMode").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc'
	});
	
	$("#newInsType").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'insTypeId',
		textField: 'insType',
		onSelect: function(rec) {
			loadInsuCombo(rec.insTypeId);
		}
	});
	
	//ҽ�����
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'cCode',
		textField: 'cDesc',
		blurValidValue: true,
		defaultFilter: 5
	});

	//����
	$HUI.combobox("#insuDic", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'DiagCode',
		textField: 'DiagDesc',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initOrdItmList() {
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		title: 'ҽ����ϸ',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: [],
		className: "web.DHCOPBillRefund",
		queryName: "FindOrdItm",
		frozenColumns: [[{field: 'ck', checkbox: true},
		           		 {title: 'ҽ��', field: 'arcimDesc', width: 180,
			           	  	formatter: function (value, row, index) {
								if (row.cantRefReason) {
									return "<a onmouseover='showCantRefReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
								}
								return value;
						  	}
		           		 }
			]],
		onColumnsLoad: function(cm) {
			cm.unshift({title: '�˷Ѳ�λ', field: 'repPartTar', align: 'center'});   //�����鿪ʼλ������һ��
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["arcimDesc", "packUom", "cantRefReason"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["refQty", "refAmt", "auditFlag", "disabled", "select", "isAppRep", "isCNMedItem", "pboRowId", "prtId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "repPartTar") {
					cm[i].formatter = function (value, row, index) {
						//������뵥ȫ��ִ��ʱ������
						if ((row.isAppRep == "Y") && (row.disabled == "N")) {
							return "<a href='javascript:;' class='editCls' onclick='openPartWinOnClick(" + index + ")'></a>";
						}
					};
				}
				if (cm[i].field == "billQty") {
					cm[i].title = "����/��λ";
					cm[i].formatter = function (value, row, index) {
						return value + "/" + row.packUom;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "repPartTar") {
						cm[i].width = 80;
					}
					if (cm[i].field == "prescNo") {
						cm[i].width = 130;
					}
					if (cm[i].field == "execInfo") {
						cm[i].width = 160;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(".editCls").linkbutton({text: $g("��λ")});
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.disabled == "Y") {
					hasDisabledRow = true;
					GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
					if (row.select == 1) {
						GV.OEItmList.checkRow(index);
					}
				}
			});
			//��disabled��ʱ����ͷҲdisabled
			GV.OEItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onCheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			if (!canCheck(row)) {
				GV.OEItmList.uncheckRow(index);
			} else {
				controlCNMedItm(index, row);
				calcRefAmt();
			}
		},
		onUncheck: function (index, row) {
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			controlCNMedItm(index, row);
			calcRefAmt();
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (!canCheck(row)) {
					GV.OEItmList.uncheckRow(index);
				}
			});
			calcRefAmt();
		},
		onUncheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if ((row.disabled == "Y") && (row.select == 1)) {
					GV.OEItmList.checkRow(index);
				}
			});
			calcRefAmt();
		}
	});
}

/**
 * �ж����ܷ񱻹�ѡ
 */
function canCheck(row) {
	if (row.select == 1) {
		return true;
	}
	if (row.disabled == "Y") {
		return false;
	}
	if ((row.isAppRep == "Y") && !row.refRepPart) {
		return false;
	}
	return true;
}

/**
* �°������뵥��ȡ��λ
*/
function openPartWinOnClick(index) {
	var invRow = GV.InvList.getSelected();
	if (!invRow) {
		return;
	}
	var prtFlag = "";
	if (invRow.invFlag == "API") {
		prtFlag = getPropValById("DHC_AccPayINV", invRow.invRowId, "API_Flag");
	}else {
		prtFlag = getPropValById("DHC_INVPRT", invRow.invRowId, "PRT_Flag");
	}
	if (prtFlag != "N") {
		var msg = "�÷�Ʊ��" + ((prtFlag == "A") ? "����" : ((prtFlag == "S") ? "���" : "")) + "������ѡ��λ";
		$.messager.popover({msg: msg, type: "info"});
		return;
	}
	
	var row = GV.OEItmList.getRows()[index];
	var oeori = row.oeori;
	var pboRowId = row.pboRowId;
	var oldRefRepPart = row.refRepPart || "";   //�Ѿ���ѡ�Ĳ�λ
	var url = "dhcapp.repparttarwin.csp?oeori=" + oeori + "&refRepPart=" + oldRefRepPart;
	websys_showModal({
		url: url,
		title: '��λ�б�',
		width: 640,
		height: 400,
		callBackFunc: function(rtnValue) {
			var arReqItmIdStr = rtnValue.split("!!").map(function (item) {
			        return item.split("^")[0];
			    }).join("!!");
			row.refRepPart = arReqItmIdStr;    //�ಿλ������뵥�˷Ѳ�λRowId��
	
			if (arReqItmIdStr != "") {
				var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "UpdateExaReqFlag", oeitm: oeori, arReqItmIdStr: arReqItmIdStr}, false);
				if (rtn != 0) {
					$.messager.popover({msg: "���¼�����벿λ���˷�����״̬ʧ�ܣ�" + rtn, type: "error"});
					return;
				}
			}
			
			setOrdItmRowChecked(index, (arReqItmIdStr != ""));
			
			//�°������뵥ȫ��/�����˱�ʶ
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "IsAllRefundRepPart",
				oeitm: oeori
			}, function(refPartFlag) {
				GV.OEItmList.setFieldValue({index: index, field: "refQty", value: refPartFlag});   //0:ȫ����δ�ˣ�1:������
			});
			
			//���㰴��λ�˷ѽ��
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "GetRepPartRefAmt",
				oeitm: oeori,
				pbo: pboRowId,
				arReqItmIdStr: arReqItmIdStr
			}, function (repPartAmt) {
				GV.OEItmList.setFieldValue({index: index, field: "refAmt", value: repPartAmt});
				calcRefAmt();
			});
		}
	});
}

/**
 * �����˷ѽ��
 */
function calcRefAmt() {
	var refSum = GV.OEItmList.getChecked().reduce(function (total, row) {
        return Number(total).add(row.refAmt).toFixed(2);
    }, 0);
    setValueById("ordRefundAmt", refSum);   //ҽ���˷ѽ��
    //+2022-03-29 ZhYW ֱ���˷���˹��ķ�Ʊ��ȫ���˷ѣ��˷ѽ���Ҫ����ҽ������
	if (GV.IsDirRefAudited == 0) {
		setValueById("refundAmt", refSum);
		setValueById("factRefundAmt", refSum);
	}
}

function loadOrdItmList() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invStr = row.invRowId + ":" + row.invFlag;
	var queryParams = {
		ClassName: "web.DHCOPBillRefund",
		QueryName: "FindOrdItm",
		invStr: invStr,
		rows: 999999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * ���Ʋ�ҩ�������˷�
 */
function controlCNMedItm(index, row) {
	var prescNo = row.prescNo;
	var isCNMedItem = row.isCNMedItem;
	if ((prescNo == "") || (isCNMedItem != 1)) {
		return;
	}
	var rows = GV.OEItmList.getRows();
	$.each(rows, function (idx, row) {
		if ((index == idx) || (prescNo != row.prescNo)) {
			return true;
		}
		setOrdItmRowChecked(idx, getOrdItmRowChecked(index));
	});
}

/**
 * ����ҽ����ϸdatagrid��ѡ/����ѡ״̬
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelOrdRowIdx = index;
	if (checked) {
		GV.OEItmList.checkRow(index);
	} else {
		GV.OEItmList.uncheckRow(index);
	}
	delete GV.SelOrdRowIdx;
}

/**
 * ��ȡҽ����ϸdatagrid��ѡ/����ѡ״̬
 */
function getOrdItmRowChecked(index) {
	return GV.OEItmList.getPanel().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(":checked");
}

/**
* ԭ���ش�
*/
function reprtClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReprt();
	}else {
		invReprt();
	}
}

/**
* �����ش�
*/
function passNoReprtClick() {
	var _validate = function() {
		return new Promise(function(resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				$.messager.popover({msg: "��ѡ����Ҫ�����ش�ķ�Ʊ��¼", type: "info"});
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			invNo = row.invNo;
			if (!invNo) {
				$.messager.popover({msg: "û�д�ӡ��Ʊ�����ܹ����ش�", type: "info"});
				return reject();
			}
			var prtFlag = "";
			var prtUserDR = "";
			var prtReportsDR = "";
			if (invFlag == "API") {
				var jsonObj = getPersistClsObj("User.DHCAccPayINV", invRowId);
				prtFlag = jsonObj.APIFlag;
				prtUserDR = jsonObj.APIPUserDR;
				prtReportsDR = jsonObj.APIINVRepDR;
			}else {
				var jsonObj = getPersistClsObj("User.DHCINVPRT", invRowId);
				prtFlag = jsonObj.PRTFlag;
				prtUserDR = jsonObj.PRTUsr;
				prtReportsDR = jsonObj.PRTDHCINVPRTRDR;
			}
			if (prtFlag != "N") {
				$.messager.popover({msg: "�÷�Ʊ���˷ѣ����ܹ����ش�", type: "info"});
				return reject();
			}
			if (prtUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "�������˴�ӡ�ķ�Ʊ�����ܹ����ش�", type: "info"});
				return reject();
			}
			if (prtReportsDR > 0) {
				$.messager.popover({msg: "�����ս�ķ�Ʊ�����ܹ����ش�", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function(resolve, reject) {
			$.messager.confirm("ȷ��", $g("�Ƿ�ȷ�Ͻ���Ʊ") + "��<font color='red'>" + invNo + "</font>��" + $g("�����ش�? "), function(r) {
				return r ? resolve() : reject();
			});
		});
	};

	/**
	 * �����ش�
	*/
	var _passRePrint = function() {
		return new Promise(function(resolve, reject) {
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "PassNoRePrint",
				invRowId: invRowId,
				invFlag: invFlag,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "�����ش�ɹ�", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "�����ش�ʧ��: " + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};

	/**
	* �����ش�ɹ����ӡ��Ʊ
	*/
	var _success = function () {
		if (invFlag == "API") {
			accPInvPrint(invRowId);
		}else {
			billPrintTask(invRowId);
		}
	};

	if ($("#btn-passNoReprt").linkbutton("options").disabled) {
		return;
	}
	$("#btn-passNoReprt").linkbutton("disable");
	
	var invRowId = "";
	var invFlag = "";
	var invNo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_passRePrint)
		.then(function() {
			_success();
			$("#btn-passNoReprt").linkbutton("enable");
		}, function () {
			$("#btn-passNoReprt").linkbutton("enable");
		});
}

/**
* ����ҽ��
*/
function reInsuDivideClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (invFlag == "API") {
		accInvReInsuDivide();
	}else {
		invReInsuDivide();
	}
}

/**
* �������۽���
*/
function cancleStayChargeClick() {
	if ($("#btn-cancleStayCharge").hasClass("l-btn-disabled")) {
		return;
	}
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //���д�ӡ��Ʊ�Զ�����ʱ��С���˷ѣ����˷ѳ����г������д�ӡ��Ʊ
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "PRT") {
		cancleStayCharge();
	}
}

/**
 * ����
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f").combobox("clear");
	$("#refundMode").combobox("loadData", []);
	$("#guser").combobox("reload");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById("auditFlag", CV.DefAuditFlag);
	GV.InvList.options().pageNumber = 1;   //��ת����һҳ
	GV.InvList.loadData({total: 0, rows: []});
	clearRefPanel();
}

/**
 * ����˷�Panel����
 */
function clearRefPanel() {
	$(".combobox-f:not(#guser,#refundMode)").combobox("clear").combobox("loadData", []);
	$(".numberbox-f").numberbox("setValue", 0);
	$("#refundMode").combobox("clear").combobox("loadData", []);
	$("#paymList").html("");
	$(".datagrid-f:not(#invList)").datagrid("loadData", {
		total: 0,
		rows: []
	});
	disablePageBtn();
}

/**
* ����/���
*/
function refundInvClick() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	if ((invFlag == "API") && prtRowId) {    //���д�ӡ��Ʊ�Զ�����ʱ��С���˷ѣ����˷ѳ����г������д�ӡ��Ʊ
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId) {
		return;
	}
	if (invFlag == "API") {
		accInvRefSaveInfo();
	}else {
		invRefSaveInfo();
	}
}

function disablePageBtn() {
	disableById("btn-refund");
	disableById("btn-reprt");
	disableById("btn-passNoReprt");
	disableById("btn-reInsuDivide");
	disableById("btn-cancleStayCharge");
}

/**
* ����ҽ����𡢲���
*/
function loadInsuCombo(insTypeId) {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invFlag = row.invFlag;
	if ((invFlag == "API") && row.prtRowId) {
		invFlag = "PRT";
	}
	var CPPFlag = (invFlag == "API") ? "Y" : "";
	var strikeFlag = "S";
	var insuDivId = getValueById("insuDivId");
	var expStr = "OP" + "^" + CPPFlag + "^" + strikeFlag + "^" + insuDivId;
	//ҽ�����
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryMedType&ResultSetType=array&AdmReaId=" + insTypeId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;  
	$("#insuAdmType").combobox("clear").combobox("reload", url);
	
	//����
	var patientId = getValueById("patientId");
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryChronic&ResultSetType=array&AdmReaId=" + insTypeId + "&PapmiDr=" + patientId + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID + "&ExpStr=" + expStr;
	$("#insuDic").combobox("clear").combobox("reload", url);
}

/**
* ��ܽ��ʾ�����˷�ԭ��
*/
function showCantRefReason($this, row) {
	if (GV.IsDirRefAudited == 1) {
		return;   //����ֱ���˷���˵Ĳ���ʾ�����˷�ԭ��
	}
	$($this).popover({
		title: '<font color="#FF0000">' + row.arcimDesc + '</font>' + $g("�����˷�ԭ��"),
		trigger: 'hover',
		content: row.cantRefReason
	}).popover("show");
}

function getRefInfoHTML(invStr) {
	var html = "";
	var jsonObj = $.cm({ClassName: "web.DHCOPBillRefund", MethodName: "GetRefundInfo", invStr: invStr}, false);
	if ((jsonObj.code == 0) && (jsonObj.refPatSum != 0)) {
		setValueById("factRefundAmt", jsonObj.refSelfSum);
		
		html += "<p class=\"fail-Cls\">" + "�˷ѽ��Ϊ��" + jsonObj.refPatSum + "Ԫ</p>";
		if (jsonObj.refmodeStr) {
			var begSign = "";
			var endSign = "";
			var refmodeAry = jsonObj.refmodeStr.split(",");
			$.each(refmodeAry, function(index, item) {
				begSign = (index == 0) ? "��" : "";
				endSign = (index == (refmodeAry.length - 1)) ? "��" : "";
				item = item.replace(/��/, "<a class=\"succ-Cls\">��</a>") + "Ԫ";
				html += "<p class=\"fail-Cls\">" + begSign + item + endSign + "</p>";
			});
		}
	}
	return html;
}

/**
* ��ȡ�˻����
*/
function getAccMLeft() {
	var accMRowId = getValueById("accMRowId");
	return (accMRowId > 0) ? $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false) : "";
}

/**
* �ж��Ƿ�������˵�δ����ִ�еĲ����˷�ҽ��
*/
function hasNoCancelAuditOrd() {
	var bool = false;
	$.each(GV.OEItmList.getRows(), function (index, row) {
		if (row.auditFlag != "Y") {
			return true;
		}
		if (row.disabled != "Y") {
			return true;
		}
		if (getOrdItmRowChecked(index)) {
			return true;
		}
		bool = true;
		return false;
	});
	return bool;
}

/**
* �ж��Ƿ�����ֱ���˷����
*/
function isDirectRefAudit(invId, invType) {
	return $.m({ClassName: "BILL.OP.BL.DirectRefundAudit", MethodName: "CheckIsAudited", invId: invId, invType: invType}, false)
}

/**
* ��"�˷�"��ťʱ���ж��Ƿ��ǹ����ش�
*/
function isPassNoReChg() {
	if (GV.ReBillFlag == 0) {
		return false;
	}
	if (GV.OEItmList.getChecked().length > 0) {
		return false;
	}
	return true;
}

/**
* 2022-09-14
* ZhYW
* ��ȡ�����˷ѷ�ʽcombobox��url
*/
function loadRefundModeData(paymId) {
	$.cm({
		ClassName: "web.UDHCOPGSConfig",
		QueryName: "QryGSContraRefPMList",
		ResultSetType: "array",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID,
		TypeFlag: "REF",
		CfgCode: "OPCHRG.OPRefd.TFZFFSYSFZFFSDZ",
		PayMID: paymId
	}, function(data) {
		$("#refundMode").combobox("loadData", data);
	});
};

/**
* 2022-11-22
* ZhYW
* ҽ���շѿ����Ƿ����˷�
*/
function isAllowedRefInsuDiffMth(invId, invType) {
	return ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedRefInsuDiffMth", prtRowId: invId, invType: invType}, false) == 1);
}

/**
* 2023-04-04
* ZhYW
* ҽ��סԺ�����Ƿ��������ﲿ���˷�
*/
function isAllowedIPPatPartRef(patientId) {
	return ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedIPPatPartRef", patientId: patientId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}
