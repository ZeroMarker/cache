/*
 *模块:门诊药房
 *子模块:门诊药房-工作量统计
 *createdate:2016-11-15
 *creator:dinghongying
 */
$(function () {
	/* 初始化插件 start*/
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
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	InitWorkLoadList();
	ClearConditions();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BtnPrintHandler);
	/* 绑定按钮事件 end*/
;
	$("#workloaddg").closest(".panel-body").height(GridCanUseHeight(1));

})
//初始化工作量统计列表
function InitWorkLoadList() {
	//定义columns
	var columns = [[{
				field: 'TPhName',
				title: '药房人员',
				align: 'center',
				width: 125
			}, {
				field: 'TPYRC',
				title: '配药处方',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYRC',
				title: '发药处方',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TPYJE',
				title: '配药金额',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYJE',
				title: '发药金额',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TPYL',
				title: '配药量',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYL',
				title: '发药量',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetPresc',
				title: '退药处方',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: '退药金额',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetYL',
				title: '退药量',
				width: 110,
				align: 'right',
				sortable: true
			}, {
				field: 'TPyFS',
				title: '配药付数',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFyFS',
				title: '发药付数',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TTyFS',
				title: '退药付数',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TJYFS',
				title: '煎药付数',
				width: 120,
				sortable: true,
				hidden: true
			}, {
				field: 'TJYCF',
				title: '煎药处方',
				width: 120,
				sortable: true,
				hidden: true
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns
	}
	//定义datagrid
	$('#workloaddg').dhcphaEasyUIGrid(dataGridOption);
}

///药房工作量统计查询
function Query() {
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + starttime + tmpSplit + endtime;
	$('#workloaddg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Workload.Query",
			QueryName: "Workload",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});

}

//清空
function ClearConditions() {

	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+' 00:00:00')
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+' 00:00:00');
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+' 23:59:59');
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+' 23:59:59');
	$('#workloaddg').clearEasyUIGrid();
}

//打印
function BtnPrintHandler() {
	if ($('#workloaddg').datagrid('getData').rows.length == 0) //获取当面界面数据行数
	{
		dhcphaMsgBox.alert("页面没有数据！");
		return;
	}
	var WorkLoaddgOption = $("#workloaddg").datagrid("options");
	var WorkLoaddgparams = encodeURIComponent(WorkLoaddgOption.queryParams.Params);
	var WorkLoaddgUrl = WorkLoaddgOption.url;
	var classname = "PHA.OP.Workload.Query";
	var queryname = "Workload";
	$.ajax({
		type: "GET",
		url: WorkLoaddgUrl + "?page=1&rows=9999&ClassName=" + classname + "&QueryName=" + queryname + "&Params=" + WorkLoaddgparams,
		async: false,
		dataType: "json",
		success: function (workloaddata) {
			var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
			var startdatetime=$("#date-start").val();
			var enddatetime=$("#date-end").val();
			var datetimerange=startdatetime+" 至 "+enddatetime;
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: 'PHAOPWorkLoad',
				data:{
					Para: {
						titlemain:HospitalDesc + "门诊工作量统计",
						titlesecond: "药房:" + DHCPHA_CONSTANT.DEFAULT.LOC.text+"     统计范围:"+datetimerange,
						lasttitle:"打印人:"+session['LOGON.USERNAME']+"      打印时间:"+getPrintDateTime()
					},
					List: workloaddata.rows
				},
				aptListFields: ["lasttitle"],
				listBorder: {style:4, startX:1, endX:195,space:1},
			})
		}
	});
}
