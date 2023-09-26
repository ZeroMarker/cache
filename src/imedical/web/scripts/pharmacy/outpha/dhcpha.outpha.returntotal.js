/*
 *模块:门诊药房
 *子模块:门诊药房-药品退药汇总
 *createdate:2016-11-21
 *creator:dinghongying
 */
$(function () {
	/* 初始化插件 start*/
	var daterangeoptions = {
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
	InitLoc();
	InitReturnTotalList();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BPrintHandler);
	$("#btn-export").on("click", function () {
		ExportAllToExcel("returntotaldg")
	});
	/* 绑定按钮事件 end*/
;
	$("#returntotaldg").closest(".panel-body").height(GridCanUseHeight(1));
})

//初始化科室
function InitLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetCtLocDs&style=select2&custtype=DocLoc",
		allowClear: true,
		width: '15em'
	}
	$("#sel-loc").dhcphaSelect(selectoption)
	$('#sel-loc').on('select2:select', function (event) {
		//alert(event)
	});
}

//初始化药品退药汇总列表
function InitReturnTotalList() {
	//定义columns
	var columns = [[{
				field: 'TPhDesc',
				title: '药品名称',
				width: 300,
				align: 'left'
			}, {
				field: 'TPhUom',
				title: '单位',
				width: 150,
				align: 'center'
			}, {
				field: 'TRetQty',
				title: '退药数量',
				width: 150,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: '退药金额',
				width: 150,
				align: 'right',
				sortable: true
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true
		//pagination:false,
		//pageSize:100,
		//view:scrollview //如用户不需要分页,则设置此pagination:false,pagesize写死
	}
	//定义datagrid
	$('#returntotaldg').dhcphaEasyUIGrid(dataGridOption);
}

///药品退药汇总查询
function Query() {
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var depcode = $("#sel-loc").val();
	if (depcode == null) {
		depcode = "";
	}
	var doctor = "";
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + depcode + tmpSplit + doctor;
	$('#returntotaldg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.RetQuery.Query",
			QueryName: "ReturnTotal",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});

}

//清空
function ClearConditions() {
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());	
	$("#sel-loc").empty();
	$('#returntotaldg').clearEasyUIGrid();
}

//打印
function BPrintHandler() {
	//获取当面界面数据行数
	if ($('#returntotaldg').datagrid('getData').rows.length == 0) {
		dhcphaMsgBox.alert("页面没有数据,无法打印!");
		return ;
	}
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var daterange=startdate+" 至 "+enddate;
	var title = DHCPHA_CONSTANT.SESSION.GHOSP_DESC+DHCPHA_CONSTANT.DEFAULT.LOC.text + "退药汇总";
	var Para = {
		daterange: daterange,
		title: title
	}
	//打印公共 Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPReturnTotal',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'returntotaldg'}
		},
		listBorder: {style:4, startX:6, endX:160},
		page: {rows:30, x:6, y:4, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'}
	});
}
