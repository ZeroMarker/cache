/*
 *模块:门诊药房
 *子模块:日常业务-基数药补货单查询
 *createdate:2016-12-07
 *creator:dinghongying
 */
$(function () {
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
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
	InitPhaLoc();
	InitBasicLoc();
	InitSupplyQueryList();
	InitSupplyQueryTotalList();
	ClearConditions();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-print').on('click', BPrintHandler);
	/* 绑定按钮事件 end*/
;
	$("#supplyquerydg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
	$("#supplyquerytotaldg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//初始化科室
function InitPhaLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetUserAllLocDs&style=select2&gUserId=" +
		DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
		allowClear: false,
		minimumResultsForSearch: Infinity
	}
	$("#sel-phaloc").dhcphaSelect(selectoption);
	var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
		$("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
	$('#sel-phaloc').on('select2:select', function (event) {
		//alert(event)
	});
}

//初始化基数科室
function InitBasicLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetBasicLocList&style=select2",
		allowClear: true,
		width: '11em',
		placeholder: '基数科室...'
	}
	$("#sel-basicloc").dhcphaSelect(selectoption);
	$('#sel-basicloc').on('select2:select', function (event) {
		//alert(event)
	});
}

//初始化基数药补货单列表
function InitSupplyQueryList() {
	//定义columns
	var columns = [[{
				field: 'Tward',
				title: '病区',
				width: 60,
				hidden: true
			}, {
				field: 'Tdocloc',
				title: '基数科室',
				width: 150
			}, {
				field: 'Tsuppdate',
				title: '日期',
				width: 80
			}, {
				field: 'Tsupptime',
				title: '时间',
				width: 70
			}, {
				field: 'Tusername',
				title: '操作人',
				width: 100
			}, {
				field: 'Tsuppno',
				title: '单号',
				width: 150
			}, {
				field: 'Tsupp',
				title: '',
				width: 60,
				align: 'center',
				hidden: true
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		onSelect: function (rowIndex, rowData) {
			QuerySub();
		},
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
			}
		}
	}
	//定义datagrid
	$('#supplyquerydg').dhcphaEasyUIGrid(dataGridOption);
}

//初始化基数药补货单汇总列表
function InitSupplyQueryTotalList() {
	//定义columns
	var columns = [[{
				field: 'Tincicode',
				title: '药品代码',
				width: 100
			}, {
				field: 'Tincidesc',
				title: '药品名称',
				width: 300
			}, {
				field: 'Tqty',
				title: '发药数量',
				width: 100
			}, {
				field: 'Tspec',
				title: '规格',
				width: 135
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true
	}
	//定义datagrid
	$('#supplyquerytotaldg').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
	$('#supplyquerytotaldg').clearEasyUIGrid();
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var WardId = ""
		var DispLocId = $("#sel-phaloc").val();
	if (DispLocId == null) {
		DispLocId = "";
		dhcphaMsgBox.alert("请选择药房!");
		return;
	}
	var DoctorLocId = $("#sel-basicloc").val();
	if (DoctorLocId == null) {
		DoctorLocId = "";
	}
	var DispNo = $("#txt-supplyno").val();
	var OutFlag = "1";
	var InFlag = "0";
	var PamStr = OutFlag + "^" + InFlag;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + DispLocId + tmpSplit + WardId + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + DoctorLocId + tmpSplit + DispNo + tmpSplit + PamStr;
	$('#supplyquerydg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Supply.Query",
			QueryName: "SupplyList",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});

}

///基数药补货单汇总查询
function QuerySub() {
	var selecteddata = $('#supplyquerydg').datagrid('getSelected');
	if (selecteddata == null) {
		return;
	}
	var supp = selecteddata["Tsupp"];
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params =supp;
	$('#supplyquerytotaldg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Supply.Query",
			QueryName: "SupplyTotal",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});
}

//清空
function ClearConditions() {
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "23:59:59");
	InitPhaLoc();
	$("#sel-basicloc").empty();
	$("#txt-supplyno").val("");
	$('#supplyquerydg').clearEasyUIGrid();
	$('#supplyquerytotaldg').clearEasyUIGrid();
}

///基数药补货单打印
function BPrintHandler() {
	if ($('#supplyquerydg').datagrid('getData').rows.length == 0) //获取当前界面数据行数
	{
		dhcphaMsgBox.alert("页面没有数据!");
		return;
	}
	var gridSelected = $('#supplyquerydg').datagrid('getSelected');
	if (gridSelected == null) {
		dhcphaMsgBox.alert("请选择需要打印的行!");
		return;
	}
	if ($('#supplyquerytotaldg').datagrid('getData').rows.length == 0) //获取当前界面数据行数
	{
		dhcphaMsgBox.alert("页面没有数据");
		return;
	}
	PrintSupp(gridSelected.Tsupp);
}
