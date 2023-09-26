/**
 * FileName: dhcbill.pkg.ordersharer.js
 * Anchor: ZhYW
 * Date: 2019-10-14
 * Description: ����Ȩ����ά��
 */
 
var GV = {
	EndRowIndex: 0,
	PatientId: getParam("PatientId")
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initSharerList();
	initPatPkgTreeList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard, #btn-shareSeadCard", {
		onClick: function () {
			readHFMagCardClick($(this)[0].id);
		}
	});
	
	//���Żس���ѯ�¼�
	$("#cardNo, #shareCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo, #sharePatientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//������
	$HUI.combobox("#cardType, #shareCardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox("getValue");
			initReadCard(cardType, $(this)[0].id);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType, $(this)[0].id);
		}
	});

	if (GV.PatientId) {
		getPatDetail(GV.PatientId);
		var patAry = setPatNameById(GV.PatientId);
		setValueById("patientNo", patAry[1]);
	}
}

/**
 * ��ʼ��������ʱ���źͶ�����ť�ı仯
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType, id) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			if (id == "cardType") {
				disableById("btn-readCard");
				$("#cardNo").attr("readOnly", false);
				focusById("cardNo");
			}else {
				disableById("btn-shareSeadCard");
				$("#shareCardNo").attr("readOnly", false);
				focusById("shareCardNo");
			}
		} else {
			if (id == "cardType") {
				enableById("btn-readCard");
				setValueById("cardNo", "");
				$("#cardNo").attr("readOnly", true);
				focusById("btn-readCard");
			}else {
				enableById("btn-shareSeadCard");
				setValueById("shareCardNo", "");
				$("#shareCardNo").attr("readOnly", true);
				focusById("btn-shareSeadCard");
			}
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
function readHFMagCardClick(id) {
	if ($("#" + id).linkbutton("options").disabled) {
		return;
	}
	try {
		var cardType = (id == "btn-readCard") ? getValueById("cardType") : getValueById("shareCardType");
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
			if (id == "btn-readCard") {
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatDetail(myAry[4]);
			}else {
				setValueById("shareCardNo", myAry[1]);
				setValueById("sharePatientId", myAry[4]);
				setValueById("sharePatientNo", myAry[5]);
				var patAry = setPatNameById(myAry[4]);
				setValueById("sharePatName", patAry[2]);
			}
			break;
		case "-200":
			$.messager.alert("��ʾ", "����Ч", "info", function () {
				if (id == "btn-readCard") {
					focusById("btn-readCard");
				}else {
					focusById("btn-shareSeadCard");
				}
			});
			break;
		case "-201":
			if (id == "btn-readCard") {
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatDetail(myAry[4]);
			}else {
				setValueById("shareCardNo", myAry[1]);
				setValueById("sharePatientId", myAry[4]);
				setValueById("sharePatientNo", myAry[5]);
				var patAry = setPatNameById(myAry[4]);
				setValueById("sharePatName", patAry[2]);
			}
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
			var cardNo = getValueById(e.target.id);
			if (!cardNo) {
				return;
			}
			var cardType = (e.target.id == "cardNo") ? getValueById("cardType") : getValueById("shareCardType");
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
				if (e.target.id == "cardNo") {
					setValueById("cardNo", myAry[1]);
					setValueById("patientNo", myAry[5]);
					getPatDetail(myAry[4]);
				}else {
					setValueById("shareCardNo", myAry[1]);
					setValueById("sharePatientId", myAry[4]);
					setValueById("sharePatientNo", myAry[5]);
					var patAry = setPatNameById(myAry[4]);
					setValueById("sharePatName", patAry[2]);
				}
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("��ʾ", "����Ч", "info", function () {
						if (e.target.id == "cardNo") {
							focusById("cardNo");
						}else {
							focusById("shareCardNo");
						}
					});
				}, 10);
				break;
			case "-201":
				if (e.target.id == "cardNo") {
					setValueById("cardNo", myAry[1]);
					setValueById("patientNo", myAry[5]);
					getPatDetail(myAry[4]);
				}else {
					setValueById("shareCardNo", myAry[1]);
					setValueById("sharePatientId", myAry[4]);
					setValueById("sharePatientNo", myAry[5]);
					var patAry = setPatNameById(myAry[4]);
					setValueById("sharePatName", patAry[2]);
				}
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
		getPatInfo(e.target.id);
	}
}

function getPatInfo(id) {
	var patientNo = getValueById(id);
	if (patientNo) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: patientNo
		}, function(patientNo) {
			setValueById(id, patientNo);
			var expStr = "";
			$.m({
				ClassName: "web.DHCOPCashierIF",
				MethodName: "GetPAPMIByNo",
				PAPMINo: patientNo,
				ExpStr: expStr
			}, function(papmi) {
				if (id == "patientNo") {
					setValueById("patientId", papmi);
				}else {
					setValueById("sharePatientId", papmi);
				}
				if (!papmi) {
					$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
					focusById(id);
				}else {
					if (id == "patientNo") {
						getPatDetail(papmi);
					}else {
						var patAry = setPatNameById(papmi);
						setValueById("sharePatName", patAry[2]);
					}
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
	loadSharerList();
	loadPatPkgTreeList();
}

function initSharerList() {
	var toolbar = [{
					iconCls: 'icon-add',
					text: '����',
					handler: function() {
						addClick();
					}
				}, {
					iconCls: 'icon-write-order',
					text: '�޸�',
					disabled: true,
					handler: function() {
						deleteClick();
					}
				}, {
					iconCls: 'icon-save',
					text: '����',
					handler: function() {
						saveClick();
					}
				}];
	GV.SharerList = $HUI.datagrid("#sharerList", {
		fit: true,
		striped: true,
		border: false,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: toolbar,
		columns: [[{title: '�ǼǺ�', field: 'ShareRegNo', width: 150},
				   {title: '�ͻ�����', field: 'SharePatName', width: 100},
				   {title: 'SharePapmi', field: 'SharePapmi', hidden: true}				   
			]],
		onLoadSuccess: function (data) {
			GV.EndRowIndex = data.total;
		},
		onDblClickRow: function(index, row) {
			//onDblClickRowHandler(index, row);
		}
	});
	GV.SharerList.loadData({total: 0, rows: []});
}

function loadSharerList() {
	var queryParams = {
		ClassName: "BILL.PKG.BL.OrderSharer",
		QueryName: "FindOrderSharer",
		patientId: getValueById("patientId"),
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 999999999
	}
	loadDataGridStore("sharerList", queryParams);
}

function initPatPkgTreeList() {
	GV.PatPkgTreeList = $HUI.treegrid("#patPkgTreeList", {
		fit: true,
		striped: true,
		title: '�ͻ��ײ��б�',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		idField: 'id',
		treeField: 'title',
		checkbox: true,
		toolbar: [],
		pageSize: 99999999,
		columns: [[{title: 'id', field: 'id', hidden: true},
				   {title: '��Ʒ����', field: 'title', width: 250},
				   {title: 'patPkgRowId', field: 'patPkgRowId', hidden: true},
				   {title: '����', field: 'quantity', width: 100},
				   {title: '��׼���', field: 'baseAmt', align: 'right', width: 100},
				   {title: '�ۿ۽��', field: 'manualDiscAmt', align: 'right', width: 100},
				   {title: 'ʵ�����', field: 'extendedAmt', align: 'right', width: 100}
			]]
	});
}

function loadPatPkgTreeList() {
	var queryParams = {
		ClassName: "BILL.PKG.BL.OrderSharer",
		QueryName: "FindPatPackage",
		patientId: getValueById("patientId"),
		billRowId: "",
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 999999999
	}
	loadTreeGridStore("patPkgTreeList", queryParams);
}

function addClick() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		$.messager.popover({msg: "���Ȳ�ѯ��Ȩ����", type: "info"});
		return;
	}
	if (!getValueById("sharePatientId")) {
		$.messager.popover({msg: "���ѯ����Ȩ����", type: "info"});
		return;
	}
	appendEditRow();
}

function appendEditRow() {
	var row = {ShareRegNo: getValueById("sharePatientNo"), SharePatName: getValueById("sharePatName"), SharePapmi: getValueById("sharePatientId")};
	GV.SharerList.appendRow(row);
	GV.EditRowIndex = GV.SharerList.getRows().length - 1;
	GV.SharerList.selectRow(GV.EditRowIndex);
	$("#shareCardType").combobox("reload");
	setValueById("sharePatientNo", "");
	setValueById("sharePatName", "");
	setValueById("sharePatientId", "");
}

function setPatNameById(patientId) {
	var patInfo = $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetPatientByRowId", PAPMI: patientId, ExpStr: ""}, false);
	var myAry = patInfo.split("^");
	return myAry;
}

/**
* ����
*/
function saveClick() {
	var patientId = getValueById("patientId");
	if (!patientId) {
		$.messager.popover({msg: "��Ȩ���˲�����", type: "info"});
		return;
	}
	var shareAry = [];
	$.each(GV.SharerList.getRows(), function(index, item) {
		if (index < GV.EndRowIndex) {
			return true;
		}
		if (item.SharePapmi) {
			shareAry.push(item.SharePapmi);
		}
	});
	if (shareAry.length == 0) {
		$.messager.popover({msg: "����Ȩ���˲�����", type: "info"});
		return;
	}
	var sharers = shareAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	if (!sharers) {
		return;
	}
	var myStr = "";
	var myAry = [];
	$.each(GV.PatPkgTreeList.getCheckedNodes("checked"), function(index, item) {
		if (item.patPkgRowId) {
			myStr = item._parentId + "^" + item.patPkgRowId;
			myAry.push(myStr);
		}
	});
	if (myAry.length == 0) {
		$.messager.popover({msg: "��ѡ����Ҫ������ײ�", type: "info"});
		return;
	}
	var patPkgStr = myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	var expStr = "";
	$.m({
		ClassName: "BILL.PKG.BL.OrderSharer",
		MethodName: "SaveOrderSharer",
		patientId: patientId,
		sharers: sharers,
		patPkgInfo: patPkgStr,
		guserId: PUBLIC_CONSTANT.SESSION.USERID,
		expStr: ""
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.popover({msg: "����ɹ�", type: "success"});
			GV.SharerList.reload();
		}else {
			$.messager.popover({msg: "����ʧ�ܣ�" + rtn, type: "error"});
		}
	});
}