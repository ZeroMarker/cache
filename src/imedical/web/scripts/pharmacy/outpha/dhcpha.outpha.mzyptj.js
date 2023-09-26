/*
 *模块:门诊药房
 *子模块:药房统计-麻醉药品处方统计
 *createdate:2016-12-05
 *creator:dinghongying
 */
$(function () {
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	InitStkCat();
	InitPoisonCat();
	InitMZYPTJList();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-export').on('click', function () { //点击导出
		if ($('#mzyptjdg' ).datagrid("getRows").length <=1) {
			dhcphaMsgBox.alert("没有统计数据!");
			return;
		}
		ExportAllToExcel("mzyptjdg")
	});
	/* 绑定按钮事件 end*/
;
	$("#mzyptjdg").closest(".panel-body").height(GridCanUseHeight(1));

})

//初始化库存分类
function InitStkCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetStkCatDs&style=select2",
		allowClear: true,
		width: '15em'
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) {
		//alert(event)
	});
}

//初始化管制分类
function InitPoisonCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetPoisonCatDs&style=select2",
		allowClear: true,
		width: '15em',
		minimumResultsForSearch: Infinity
	}
	$("#sel-poison").dhcphaSelect(selectoption)
	$('#sel-poison').on('select2:select', function (event) {
		//alert(event)
	});
}

//麻醉药品处方信息列表
function InitMZYPTJList() {
	//定义columns
	var columns = [[{
				field: 'TPhDate',
				title: '日期',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPmiNo',
				title: '登记号',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPatName',
				title: '姓名',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				field: 'TPatSex',
				title: '性别',
				width: 40,
				align: 'center'
			}, {
				field: 'TPatAge',
				title: '年龄',
				width: 75,
				align: 'center'
			}, {
				field: 'TPatSN',
				title: '证件号码',
				width: 180,
				align: 'center'
			}, {
				field: 'TMR',
				title: '诊断',
				width: 200
			}, {
				field: 'TPrescNo',
				title: '处方号',
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TPhDesc',
				title: '药品名称',
				width: 200,
				sortable: true
			}, {
				field: 'TPhQty',
				title: '数量',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TPhUom',
				title: '单位',
				width: 60
			}, {
				field: 'TPhMoney',
				title: '金额',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TIncBatCode',
				title: '批号',
				width: 100
			}, {
				field: 'TYF',
				title: '用法',
				width: 80
			}, {
				field: 'TPatLoc',
				title: '科别',
				width: 120
			}, {
				field: 'TDoctor',
				title: '医生',
				width: 80
			}, {
				field: 'TFYUser',
				title: '发药人',
				width: 80
			}, {
				field: 'TBZ',
				title: '备注',
				width: 100
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: false
	}
	//定义datagrid
	$('#mzyptjdg').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
 	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var stkCatId = $("#sel-stk").val();
	if (stkCatId == null) {
		stkCatId = "";
	}
	var poisonCatId = $("#sel-poison").val();
	if (poisonCatId == null) {
		dhcphaMsgBox.alert("管制分类为必选项！");
		return;
	}
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + ctloc + tmpSplit + stkCatId + tmpSplit + poisonCatId;
	$('#mzyptjdg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.PreStat.Query",
			QueryName: "QueryMZYP",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});

}
//清空
function ClearConditions() {
	var today = new Date();
	$("#date-start").data('daterangepicker').setStartDate(today);
	$("#date-start").data('daterangepicker').setEndDate(today);
	$("#date-end").data('daterangepicker').setStartDate(today);
	$("#date-end").data('daterangepicker').setEndDate(today);
	$("#sel-stk").empty();
	$("#sel-poison").empty();
	$('#mzyptjdg').clearEasyUIGrid();
}
