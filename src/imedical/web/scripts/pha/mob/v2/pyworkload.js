/**
 * @Description: 移动药房 - 草药配药工作量统计
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.pyworkload.csp
 * @Js:          pha/mob/v2/pyworkload.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.VAR = {
	CONFIG: null,
	CilckName: ''
};

$(function () {
	// 初始化
	InitDict();
	InitGridPyWorkload();

	$('#btnFind').on('click', QueryPyWorkload);
	$('#btnClear').on('click', Clear);
	$('#btnCharts').on('click', EchartShow);
})

// 初始化表单
function InitDict() {
	// 发药科室
	PHA.ComboBox("phLocId", {
		placeholder: '请选择药房...',
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function (data) {
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == session['LOGON.CTLOCID']) {
					$(this).combobox('setValue', iData.RowId);
				}
			}
		},
		onSelect: function (record) {
			QueryPyWorkload();
		}
	});

	// 类型
	PHA.ComboBox("countType", {
		width: 120,
		editable: false,
		panelHeight: 'auto',
		placeholder: '请选择类型...',
		data: [{
				RowId: 'A',
				Description: '全部'
			}, {
				RowId: 'O',
				Description: '门诊'
			}, {
				RowId: 'I',
				Description: '住院'
			}
		],
		onSelect: function (record) {
			QueryPyWorkload();
		}
	});
	$("#countType").combobox('setValue', 'A');
	
	// 日期默认
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
}

// 初始化表格
function InitGridPyWorkload() {
	var columns = [[{
				field: 'uName',
				title: '配药人',
				width: 120,
				formatter: function (value, rowData, rowIndex) {
					return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=EchartPerTrendShow(" + rowIndex + ") >" + value + "</a>";
				}
			}, {
				field: 'prescNum',
				title: '处方张数',
				width: 100,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescFac',
				title: '处方付数',
				width: 100,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescWS',
				title: '味数',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescCS',
				title: '抓药次数',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescAmt',
				title: '处方金额',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValWS',
				title: '味数【贵】',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValCS',
				title: '抓药次数【贵】',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValAmt',
				title: '处方金额【贵】',
				width: 105,
				align: 'right',
				asEchartBar: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.Workload.Query',
			QueryName: 'PyWorkloadCY',
		},
		pageSize: 500,
		columns: columns,
		pagination: true,
		toolbar: '#gridPyWorkloadBar'
	};
	PHA.Grid("gridPyWorkload", dataGridOption);
}

// 查询
function QueryPyWorkload() {
	var formDataArr = PHA.DomData("#gridPyWorkloadBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridPyWorkload').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// 清屏
function Clear() {
	PHA.DomData("#gridPyWorkloadBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#phLocId').combobox('reload');
	$('#countType').combobox('setValue', 'A');
	$('#gridPyWorkload').datagrid('clear');
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


// ============== 以下为统计图表弹窗 ==============
// 可以做简单的封装 todo...
// 弹窗一：显示图表
function EchartShow(){
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '请先查询出表格数据!',
			type: "info"
		});
		return;
	}
	var mCount = 0;
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '合计') {
			continue;
		}
		mCount = mCount + 1;
	}
	if (mCount == 0) {
		PHA.Popover({
			msg: '没有数据,或者界面上仅有合计行!',
			type: "info"
		});
		return;
	}
	
	var winId = "echarts_win";
	var winContentId = "echarts_win" + "_" + "content";
	var winTitle = "草药【配药】工作量统计";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentHtml = "";
		contentHtml += '<div class="hisui-layout" fit="true" border="false">';
		contentHtml += '	<div data-options="region:\'center\'" class="pha-body">';
		contentHtml += '		<div class="hisui-layout" fit="true">';
		contentHtml += '			<div data-options="region:\'north\',height:50,split:true,border:false">';
		contentHtml += '				<div class="pha-col"><div id="chartType" style="height:100%;"></div></div>';
		contentHtml += '				<div class="pha-col" style="width:1px;height:26px;border-left: 1px solid #CCCCCC;margin-left:15px;margin-bottom:5px;"></div>';
		contentHtml += '				<div class="pha-col"><div id="chartVal" style="height:100%;"></div></div>';
		contentHtml += '			</div>';
		contentHtml += '			<div data-options="region:\'center\',split:true,border:false">';
		contentHtml += '				<div id="myChart" style="width:100%;height:100%;"></div>';
		contentHtml += '			</div>';
		contentHtml += '		</div>';
		contentHtml += '	</div>';
		contentHtml += '</div>';
		$('#' + winId).dialog({
			width: parseInt($(window).width() * 0.9),
			height: parseInt($(window).height() * 0.9),
			modal: true,
			title: winTitle,
			iconCls: 'icon-w-find',
			content: contentHtml,
			closable: true,
			onClose: function () {}
		});
		
		// 初始化
		var gridOpts = $('#gridPyWorkload').datagrid('options');
		var gridCols = gridOpts.columns[0];
		var kwItems = [];
		for (var i = 0; i < gridCols.length; i++) {
			var oneCol = gridCols[i];
			if (oneCol.asEchartBar) {
				kwItems.push({
					text: oneCol.title,
					id: oneCol.field
				});
				kwItems[0].selected = true;
			}
		}
		if (kwItems.length == 0) {
			PHA.Popover({
				msg: '请在columns中指定asEchartBar属性!',
				type: "info"
			});
			return;
		}
		
		$('#chartType').keywords({
			singleSelect: true,
			items: [
				{text:'饼状图', id:'Pie', selected: true},
				{text:'柱状图', id:'Bar'}
			],
			onClick: function(item) {
				EchartReload();
			}
		});
		$('#chartVal').keywords({
			singleSelect: true,
			labelCls: 'red',
			items: kwItems,
			onClick: function(item) {
				EchartReload();
			}
		});
	}
	EchartReload();
	$('#' + winId).dialog('open');
}
function EchartReload(){
	var cTitle = "草药配药工作量统计";
	// 获取条件
	var chartType = $("#chartType").keywords("getSelected")[0].id || "";
	var chartVal = $("#chartVal").keywords("getSelected")[0].id || "";
	// 准备数据
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	var _echartData = [];
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '合计') {
			continue;
		}
		_echartData.push({
			name: rowData.uName,
			value: rowData[chartVal]
		});
	}
	// 刷新
	if (chartType == "Pie") {
		Echart_Pie('myChart', {
			title: cTitle,
			data: _echartData
		});
	}
	if (chartType == "Bar") {
		Echart_HBar('myChart', {
			title: cTitle,
			data: _echartData,
			sort: true
		});
	}
}

// 弹窗二：显示个人工作量趋势图表
function EchartPerTrendShow(rowIndex){
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '请先查询出表格数据!',
			type: "info"
		});
		return;
	}
	var mCount = 0;
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '合计') {
			continue;
		}
		mCount = mCount + 1;
	}
	if (mCount == 0) {
		PHA.Popover({
			msg: '没有数据,或者界面上仅有合计行!',
			type: "info"
		});
		return;
	}
	PHA_COM.VAR.CilckName = rowsData[rowIndex].uName;
	
	var winId = "echarts_win_per";
	var winContentId = winId + "_" + "content";
	var winTitle = "草药【配药】工作量统计";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentHtml = "";
		contentHtml += '<div class="hisui-layout" fit="true" border="false">';
		contentHtml += '	<div data-options="region:\'center\'" class="pha-body" style="padding-bottom:7px;">';
		contentHtml += '		<div class="hisui-layout" fit="true">';
		contentHtml += '			<div data-options="region:\'north\',height:50,split:true,border:false">';
		contentHtml += '				<div class="pha-col"><div id="chartType_per" style="height:100%;"></div></div>';
		contentHtml += '				<div class="pha-col" style="width:1px;height:26px;border-left: 1px solid #CCCCCC;margin-left:15px;margin-bottom:5px;"></div>';
		contentHtml += '				<div class="pha-col"><div id="chartVal_per" style="height:100%;"></div></div>';
		contentHtml += '			</div>';
		contentHtml += '			<div data-options="region:\'center\',split:true,border:false">';
		contentHtml += '				<div id="myChart_per" style="width:100%;height:100%;"></div>';
		contentHtml += '			</div>';
		contentHtml += '		</div>';
		contentHtml += '	</div>';
		contentHtml += '</div>';
		$('#' + winId).dialog({
			width: parseInt($(window).width() * 0.9),
			height: parseInt($(window).height() * 0.9),
			modal: true,
			title: winTitle,
			iconCls: 'icon-w-find',
			content: contentHtml,
			closable: true,
			onClose: function () {}
		});
		
		// 初始化
		var gridOpts = $('#gridPyWorkload').datagrid('options');
		var gridCols = gridOpts.columns[0];
		var kwItems = [];
		for (var i = 0; i < gridCols.length; i++) {
			var oneCol = gridCols[i];
			if (oneCol.asEchartBar) {
				kwItems.push({
					text: oneCol.title,
					id: oneCol.field
				});
				kwItems[0].selected = true;
			}
		}
		if (kwItems.length == 0) {
			PHA.Popover({
				msg: '请在columns中指定asEchartBar属性!',
				type: "info"
			});
			return;
		}
		
		$('#chartType_per').keywords({
			singleSelect: true,
			items: [
				{text:'7天', id:'7', selected: true},
				{text:'30天', id:'30'}
			],
			onClick: function(item) {
				EchartPerTrendReload();
			}
		});
		$('#chartVal_per').keywords({
			singleSelect: true,
			labelCls: 'red',
			items: kwItems,
			onClick: function(item) {
				EchartPerTrendReload();
			}
		});
	}
	EchartPerTrendReload();
	$('#' + winId).dialog('open');
}
function EchartPerTrendReload(){
	var cTitle = "草药配药工作量统计";
	// 获取条件
	var phLocId = $('#phLocId').combobox('getValue');
	var days = $("#chartType_per").keywords("getSelected")[0].id || "";
	var countKey = $("#chartVal_per").keywords("getSelected")[0].id || "";
	var uName = PHA_COM.VAR.CilckName || "";
	// 准备数据
	var chartDataStr = tkMakeServerCall('PHA.MOB.Workload.Query', 'GetPerHistoryData', phLocId, 'PY', uName, countKey, days);
	var chartData = eval('(' + chartDataStr + ')');
	// 刷新
	Echart_Line('myChart_per', {
		title: '个人工作量统计',
		data: [
			{
				name: uName,
				data: chartData
			}
		]
	});
}
