/*
 *模块:门诊药房
 *子模块:门诊药房-发药
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
	/* 初始化插件 start*/
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

	/* 表单元素事件 start*/
	//登记号回车事件
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
	//卡号回车事件
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
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* 表单元素事件 end*/

	/* 绑定按钮事件 start*/
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
		websys_createWindow(lnk, $g("退药"), "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#btn-readcard").on("click", BtnReadCardHandler); //读卡
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
	/* 绑定按钮事件 end*/
	
	InitBodyStyle();
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: $g("有人"),
			offText: $g("无人"),
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

	InitModalCheckDrug(); // 核对处方药品明细modal
	HotKeyInit("FY", "grid-fy");
	Setfocus();
	if (NoJudgWinFlag=="Y") {
		$('#noJudgWin').css('display', 'inline-block');
	}

})
//初始化药品选择
function InitThisLocInci(locrowid) {
	var locincioptions = {
		id: "#sel-locinci",
		locid: locrowid
	}
	InitLocInci(locincioptions)
}
//初始化发药table
function InitGridFY() {
	var columns = [{
			header: ("发药状态"),
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 65,
			cellattr: addPhDispStatCellAttr
		}, {
			header: ("姓名"),
			index: 'TPatName',
			name: 'TPatName',
			width: 100
		}, {
			header: ("登记号"),
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 100
		}, {
			header: ("收费日期"),
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100
		}, {
			header: ("收据号"),
			index: 'TPrtInv',
			name: 'TPrtInv',
			width: 100,
			hidden: true
		}, {
			header: ("处方号"),
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 115
		}, {
			header: ("处方金额"),
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		}, {
			header: ("性别"),
			index: 'TPerSex',
			name: 'TPerSex',
			width: 40
		}, {
			header: ("年龄"),
			index: 'TPerAge',
			name: 'TPerAge',
			width: 40
		}, {
			header: ("审核状态"),
			index: 'TDocSS',
			name: 'TDocSS',
			width: 70
		}, {
			header: ("合理用药"),
			index: 'TPassCheck',
			name: 'TPassCheck',
			width: 70,
			hidden: true
		}, {
			header: ("病人密级"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		}, {
			header: ("病人级别"),
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		}, {
			header: ("诊断"),
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
			header: ("序号"),
			index: 'TNoteCode',
			name: 'TNoteCode',
			width: 50,
			hidden: true
		}, {
			header: ("药框号"),
			index: 'TBoxNum',
			name: 'TBoxNum',
			width: 60,
			hidden: true
		}, {
			header: ("发药"),
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=jsQueryFYList&style=jqGrid', //查询后台
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		multiselect: false,
		pager: "#jqGridPager", //分页控件的id
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
				//加载核对界面数据
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

//初始化发药明细table
function InitGirdFYDetail() {
	var columns = [{
			header: ("明细状态"),
			index: 'TPhDispItmStat',
			name: 'TPhDispItmStat',
			width: 65,
			cellattr: addPhDispItmStatCellAttr
		}, {
			header: '图标',
			index: 'drugIcon',
			name: 'drugIcon',
			width: 70,
			align: 'left',
			formatter: DrugIcon
		}, {
			header: ("药品名称"),
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 200,
			align: 'left',
			cellattr: DrugColor
		}, {
			header: ("数量"),
			index: 'TPhQty',
			name: 'TPhQty',
			width: 50,
			align: 'right'
		}, {
			header: ("单位"),
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80
		}, {
			header: ("规格"),
			index: 'TPhgg',
			name: 'TPhgg',
			width: 100
		}, {
			header: ("剂量"),
			index: 'TJL',
			name: 'TJL',
			width: 60
		}, {
			header: ("频次"),
			index: 'TPC',
			name: 'TPC',
			width: 60
		}, {
			header: ("用法"),
			index: 'TYF',
			name: 'TYF',
			width: 60
		}, {
			header: ("疗程"),
			index: 'TLC',
			name: 'TLC',
			width: 80
		}, {
			header: ("货位"),
			index: 'TIncHW',
			name: 'TIncHW',
			width: 100
		}, {
			header: ("备注"),
			index: 'TPhbz',
			name: 'TPhbz',
			width: 80
		}, {
			header: ("生产企业"),
			index: 'TPhFact',
			name: 'TPhFact',
			width: 200,
			align: 'left'
		}, {
			header: ("库存数量"),
			index: 'TKCQty',
			name: 'TKCQty',
			width: 80
		}, {
			header: ("医保类型"),
			index: 'TYBType',
			name: 'TYBType',
			width: 75
		}, {
			header: ("单价"),
			index: 'TPrice',
			name: 'TPrice',
			width: 60,
			align: 'right'
		}, {
			header: ("金额"),
			index: 'TMoney',
			name: 'TMoney',
			width: 40,
			align: 'right'
		}, {
			header: ("状态"),
			index: 'TOrdStatus',
			name: 'TOrdStatus',
			width: 40
		}, {
			header: ("发票号"),
			index: 'TPrtNo',
			name: 'TPrtNo',
			width: 100
		},{
			header: ("国家医保编码"),
			index: 'TCInsuCode',
			name: 'TCInsuCode',
			width: 120
		},{
			header: ("国家医保名称"),
			index: 'TCInsuDesc',
			name: 'TCInsuDesc',
			width: 120
		}
	];
	var jqOptions = {
		datatype: 'local',
		rowNum: 200,
		colModel: columns, //列
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

//叫号消息发送
function SendMessToVoice(rowIndex) {
	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("没有选中数据,不能叫号!"));
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
	SendOPInfoToMachine("103^107", "", patno) // 叫号亮灯	叫号上屏
	var SendVoiceRet = tkMakeServerCall("PHA.FACE.IN.Com", "SendMessToVoice", patno, patname, serverip, window, FYUserID);
	QueryGridWaitFY();
}
function PassQueueNo(rowIndex, state) {
	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert($g("没有选中数据,不需过号!"));
		return;
	}
	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var phwQuId = selrowdata.phwQuId;
	if (phwQuId == "") {
		dhcphaMsgBox.alert($g("没有报到排队,不需过号!"));
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
//初始化待发药table
function InitGirdWAITFY() {
	var columns = [{
			header: ("叫号"),
			index: 'tSendVoice',
			name: 'tSendVoice',
			width: 80,
			cellattr: addtSendVoiceCellAttr,
			formatter: CallPatForMat
		}, {
			header: ("姓名"),
			index: 'tbname',
			name: 'tbname',
			width: 100
		}, {
			header: ("登记号"),
			index: 'tbpatid',
			name: 'tbpatid',
			width: 100
		}, {
			header: ("排队号"),
			index: 'queueNo',
			name: 'queueNo',
			width: 100
		}, {
			header: ("叫号状态"),
			index: 'callFlag',
			name: 'callFlag',
			width: 100,
			hidden: true
		}, {
			header: ("叫号id"),
			index: 'phwQuId',
			name: 'phwQuId',
			width: 100,
			hidden: true
		}, {
			header: ("病人密级"),
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		}, {
			header: ("病人级别"),
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
		colModel: columns, //列
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
				if ((warnLevel.indexOf($g("毒")) >= 0) || (warnLevel.indexOf($g("麻")) >= 0)) {
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
//查询待发药table
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
//查询发药列表
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
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //这是配药窗口的ID
	var CPatName = "";
	var CPrescNo = "";
	var chkNoJudgWinFlag=""
	if (NoJudgWinFlag="Y") {
		if ($("#chk-noJudgWin").is(':checked')) chkNoJudgWinFlag=1
	}
	if((OnlyDispByPatNoFlag =="Y")&&(patno=="")&&(chkfy!="1")){
		dhcphaMsgBox.alert($g("请输入患者信息后查询!"));
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
//查询发药明细
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
// 执行发药
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,不能发药!"));
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

//执行全发
function ExecuteAllFY() {
	var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert($g("没有数据!"));
		return;
	}
	// 全发前简单检验下数据
	var retFlag = ChkDataBeforeALLFY()
	if(retFlag==false){
		dhcphaMsgBox.alert($g("当前处方数据中，有已发数据，请重新查询后再试！"), "error");
		return;
	}
	if ((IsOnlyOnePatno() == false)){
		if (OnlyDispByPatNoFlag = 'Y') {
			dhcphaMsgBox.alert($g("多个患者处方不允许使用全发!"), "warn");	
			return;
		}
		var warntitle = $g("存在多个患者的处方确认全发吗?系统将全部发放查询出的所有处方!")
	}else {
		var warntitle = $g("确认全发吗?系统将全部发放查询出的所有处方!")
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

 /* 检查收费情况 */
 function CheckPayment(rowid){
	var selectrow = $("#grid-fy").jqGrid('getRowData', rowid);
	var prescNo = selectrow.TPrescNo;
	/* 获取处方中的未交费医嘱信息 */
	var unPaidInfo = GetUnPaidOrder(prescNo)
		/* 存在未交费时是否允许发药 */
	if (unPaidInfo !== ""){
		if (PartPiedDispFlag == "Y") {
			dhcphaMsgBox.confirm(prescNo + $g("中存在未交费的医嘱明细!医嘱名称为:") + "<br/>" + unPaidInfo + "<br/>" + $g("点击[确认]将继续发药，点击[取消]将放弃发药操作。"), function (r) {
				if (r == true) {
					DispensingMonitor(rowid);	
				} else {
					return;
				}
			});
		}
		else {
			dhcphaMsgBox.alert(prescNo + $g("中存在未交费的医嘱明细,禁止发药!医嘱名称为:") + "<br/>" + unPaidInfo);
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
		dhcphaMsgBox.alert($g("请先审核!"))
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert($g("该处方审核不通过,禁止发药!"))
		return;
	} else if (adtresult == "S") {
		if (!confirm($g("该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。"))) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno);
	if (checkprescref == "N") {
		dhcphaMsgBox.alert($g("该处方已被拒绝,禁止发药!"));
		return;
	}
	if (checkprescref == "A") {
		dhcphaMsgBox.alert($g("该处方已被拒绝,禁止发药!"));
		return;
	}
	if (checkprescref == "S") {
		dhcphaMsgBox.confirm($g("该处方医生已提交申诉<br/>点击[确认]将同意申诉继续发药，点击[取消]将放弃发药操作。"), function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //申诉后发药应先撤消拒绝
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
		$("#grid-fy").setCell(rowid, 'TPhDispStat', $g("已发药"), cssprop);
		AfterExecPrint(prescno, PrintType, phdrowid, "");
		SendOPInfoToMachine("104^108^110", prescno, ""); //104发药灭灯 108发药时下屏 110发送机(处方状态)
		QueryGridWaitFY();
		ChkUnFyThisLocFlag="1";
	} else {
		dhcphaMsgBox.alert($g(retmessage), "error")
		tipNum = tipNum + 1;
		return;
	}
}

// 执行拒绝发药
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,不能拒绝发药!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("处方已发药，不能拒绝!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	if (prescno == "") {
		dhcphaMsgBox.alert($g("请选择要拒绝的处方"));
		return;
	}
	var ref = GetOrdRefResultByPresc(prescno);
	if (ref == "N") {
		dhcphaMsgBox.alert($g("该处方已被拒绝,不能重复操作!"))
		return;
	} else if (ref == "A") {
		dhcphaMsgBox.alert($g("该处方已被拒绝,不能重复操作!"))
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno);
	if (checkprescadt == "") {
		dhcphaMsgBox.alert($g("该处方未审核,禁止操作!"))
		return;
	} else if (checkprescadt != "Y") {
		dhcphaMsgBox.alert($g("该处方审核未通过,禁止操作!"))
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
		$("#grid-fy").setCell(selectid, 'TDocSS', $g("拒绝发药"));
	} else {
		dhcphaMsgBox.alert($g("拒绝失败!错误代码:") + refuseret)
		return;
	}
}

// 撤消拒绝发药
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,不能撤消拒绝发药!"));
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	var prescno = selrowdata.TPrescNo;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert($g("该记录已经发药!"));
		return;
	}
	if (prescno == "") {
		dhcphaMsgBox.alert($g("请选择要撤消拒绝的处方"));
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  处方拒绝
	if ((checkprescref != "N") && (checkprescref != "A")) {
		if (checkprescref == "S") {
			dhcphaMsgBox.alert($g("该处方医生已提交申诉,不需要撤消!"))
			return;
		} else {
			dhcphaMsgBox.alert($g("该处方未被拒绝,不能撤消操作!"))
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
		dhcphaMsgBox.alert($g("撤消成功!"), "success");
	} else if (cancelrefuseret == "-2") {
		dhcphaMsgBox.alert($g("该处方未被拒绝,不能撤消操作!"));
	} else if (retval == "-3") {
		dhcphaMsgBox.alert($g("该处方已撤消,不能再次撤消!"));
	}
}
//获取处方拒绝结果
function GetOrdRefResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	return ref;
}
//获取处方审核结果
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//获取拒绝发药和处方审核结果
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//获取处方中未交费医嘱明细
function GetUnPaidOrder(prescno) {
	var ref = tkMakeServerCall("PHA.OP.COM.Method", "GetUnPaidInfo", prescno);
	return ref;
}
//获取其他科室未发药记录,仅读卡发药时
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
		// alert("病人为空,请读卡")
	} else if (ret == -2) {
		dhcphaMsgBox.alert($g("没找到登记号为") + patno + $g("的病人"));
		return;

	} else if ((ret != "") && (ret != null)) {
		dhcphaMsgBox.alert(ret);
	}
}
//打印
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,无法打印!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Presc(prescno, "", "");
}
//重打标签
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert($g("没有选中数据,无法打印!"));
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno);
}
//清空
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

//本页面table可用高度
function OutFYCanUseHeight() {
	var conditionheight = QueryConditionHeight();
	var panelheadheight = PanelHeadingHeight(2);
	var tableheight = $(window).height() - conditionheight - panelheadheight - 117;
	return tableheight;
}

//初始化配药窗口table
function InitGridWin() {
	var columns = [{
			header: ("药房窗口"),
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		}, {
			header: ("窗口状态"),
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
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&ChkRelFlag=',
		height: '100%',
		autowidth: true,
		loadComplete: function () {}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}

function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "有人") {
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
		dhcphaMsgBox.alert($g("请确保至少一个窗口为有人状态!"));
		return false;
	} else {
		dhcphaMsgBox.alert($g("修改窗口状态失败,错误代码:") + modifyret, "error");
		return false;
	}
}

//发药窗口确认
function FYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var fywindata = $("#sel-window").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert($g("发药窗口不能为空!"));
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

//权限验证
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
				permissionmsg = $g("药房科室:") + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签中维护!")
			} else {
				permissionmsg = $g("工号:") + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "　　" + $g("姓名:") + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签中维护!")
				} else if (retdata.phnouse == "Y") {
					permissioninfo = $g("门诊药房科室配置的人员权限页签中已设置为无效!")
				} else if (retdata.phfy != "Y") {
					permissioninfo = $g("门诊药房科室配置的人员权限页签中未设置发药权限!")
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				});
				//点灰色区域不关闭
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
//初始化发药窗口
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
	if (val == $g("已配药")) {
		return "class=dhcpha-record-pyed";
	} else if (val == $g("已打印")) {
		return "class=dhcpha-record-printed";
	} else if (val == $g("已发药")) {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}

function addPhDispItmStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == $g("库存不足")) {
		return "class=dhcpha-record-nostock";
	} else if ((val.indexOf($g("作废")) > 0) || (val.indexOf("停止") > 0)) {
		return "class=dhcpha-record-ordstop";
	} else if ((val.indexOf($g("退费")) > 0)|| (val.indexOf($g("未收费")) > -1)) {
		return "class=dhcpha-record-owefee";
	}else {
		return "";
	}
}
// 读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
// 读卡返回操作
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
// 初始化核对界面
function InitModalCheckDrug() {
	// 初始化表格
	InitGirdCheck();

	// 隐藏显示事件
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

	// 弹窗里面的按钮事件
	$("#btn-modal-sure").on("click", CompleteCheckPresc); //完成核对
	$("#btn-modal-cancel").on("click", HideModalCheckDrug); //取消核对
	$("#btn-modal-dispall").on("click", AllFYByClick); //全发

	//卡号回车事件
	$('#txt-drugbarcode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var barcode = $.trim($("#txt-drugbarcode").val());
			if (barcode != "") {
				CheckDrugItm();
			}
		}
	});
}

// 完成处方核对
function CompleteCheckPresc() {
	var prescStr = "";
	var ids = $('#grid-checkdrug').getDataIDs();
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		var getRow = $('#grid-checkdrug').getRowData(ids[i]);
		var TSelect = getRow.TSelect;
		var TOrditm = getRow.TOrditm;
		if (TSelect == "No" && TOrditm != 0) {
			dhcphaMsgBox.alert($g("有药品未核对!"));
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
		dhcphaMsgBox.alert($g("确认失败!"));
		return;
	} else {
		$("#modal-checkdrug").modal('hide'); //确认核对
	}
}

// 隐藏弹窗
function HideModalCheckDrug() {
	$("#modal-checkdrug").modal('hide');
}

// 初始化核对列表
function InitGirdCheck() {
	var columns = [
		{
			name: 'TSelect',
			index: 'TSelect',
			header: '全选',
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
			header: ("名称"),
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 380,
			align: 'left',
			cellattr: addPrescColor
		}, {
			header: ("数量"),
			index: 'TPhQty',
			name: 'TPhQty',
			width: 60
		}, {
			header: ("单位"),
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80
		}, {
			header: ("频次"),
			index: 'TPC',
			name: 'TPC',
			width: 80
		}, {
			header: ("剂量"),
			index: 'TJL',
			name: 'TJL',
			width: 100
		}, {
			header: ("用法"),
			index: 'TYF',
			name: 'TYF'
		}, {
			header: ("条码"),
			index: 'TBarCode',
			name: 'TBarCode',
			width: 120,
			hidden: true
		}, {
			header: ("易混标识"),
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
	$("#jqgh_grid-checkdrug_TSelect").html('<a>'+$g('全选')+'</a>')
    $("#jqgh_grid-checkdrug_TSelect a").on('click',function(){SelectAll()})
}
function formatterIecTypeIcon(cellvalue, options, rowObject) {
	var IecTypeStr = cellvalue;
	var Inci = rowObject.TInci;
	var htmlStr = "";
	var IecTyp = "";
	if (IecTypeStr.indexOf("1") > -1) { //看似
		IecTyp = "1";
		htmlStr = "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("看似") + "' src='../scripts/pharmacy/common/image/drug-look-like-small.svg' width='20' height='20'   border=5/></a>";
	}
	if (IecTypeStr.indexOf("2") > -1) { //听似
		IecTyp = "2";
		htmlStr = htmlStr + "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("听似") + "' src='../scripts/pharmacy/common/image/drug-sounds-like-small.svg' width='20' height='20'  border=5/></a>";
	}
	if (IecTypeStr.indexOf("3") > -1) { //一品多规
		IecTyp = "3";
		htmlStr = htmlStr + "<a href='#' onmouseover='ShowIncEasyCon(this,\"" + Inci + '","' + IecTyp + "\")' onmouseout='HideIncEasyCon()'><img title='" + $g("一品多规") + "' src='../scripts/pharmacy/common/image/drug-many-rules-small.svg' width='20' height='20' border=5/></a>";
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

//加载核对界面数据
function loadCheckData(patno) {
	ifPatNoEnter = false;
	var windID = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var phl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var myparams = "";
	var ids = $('#grid-fy').getDataIDs(); //返回数据表的ID数组["1","2","3"..]
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		var getRow = $('#grid-fy').getRowData(ids[i]); //获取当前的数据行
		var prescno = getRow.TPrescNo || "";
		if (prescno == "") {
			continue;
		}
		//入参拼接
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
			dhcphaMsgBox.alert(prescInfoHTML); //提示其他窗口的取药信息
			return;
		} else {
			$("#grid-checkdrug").clearJqGrid();
			$("#modal-checkdrug").modal('hide');
			return;
		}
	} else {
		$("#modal-checkdrug").modal('show');
	}
	//显示病人信息
	var patInfo = retJSON.patInfo;
	var patInfoHTML = '<b>' + patInfo.patName + " " + patInfo.patSex + " " + patInfo.patAge + " " + patInfo.patNo + "</b>";
	$("#span-patInfo").html(patInfoHTML);
	$("#span-patMR").html('<p align="left">' + patInfo.allMRDiagnos + '</p>');
	/*
	//显示处方信息
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
	//显示处方明细
	$("#grid-checkdrug").setGridParam({
		datatype: 'local',
		data: retJSON.prescDetail
	}).trigger("reloadGrid");
}

// 全选(全部核对)
function SelectAll() {
	var tmpSelectFlag = "";
	if($("#jqgh_grid-checkdrug_TSelect a").text()==$g("全选")){
		$("#jqgh_grid-checkdrug_TSelect a").text($g("全消"));
		tmpSelectFlag="Y"
	}else{
		$("#jqgh_grid-checkdrug_TSelect a").text($g("全选"));
		tmpSelectFlag="N"
	}

	var ids = $('#grid-checkdrug').getDataIDs(); //返回数据表的ID数组["1","2","3"..]
	var len = ids.length;
	for (var i = 0; i < len; i++) {
		//过滤处方号行
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
		//整张处方已完成核对不允许修改
		//更新界面勾选状态
		var newdata = {
			TSelect: tmpSelectFlag
		};
		$("#grid-checkdrug").jqGrid('setRowData', i + 1, newdata);
	}
}

// 核对界面: 点击行或者核对
function CheckAction(id) {
	var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', id);
	var TSelect = selrowdata.TSelect;
	var TOrditm = selrowdata.TOrditm;
	var TPrescStat = selrowdata.TPrescStat;
	if (TPrescStat == "Yes") {
		return;
	} //整张处方已完成核对不允许修改
	var TPrescNo = selrowdata.TPrescNo;
	//修改表状态
	if (TSelect == "Yes") {
		var tempSelFlag = "No";
	} else {
		var tempSelFlag = "Yes";
	}
	if (TOrditm == 0) {
		return
	}
	//修改显示状态
	var newdata = {
		TSelect: tempSelFlag
	};
	$("#grid-checkdrug").jqGrid('setRowData', id, newdata);
	//改变行颜色
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
	var ids = $('#grid-checkdrug').getDataIDs(); //返回数据表的ID数组["1","2","3"..]
	var len = ids.length;
	var sussNum = 0;
	for (var i = 0; i < len; i++) {
		//过滤处方号行
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
		//整张处方已完成核对不允许修改
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
		dhcphaMsgBox.alert($g("药品信息中无此条码信息！")); //提示其他窗口的取药信息
		return;
	}
	$('#txt-drugbarcode').val("");
	$('#txt-drugbarcode').focus();

}
// 核对界面: 空格键核对功能
function CheckBySpaceKey() {
	var ids = $('#grid-checkdrug').getDataIDs();
	var len = ids.length;
	if (len == 0) {
		return;
	}
	var selectid = $("#grid-checkdrug").jqGrid('getGridParam', 'selrow'); //获取当前选中的行ID
	var nextid = parseFloat(selectid) + 1; //下一行
	var selrowdata = $("#grid-checkdrug").jqGrid('getRowData', nextid);
	var TOrditm = selrowdata.TOrditm;
	if (TOrditm == 0) {
		nextid = nextid + 1; //如果是处方行
	}
	if (nextid <= len) {
		$("#grid-checkdrug").jqGrid('setSelection', nextid);
		CheckAction(nextid);
	}
}

// 核对界面:点击全发
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
	var docStr = firstInfo.DocStr; //文件信息

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
	htmlStr += '			<span class="modal-title" style="background-color:#556983;"><i style="font-size:15px;" class="fa fa-medkit"></i>' + $g("易混信息") + '</span>';
	htmlStr += '		</div>';
	htmlStr += '		<div style="height:280px;word-break:break-all;" >'; //border-bottom-style:dashed;
	htmlStr += '			<div style="padding:5px;float:left">';
	htmlStr += '				<img src=' + imgSrc + ' height="280px" width="400px">';
	htmlStr += '			</div>';
	htmlStr += '			<div style="padding:5px">';
	htmlStr += '				<div>';
	htmlStr += '					<a style="color:black">' + $g("代码") + ':</a>';
	htmlStr += '					<a style="color:red">' + inciCode + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("描述") + ':</a>';
	htmlStr += '					<a style="color:red">' + inciDesc + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("规格") + ':</a>';
	htmlStr += '					<a style="color:red">' + Spec + '</a>';
	htmlStr += '				</div>';
	htmlStr += '				<div >';
	htmlStr += '					<a style="color:black">' + $g("生产企业") + ':</a>';
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
			var alertMsg=$g("该患者本次就诊共缴费待发处方数：")+prescNum+"<br>"+$g("此次发药处方数：")+dspPrescNum+"</br>"+$g("待发处方数：")+unDspNum
			if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
			dhcphaMsgBox.alert(alertMsg)
	   }
		else  if (otherLocRet!="") {
			dhcphaMsgBox.alert(otherLocRet)
		}
    }else  {
		dhcphaMsgBox.alert($g("此次发药处方数：")+dspPrescNum);
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
