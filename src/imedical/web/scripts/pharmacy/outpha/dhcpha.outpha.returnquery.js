/*
 *模块:门诊药房
 *子模块:门诊药房-退药单据查询
 *createdate:2016-11-22
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
	InitReturnInfoList();
	InitReturnDetailList();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BPrintHandler);
	$("#btn-cancel").on("click", BCancelReturnHandler);
	$("#btn-export").on("click", function () {
		ExportAllToExcel("returninfodg");
	});
	/* 绑定按钮事件 end*/
	$("#returninfodg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
	$("#returndetaildg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//初始化退药单列表
function InitReturnInfoList() {
	//定义columns
	var columns = [[{
				field: 'TPmiNo',
				title: ("登记号"),
				width: 150,
				align: 'center',
				sortable: true
			}, {
				field: 'TPatName',
				title: ("姓名"),
				width: 100,
				align: 'center'
			}, {
				field: 'TRetDate',
				title: ("退药日期"),
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: ("退药金额"),
				width: 80,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetUser',
				title: ("操作人"),
				width: 100,
				align: 'center',
				sortable: true
			}, {
				field: 'TDoctor',
				title: ("医生"),
				width: 100,
				align: 'center'
			}, {
				field: 'TLocDesc',
				title: ("科室"),
				width: 120,
				align: 'left',
				sortable: true
			}, {
				field: 'TRetReason',
				title: ("退药原因"),
				width: 150,
				align: 'left',
				sortable: true
			}, {
				field: 'TDispDate',
				title: ("发药日期"),
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleUser',
				title: ("撤消人"),
				width: 80,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleDate',
				title: ("撤消日期"),
				width: 80,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleTime',
				title: ("撤消时间"),
				width: 120,
				align: 'center',
				sortable: true,
				hidden: true
			}, {
				field: 'TEncryptLevel',
				title: ("病人密级"),
				width: 80,
				align: 'center',
				hidden: true
			}, {
				field: 'TPatLevel',
				title: ("病人级别"),
				width: 80,
				align: 'center',
				hidden: true
			}, {
				field: 'TRetRowid',
				title: ("退药单Id"),
				width: 80,
				hidden: false
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		onSelect: function (rowIndex, rowData) {
			QueryDetail();
		},
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
			} else {
				$('#returndetaildg').clearEasyUIGrid();
			}
		}
	}
	//定义datagrid
	$('#returninfodg').dhcphaEasyUIGrid(dataGridOption);
}

//初始化退药单明细列表
function InitReturnDetailList() {
	//定义columns
	var columns = [[{
				field: 'TPhDesc',
				title: ("药品名称"),
				width: 300,
				align: 'left'
			}, {
				field: 'TPhUom',
				title: ("单位"),
				width: 125,
				align: 'center'
			}, {
				field: 'TRetQty',
				title: ("退药数量"),
				width: 125,
				align: 'right'
			}, {
				field: 'TPhprice',
				title: ("单价"),
				width: 125,
				align: 'right'
			}, {
				field: 'TRetMoney',
				title: ("退药金额"),
				width: 125,
				align: 'right'
			}, {
				field: 'TBatExpStr',
				title: ("批号~效期"),
				width: 125,
				align: 'center'
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		pagination: false
	}
	//定义datagrid
	$('#returndetaildg').dhcphaEasyUIGrid(dataGridOption);

}

///退药单查询
function Query() {
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + ctloc;
	$('#returninfodg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.RetQuery.Query",
			QueryName: "ReturnBill",
			Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});
}

//查询明细
function QueryDetail() {
	var selectdata = $("#returninfodg").datagrid("getSelected")
		if (selectdata == null) {
			dhcphaMsgBox.alert($g("选中数据异常!"));
			return;
		}
		var params = selectdata["TRetRowid"]
		$('#returndetaildg').datagrid({
			queryParams: {
				ClassName: "PHA.OP.RetQuery.Query",
				QueryName: "ReturnBillDet",
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
	$('#returninfodg').clearEasyUIGrid();
	$('#returndetaildg').clearEasyUIGrid();
}

//打印
function BPrintHandler() {
	var selectdata = $("#returninfodg").datagrid("getSelected");
	if (selectdata == null) {
		dhcphaMsgBox.alert($g("请选择需要打印的退药单!"));
		return;
	}
	var retrowid = selectdata["TRetRowid"];
	PrintReturn(retrowid, "补");
}

//撤销退药
function BCancelReturnHandler() {
	var selectdata = $("#returninfodg").datagrid("getSelected");
	if (selectdata == null) {
		dhcphaMsgBox.alert($g("请选择需要撤消的退药单!"));
		return;
	}
	var retrowid = selectdata["TRetRowid"];
	var othParams=DHCPHA_CONSTANT.SESSION.GROUP_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var cancelRet = tkMakeServerCall("PHA.OP.Return.OperTab", "CancleReturn", retrowid,DHCPHA_CONSTANT.SESSION.GUSER_ROWID,othParams);
	var cancelRetArr = cancelRet.split("^");
	var retCode = cancelRetArr[0];
	if (retCode != 0) {
		var cancelRetInfo = cancelRetArr[1] || "";
		if (cancelRetInfo != "") {
			dhcphaMsgBox.alert(cancelRetInfo);
		} else {
			dhcphaMsgBox.alert($g("撤消失败,请联系相关人员进行处理,错误代码:") + cancelRet);
		}
	} else {
		dhcphaMsgBox.alert($g("撤消成功！"));
		Query();
	}
}
