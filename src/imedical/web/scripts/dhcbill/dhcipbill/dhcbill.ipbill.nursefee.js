/**
 * FileName: dhcbill.ipbill.nursefee.js
 * Author: WangXQ
 * Date: 2022-12-26
 * Description: ҽ�����ò�ѯ
 */
$(function () {
	initQueryMenu();
	initCateList();
	initOrdItmList();
	initOEItmList();
	initTarItmList();
	
	//�����ӹ����ľ���Ÿ���episodeId
	if (GV.EpisodeID) {
		var admType = getPropValById("PA_Adm", GV.EpisodeID, "PAADM_Type");
		if (admType != "I") {
			$.messager.alert("��ʾ", "��סԺ����", "info");
			return;
		}
		getPatInfoByAdm(GV.EpisodeID);      //dhcbill.inpatient.banner.csp
	}
});

function initQueryMenu() {
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

	$HUI.linkbutton("#btn-bill", {
		onClick: function () {
			billClick();
		}
	});

	$HUI.linkbutton("#btn-execFind", {
		onClick: function () {
			loadOEItmList();
		}
	});

	$HUI.linkbutton("#btn-depDtl", {
		onClick: function () {
			depDtlClick();
		}
	});

	$HUI.linkbutton("#btn-feeDtl", {
		onClick: function () {
			feeDtlClick();
		}
	});

	$HUI.linkbutton("#btn-checkfee", {
		onClick: function () {
			checkFeeClick();
		}
	});

	$HUI.linkbutton("#btn-feeDtl", {
		onClick: function () {
			feeDtlClick();
		}
	});

	$HUI.linkbutton("#btn-clean", {
		onClick: function () {
			clearClick();
		}
	});

	//ִ�м�¼ֹͣ��ť
	$("#btn-stop").click(stopClick);

	//ִ�м�¼����ִ�м�����ť
	$("#btn-cancel").click(cancelClick);

	//���Żس���ѯ�¼�
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//�����Żس���ѯ�¼�
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	var $tb = $("#more-container");
	var _narrow = function () {
		$tb.find(".arrows-b-text").text($g("����"));
		if(HISUIStyleCode == "lite") {
			$tb.find(".retract-l-up").removeClass("retract-l-up").addClass("spread-l-down");
		}else{
			$tb.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
		}
		$("tr.display-more-tr").slideUp("fast", setHeight(-120));
	}
	
	var _spread = function () {
		$tb.find(".arrows-b-text").text($g("����"));
		if(HISUIStyleCode == "lite") {
			$tb.find(".spread-l-down").removeClass("spread-l-down").addClass("retract-l-up");
		}else{
			$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
		}
		$("tr.display-more-tr").slideDown("normal", setHeight(120));
	}
	
	if(HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	}
	if ($(window).height() > CV.OuterHeight) {
		if ($tb.find(".arrows-b-text").text() == $g("����")) {
			_spread();
		}
	}
	
	$tb.click(function () {
		if ($tb.find(".arrows-b-text").text() == $g("����")) {
			_spread();
		} else {
			_narrow();
		}
	});

	$HUI.combogrid("#episodeId", {
		panelWidth: 400,
		panelHeight: 200,
		fitColumns: true,
		editable: false,
		url: $URL + "?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindAdmList",
		idField: 'adm',
		textField: 'adm',
		mode: 'remote',
		columns: [[{field: 'adm', title: '�����', width: 60},
				   {field: 'admDate', title: '��Ժʱ��', width: 150,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.admTime;
					}
				   },
				   {field: 'admDept', title: '�������', width: 120}
			]],
		onBeforeLoad: function (param) {
			param.patientId = GV.PatientID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onLoadSuccess: function(data) {
			if ($.hisui.indexOfArray(data.rows, "adm", GV.EpisodeID) == -1) {
				$(this).combogrid("clear");
				return;
			}
			$(this).combogrid("setValue", GV.EpisodeID);
		},
		onSelect: function(index, row) {
			var admJson =getAdmJson(row.adm);
			setValueById("localDept", (admJson.Dept || ""));
			loadCateList();
			loadOrdItmList();
		}
	});

	//ҽ����
	$HUI.combobox("#arcItm", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "BILL.COM.ItemMast";
				param.QueryName = "FindARCItmMast";
				param.ResultSetType = "array";
				var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
				param.alias = param.q;
				param.sessionStr = sessionStr;
			}
		}
	});
	
	//��������, ҽ�����տ���
	$HUI.combobox("#userDept, #ordRecDept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0;
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});

	//�˵�״̬
	$HUI.combobox("#billStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: $g('ȫ��')},
		       {value: '0', text: $g('δ����')},
		       {value: '1', text: $g('�ѽ���')}
		]
	});
	
	$HUI.switchbox("#merge-switch", {
		onText: $g('����'),
		offText: $g('��ϸ'),
		animated: true,
		onClass: 'primary',
		offClass: 'info',
		onSwitchChange: function (e, val) {
			loadOrdItmList();
		}
	});
	
	//���ڿ���
	$("#localDept").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		disabled: (["L", "W"].indexOf(CV.ViewType) != -1),
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0;
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		},
	});

	if (!GV.EpisodeID){
		showPatSexBGImg();		//��ʾĬ���Ա�ͷ�� WangXQ 20230424
	}
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

/**
* ִ�м�¼ֹͣ��ť
*/
function stopClick() {
	var rows = GV.OEItmList.getChecked();
	if (rows.length == 0){
		$.messager.popover({msg: "δѡ��ִ�м�¼", type: "info"});
		return;
	}
	
	var _cfr = function() {
		$.each(rows, function (index, row) {
			if ((row.TPriortyCode != "S")&&(row.TPriortyCode != "OMST")&&(row.TPriortyCode != "OMCQZT")){
				$.messager.popover({msg: $g("��ʱҽ��ֻ�ܳ���ִ��"), type: "info"});
				return reject();
			}
		});
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", $g("ִֹͣ�к��޷������������Ƿ�ȷ��ֹͣ��ѡ��") + rows.length + $g("��ִ�м�¼�� "), function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _stop = function () {
		var oeoreStr = rows.filter(function(row) {
			return (row.TOEORE != "");
		}).map(function(row) {
			return row.TOEORE;
		}).join("^");

		var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + "" + "^" + "" + "^" + "";
		var rtn = tkMakeServerCall("web.DHCDocInterfaceMethod", "DHCDocHisInterface", "doc.ord.OrdExecDealWith", oeoreStr, "", "", "D", "", expStr, "", "");
		if (rtn != 0) {
			$.messager.alert("��ʾ", $g("ֹͣʧ��:") + rtn, "error");
			return;
		}
		$.messager.popover({msg: "ֹͣ�ɹ�", type: "success"});
	};

	var promise = Promise.resolve();
	promise
		.then(_cfr)
		.then(_stop)
		.then(function() {
			loadOEItmList();
		}, function() {
			loadOEItmList();
		});
}

/**
* ִ�м�¼����������ť
*/
function cancelClick() {
	var ordRow = GV.OrdItmList.getSelected();
	if (!ordRow){
		$.messager.popover({msg: "δѡ��ҽ��", type: "info"});
		return;
	}
	var oeRows = GV.OEItmList.getChecked();
	if (oeRows.length == 0){
		$.messager.popover({msg: "δѡ��ִ�м�¼", type: "info"});
		return;
	}
	
	var _cfr = function() {
		$.each(oeRows, function (index, row) {
			if ((row.TPriortyCode == "S")||(row.TPriortyCode == "OMST")||(row.TPriortyCode == "OMCQZT")){
				$.messager.popover({msg: $g("����ҽ��ֻ��ִֹͣ��"), type: "info"});
				return reject();
			}
		});
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", $g("����ִ�к��޷������������Ƿ�ȷ��������ѡ��") + oeRows.length + $g("��ִ�м�¼�� "), function (r) {
				return r ? resolve() : reject();
			});
		});
	};

	var _cancel = function () {
		return new Promise(function (resolve, reject) {
			var oeoreStr = oeRows.filter(function(row) {
				return (row.TOEORE != "");
			}).map(function(row) {
				return row.TOEORE;
			}).join("^");
			var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + "" + "^" + "" + "^" + "";
			var rtn = tkMakeServerCall("web.DHCDocInterfaceMethod", "DHCDocHisInterface", "doc.ord.OrdExecDealWith", oeoreStr, "", "", "C", "", expStr, "", "");
			if (rtn != 0){
				$.messager.alert("��ʾ", $g("����ʧ��:.") + rtn, 'error');
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* ������������ҽ��
	*/
	var _handle = function () {
		var oeoriIdStr = "";
		if (GV.DetailSummaryFlag == 1){
			oeoriIdStr = ordRow.TOEORI;
		}else {
			oeoriIdStr = ordRow.ordItm;
		}
		$.cm({
			ClassName: "Nur.NIS.Service.Base.OrderHandle",
			MethodName: "CancelSeeOrderChunks",
			oeoriIdStr: oeoriIdStr,
			userId: PUBLIC_CONSTANT.SESSION.USERID,
			logonLoc: PUBLIC_CONSTANT.SESSION.CTLOCID
		}, function(data) {
			if(data.success == 0) {
				$.messager.popover({msg: "�����ɹ�", type: "success"});
				return;
			}
			$.messager.alert("��ʾ", "�����ɹ�,����ʧ��:"+ data.errList[0].errInfo, "error");  
		});
	};
	
	var promise = Promise.resolve();
	promise
		.then(_cfr)
		.then(_cancel)
		.then(_handle)
		.then(function() {
			loadOEItmList();
		}, function() {
			loadOEItmList();
		});
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
		getPatInfo();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("medicareNo", "");
		getPatInfo();
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("patientNo", "");
		getPatInfo();
	}
}

function getPatInfo() {
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetPatCurrAdm",
		patientNo: getValueById("patientNo"),
		medicareNo: getValueById("medicareNo"),
		sessionStr: getSessionStr()
	}, function (episodeId) {
		GV.EpisodeID = episodeId;
		GV.PatientID = getPropValById("PA_Adm", episodeId, "PAADM_PAPMI_DR");
		$("#episodeId").combogrid("grid").datagrid("reload");
		getPatInfoByAdm(episodeId);   //dhcbill.inpatient.banner.csp
	});
}

/**
* ��ʼ��ҽ������Grid
*/
function initCateList() {
	GV.CateList=$HUI.datagrid("#cateList", {
		fit: true,
        border: false,
		fitColumns: true,
		singleSelect: true,
		rownumbers: true,
		remoteSort: false,
		pageSize: 99999999,
		toolbar: [],
		columns: [[
				   {title: 'ҽ������', field: 'TCateDesc', width: 70},
				   {title: '�ѼƷѽ��',field: 'TCateAmt', align: 'right', width: 70, sortable: true,
						sorter: function (a, b) {
							return ((numCompute(a, b, "-") > 0) ? 1 : -1);
						}
				   },
				   {title: 'ҽ������ID', field: 'TCateId', width: 70, hidden:true}
				]],
		onClickRow:function(index,row) {
			loadOrdItmList();
		},
		rowStyler: function (index, row) {
			if (row.TCateDesc.endsWith($g("�ϼ�"))) {
				return "font-weight: bold";
			}
		}
	});
}

function initOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		titleNoWrap: false,
		nowrap: false,
		toolbar: [],
		columns: [[
				   {title: 'ҽ������', field: 'TCateDesc', width: 80},
				   {title: 'ҽ������', field: 'TArcimDesc', width: 300},
				   {title: '��λ', field: 'TUom', width: 70},
				   {title: '����', field: 'TPrice', width: 70, align:'right'},
				   {title: '����', field: 'TQty', width: 70},
				   {title: '���', field: 'TAmt', width: 70, align:'right'},
				   {title: 'ҽ����ID', field: 'TARCIM', width: 80},
				   {title: 'ҽ��ID', field: 'TOEORI', width: 300, hidden:true}
			]],
		onLoadSuccess: function (data) {
			GV.OrdItmList.autoMergeCells(['TCateDesc']);    //�ϲ���ͬ��
		},
		onSelect: function (index, row) {
			GV.TarItmList.loadData({total: 0, rows: []});  //����շ���
			loadOEItmList();
		}
	});
}

function initDetailedOrdItmList() {
	GV.OrdItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		titleNoWrap: false,
		nowrap: false,
		toolbar:'#ordItmDetaileToolBar',
		columns: [[
				   {title: 'ҽ������', field: 'arcimDesc', width: 300},
				   {title: 'ҽ�����', field: 'seqNo', width: 80},
				   {title: 'ҽ������', field: 'datTime', width: 120},
				   {title: '����ҽ��', field: 'docName', width: 100},
				   {title: 'ҽ��״̬', field: 'status', width: 100},
				   {title: '����', field: 'billQty', width: 100},
				   {title: 'С��', field: 'itmTotalAmt', width: 100},
				   {title: 'ҩ�����', field: 'phQty', width: 100},
				   {title: 'δ��ҩ����', field: 'drugTCQty', width: 100},
				   {title: '��ҩ����', field: 'phReturnQty', width: 100},
				   {title: 'ҽ��ID', field: 'ordItm', width: 100},
				   {title: 'ҽ�����ȼ�', field: 'priorty', width: 100},
				   {title: 'ҽ������', field: 'itmCatDesc', width: 100},
				   {title: '������', field: 'prescno', width: 120},
				   {title: '���տ���', field: 'recDeptName', width: 120},
				   {title: '��������', field: 'userDeptName', width: 100},
				   {title: '��ҩ״̬', field: 'dspStatus', width: 100},
				   {title: 'δ�Ʒ�ִ�м�¼����', field: 'notBillNum', width: 150},
				   {title: 'Ƶ��', field: 'phFreq', width: 100},
				   {title: '�Ը�����', field: 'patShareAmt', width: 100},
				   {title: '���˷���', field: 'payOrShareAmt', width: 100},
				   {title: '�ۿ۷���', field: 'discAmt', width: 100},
				   {title: '�Ʒѵ�', field: 'billCondition', width: 100},
				   {title: '������Դ', field: 'feeSource', width: 100}
			]],
		onSelect: function (index, row) {
			GV.TarItmList.loadData({total: 0, rows: []});  //����շ���
			loadOEItmList();
		},
		rowStyler: function (index, row) {
			if(GV.DetailSummaryFlag == 0){
				if (row.arcimDesc.endsWith($g("�ϼ�"))) {
					return "font-weight: bold";
				}
			}
		}
	});
}

function initOEItmList() {
	GV.OEItmList = $HUI.datagrid("#oeItmList", {
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		toolbar: '#oeItmToolBar',
		className: "web.DHCIPBillPatOrdFee",
		queryName: "FindOrdExecInfo",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //�����鿪ʼλ������һ��
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TExecDate", "TExecStDate", "TBilled"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBilledDesc") {
					cm[i].styler = function (value, row, index) {
						if (row.TFreeChargeFlag == "Y") {
							return;
						}
						if ((row.TBilled == "TB") || ((row.TBilled == "B") && (row.TBillTotalAmt == 0))) {
							return "font-weight: bold; color: #FF0000";
						}
					};
				}
				if (cm[i].field == "TExecTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExecDate + " " + value;
					};
				}
				if (cm[i].field == "TExecStTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TExecStDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TExecTime", "TExecStTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		},
		onSelect: function (index, row) {
			loadTarItmList();
		}
	});
}

function initTarItmList() {
	GV.TarItmList = $HUI.datagrid("#tarItmList", {
		fit: true,
		title: '�շ���',
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: true,
		pageSize: 999999999,
		toolbar: [],
		className: "web.DHCIPBillPatOrdFee",
		queryName: "FindTarInfo",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TBillDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBillTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TBillDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 80;
					if ($.inArray(cm[i].field, ["TUomDesc"]) != -1) {
						cm[i].width = 50;
					}
					if ($.inArray(cm[i].field, ["TTarItmDesc", "TBillTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		}
	});
}

/**
 * ��ѯ��ť����¼�
 * @method findClick
 * @author ZhYW
 */
function findClick() {
	//���ִ�м�¼
	GV.OEItmList.options().pageNumber = 1;   //��ת����һҳ
	GV.OEItmList.loadData({total: 0, rows: []});
	//����շ���
	GV.TarItmList.loadData({total: 0, rows: []});
	//��մ�����
	GV.CateList.loadData({total: 0, rows: []});
	loadCateList();
	loadOrdItmList();
}

//����סԺ���ô�����
function loadCateList() {
	var ordDeptId = getValueById("localDept");
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var queryParams = {
		ClassName: "web.DHCIPBillPATCostInquriy",
		QueryName: "FindBillCateFee",
		billId: "",
		stDate: stDate,
		endDate: endDate,
		ordDeptId: ordDeptId,
		episodeId: $("#episodeId").combogrid("getValue"),
		userDeptId: getValueById("userDept") || "",
		recDeptId: getValueById("ordRecDept") || ""
	};
	loadDataGridStore("cateList", queryParams);
}
/**
 * ���¼�����ϸgrid
 * @method loadOrdItmList
 * @author WangXQ
 */
function loadOrdItmList() {
	$("#ordItmList").datagrid("options").queryParams.QueryName = ""; 
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var stTime = getValueById("stTime");
	var endTime = getValueById("endTime");
	var billStatus = getValueById("billStatus");
	var itemCateId = "";
	var itemCaterow = $("#cateList").datagrid("getSelected");
	if (itemCaterow){
		itemCateId = itemCaterow.TCateId;
	}
	if ($("#merge-switch").switchbox("getValue")){
		if(GV.DetailSummaryFlag != 1){
			GV.DetailSummaryFlag = 1;
			initOrdItmList();
		}
		var ordDeptId = getValueById("localDept");
		var queryParams = {
			ClassName: "BILL.IP.BL.NurseFee",
			QueryName: "FindOrderDetail",
			billId: "",
			stDate: stDate|| "",
			endDate: endDate|| "",
			ordDeptId: ordDeptId,
			itemCateId: itemCateId,
			episodeId: $("#episodeId").combogrid("getValue"),
			recDeptId: getValueById("ordRecDept") || "",
			userDeptId: getValueById("userDept") || "",
			billStatus: billStatus,
		};
	}else {
		var _content = "<div id=\"ordItmDetaileToolBar\">"
						+ "<label style='padding:0 10px 0 10px'>" + $g("�Ʒ�״̬") + "</label>"
						+ "<input id=\"chargeStatus\" class=\"textbox tb130\"/>"
					+ "</div>";
		$("body").append(_content);
		if(GV.DetailSummaryFlag != 0){
			GV.DetailSummaryFlag = 0;
			initDetailedOrdItmList();
			initChargeStatuComb();
		}
		var tarItmId = getValueById("arcItm") || "";
		var queryParams = {
			ClassName: "BILL.IP.BL.NurseFee",
			QueryName: "FindOrdDetail",
			itmCateId: itemCateId,
			episodeId: $("#episodeId").combogrid("getValue"),
			recDeptId: getValueById("ordRecDept") || "",
			ordDeptId: getValueById("localDept") || "",
			userDeptId: getValueById("userDept") || "",
			sessionStr: getSessionStr(),
			stDate: stDate,
			endDate: endDate,
			billStatus: billStatus,
			arcimId: tarItmId,
			stTime: stTime,
			endTime: endTime,
			chargeStatus: getValueById("chargeStatus")
		};
	}
	loadDataGridStore("ordItmList", queryParams);
}

/**
 * ����ִ�м�¼grid
 * @method loadOEItmList
 * @author ZhYW
 */
function loadOEItmList() {
	var row = GV.OrdItmList.getSelected();
	if(GV.DetailSummaryFlag == 1){
		var ordItm = (row && row.TOEORI) ? row.TOEORI : "";
	}else {
		var ordItm = (row && row.ordItm) ? row.ordItm : "";
	}
	var queryParams = {
		ClassName: "web.DHCIPBillPatOrdFee",
		QueryName: "FindOrdExecInfo",
		ordItm: ordItm,
		stDate: getValueById("execStDate"),
		endDate: getValueById("execEndDate")
	};
	loadDataGridStore("oeItmList", queryParams);
}

/**
 * �����շ�����ϸgrid
 * @method loadTarItmList
 * @author ZhYW
 */
function loadTarItmList() {
	var row = GV.OEItmList.getSelected();
	var pboRowId = (row && row.TPBORowID) ? row.TPBORowID : "";
	var queryParams = {
		ClassName: "web.DHCIPBillPatOrdFee",
		QueryName: "FindTarInfo",
		pboRowId: pboRowId,
		rows: 99999999
	};
	loadDataGridStore("tarItmList", queryParams);
}

/**
 * ����layout�߶�
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $("#head-menu");
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

/**
 * �˵�
 * @method billClick
 * @author ZhYW
 */
function billClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "�����Ϊ��", type: "info"});
		return;
	}
	var billed = getPropValById("PA_Adm", episodeId, "PAADM_BillFlag");
	if (billed == "Y") {
		$.messager.popover({msg: "����������㣬�����˵�", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCIPBillPatOrdFee", MethodName: "GetMotherAdmByBabyAdm", episodeId: episodeId}, false);
	var myAry = rtn.split("^");
	var babyFlag = myAry[0];
	if (babyFlag == "true") {
		$.messager.popover({msg: "�˻���ΪӤ���������˵�", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", episodeId, PUBLIC_CONSTANT.SESSION.USERID, "", ClientIPAddress);
	var myAry = rtn.split("^");
	if (myAry[0] == 0) {
		$.messager.popover({msg: "�˵��ɹ�", type: "success"});
		findClick();
		return;
	}
	$.messager.popover({msg: $g('�˵�ʧ�ܣ�')+ (myAry[1] || myAry[0]), type: "error"});
}

/**
 * Ѻ����ϸdialog
 * @method depDtlClick
 * @author ZhYW
 */
function depDtlClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "�����Ϊ��", type: "info"});
		return;
	}
	var depositTypeId = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
	var url = "dhcbill.ipbill.depositlist.csp?EpisodeID=" + episodeId + "&DepositType=" + depositTypeId;
	websys_showModal({
		url: url,
		title: $g('Ѻ����ϸ'),
		iconCls: "icon-w-list"
	});
}

/**
 * ������ϸ��ѯ
 * @method feeDtlClick
 * @author ZhYW
 */
function feeDtlClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "�����Ϊ��", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetValidPBInfo",
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		var num = myAry[0];
		var billId = myAry[1];
		var url = "";
		switch (num) {
		case "1":
			if (!billId) {
				$.messager.popover({msg: "�˵���Ϊ��", type: "info"});
				break;
			}
			url = "dhcbill.ipbill.billdtl.csp?EpisodeID=" + episodeId + "&BillID=" + billId;
			websys_showModal({
				url: url,
				title: $g('������ϸ'),
				iconCls: 'icon-w-list',
				width: '85%'
			});
			break;
		default:
			url = "dhcbill.ipbill.billselect.csp?EpisodeID=" + episodeId;
			websys_showModal({
				url: url,
				title: $g('�˵��б�'),
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * ҽ�����ú˶�
 * @method checkFeeClick
 * @author ZhYW
 */
function checkFeeClick() {
	var episodeId = $("#episodeId").combogrid("getValue");
	if (!episodeId) {
		$.messager.popover({msg: "�����Ϊ��", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPatOrdFee",
		MethodName: "GetValidPBInfo",
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		var num = myAry[0];
		var billId = myAry[1];
		var url = "";
		switch (num) {
		case "1":
			if (!billId) {
				$.messager.popover({msg: "�˵���Ϊ��", type: "info"});
				break;
			}
			url = "dhcbill.ipbill.billorder.csp?EpisodeID=" + episodeId + "&BillID=" + billId;
			websys_showModal({
				url: url,
				title: $g('���ú˶�'),
				iconCls: 'icon-w-stamp',
				width: '90%'
			});
			break;
		default:
			url = "dhcbill.ipbill.billselect.csp?EpisodeID=" + episodeId;
			websys_showModal({
				url: url,
				title: $g('�˵��б�'),
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * �����б���ѡ�����л�
 */
function switchPatient(patientId, episodeId) {
	$("#InpatListDiv").data("AutoOpen", 0);
	GV.PatientID = patientId;
	GV.EpisodeID = episodeId;
	$("#episodeId").combogrid("grid").datagrid("reload");
	getPatInfoByAdm(GV.EpisodeID);      //dhcbill.inpatient.banner.csp
}

function getAdmJson(episodeId) {
	return $.cm({ClassName: "web.DHCIPBillReg", MethodName: "GetAdmInfo", type: "GET", episodeId: episodeId, sessionStr: getSessionStr()}, false);
}

/**
 * ����
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$("#episodeId").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
	setValueById("stDate", "");
	setValueById("endDate","");
	setValueById("execStDate", "");
	setValueById("execEndDate","");
	setValueById("billStatus", "");
	GV.OrdItmList.loadData({total: 0, rows: []});
	GV.OEItmList.loadData({total: 0, rows: []});
	GV.TarItmList.loadData({total: 0, rows: []});
	GV.CateList.loadData({total: 0, rows: []});
	if (!CV.EpisodeID){
		getPatInfoByAdm();
	}else{
		GV.PatientID=CV.PatientID;
		GV.EpisodeID=CV.EpisodeID;
		getPatInfoByAdm(GV.EpisodeID);
		$("#episodeId").combogrid("grid").datagrid("reload");
	}
}
/**
 * ��ʼ���Ʒ�״̬combobox
 * @method initChargeStatuComb
 * @author WangXQ
 */
function initChargeStatuComb(){
	//�Ʒ�״̬
	$HUI.combobox("#chargeStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: $g('ȫ��')},
		       {value: '0', text: $g('�ѼƷ�')},
		       {value: '1', text: $g('δ�Ʒ�')}
		],
		onSelect:function(record){
			loadOrdItmList();
		}
	});
}
