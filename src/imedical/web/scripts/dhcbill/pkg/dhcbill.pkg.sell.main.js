/**
 * FileName: dhcbill.pkg.sell.main.js
 * Anchor: ZhYW
 * Date: 2019-09-23
 * Description: �ײͶ���
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMinAmount: {    //У��ʵ����������Ƿ��������ۼ�
	    validator: function(value) {
		    return +value >= +GV.MinAmount;
		},
		message: '����С������������'
	},
	checkMaxAmount: {    //У��ʵ����������Ƿ��������ۼ�
	    validator: function(value) {
		    return +value <= +getValueById("totalAmt");
		},
		message: '���ܴ�������������'
	}
});

var GV = {
	MinAmount: 0,
	BalanceAmt: "",
	EditIndex: undefined
};
	
$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e)
	});
	initQueryMenu();
	initProductList();
	initPkgInvList();
});

function frameEnterKeyCode(e) {
	var key = websys_getKey(e)
	switch(key){
	case 120 : 
		sellClick();
		break;
	default:		
   }	
}

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//����
	$HUI.linkbutton("#btn-sell", {
		onClick: function () {
			sellClick();
		}
	});
	
	//Ȩ����ά��
	$HUI.linkbutton("#btn-setHolder", {
		onClick: function () {
			setHolderClick();
		}
	});
	
	//���Żس���ѯ�¼�
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$("#discRate").keydown(function (e) {
		discRateKeydown(e);
	});
	
	$("#salesAmt").keydown(function (e) {
		salesAmtKeydown(e);
	});
	
	$("#ss").searchbox({ 
		searcher: function(value, name) {
			loadProductList();
		}
	});

	//��������
	$HUI.combobox("#patType", {
		panelHeight: 'auto',
		data: [{value: 'OP', text: '����', selected: true},
			   {value: 'EP', text: '����'},
			   {value: 'PE', text: '���'},
			   {value: 'IP', text: 'סԺ'}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		onSelect: function(rec) {
			GV.ProductList.options().singleSelect = (rec.value == 'IP');
			loadProductList();
		}
	});
	
	//������
	$HUI.combobox("#cardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox("getValue");
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
}

/**
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
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
		$.messager.popover({msg: e.message, type: "info"});
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
			getPatDetail(myAry[4]);
			break;
		case "-200":
			$.messager.alert("��ʾ", "����Ч", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatDetail(myAry[4]);
			break;
		default:
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
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
				myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
			}
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatDetail(myAry[4]);
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("��ʾ", "����Ч", "info", function () {
						focusById("cardNo");
					});
				}, 10);
				break;
			case "-201":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatDetail(myAry[4]);
				break;
			default:
			}
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
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
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: patientNo
		}, function(patientNo) {
			setValueById("patientNo", patientNo);
			var expStr = "";
			$.m({
				ClassName: "web.DHCOPCashierIF",
				MethodName: "GetPAPMIByNo",
				PAPMINo: patientNo,
				ExpStr: expStr
			}, function(papmi) {
				if (!papmi) {
					setValueById("patientId", papmi);
					$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
					focusById("patientNo");
				}else {
					getPatDetail(papmi);
				}
			});
		});
	}
}

function getPatDetail(papmi) {
	setValueById("patientId", papmi);
	if (papmi) {
		refreshBar(papmi, "");
	}
}

function initProductList() {
	//�ײ���
	$HUI.combobox("#pkgGroup", {
		panelHeight: 150,
		url: $URL + '?ClassName=BILL.PKG.BL.PackageGroup&QueryName=QueryPackageGroup&ResultSetType=array&KeyWords=&ActStatus=1&HospDr=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		method: 'get',
		valueField: 'Id',
		textField: 'Desc',
		defaultFilter: 4,
		onSelect: function(rec) {
			loadProductList();
		}
	});
	
	//�Ƿ���������
	$("#indepPricing").checkbox({
		onCheckChange: function(e, value) {
			if (value) {
				enableById("salesAmt");
				enableById("discRate");
			}else {
				disableById("salesAmt");
				disableById("discRate");
			}
			loadProductList();
		}
	});
	
	GV.ProductList = $HUI.datagrid("#productList", {
		fit: true,
		striped: true,
		title: '�ײͲ�Ʒ',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		rownumbers: false,
		pageSize: 999999999,
		toolbar: '#tToolBar',
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: [[{title: 'Rowid', field: 'Rowid', hidden: true},
				   {title: '��Ʒ��ϸ', field: 'detail', width: 80, align: 'center',
					formatter:function(value, row, index) {
						return "<img class='myTooltip' title='��Ʒ��ϸ' onclick=\"proDtlClick('" + row.Rowid + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' style='border:0px;cursor:pointer'>";
					}
      			   },
				   {title: '��Ʒ����', field: 'PROName', width: 100},
				   {title: '��׼����', field: 'PROPrice', align: 'right', width: 80},
				   {title: '�ۼ�', field: 'PROSalesPrice', align: 'right', width: 80},
				   {title: '����ۼ�', field: 'PROMimuamout', align: 'right', width: 80},
				   {title: '�Ƿ���', field: 'PROIsshare', width: 80,
				   	formatter: function(value, row, index) {
					   	return (+value == 1) ? '<font color="#21ba45">��</font>' : '<font color="#f16e57">��</font>';
					}
				   },
				   {title: '�Ƿ���������', field: 'PROIndependentpricing', width: 100,
				   	formatter: function(value, row, index) {
					   	return (+value == 1) ? '<font color="#21ba45">��</font>' : '<font color="#f16e57">��</font>';
					}
				   }
			]],
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
			$('.myTooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({});
				}
			});
		},
		onCheck: function (rowIndex, rowData) {
			checkProListHandler();
		},
		onUncheck: function (rowIndex, rowData) {
			checkProListHandler();
		},
		onCheckAll: function (rows) {
			checkProListHandler();
		},
		onUncheckAll: function (rows) {
			checkProListHandler();
		}
	});
	GV.ProductList.loadData({total: 0, rows: []});
}

function proDtlClick(productId) {
	websys_showModal({
		url: 'dhcbill.pkg.prodetails.csp?&ProductId=' + productId,
		title: '��Ʒ��ϸ',
		iconCls: 'icon-w-list'
	});
}

function initPkgInvList() {
	GV.PkgInvList = $HUI.datagrid("#pkgInvList", {
		fit: true,
		striped: true,
		title: '�����б�',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		autoRowHeight: false,
		rownumbers: true,
		toolbar: [],
		pageSize: 99999999,
		columns: [[{title: '��������', field: 'PatName', width: 70},
				   {title: 'Ʊ�ݽ��', field: 'Acount', align: 'right', width: 70},
				   {title: '����ʱ��', field: 'PrtDate', width: 150,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.PrtTime;
					}
				   },
				   {title: '�վݺ�', field: 'PRTInv', width: 100},
				   {title: '��������', field: 'PatTypeDesc', width: 70},
				   {title: '������', field: 'BillNumber', width: 120},
				   {title: '�������', field: 'BillTotalAmt', align: 'right', width: 100},
				   {title: '�����ۿ۽��', field: 'BillTotalDiscAmt', align: 'right', width: 100},
				   {title: '����ʵ�ս��', field: 'BillTotalPayAmt', align: 'right', width: 100},
				   {title: '����Ա', field: 'CreatUser', width: 70},
				   {title: '������', field: 'BuyUser', width: 100},
				   {title: '�����˵绰', field: 'BuyTelePhone', width: 100},
				   {title: '�����˵�λ', field: 'BuyWork', width: 100}
			]]
	});
}

function loadProductList() {
	var queryParams = {
		ClassName: "BILL.PKG.BL.Product",
		QueryName: "QueryProduct",
		KeyWords: $("#ss").searchbox("getValue"),
		Status: 10,
		PkgDr: getValueById("pkgGroup"),
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID,
		StDate: "",
		EdDate: "",
		UserDr: "",
		PLevel: "",
		Issellseparately: "",
		IsIndependentpricing: getValueById("indepPricing") ? 1 : 0,
		Isshare: "",
		Type: getValueById("patType"),
		PdType: "Bill",
		rows: 99999999
	}
	loadDataGridStore("productList", queryParams);
}

function checkProListHandler() {
	GV.MinAmount = 0;
	var totalAmt = 0;
	var salesAmt = 0;
	$.each(GV.ProductList.getChecked(), function(index, row) {
		totalAmt += +row.PROPrice;
		salesAmt += +row.PROSalesPrice;
		GV.MinAmount += +row.PROMimuamout || +row.PROSalesPrice;
	});	
	setValueById("totalAmt", totalAmt.toFixed(2));
	setValueById("salesAmt", salesAmt.toFixed(2));
	setValueById("minSalesAmt", GV.MinAmount.toFixed(2));
	var discAmt = (getValueById("totalAmt") - getValueById("salesAmt")).toFixed(2);
	setValueById("discAmt", discAmt);
}

function sellClick() {
	if (!checkData()) {
		return;
	}
	var patientId = getValueById("patientId");
	if (!patientId) {
		$.messager.popover({msg: "�ͻ�������", type: "info"});
		return;
	}
	var productStr = getCheckedProIdStr();
	if (!productStr) {
		$.messager.popover({msg: "�빴ѡ��Ҫ������ײͲ�Ʒ", type: "info"});
		return;
	}
	$("#paymWin").show();
	$("#paymWin").dialog({
		iconCls: 'icon-w-inv',
		title: '����',
		draggable: false,
		modal: true,
		onBeforeOpen: function() {
			$("#paymWin").form("clear");
			setValueById("winTotalAmt", getValueById("totalAmt"));
			var payAmt = getValueById("salesAmt") || (getValueById("discRate") * getValueById("totalAmt")).toFixed(2);
			setValueById("winPayAmt", payAmt);
			var discAmt = (getValueById("winTotalAmt") - getValueById("winPayAmt")).toFixed(2);
			setValueById("winDiscAmt", discAmt);
			initPaymWinMenu();
			initPayMList();
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			$.messager.popover({msg: "������<font color=red>" + $(this).parent().prev().text() + "</font>", type: "info"});
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return bool;
	}

	var buyTelePhone = getValueById("buyTelePhone");
	if (!DHCC_IsTelOrMobile(buyTelePhone)) {
		$.messager.popover({msg: "�����˵绰���벻��ȷ", type: "info"});
		focusById("buyTelePhone");
		return false;
	}
	return true;
}

function getCheckedProIdStr() {
	var myAry = [];
	$.each(GV.ProductList.getChecked(), function (index, row) {
		myAry.push(row.Rowid);
	});
	var rowIdStr = myAry.join("^");
	return rowIdStr;
}

function discRateKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var discRate = $(e.target).val();
		if (!discRate) {
			return;
		}
		setValueById("discRate", discRate);  //numberbox ��ʧȥ����ʱ����ܻ�ȡ��ֵ������������丳ֵ�Ա���ȡ��
		setValueById("salesAmt", (discRate * getValueById("totalAmt")).toFixed(2));
		var discAmt = getValueById("totalAmt") - getValueById("salesAmt");
		setValueById("discAmt", discAmt.toFixed(2));
	}
}

function salesAmtKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var salesAmt = $(e.target).val();
		if (!salesAmt) {
			return;
		}
		var discAmt = getValueById("totalAmt") - salesAmt;
		setValueById("discAmt", discAmt.toFixed(2));
	}
}

function loadPkgInvList(prtRowId) {
	var queryParams = {
		ClassName: "BILL.PKG.BL.InvPrt",
		QueryName: "FindInvInfo",
		PatDr: "",
		PrtRowId: prtRowId,
		Hospital: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999999
	}
	loadDataGridStore("pkgInvList", queryParams);
}

/**
* Ȩ���˹���
*/
function setHolderClick() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		$.messager.popover({msg: "�ͻ�������", type: "info"});
		return;
	}
	$.m({
		ClassName: "BILL.PKG.BL.OrderSharer",
		MethodName: "CheckPatHasSharePro",
		patientId: patientId,
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.popover({msg: "û�й����ײͣ����ܹ���", type: "info"});
			return;
		}
		var url = "dhcbill.pkg.ordersharer.csp?&PatientId=" + patientId;
		websys_showModal({
			url: url,
			title: 'Ȩ����ά��',
			iconCls: 'icon-w-list',
			width: '96%',
			height: '80%'
		});
	});
}