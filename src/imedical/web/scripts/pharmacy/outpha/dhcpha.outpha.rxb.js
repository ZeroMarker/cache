/*
 *模块:门诊药房
 *子模块:药房统计-日消耗统计
 *createdate:2016-12-06
 *creator:dinghongying
 */
var gNewCatId = "";
var QUERYPID = "";
$(function () {
	var daterangeoptions = {
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
		}
	}
	/* 初始化插件 start*/
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);


	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})

	/*药理分类 start*/
	$("#txt-phccat").next().children("i").on('click', function (event) {
		ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				gNewCatId=catObj.id||'';
			}
		})
	});
	/*药理分类 end*/
	InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	InitStkCat();
	InitManaGroup();
	InitFyUser();
	InitRXBList();
	ClearConditions();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-export').on('click', function () { //点击导出
		ExportAllToExcel("rxbdg")
	});
	$('#btn-print').on('click', BtnPrintHandler);
	/* 绑定按钮事件 end*/
;
	$("#rxbdg").closest(".panel-body").height($(window).height() - QueryConditionHeight() - 60);
	//$("#rxbdg").closest(".panel-body").css("min-height",500);

})
//初始化药品选择
function InitThisLocInci(locrowid) {
	var locincioptions = {
		id: "#sel-locinci",
		locid: locrowid
	}
	InitLocInci(locincioptions)
}
//初始化库存分类
function InitStkCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetStkCatDs&style=select2",
		allowClear: true,
		width: 250,
		placeholder: "库存分类..."
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) {
		//alert(event)
	});
}
//初始化管理组
function InitManaGroup() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetManaGroupDs&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		allowClear: true,
		minimumResultsForSearch: Infinity,
		placeholder: "管理组..."
	}
	$("#sel-managroup").dhcphaSelect(selectoption)
	$('#sel-managroup').on('select2:select', function (event) {
		//alert(event)
	});
}

//初始化发药人
function InitFyUser() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetPYUserList&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&gUserId=" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
		allowClear: true,
		placeholder: "发药人..."
	}
	$("#sel-fyuser").dhcphaSelect(selectoption)
	$('#sel-fyuser').on('select2:select', function (event) {
		//alert(event)
	});
}

//日消耗列表
function InitRXBList() {
	//定义columns
	var columns = [[{
				field: 'incCode',
				title: '药品代码',
				width: 80,
				sortable: true
			}, {
				field: 'incDesc',
				title: '药品名称',
				width: 250,
				sortable: true
			}, {
				field: 'qty',
				title: '发出数量',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'uomDesc',
				title: '单位',
				width: 100,
				sortable: true
			}, {
				field: 'sp',
				title: '售价',
				width: 75,
				align: 'right',
				sortable: true
			}, {
				field: 'spAmt',
				title: '发出金额',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'rp',
				title: '进价',
				width: 75,
				align: 'right',
				sortable: true
			}, {
				field: 'rpAmt',
				title: '进价金额',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'manfDesc',
				title: '生产厂家',
				width: 200,
				sortable: true
			}, {
				field: 'pid',
				title: '进程号',
				width: 200,
				sortable: true,
				hidden: true
			}
		]];

	var dataGridOption = {
		url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DayCons.Display&MethodName=EuiGetRXBStat",
		columns: columns,
		fitColumns: true,
		showFooter: true,
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
				QUERYPID = $(this).datagrid("getRows")[0].pid;
				$(this).datagrid("options").queryParams.Pid = QUERYPID;
			}
		}
	}
	//定义datagrid
	$('#rxbdg').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
 	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var gUserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var stkCatId = $("#sel-stk").val();
	if (stkCatId == null) {
		stkCatId = "";
	}
	var fyUserId = $("#sel-fyuser").val();
	if (fyUserId == null) {
		fyUserId = "";
	}
	var manaGroupId = $("#sel-managroup").val();
	if (manaGroupId == null) {
		manaGroupId = "";
	}
	var price = $("#txt-inciSp").val();
	var chkmana = "N";
	if ($("#chk-mana").is(':checked')) {
		chkmana = "Y";
	}
	var inciRowid = $("#sel-locinci").val();
	if (inciRowid == null) {
		inciRowid = "";
	}
	var winposcode = "";
	if ($("#txt-phccat").val() == "") {
		gNewCatId = "";
	}
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + fyUserId + tmpSplit + inciRowid + tmpSplit + stkCatId + tmpSplit + price + tmpSplit + chkmana + tmpSplit + manaGroupId + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + gNewCatId;
	KillTmpGloal();
	$('#rxbdg').datagrid({
		queryParams: {
			InputStr: params,
			Pid: ""
		}
	});

}

//清空
function ClearConditions() {
	$("#sel-stk").empty();
	$("#sel-fyuser").empty();
	$("#sel-locinci").empty();
	$("#txt-inciSp").val("");
	$("#txt-phccat").val("");
	gNewCatId = "";
	$("#sel-managroup").empty();
	$("#chk-mana").iCheck('uncheck');
	$('#rxbdg').clearEasyUIGrid();
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "23:59:59");
	KillTmpGloal();
}
// 清除临时global
function KillTmpGloal() {
	tkMakeServerCall("PHA.OP.DayCons.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
	KillTmpGloal();
}

//打印
function BtnPrintHandler() {
	//获取当面界面数据行数
	if ($('#rxbdg').datagrid('getData').rows.length == 0) {
		dhcphaMsgBox.alert("页面没有数据","info");
		return ;
	}
	// 取页面数据
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var daterange = startdate+" 至 "+enddate;
	var footerData=$("#rxbdg").datagrid('getFooterRows')
	var rpamtTotal=footerData[0].rpAmt;
	var spamtTotal=footerData[0].spAmt;
	var Para = {
		title: DHCPHA_CONSTANT.DEFAULT.LOC.text + "日消耗",
		daterange: daterange,
		rpamtTotal:rpamtTotal,
		spamtTotal:spamtTotal
	}
	//打印公共 Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPDailyConsum',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'rxbdg'}
		},
		listBorder: {style:4, startX:1, endX:170},
		page: {rows:30, x:20, y:2, fontname:'黑体', fontbold:'true', fontsize:'12', format:'第{1}页/共{2}页'},
		aptListFields: ["label9", "spamtTotal"]
	});
}
