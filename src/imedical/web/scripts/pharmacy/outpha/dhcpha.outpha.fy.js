/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-��ҩ
 *createdate:2016-09-02
 *creator:dinghongying
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 1000;
DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA");
var PrintType = "";
var ifPatNoEnter = false;
var ifCheckShow = false;
var FyCheckDrug = "";
var HttpSrc = "";
var FocusFlag = "";
var readCardFlag = 0;
var tipNum = 0;
var changeFlag = 0;
var NoJudgWinFlag="";
var PartPiedDispFlag=""
var ChkUnFyThisLocFlag=""
var OnlyDispByPatNoFlag = "";
var curPatNo = "";
$(function () {
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
	var daterangeoptions = {
		singleDatePicker: true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	InitGridWin();
	InitFYWin();
	InitGridFY();
	InitGirdFYDetail();
	InitGirdWAITFY();
	InitConfig();

	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				if (newpatno == "") {
					return;
				}
				if (FyCheckDrug == "Y") {
					ifPatNoEnter = true;
				}
				QueryGridFY();
			}
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			readCardFlag = 1;
			if (cardno != "") {
				if (FyCheckDrug == "Y") {
					ifPatNoEnter = true;
				}
				BtnReadCardHandler();
			}
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* ��Ԫ���¼� end*/

	/* �󶨰�ť�¼� start*/
	$("#a-refresh").on("click", QueryGridWaitFY)
	$("#btn-find").on("click", QueryGridFY);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-calculator").on("click", function () {
		$("#modal-calculator").modal('show');
	});
	$("#btn-fy").on("click", function () {
		CACert("PHAOPExecuteFY", ExecuteFY);
	});
	$("#btn-reffy").on("click", ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click", CancelRefuseFY);
	$("#btn-allfy").on("click", function () {
		CACert("PHAOPExecuteAllFY", ExecuteAllFY);
	});
	$('#btn-printlabel').on("click", RePrintLabelHandler);
	$('#btn-print').on("click", PrintHandler);
	$("#btn-win-sure").on("click", FYWindowConfirm);
	$("#btn-redir-return").on("click", function () {
		var lnk = "dhcpha/dhcpha.outpha.return.csp";
		websys_createWindow(lnk, $g("��ҩ"), "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	$("#a-changegrid").on("click", function () {
		$('.js-pha-orders-preview').toggle();
		var _opt = {
			gridName: "grid-fydetail",
			changFlag: changeFlag
		};
		QueryDetailOrders(_opt);
		changeFlag = changeFlag + 1;
	});
	$('#pha-orders-preview').css('height', (DhcphaJqGridHeight(2, 3) * 0.5) + 34);
	/* �󶨰�ť�¼� end*/
	
	InitBodyStyle();
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: $g("����"),
			offText: $g("����"),
			onColor: "success",
			offColor: "default",
			size: "small",
			onSwitchChange: function (event, state) {
				var ret = ChangeWinStat(state);
				if (ret == false) {
					$(this).bootstrapSwitch('state', !state, true);
				}
			}
		})
		$("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		$("#grid-window").HideJqGridScroll({
			hideType: "X"
		})
	});
	$("#modal-windowinfo").on('hidden.bs.modal', function () {
		Setfocus();
	})
	$("#modal-calculator").on('shown.bs.modal', function () {
		$("#grid-calculator").setGridWidth($("#modal-calculator .div_content").width())
		$("#grid-calculator").HideJqGridScroll({
			hideType: "X"
		})
	});

	InitModalCheckDrug(); // �˶Դ���ҩƷ��ϸmodal
	HotKeyInit("FY", "grid-fy");
	Setfocus();
	if (NoJudgWinFlag=="Y") {
		$('#noJudgWin').css('display', 'inline-block');
	}

})
//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
	var locincioptions = {
		id: "#sel-locinci",
		locid: locrowid
	}
	InitLocInci(locincioptions)
}
//��ʼ����ҩtable
function InitGridFY() {
	var columns = [{
			header: ("��ҩ״̬"),
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 65,
			cellattr: addPhDispStatCellAttr
		}, {
			header: ("����"),
			index: 'TPatName',
			name: 'TPatName',
			width: 100
		}, {
			header: ("�ǼǺ�"),
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 100
		}, {
			header: ("�շ�����"),
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100
		}, {
			header: ("�վݺ�"),
			index: 'TPrtInv',
			name: 'TPrtInv',
			width: 100,
			hidden: true
		}, {
			header: ("������"),
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 115
		}, {
			header: ("�������"),
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		}, {
			header: ("�Ա�"),
			index: 'TPerSex',
			name: 'TPerSex',
			width: 40
		}, {
			header: ("����"),
			index: 'TPerAge',
			name: 'TPerAge',
			width: 40
		}, {
			header: ("���״̬"),
			index: 'TDocSS',
			name: 'TDocSS',
			width: 70
		}, {
			header: ("������ҩ"),
			index: 'TPassCheck',
			name: 'TPassCheck',
			width: 70,
			hidden: true
		}, {
			header: ("�����ܼ�"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		}, {
			header: ("���˼���"),
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		}, {
			header: ("���"),
			index: 'TMR',
			name: 'TMR',
			width: 200,
			align: 'left'
		}, {
			header: 'phdrow',
			index: 'phdrow',
			name: 'phdrow',
			width: 60,
			hidden: true
		}, {
			header: ("���"),
			index: 'TNoteCode',
			name: 'TNoteCode',
			width: 50,
			hidden: true
		}, {
			header: ("ҩ���"),
			index: 'TBoxNum',
			name: 'TBoxNum',
			width: 60,
			hidden: true
		}, {
			header: ("��ҩ"),
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=jsQueryFYList&style=jqGrid', //��ѯ��̨
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		multiselect: false,
		pager: "#jqGridPager", //��ҳ�ؼ���id
		shrinkToFit: false,
		onSelectRow: function (id, status) {
			QueryGridFYSub();
			var selrowdata = $(this).jqGrid('getRowData', id);
			var prescNo = selrowdata.TPrescNo;
			InitErpMenu(prescNo);
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#grid-fydetail").clearJqGrid();
			} else {
				$(this).jqGrid('setSelection', 1);
			}
			var chkfy = "";
			if ($("#chk-fy").is(':checked')) {
				chkfy = "1";
			}
			if (chkfy != 1) {
				var fyrowdata = $("#grid-fy").jqGrid('getRowData');
				var fygridrows = fyrowdata.length;
				if (fygridrows <= 0) {
					return;
				}
				var patno = "";
				for (var rowi = 1; rowi <= fygridrows; rowi++) {
					var selrowdata = $("#grid-fy").jqGrid('getRowData', rowi)
						var prescno = selrowdata.TPrescNo;
					patno = selrowdata.TPmiNo;
					if (readCardFlag == 1) {
						SendOPInfoToMachine("105", prescno, "")
					}
				}
				//���غ˶Խ�������
				if (ifPatNoEnter == true) {
					loadCheckData(patno);
				}
			}
			$('#txt-patno').val("");
			Setfocus();
		}
	};
	$("#grid-fy").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ϸtable
function InitGirdFYDetail() {
	var columns = [{
			header: ("��ϸ״̬"),
			index: 'TPhDispItmStat',
			name: 'TPhDispItmStat',
			width: 65,
			cellattr: addPhDispItmStatCellAttr
		}, {
			header: 'ͼ��',
			index: 'drugIcon',
			name: 'drugIcon',
			width: 70,
			align: 'left',
			formatter: DrugIcon
		}, {
			header: ("ҩƷ����"),
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 200,
			align: 'left',
			cellattr: DrugColor
		}, {
			header: ("����"),
			index: 'TPhQty',
			name: 'TPhQty',
			width: 50,
			align: 'right'
		}, {
			header: ("��λ"),
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80
		}, {
			header: ("���"),
			index: 'TPhgg',
			name: 'TPhgg',
			width: 100
		}, {
			header: ("����"),
			index: 'TJL',
			name: 'TJL',
			width: 60
		}, {
			header: ("Ƶ��"),
			index: 'TPC',
			name: 'TPC',
			width: 60
		}, {
			header: ("�÷�"),
			index: 'TYF',
			name: 'TYF',
			width: 60
		}, {
			header: ("�Ƴ�"),
			index: 'TLC',
			name: 'TLC',
			width: 80
		}, {
			header: ("��λ"),
			index: 'TIncHW',
			name: 'TIncHW',
			width: 100
		}, {
			header: ("��ע"),
			index: 'TPhbz',
			name: 'TPhbz',
			width: 80
		}, {
			header: ("������ҵ"),
			index: 'TPhFact',
			name: 'TPhFact',
			width: 200,
			align: 'left'
		}, {
			header: ("�������"),
			index: 'TKCQty',
			name: 'TKCQty',
			width: 80
		}, {
			header: ("ҽ������"),
			index: 'TYBType',
			name: 'TYBType',
			width: 75
		}, {
			header: ("����"),
			index: 'TPrice',
			name: 'TPrice',
			width: 60,
			align: 'right'
		}, {
			header: ("���"),
			index: 'TMoney',
			name: 'TMoney',
			width: 40,
			align: 'right'
		}, {
			header: ("״̬"),
			index: 'TOrdStatus',
			name: 'TOrdStatus',
			width: 40
		}, {
			header: ("��Ʊ��"),
			index: 'TPrtNo',
			name: 'TPrtNo',
			width: 100
		},{
			header: ("����ҽ������"),
			index: 'TCInsuCode',
			name: 'TCInsuCode',
			width: 120
		},{
			header: ("����ҽ������"),
			index: 'TCInsuDesc',
			name: 'TCInsuDesc',
			width: 120
		}
	];
	var jqOptions = {
		datatype: 'local',
		rowNum: 200,
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispListDetail&style=jqGrid',
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		shrinkToFit: false,
		loadComplete: function () {
			QueryDetailOrders({
				gridName: "grid-fydetail",
				changFlag: changeFlag + 1
			});
			DrugTips();
		}
	};
	$("#grid-fydetail").dhcphaJqGrid(jqOptions);
}

//�к���Ϣ����
function SendMessToVoice(rowIndex) {
	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܽк�!"));
		return;
	}
	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var patno = selrowdata.tbpatid;
	var patname = selrowdata.tbname;
	var window = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var serverip = ClientIPAddress;
	var FYUserID = DHCPHA_CONSTANT.DEFAULT.PHUSER;
	var phwQuId = selrowdata.phwQuId;
	if (phwQuId != "") {
		var state = "Call";
		var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
	}
	SendOPInfoToMachine("103^107", "", patno) // �к�����	�к�����
	var SendVoiceRet = tkMakeServerCall("PHA.FACE.IN.Com", "SendMessToVoice", patno, patname, serverip, window, FYUserID);
	QueryGridWaitFY();
}
function PassQueueNo(rowIndex, state) {
	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("û��ѡ������,�������!"));
		return;
	}
	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var phwQuId = selrowdata.phwQuId;
	if (phwQuId == "") {
		dhcphaMsgBox.alert($g("û�б����Ŷ�,�������!"));
		return;
	}
	var state = "Skip";
	var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
	QueryGridWaitFY();
}
function CallPatForMat(cellvalue, options, rowObject) {
	return "<a onclick='SendMessToVoice(\"" + options.rowId + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/ring.png' border=0/></a>"
	 + "<a style='margin-left:10px' onclick='PassQueueNo(\"" + options.rowId + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/skip_no.png' border=0/></a>";
}
//��ʼ������ҩtable
function InitGirdWAITFY() {
	var columns = [{
			header: ("�к�"),
			index: 'tSendVoice',
			name: 'tSendVoice',
			width: 80,
			cellattr: addtSendVoiceCellAttr,
			formatter: CallPatForMat
		}, {
			header: ("����"),
			index: 'tbname',
			name: 'tbname',
			width: 100
		}, {
			header: ("�ǼǺ�"),
			index: 'tbpatid',
			name: 'tbpatid',
			width: 100
		}, {
			header: ("�ŶӺ�"),
			index: 'queueNo',
			name: 'queueNo',
			width: 100
		}, {
			header: ("�к�״̬"),
			index: 'callFlag',
			name: 'callFlag',
			width: 100,
			hidden: true
		}, {
			header: ("�к�id"),
			index: 'phwQuId',
			name: 'phwQuId',
			width: 100,
			hidden: true
		}, {
			header: ("�����ܼ�"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		}, {
			header: ("���˼���"),
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		}, {
			header: 'TWarnLevel',
			index: 'TWarnLevel',
			name: 'TWarnLevel',
			width: 100,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		height: DhcphaJqGridHeight(1, 1),
		recordtext: "",
		pgtext: "",
		datatype: 'local',
		shrinkToFit: false,
		onSelectRow: function (id, status) {
			var selrowdata = $(this).jqGrid('getRowData', id);
			var patno = selrowdata.tbpatid;
			$("#txt-patno").val(patno);
			QueryGridFY();
		},
		gridComplete: function () {
			var ids = $("#grid-waitfy").jqGrid("getDataIDs");
			var rowDatas = $("#grid-waitfy").jqGrid("getRowData");
			for (var i = 0; i < rowDatas.length; i++) {
				var rowData = rowDatas[i];
				var warnLevel = rowData.TWarnLevel;
				var callFlag = rowData.callFlag;
				if ((warnLevel.indexOf($g("��")) >= 0) || (warnLevel.indexOf($g("��")) >= 0)) {
					$("#grid-waitfy" + " #" + ids[i] + " td").css({
						color: '#FF6356',
						'font-weight': 'bold'
					});
				}

			}
			return true;
		}
	};
	$("#grid-waitfy").dhcphaJqGrid(jqOptions);
}
//��ѯ����ҩtable
function QueryGridWaitFY() {
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var chkNoJudgWinFlag=""
	if (NoJudgWinFlag="Y") {
		if ($("#chk-noJudgWin").is(':checked')) chkNoJudgWinFlag=1
	}
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^^" + stdate + "^" + enddate + "^" +chkNoJudgWinFlag;
	$("#grid-waitfy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	if ((DHCPHA_CONSTANT.DEFAULT.PHLOC != "") && (DHCPHA_CONSTANT.DEFAULT.PHWINDOW != "")) {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	}
}
//��ѯ��ҩ�б�
function QueryGridFY() {
	curPatNo = "";
	ClearErpMenu();
	ChkUnFyOtherLoc();
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var chkfy = "";
	if ($("#chk-fy").is(':checked')) {
		chkfy = "1";
	}
	var patno = $("#txt-patno").val();
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //������ҩ���ڵ�ID
	var CPatName = "";
	var CPrescNo = "";
	var chkNoJudgWinFlag=""
	if (NoJudgWinFlag="Y") {
		if ($("#chk-noJudgWin").is(':checked')) chkNoJudgWinFlag=1
	}
	if((OnlyDispByPatNoFlag =="Y")&&(patno=="")&&(chkfy!="1")){
		dhcphaMsgBox.alert($g("�����뻼����Ϣ���ѯ!"));
		return;
	}
	curPatNo = patno
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + CPrescNo + "^" + chkfy + "^" + chkNoJudgWinFlag;
	$("#grid-fy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		},
		page: 1
	}).trigger("reloadGrid");
	readCardFlag = 0;
	Setfocus();
}
//��ѯ��ҩ��ϸ
function QueryGridFYSub() {
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var rPhdrow = selrowdata.phdrow;
	var chkfy = "";
	if ($("#chk-fy").is(':checked')) {
		chkfy = "on";
	} else {
		chkfy = "";
	}
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + prescno + "^" + rPhdrow + "^" + chkfy;
	$("#grid-fydetail").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");

}
// ִ�з�ҩ
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܷ�ҩ!"));
		return;
	}
	ChkUnFyThisLocFlag="0"
	//DispensingMonitor(selectid);
	CheckPayment(selectid);
	var nextSelectid = parseInt(selectid) + 1;
	var rowDatas = $("#grid-fy").jqGrid("getRowData");
	if (nextSelectid <= rowDatas.length) {
		$("#grid-fy").setSelection(nextSelectid);
	}
	if (ChkUnFyThisLocFlag=="1") ChkUnFyThisLoc(1);
	Setfocus();
}

//ִ��ȫ��
function ExecuteAllFY() {
	var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert($g("û������!"));
		return;
	}
	// ȫ��ǰ�򵥼���������
	var retFlag = ChkDataBeforeALLFY()
	if(retFlag==false){
		dhcphaMsgBox.alert($g("��ǰ���������У����ѷ����ݣ������²�ѯ�����ԣ�"), "error");
		return;
	}
	if ((IsOnlyOnePatno() == false)){
		if (OnlyDispByPatNoFlag = 'Y') {
			dhcphaMsgBox.alert($g("������ߴ���������ʹ��ȫ��!"), "warn");	
			return;
		}
		var warntitle = $g("���ڶ�����ߵĴ���ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!")
	}else {
		var warntitle = $g("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!")
	}
	dhcphaMsgBox.confirm($g(warntitle), ConfirmDispAll);

}
function ConfirmDispAll(result) {
	if (result == true) {
		var fyrowdata = $("#grid-fy").jqGrid('getRowData');
		var fygridrows = fyrowdata.length;
		tipNum = 0;
		for (var rowi = 1; rowi <= fygridrows; rowi++) {
			CheckPayment(rowi);
			if (tipNum > 0) {
				return;
			}
		 }
		ChkUnFyThisLoc(fygridrows);
		
		QueryGridWaitFY();
	}
	Setfocus();
}

 /* ����շ���� */
 function CheckPayment(rowid){
	var selectrow = $("#grid-fy").jqGrid('getRowData', rowid);
	var prescNo = selectrow.TPrescNo;
	/* ��ȡ�����е�δ����ҽ����Ϣ */
	var unPaidInfo = GetUnPaidOrder(prescNo)
		/* ����δ����ʱ�Ƿ�����ҩ */
	if (unPaidInfo !== ""){
		if (PartPiedDispFlag == "Y") {
			dhcphaMsgBox.confirm(prescNo + $g("�д���δ���ѵ�ҽ����ϸ!ҽ������Ϊ:") + "<br/>" + unPaidInfo + "<br/>" + $g("���[ȷ��]��������ҩ�����[ȡ��]��������ҩ������"), function (r) {
				if (r == true) {
					DispensingMonitor(rowid);	
				} else {
					return;
				}
			});
		}
		else {
			dhcphaMsgBox.alert(prescNo + $g("�д���δ���ѵ�ҽ����ϸ,��ֹ��ҩ!ҽ������Ϊ:") + "<br/>" + unPaidInfo);
			return;
		}
	}
	else{
		DispensingMonitor(rowid);	
	}
		
}

function DispensingMonitor(rowid) {
	var selrowdata = $("#grid-fy").jqGrid('getRowData', rowid);
	var prescno = selrowdata.TPrescNo;
	var phdrowid = selrowdata.phdrow;
	var adtresult = GetOrdAuditResultByPresc(prescno);
	if (adtresult == "") {
		dhcphaMsgBox.alert($g("�������!"))
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert($g("�ô�����˲�ͨ��,��ֹ��ҩ!"))
		return;
	} else if (adtresult == "S") {
		if (!confirm($g("�ô���ҽ�����ύ����,���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������"))) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);
	if (checkprescref == "N") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,��ֹ��ҩ!"));
		return;
	}
	if (checkprescref == "A") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,��ֹ��ҩ!"));
		return;
	}
	if (checkprescref == "S") {
		dhcphaMsgBox.confirm($g("�ô���ҽ�����ύ����<br/>���[ȷ��]��ͬ�����߼�����ҩ�����[ȡ��]��������ҩ������"), function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //���ߺ�ҩӦ�ȳ����ܾ�
				ExecuteDisp(phdrowid, prescno, rowid);
			} else {
				return;
			}
		});
	} else {
		ExecuteDisp(phdrowid, prescno, rowid);
	}

}

function ExecuteDisp(phdrowid, prescno, rowid) {
	var RetInfo = tkMakeServerCall("PHA.OP.PyDisp.OperTab", "SaveDispData", phdrowid, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	var retarr = RetInfo.split("^");
	var dispret = retarr[0];
	var retmessage = retarr[1];
	if (dispret > 0) {
		var bgcolor = $(".dhcpha-record-disped").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-fy").setCell(rowid, 'TFyFlag', 'OK');
		$("#grid-fy").setCell(rowid, 'TPhDispStat', $g("�ѷ�ҩ"), cssprop);
		AfterExecPrint(prescno, PrintType, phdrowid, "");
		SendOPInfoToMachine("104^108^110", prescno, ""); //104��ҩ��� 108��ҩʱ���� 110���ͻ�(����״̬)
		QueryGridWaitFY();
		ChkUnFyThisLocFlag="1";
	} else {
		dhcphaMsgBox.alert($g(retmessage), "error")
		tipNum = tipNum + 1;
		return;
	}
}

// ִ�оܾ���ҩ
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܾܾ���ҩ!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("�����ѷ�ҩ�����ܾܾ�!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	if (prescno == "") {
		dhcphaMsgBox.alert($g("��ѡ��Ҫ�ܾ��Ĵ���"));
		return;
	}
	var ref = GetOrdRefResultByPresc(prescno);
	if (ref == "N") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,�����ظ�����!"))
		return;
	} else if (ref == "A") {
		dhcphaMsgBox.alert($g("�ô����ѱ��ܾ�,�����ظ�����!"))
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno);
	if (checkprescadt == "") {
		dhcphaMsgBox.alert($g("�ô���δ���,��ֹ����!"))
		return;
	} else if (checkprescadt != "Y") {
		dhcphaMsgBox.alert($g("�ô������δͨ��,��ֹ����!"))
		return;
	}
	var waycode = DHCPHA_CONSTANT.VAR.OUTPHAWAY;

	ShowPHAPRASelReason({
		wayId: waycode,
		oeori: "",
		prescNo: prescno,
		selType: "PRESCNO"
	}, SaveCommontResultEX, {
		prescno: prescno
	});

}

function SaveCommontResultEX(reasonStr, origOpts) {
	if (reasonStr == "") {
		return "";
	}
	var retarr = reasonStr.split("@");
	var ret = "N";
	var reasondr = retarr[0];
	var advicetxt = retarr[2];
	var factxt = retarr[1];
	var phnote = retarr[3];
	var input = ret + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + origOpts.prescno + "^OR"; //orditm;
	if (reasondr.indexOf("$$$") == "-1") {
		reasondr = reasondr + "$$$" + prescno;
	}
	var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	
	if (refuseret == 0) {
		$("#grid-fy").setCell(selectid, 'TDocSS', $g("�ܾ���ҩ"));
	} else {
		dhcphaMsgBox.alert($g("�ܾ�ʧ��!�������:") + refuseret)
		return;
	}
}

// �����ܾ���ҩ
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,���ܳ����ܾ���ҩ!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	var prescno = selrowdata.TPrescNo;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("�ü�¼�Ѿ���ҩ!"));
		return;
	}
	if (prescno == "") {
		dhcphaMsgBox.alert($g("��ѡ��Ҫ�����ܾ��Ĵ���"));
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  �����ܾ�
	if ((checkprescref != "N") && (checkprescref != "A")) {
		if (checkprescref == "S") {
			dhcphaMsgBox.alert($g("�ô���ҽ�����ύ����,����Ҫ����!"))
			return;
		} else {
			dhcphaMsgBox.alert($g("�ô���δ���ܾ�,���ܳ�������!"))
			return;
		}
	}
	var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR");
	if (cancelrefuseret == "0") {
		var PrescResult = GetPrescResult(prescno);
		var newdata = {
			TDocSS: PrescResult
		};
		$("#grid-fy").jqGrid('setRowData', selectid, newdata);
		dhcphaMsgBox.alert($g("�����ɹ�!"), "success");
	} else if (cancelrefuseret == "-2") {
		dhcphaMsgBox.alert($g("�ô���δ���ܾ�,���ܳ�������!"));
	} else if (retval == "-3") {
		dhcphaMsgBox.alert($g("�ô����ѳ���,�����ٴγ���!"));
	}
}
//��ȡ�����ܾ����
function GetOrdRefResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	return ref;
}
//��ȡ������˽��
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//��ȡ�ܾ���ҩ�ʹ�����˽��
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//��ȡ������δ����ҽ����ϸ
function GetUnPaidOrder(prescno) {
	var ref = tkMakeServerCall("PHA.OP.COM.Method", "GetUnPaidInfo", prescno);
	return ref;
}
//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc() {
	var LocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var GroupId = DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
	var UserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ChkOtherLocUnFyRet = tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispOtherLoc")
	if (ChkOtherLocUnFyRet!="Y") return;
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var patno = $("#txt-patno").val();
	if ((patno == "") || (patno == null)) {
		return;
	}
	var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	if (ret == -1) {
		// alert("����Ϊ��,�����")
	} else if (ret == -2) {
		dhcphaMsgBox.alert($g("û�ҵ��ǼǺ�Ϊ") + patno + $g("�Ĳ���"));
		return;

	} else if ((ret != "") && (ret != null)) {
		dhcphaMsgBox.alert(ret);
	}
}
//��ӡ
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,�޷���ӡ!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Presc(prescno, "", "");
}
//�ش��ǩ
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("û��ѡ������,�޷���ӡ!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno);
}
//���
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-fy').iCheck('uncheck');
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#grid-fy").clearJqGrid();
	$("#grid-fydetail").clearJqGrid();
	QueryGridWaitFY();
	ClearErpMenu();
	curPatNo = "";
}

//��ҳ��table���ø߶�
function OutFYCanUseHeight() {
	var conditionheight = QueryConditionHeight();
	var panelheadheight = PanelHeadingHeight(2);
	var tableheight = $(window).height() - conditionheight - panelheadheight - 117;
	return tableheight;
}

//��ʼ����ҩ����table
function InitGridWin() {
	var columns = [{
			header: ("ҩ������"),
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		}, {
			header: ("����״̬"),
			index: 'phwWinStat',
			name: 'phwWinStat',
			formatter: statusFormatter,
			title: false
		}, {
			header: 'phwid',
			index: 'phwid',
			name: 'phwid',
			width: 20,
			hidden: true
		}, {
			header: 'phwpid',
			index: 'phwpid',
			name: 'phwpid',
			width: 20,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&ChkRelFlag=',
		height: '100%',
		autowidth: true,
		loadComplete: function () {}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}

function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "����") {
		return '<input name="dhcphaswitch" type="checkbox" checked> '
	} else {
		return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	}
}

function ChangeWinStat(state) {
	var wintd = $(event.target).closest("td");
	var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	var phwpid = selrowdata.phwpid;
	var phwid = selrowdata.phwid
		var phwWinStat = state;
	var winstat = "";
	if (phwWinStat == true) {
		phwWinStat = "1";
	} else {
		phwWinStat = "0";
	}
	var paramStr = DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID;
	var modifyret = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag", phwid, phwWinStat, paramStr);
	if (modifyret == 0) {
		return true;
	} else if (modifyret == -11) {
		dhcphaMsgBox.alert($g("��ȷ������һ������Ϊ����״̬!"));
		return false;
	} else {
		dhcphaMsgBox.alert($g("�޸Ĵ���״̬ʧ��,�������:") + modifyret, "error");
		return false;
	}
}

//��ҩ����ȷ��
function FYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var fywindata = $("#sel-window").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert($g("��ҩ���ڲ���Ϊ��!"));
		return false;
	}
	var fywin = fywindata.id;
	var fywindesc = fywindata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(fywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	var phcookieinfo = fywin + "^" + fywindesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy", phcookieinfo);
	ClearConditions();
	return false;
}

//Ȩ����֤
function CheckPermission() {
	$.ajax({
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
		'&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
		'&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
		'&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type: 'post',
		success: function (data) {
			var retjson = eval("(" + data + ")");
			var retdata = retjson[0];
			var permissionmsg = "",
			permissioninfo = "";
			if (retdata.phloc == "") {
				permissionmsg = $g("ҩ������:") + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��!")
			} else {
				permissionmsg = $g("����:") + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "����" + $g("����:") + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��!")
				} else if (retdata.phnouse == "Y") {
					permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��������Ϊ��Ч!")
				} else if (retdata.phfy != "Y") {
					permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��δ���÷�ҩȨ��!")
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				});
				//���ɫ���򲻹ر�
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)

				})
				$("#modal-dhcpha-permission").modal('show');
			} else {
				DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					QueryGridWaitFY();
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
				})

			}
			FyCheckDrug = retdata.FyCheckDrug;
		},
		error: function () {}
	})
}
//��ʼ����ҩ����
function InitFYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetFYWinList&style=select2&gLocId=" +
		DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&ChkRelFlag=",
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}

function InitBodyStyle() {
	$("#grid-waitfy").setGridWidth("")

}
function addtSendVoiceCellAttr(rowId, val, rawObject, cm, rdata) {
	var callFlag = rawObject.callFlag
		if (callFlag == "0") {
			return "class=dhcpha-record-call";
		} else if (callFlag == "3") {
			return "class=dhcpha-record-skip";
		} else if (callFlag == "5") {
			return "class=dhcpha-record-unqueue";
		} else {
			return "";
		}
}
function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == $g("����ҩ")) {
		return "class=dhcpha-record-pyed";
	} else if (val == $g("�Ѵ�ӡ")) {
		return "class=dhcpha-record-printed";
	} else if (val == $g("�ѷ�ҩ")) {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}

function addPhDispItmStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == $g("��治��")) {
		return "class=dhcpha-record-nostock";
	} else if ((val.indexOf($g("����")) > 0) || (val.indexOf("ֹͣ") > 0)) {
		return "class=dhcpha-record-ordstop";
	} else if ((val.indexOf($g("�˷�")) > 0)|| (val.indexOf($g("δ�շ�")) > -1)) {
		return "class=dhcpha-record-owefee";
	}else {
		return "";
	}
}
// ����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
// �������ز���
function ReadCardReturn() {
	QueryGridFY();
}

function InitConfig() {
	var CongigStr = tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
		if (CongigStr != "") {
			var arr = CongigStr.split("^");
			if (arr.length >= 15) {
				PrintType = arr[9];
				//FyCheckDrug = arr[11];
				FocusFlag = arr[12];
				NoJudgWinFlag = arr[14];
				PartPiedDispFlag=arr[13];
				OnlyDispByPatNoFlag = arr[15];
			}
		}
}

function SendOPInfoToMachine(faceCode, prescNo, patNo) {
	if (prescNo == undefined) {
		prescNo = ""
	}
	if (patNo == undefined) {
		patNo = "";
	}
	var paramStr = {
		faceCode: faceCode,
		prescNo: prescNo,
		patNo: patNo
	};
	DoOPInterfaceCom(paramStr)
}
function Setfocus() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");

	if (FocusFlag == 1) {
		$('#txt-cardno').focus();
	} else {
		$('#txt-patno').focus();
	}
}
// ��ʼ���˶Խ���
function InitModalCheckDrug() {
	// ��ʼ�����
	InitGirdCheck();

	// ������ʾ�¼�
	$('#modal-checkdrug').on('shown.bs.modal', function (e) {
		//ifCheckShow = true;
		$('#txt-patno').blur();
		$('#txt-drugbarcode').focus();
	});
	$('#modal-checkdrug').on('hidden.bs.modal', function (e) {
		//ifCheckShow = false;
		Setfocus();
		$("#grid-checkdrug").clearJqGrid();

	});

	// ��������İ�ť�¼�
	$("#btn-modal-sure").on("click", CompleteCheckPresc); //��ɺ˶�
	$("#btn-modal-cancel").on("click", HideModalCheckDrug); //ȡ���˶�
	$("#btn-modal-dispall").on("click", AllFYByClick); //ȫ��

	//���Żس��¼�
	$('#txt-drugbarcode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var barcode = $.trim($("#txt-drugbarcode").val());
			if (barcode != "") {
				CheckDrugItm();
			}
		}
	});
}

// ��ɴ����˶�
function CompleteCheckPresc() {
	var prescStr = "";
	var ids = $('#grid-checkdrug').getDataIDs();
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		var getRow = $('#grid-checkdrug').getRowData(ids[i]);
		var TSelect = getRow.TSelect;
		var TOrditm = getRow.TOrditm;
		if (TSelect == "No" && TOrditm != 0) {
			dhcphaMsgBox.alert($g("��ҩƷδ�˶�!"));
			return;
		}
		if (TOrditm != 0) {
			continue;
		}
		var prescNo = getRow.TPhDesc;
		if (prescStr == "") {
			prescStr = prescNo;
		} else {
			prescStr = prescStr + "^" + prescNo;
		}
	}
	if (prescStr == "") {
		return;
	}
	var cancelRet = tkMakeServerCall("PHA.OP.PyDisp.OperTab", "UpdateCheckMainInfo", prescStr, session['LOGON.USERID'], "Y");
	if (parseFloat(cancelRet) < 0) {
		dhcphaMsgBox.alert($g("ȷ��ʧ��!"));
		return;
	} else {
		$("#modal-checkdrug").modal('hide'); //ȷ�Ϻ˶�
	}
}

// ���ص���
function HideModalCheckDrug() {
	$("#modal-checkdrug").modal('hide');
}

// ��ʼ���˶��б�
function InitGirdCheck() {
	var columns = [
		{
			name: 'TSelect',
			index: 'TSelect',
			header: 'ȫѡ',
			width: 35,
			align: 'center',
			editable: false,
			edittype: 'checkbox',
			formatter: "checkbox",
			formatoptions: {
				disabled: true
			}
		}, {
			header: 'TPrescNo',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 20,
			hidden: true
		}, {
			header: 'TOrditm',
			index: 'TOrditm',
			name: 'TOrditm',
			width: 20,
			hidden: true
		}, {
			header: 'TPrescStat',
			index: 'TPrescStat',
			name: 'TPrescStat',
			width: 20,
			hidden: true
		}, {
			header: ("����"),
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 380,
			align: 'left',
			cellattr: addPrescColor
		}, {
			header: ("����"),
			index: 'TPhQty',
			name: 'TPhQty',
			width: 60
		}, {
			header: ("��λ"),
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80
		}, {
			header: ("Ƶ��"),
			index: 'TPC',
			name: 'TPC',
			width: 80
		}, {
			header: ("����"),
			index: 'TJL',
			name: 'TJL',
			width: 100
		}, {
			header: ("�÷�"),
			index: 'TYF',
			name: 'TYF'
		}, {
			header: ("����"),
			index: 'TBarCode',
			name: 'TBarCode',
			width: 120,
			hidden: true
		}, {
			header: ("�׻��ʶ"),
			index: 'IecTypeStr',
			name: 'IecTypeStr',
			width: 120,
			formatter: formatterIecTypeIcon
		}, {
			header: 'TInci',
			index: 'TInci',
			name: 'TInci',
			width: 120,
			hidden: true
		},
	];
	var jqOptions = {
		colModel: columns,
		multiselect: false,
		height: 380,
		width: 975,
		recordtext: "",
		pgtext: "",
		datatype: 'local',
		autowidth: false,
		onSelectRow: function (id, status) {
			CheckAction(id);
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#grid-checkdrug").clearJqGrid();
			} else {
				$(this).jqGrid('setSelection', 1);
			}
		}
	};
	$("#grid-checkdrug").dhcphaJqGrid(jqOptions);
	$("#jqgh_grid-checkdrug_TSelect").html('<a>'+$g('ȫѡ')+'</a>')
    $("#jqgh_grid-checkdrug_TSelect a").on('click',function(){SelectAll()})
}
function formatterIecTypeIcon(cellvalue, options, rowObject) {
	var IecTypeStr = cellvalue;
	var Inci = rowObject.TInci;
	var htmlStr = "";
	var IecTyp = "";
	if (IecTypeStr.indexOf("1") > -1) { //����
		IecTyp = "1";
		htmlStr = "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("����") + "' src='../scripts/pharmacy/common/image/drug-look-like-small.svg' width='20' height='20'   border=5/></a>";
	}
	if (IecTypeStr.indexOf("2") > -1) { //����
		IecTyp = "2";
		htmlStr = htmlStr + "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("����") + "' src='../scripts/pharmacy/common/image/drug-sounds-like-small.svg' width='20' height='20'  border=5/></a>";
	}
	if (IecTypeStr.indexOf("3") > -1) { //һƷ���
		IecTyp = "3";
		htmlStr = htmlStr + "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("һƷ���") + "' src='../scripts/pharmacy/common/image/drug-many-rules-small.svg' width='20' height='20' border=5/></a>";
	}
	return htmlStr;
}
function addPrescColor(rowId, val, rawObject, cm, rdata) {
	if (rdata.TOrditm == 0) {
		return "class=dhcpha-record-disped";
	}
	var TSelect = rdata.TSelect;
	if (TSelect == "Yes") {
		return "class=dhcpha-record-printed";
	}
}

//���غ˶Խ�������
function loadCheckData(patno) {
	ifPatNoEnter = false;
	var windID = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var phl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var myparams = "";
	var ids = $('#grid-fy').getDataIDs(); //�������ݱ��ID����["1","2","3"..]
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		var getRow = $('#grid-fy').getRowData(ids[i]); //��ȡ��ǰ��������
		var prescno = getRow.TPrescNo || "";
		if (prescno == "") {
			continue;
		}
		//���ƴ��
		if (myparams == "") {
			myparams = phl + "^" + prescno;
		} else {
			myparams = myparams + "#" + phl + "^" + prescno;
		}
	}
	if (myparams == "") {
		return;
	}
	var retData = tkMakeServerCall("PHA.OP.PyDisp.Query", "GetDrugTotal", myparams, patno, windID);
	var retJSON = eval("(" + retData + ")");
	if (retJSON.prescDetail.length == 0) {
		if (prescInfoHTML != "<b></b>") {
			$("#grid-checkdrug").clearJqGrid();
			$("#modal-checkdrug").modal('hide');
			dhcphaMsgBox.alert(prescInfoHTML); //��ʾ�������ڵ�ȡҩ��Ϣ
			return;
		} else {
			$("#grid-checkdrug").clearJqGrid();
			$("#modal-checkdrug").modal('hide');
			return;
		}
	} else {
		$("#modal-checkdrug").modal('show');
	}
	//��ʾ������Ϣ
	var patInfo = retJSON.patInfo;
	var patInfoHTML = '<b>' + patInfo.patName + " " + patInfo.patSex + " " + patInfo.patAge + " " + patInfo.patNo + "</b>";
	$("#span-patInfo").html(patInfoHTML);
	$("#span-patMR").html('<p align="left">' + patInfo.allMRDiagnos + '</p>');
	/*
	//��ʾ������Ϣ
	var prescNoInfo = retJSON.prescNoInfo;
	var prescInfoHTML = '<b>';
	for(var j=0; j<prescNoInfo.length; j++){
	if(j==0){
	prescInfoHTML = prescInfoHTML + prescNoInfo[j];
	continue;
	}
	if(j%3==0){
	prescInfoHTML = prescInfoHTML + "<br/>" + prescNoInfo[j];
	}else{
	prescInfoHTML = prescInfoHTML + "; " + prescNoInfo[j];
	}
	}
	prescInfoHTML = prescInfoHTML + '</b>';
	$("#span-prescInfo").html(prescInfoHTML);
	 */
	//��ʾ������ϸ
	$("#grid-checkdrug").setGridParam({
		datatype: 'local',
		data: retJSON.prescDetail
	}).trigger("reloadGrid");
}

// ȫѡ(ȫ���˶�)
function SelectAll() {
	var tmpSelectFlag = "";
	if($("#jqgh_grid-checkdrug_TSelect a").text()==$g("ȫѡ")){
		$("#jqgh_grid-checkdrug_TSelect a").text($g("ȫ��"));
		tmpSelectFlag="Y"
	}else{
		$("#jqgh_grid-checkdrug_TSelect a").text($g("ȫѡ"));
		tmpSelectFlag="N"
	}

	var ids = $('#grid-checkdrug').getDataIDs(); //�������ݱ��ID����["1","2","3"..]
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		//���˴�������
		var id = ids[i];
		var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', id);
		var TOrditm = selrowdata.TOrditm;
		if (TOrditm == 0) {
			continue;
		}
		var TPrescStat = selrowdata.TPrescStat;
		if (TPrescStat == "Yes") {
			continue;
		}
		//���Ŵ�������ɺ˶Բ������޸�
		//���½��湴ѡ״̬
		var newdata = {
			TSelect: tmpSelectFlag
		};
		$("#grid-checkdrug").jqGrid('setRowData', i + 1, newdata);
	}
}

// �˶Խ���: ����л��ߺ˶�
function CheckAction(id) {
	var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', id);
	var TSelect = selrowdata.TSelect;
	var TOrditm = selrowdata.TOrditm;
	var TPrescStat = selrowdata.TPrescStat;
	if (TPrescStat == "Yes") {
		return;
	} //���Ŵ�������ɺ˶Բ������޸�
	var TPrescNo = selrowdata.TPrescNo;
	//�޸ı�״̬
	if (TSelect == "Yes") {
		var tempSelFlag = "No";
	} else {
		var tempSelFlag = "Yes";
	}
	if (TOrditm == 0) {
		return
	}
	//�޸���ʾ״̬
	var newdata = {
		TSelect: tempSelFlag
	};
	$("#grid-checkdrug").jqGrid('setRowData', id, newdata);
	//�ı�����ɫ
	var TPhDesc = selrowdata.TPhDesc;
	if (tempSelFlag == "Yes") {
		var bgcolor = $(".dhcpha-record-printed").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-checkdrug").setCell(id, 'TPhDesc', TPhDesc, cssprop);
	} else {
		var cssprop = {
			background: '#fff',
			color: 'black'
		};
		$("#grid-checkdrug").setCell(id, 'TPhDesc', TPhDesc, cssprop);
	}
}

function CheckDrugItm() {
	var barcode = $.trim($("#txt-drugbarcode").val());
	if (barcode == "")
		return;
	var ids = $('#grid-checkdrug').getDataIDs(); //�������ݱ��ID����["1","2","3"..]
	var len = ids.length;
	var sussNum = 0;
	for (var i = 0; i < len; i++) {
		//���˴�������
		var id = ids[i];
		var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', id);
		var TOrditm = selrowdata.TOrditm;
		if (TOrditm == 0) {
			continue;
		}
		var TPrescStat = selrowdata.TPrescStat;
		if (TPrescStat == "Yes") {
			continue;
		} 
		//���Ŵ�������ɺ˶Բ������޸�
		var gridBarCode = selrowdata.TBarCode;
		if ((gridBarCode != "") && (gridBarCode.indexOf(barcode + ",") > -1)) {
			var newdata = {
				TSelect: 'Yes'
			};
			$("#grid-checkdrug").jqGrid('setRowData', i + 1, newdata);
			var TPhDesc = selrowdata.TPhDesc;
			var bgcolor = $(".dhcpha-record-printed").css("background-color");
			var cssprop = {
				background: bgcolor,
				color: 'black'
			};
			$("#grid-checkdrug").setCell(i + 1, 'TPhDesc', TPhDesc, cssprop);
			sussNum = sussNum + 1
		}
	}
	if (sussNum == 0) {
		dhcphaMsgBox.alert($g("ҩƷ��Ϣ���޴�������Ϣ��")); //��ʾ�������ڵ�ȡҩ��Ϣ
		return;
	}
	$('#txt-drugbarcode').val("");
	$('#txt-drugbarcode').focus();

}
// �˶Խ���: �ո���˶Թ���
function CheckBySpaceKey() {
	var ids = $('#grid-checkdrug').getDataIDs();
	var len = ids.length;
	if (len == 0) {
		return;
	}
	var selectid = $("#grid-checkdrug").jqGrid('getGridParam', 'selrow'); //��ȡ��ǰѡ�е���ID
	var nextid = parseFloat(selectid) + 1; //��һ��
	var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', nextid);
	var TOrditm = selrowdata.TOrditm;
	if (TOrditm == 0) {
		nextid = nextid + 1; //����Ǵ�����
	}
	if (nextid <= len) {
		$("#grid-checkdrug").jqGrid('setSelection', nextid);
		CheckAction(nextid);
	}
}

// �˶Խ���:���ȫ��
function AllFYByClick() {
	ExecuteAllFY();
	$("#modal-checkdrug").modal('hide');
}

function ShowIncEasyCon(event, Inci, Type) {
	var retData = tkMakeServerCall("PHA.OP.PyDisp.Query", "GetIncEasyCon", Inci, Type);
	var retJSON = eval("(" + retData + ")");

	var infoLen = retJSON.length;
	if (infoLen == 0) {
		return;
	}
	var firstInfo = retJSON[0];
	var inciCode = firstInfo.InciCode;
	var inciDesc = firstInfo.InciDesc;
	var manfDesc = firstInfo.ManfDesc;
	var Spec = firstInfo.Spec;
	var docStr = firstInfo.DocStr; //�ļ���Ϣ

	var modalwidth = $("#dialogCheckDrug").innerWidth();
	var modalhight = $("#dialogCheckDrug").innerHeight();
	var tipwidth = 600;
	var tipheight = 330;
	var left = (document.body.clientWidth - tipwidth) / 2; //window.event.clientX-((document.body.clientWidth-modalwidth)/2)-tipwidth -30;   //200;  //
	var top = (document.body.clientHeight - tipheight) / 2; //window.event.clientY-(document.body.clientHeight-modalhight)/2 -tipheight-110; ;
	if (top < -15) {
		top = window.event.clientY - (document.body.clientHeight - modalhight) / 2 - 100;
	}
	var imgName = "";
	if (docStr.length > 0) {
		var imgName = docStr[0].DocName;
	}
	var imgSrc = GetHttpFile(imgName);
	if (imgSrc == "") {
		imgSrc = "../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
	}
	var htmlStr = "";
	htmlStr += '	<div class=" modal-content" style="height:' + tipheight + 'px;width:' + tipwidth + 'px;z-index:999;position:fixed;left:' + left + ';top:' + top + '" align="left" >'; //;overflow-y:auto
	htmlStr += '		<div class="modal-header modal_header_style" >';
	htmlStr += '			<span class="modal-title" style="background-color:#556983;"><i style="font-size:15px;" class="fa fa-medkit"></i>' + $g("�׻���Ϣ") + '</span>';
	htmlStr += '		</div>';
	htmlStr += '		<div style="height:280px;word-break:break-all;" >'; //border-bottom-style:dashed;
	htmlStr += '			<div style="padding:5px;float:left">';
	htmlStr += '				<img src=' + imgSrc + ' height="280px" width="400px">';
	htmlStr += '			</div>';
	htmlStr += '			<div style="padding:5px">';
	htmlStr += '				<div>';
	htmlStr += '					<a style="color:black">' + $g("����") + ':</a>';
	htmlStr += '					<a style="color:red">' + inciCode + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("����") + ':</a>';
	htmlStr += '					<a style="color:red">' + inciDesc + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("���") + ':</a>';
	htmlStr += '					<a style="color:red">' + Spec + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("������ҵ") + ':</a>';
	htmlStr += '					<a style="color:red">' + manfDesc + '</a>';
	htmlStr += '				</div>';
	htmlStr += '			</div>';
	htmlStr += '		</div>';
	htmlStr += '	</div>';

	var showbox = $(htmlStr).css({
		position: 'fixed',
		top: top,
		left: left
	}).addClass("showbox");
	showbox.insertAfter(event);
}
function HideIncEasyCon(event) {
	$("#modal-inceasycon").modal('hide');
	$(".showbox").remove();
}

function ChkUnFyThisLoc(dspPrescNum)
{
	var PatNo=curPatNo
	var LocId=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    var GroupId=DHCPHA_CONSTANT.SESSION.GROUP_ROWID;
    var UserId=DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
    var ChkUnFyRet=tkMakeServerCall("PHA.OP.COM.Method","GetSingleProp",GroupId,LocId,UserId,"ChkUnDispPrescNum")
    if (ChkUnFyRet!="Y") return;
    
	var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;	 
	if(dspPrescNum!=1){
	   var successNum=0;
	   for (var rowi = 1; rowi <= fygridrows; rowi++) {
		   rowdata = fyrowdata[rowi-1]
		   var okFlag = rowdata.TFyFlag;		 
		   if(okFlag == "OK")successNum = successNum + 1
	   }
	   dspPrescNum = successNum;
   }
    var GPhl=DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var StDate = $("#date-start").val();
	var EndDate = $("#date-end").val();
    
    if (PatNo!=""){
		var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",StDate,EndDate,PatNo,GPhl)
		var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",StDate,EndDate,PatNo,GPhl,GPhw)
		if (unDspNum<0) unDspNum=0
		if (unDspNum>=0) { 
			var prescNum = parseInt(unDspNum) + dspPrescNum;
			var alertMsg=$g("�û��߱��ξ��ﹲ�ɷѴ�����������")+prescNum+"<br>"+$g("�˴η�ҩ��������")+dspPrescNum+"</br>"+$g("������������")+unDspNum
			if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
			dhcphaMsgBox.alert(alertMsg)
	   }
		else  if (otherLocRet!="") {
			dhcphaMsgBox.alert(otherLocRet)
		}
    }else  {
		dhcphaMsgBox.alert($g("�˴η�ҩ��������")+dspPrescNum);
	}
}
// add by zhaoxinlong  2022.05.16 
function IsOnlyOnePatno()
{
   var checkflag = '0';
   var firstrowdata = $("#grid-fy").jqGrid('getRowData', 1);
   var firstpatno = firstrowdata.patNo;
   var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
   for (var rowi = 1; rowi <= fygridrows; rowi++) {
	   var rowdata = $("#grid-fy").jqGrid('getRowData', rowi);
	   var patno = rowdata.patNo;
	   if (patno != firstpatno){
		   checkflag = '1';
		   return false;
	   }	
   }
   if (checkflag == '1'){
	   return false;
   }
   return true;
}

function ChkDataBeforeALLFY(){
	var $grid = $("#grid-fy")
	var fyrowdata = $grid.jqGrid('getRowData');
    var fygridrows = fyrowdata.length;
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		var rowdata = $grid.jqGrid('getRowData', rowi);
		var okFlag = rowdata.TFyFlag;		 
		if(okFlag == "OK"){
			return false;
		}
   	}
	return true;
}
