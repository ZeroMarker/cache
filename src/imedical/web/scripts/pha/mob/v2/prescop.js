/**
 * @Description: 移动药房 - 门诊中草药处方查询
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.prescop.csp
 * @Js:          pha/mob/v2/prescop.js
 */
var curLocId = session['LOGON.CTLOCID'];
var curUserId = session['LOGON.USERID'];
var combWidth = 130;
PHA_COM.VAR = {
	CONFIG: null
};
var gLocId = session['LOGON.CTLOCID'] ;
PHA_COM.App.ProCode = 'HERB' ;
PHA_COM.App.ProDesc = '中草药房';
PHA_COM.App.Csp = 'pha.mob.v2.prescop.csp' ;
PHA_COM.App.Name = '门诊处方查询' ;

$(function () {
	//初始化函数
	InitDict();
	InitGridPresc();
	InitGridPrescDetail();
	PHA_COM.ResizePanel({
		layoutId: 'layout-main',
		region: 'south',
		height: 0.4
	});

	// 绑定事件
	$('#btnFind').on("click", QueryPresc);
	$('#btnPrint').on("click", Print);
	$('#btnPrinLabel').on("click", PrinDJLabel);
	$('#btnPrintHPLabel').on("click", PrintHPLabel);
	$('#btnAllowRet').on("click", AllowRet);
	$('#btnEmergency').on("click", Emergency);
	$('#btnCancelRefuse').on('click', CancelRefuse);
	$('#btnClear').on('click', Clear);

	// 登记号回车事件
	$('#patNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var patNo = $('#patNo').val();
			if (patNo == "") {
				return;
			}
			var newPatNo = PHA_COM.FullPatNo(patNo);
			$('#patNo').val(newPatNo);
			QueryPresc();
		}
	});

	// 处方号回车事件
	$('#prescNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var prescNo = $('#txt-PrescNo').val();
			if (prescNo == "") {
				return;
			}
			var newPrescNo = tkMakeServerCall("PHA.COM.MOB.Utils", "%PrescNoPadding", prescNo, 6, "O");
			$('#txt-PrescNo').val(newPrescNo);
			QueryPresc();
		}
	});
});

// 初始化表单数据
function InitDict() {
	PHA.ComboBox("phLoc", {
		placeholder: '请选择药房...',
		url: PHA_STORE.Pharmacy().url,
		width: combWidth ,
		onLoadSuccess: function (data) {
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == gLocId) {
					$('#phLoc').combobox('setValue', iData.RowId);
				}
			}
		}
	});

	PHA.ComboBox("prescStatus", {
		placeholder: '选择处方状态...',
		//url: $URL + '?ResultSetType=Array&ClassName=PHA.MOB.PrescOP.Query&QueryName=StatusList&locId=' + session['LOGON.CTLOCID'],
		url: $URL + '?ResultSetType=Array&ClassName=PHA.HERB.Com.Store&QueryName=ExeProStore&gLocId=' + session['LOGON.CTLOCID'] + '&HospId=' + session['LOGON.HOSPID'] + '&admType=O',
		width: combWidth ,
		panelHeight: 'auto',
		editable: true,
		onLoadSuccess: function (data) {
			//$('#prescStatus').combobox('setValue', '0');
		}
	});
	
	// 日期默认
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
	
	PHA.ComboBox('refuseFlag', {
		placeholder: '请选择拒绝...',
        data: [
            { RowId: 'Y', Description: $g('是') },
            { RowId: 'N', Description: $g('否') }
        ],
        panelHeight: 'auto',
        width: combWidth ,
		editable: false,
        onSelect: function () {}
    });
	
	PHA.ComboBox('cookType', {
		placeholder: '请选择煎药方式...',
        url: PHA_HERB_STORE.CookType('', curLocId).url,
        width: combWidth ,
        panelHeight: 'auto'
    });
	
}

// 初始化主表格
function InitGridPresc() {
	var columns = [[{
				field: "phar",
				title: 'phar',
				width: 80,
				hidden: true
			}, {
				field: 'phbdId',
				title: 'phbdId',
				width: 80,
				hidden: true
			}, {
				field: "prescNo",
				title: '处方号',
				width: 125,
				formatter: function (value, rowData, rowIndex) {
					return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=OpenStepWin(" + rowIndex + ") >" + value + "</a>";
				}
			}, {
				field: 'phCookMode',
				title: '煎药类型',
				width: 80
			}, {
				field: 'patName',
				title: '患者姓名',
				width: 100
			}, {
				field: 'patNo',
				title: '登记号',
				width: 120
			}, {
				field: 'winDesc',
				title: '窗口',
				width: 80
			}, {
				field: 'phLocDesc',
				title: '发药科室',
				width: 120
			}, {
				field: 'admLocDesc',
				title: '就诊科室',
				width: 160
			}, {
				field: 'comUserName',
				title: '普通药配药人',
				width: 100
			}, {
				field: 'valUserName',
				title: '贵重药配药人',
				width: 100
			}, {
				field: 'ordDT',
				title: '医嘱时间',
				width: 155,
				align: 'center'
			}, {
				field: 'phaDT',
				title: '收费时间',
				width: 155,
				align: 'center'
			}, {
				field: 'status',
				title: '处方状态',
				width: 80,
				align: 'center'
			}, {
				field: 'startPy',
				title: '配药状态',
				width: 80,
				hidden: true ,
				align: 'center'
			}, {
				field: 'priceFlag',
				title: '贵重药',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'priFlag',
				title: '是否优先',
				width: 75,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'allowRetFlag',
				title: '允许退药标志',
				width: 110,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'refuseFlag',
				title: '拒绝标志',
				width: 70,
				align: 'center',
				formatter: YesNoFormatter
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescOP.Query',
			QueryName: 'PharData'
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridPrescBar',
		onSelect: function (rowIndex, rowData) {
			QueryPrescDetail();
		},
		onClickCell: function (index, field, value) {},
		onLoadSuccess: function (data) {
			$('#gridPrescDetail').datagrid('clear');
			if (data.total > 0) {
				var selRowIdx = $(this).datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$(this).datagrid("selectRow", selRowIdx);
				} else {
					$(this).datagrid("selectRow", 0);
				}
			}
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}

// 明细表格
function InitGridPrescDetail() {
	var columns = [[{
				field: 'inci',
				title: 'inci',
				width: 80,
				hidden: true
			}, {
				field: 'dspId',
				title: 'dspId',
				width: 80,
				hidden: true
			}, {
				field: 'oeori',
				title: 'oeori',
				width: 80,
				hidden: true
			}, {
				field: 'oeStatusDesc',
				title: '医嘱状态',
				width: 100,
				align: 'center',
				styler: function(value, rowData, rowIndex) {
					if (rowData.oeStatusCode != "V" && rowData.oeStatusCode != "E") {
						return 'background-color:#FF5252; color:white;';
					}
				}
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 150
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 200
			}, {
				field: 'geneDesc',
				title: '通用名',
				width: 160
			}, {
				field: 'goodName',
				title: '商品名',
				width: 160,
				hidden: true
			}, {
				field: 'inciSpec',
				title: '规格',
				width: 100
			}, {
				field: 'dspQty',
				title: '数量',
				width: 100
			}, {
				field: 'dspUomDesc',
				title: '单位',
				width: 100
			}, {
				field: 'pyFlag',
				title: '配药完成',
				width: 100,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'freqDesc',
				title: '频次',
				width: 150
			}, {
				field: 'instDesc',
				title: '用法',
				width: 100
			}, {
				field: 'duratDesc',
				title: '疗程',
				width: 100
			}, {
				field: 'ordRemark',
				title: '医嘱备注',
				width: 150
			}, {
				field: 'feeType',
				title: '费别',
				width: 150
			}, {
				field: 'oeDate',
				title: '医嘱日期',
				width: 120,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescOP.Query',
			QueryName: 'PrescDetail'
		},
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: false,
		onLoadSuccess: function (data) {}
	};
	PHA.Grid("gridPrescDetail", dataGridOption);
}

// 查询
function QueryPresc() {
	// 查询条件
	var formDataArr = PHA.DomData("#gridPrescBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridPresc').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// 查询明细
function QueryPrescDetail() {
	var selRow = $('#gridPresc').datagrid('getSelected');
	var prescNo = selRow.prescNo;
	var pJsonStr = JSON.stringify({
		prescNo: prescNo
	});
	
	$('#gridPrescDetail').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// 清屏
function Clear() {
	PHA.DomData("#gridPrescBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#prescStatus').combobox('setValue', '');
	$('#gridPresc').datagrid('clear');
	$('#gridPrescDetail').datagrid('clear');
	
	PHA_SYS_SET.Form.ReSet({
		phLoc: gLocId
	});
}

// 打印配药单
function Print() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	/*
	var phdId= tkMakeServerCall("PHA.OP.COM.Print","GetPhdByPrescNo",prescNo)
	*/
	var pyInfo = tkMakeServerCall("PHA.HERB.Com.Data","GetPrescPYInfo",prescNo)
	if (pyInfo == ""){
		$.messager.alert("提示", "该处方尚未配药，不能打印配药单", "warning");
		return;	
	}
	PHA_MOB_PRINT.PrintPyd(prescNo);
}

// 补打代煎标签
function PrinDJLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var cookMode = selRow.phCookMode || "";
	if (cookMode !== "代煎") {
		$.messager.alert("提示", "该处方煎药类型不是代煎，不需要打印代煎标签", "warning");
		return;
	}
	
	// 窗口
	var winId = "presc_win_printNum";
	var winContentId = "presc_win_printNum" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 250,
			height: 140,
			modal: true,
			title: "请输入代煎标签张数",
			iconCls: 'icon-w-print',
			content: "<div style='padding:10px;'><input id='prntDJNum' class='hisui-validatebox' style='width:222px;'/></div>",
			closable: true,
			buttons:[{
				text:'确认',
				handler:function(){
					var prescNo = GetSelectedPrescNo();
					var printNum = $('#prntDJNum').val() || "";
					if (printNum == "" || printNum <= 0 || isNaN(parseInt(printNum))) {
						$.messager.popover({
							msg: "请输入一个正整数!",
							type: "alert",
							timeout: 1000,
							style: {top: 20, left: ""}
						});
					}
					PHA_MOB_PRINT.PrintDJLabel(prescNo, printNum);
					$('#' + winId).dialog('close');
				}
			},{
				text:'取消',
				handler:function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	
	// 取默认的张数
	var printNum = tkMakeServerCall('PHA.MOB.COM.Print', 'GetDefaultDJNum', prescNo);
	printNum = printNum <= 0 ? 1 : printNum;
	$('#prntDJNum').val(printNum);
	$('#prntDJNum').focus();
}

// 贵重药标签
function PrintHPLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var priceFlag = selRow.priceFlag || "";
	if (priceFlag !== "Y") {
		$.messager.alert("提示", "该处方不含有贵重药，不需要打印贵重药标签", "warning");
		return;
	}
	PHA_MOB_PRINT.PrintPriceLabel(prescNo);
}

// 设置为优先
function Emergency() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var priFlag = selRow.priFlag || "";
	if (priFlag == "Y") {
		$.messager.alert("提示", "该处方已经是优先状态，不需要再次设置！", "warning");
		return;
	}
	var pJsonStr = JSON.stringify({
		prescNo: prescNo
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "PrescEmergency", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("提示", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "设置成功!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

// 允许退药
function AllowRet() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var phbdId = selRow.phbdId || "";

	var pJsonStr = JSON.stringify({
		phbdId: phbdId,
		userId: session['LOGON.USERID']
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "PrescAllowRet", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("提示", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "设置成功!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

// 手机上拒绝发药的撤消拒绝
function CancelRefuse() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var refuseFlag = selRow.refuseFlag || "";
	if (refuseFlag !== "Y") {
		$.messager.alert("提示", "该处方未拒绝发药，不能撤消拒绝", "warning");
		return;
	}
	
	var pJsonStr = JSON.stringify({
		prescNo: prescNo,
		userId: curUserId
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "CancelRefuse", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("提示", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "撤消成功!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

function GetSelectedPrescNo() {
	var selRow = $('#gridPresc').datagrid('getSelected');
	if (selRow == null) {
		$.messager.popover({
			msg: "请选择处方!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	var prescNo = selRow.prescNo || "";
	if (prescNo == "") {
		$.messager.popover({
			msg: "请选择处方!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	return prescNo;
}

// 处方追踪弹窗
function OpenStepWin(rowIndex) {
	var rowsData = $('#gridPresc').datagrid('getRows');
	if (rowsData == null) {
		$.messager.popover({
			msg: "处方列表没有数据!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var rowData = rowsData[rowIndex];
	var prescNo = rowData.prescNo || "";
	if (prescNo == "") {
		$.messager.popover({
			msg: "请先选择处方!",
			type: "alert",
			timeout: 1000
		});
		return;
	}

	// 窗口
	var winWidth = parseInt($(document.body).width() * 0.97);
	var winId = "presc_win_step";
	var winContentId = "presc_win_step" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
			height: 160,
			modal: true,
			title: "处方状态追踪",
			iconCls: 'icon-w-find',
			content: "<div id='" + winContentId + "' style='height:90px;margin:10px;'></div>",
			closable: true,
			onClose: function () {}
		});
	}

	// 步骤
	$("#" + winContentId).children().remove();
	var stepJsonStr = tkMakeServerCall('PHA.MOB.PrescOP.Query', 'GetStepWinInfo', prescNo);
	var stepJsonData = eval('(' + stepJsonStr + ')');
	var steps = stepJsonData.items.length;
	var stepWidth = (winWidth - 40) / steps;
	$("#" + winContentId).hstep({
		titlePostion: 'top',
		showNumber: false,
		stepWidth: stepWidth,
		currentInd: stepJsonData.currentInd,
		items: stepJsonData.items,
		onSelect: function (ind, item) {}
	});

	// 打开窗口
	$('#' + winId).dialog('open');
	$('#' + winId).dialog('setTitle', "处方状态追踪 - " + prescNo);
}

function YesNoFormatter(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// 加载配置
function InitConfig() {
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
