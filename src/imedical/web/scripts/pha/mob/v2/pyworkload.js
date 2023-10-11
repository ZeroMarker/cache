/**
 * @Description: �ƶ�ҩ�� - ��ҩ��ҩ������ͳ��
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
	// ��ʼ��
	InitDict();
	InitGridPyWorkload();

	$('#btnFind').on('click', QueryPyWorkload);
	$('#btnClear').on('click', Clear);
	$('#btnCharts').on('click', EchartShow);
})

// ��ʼ������
function InitDict() {
	// ��ҩ����
	PHA.ComboBox("phLocId", {
		placeholder: '��ѡ��ҩ��...',
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

	// ����
	PHA.ComboBox("countType", {
		width: 120,
		editable: false,
		panelHeight: 'auto',
		placeholder: '��ѡ������...',
		data: [{
				RowId: 'A',
				Description: 'ȫ��'
			}, {
				RowId: 'O',
				Description: '����'
			}, {
				RowId: 'I',
				Description: 'סԺ'
			}
		],
		onSelect: function (record) {
			QueryPyWorkload();
		}
	});
	$("#countType").combobox('setValue', 'A');
	
	// ����Ĭ��
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
}

// ��ʼ������
function InitGridPyWorkload() {
	var columns = [[{
				field: 'uName',
				title: '��ҩ��',
				width: 120,
				formatter: function (value, rowData, rowIndex) {
					return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=EchartPerTrendShow(" + rowIndex + ") >" + value + "</a>";
				}
			}, {
				field: 'prescNum',
				title: '��������',
				width: 100,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescFac',
				title: '��������',
				width: 100,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescWS',
				title: 'ζ��',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescCS',
				title: 'ץҩ����',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescAmt',
				title: '�������',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValWS',
				title: 'ζ������',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValCS',
				title: 'ץҩ��������',
				width: 105,
				align: 'right',
				asEchartBar: true
			}, {
				field: 'prescValAmt',
				title: '��������',
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

// ��ѯ
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

// ����
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

// ��������
function InitConfig() {
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}


// ============== ����Ϊͳ��ͼ������ ==============
// �������򵥵ķ�װ todo...
// ����һ����ʾͼ��
function EchartShow(){
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '���Ȳ�ѯ����������!',
			type: "info"
		});
		return;
	}
	var mCount = 0;
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '�ϼ�') {
			continue;
		}
		mCount = mCount + 1;
	}
	if (mCount == 0) {
		PHA.Popover({
			msg: 'û������,���߽����Ͻ��кϼ���!',
			type: "info"
		});
		return;
	}
	
	var winId = "echarts_win";
	var winContentId = "echarts_win" + "_" + "content";
	var winTitle = "��ҩ����ҩ��������ͳ��";
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
		
		// ��ʼ��
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
				msg: '����columns��ָ��asEchartBar����!',
				type: "info"
			});
			return;
		}
		
		$('#chartType').keywords({
			singleSelect: true,
			items: [
				{text:'��״ͼ', id:'Pie', selected: true},
				{text:'��״ͼ', id:'Bar'}
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
	var cTitle = "��ҩ��ҩ������ͳ��";
	// ��ȡ����
	var chartType = $("#chartType").keywords("getSelected")[0].id || "";
	var chartVal = $("#chartVal").keywords("getSelected")[0].id || "";
	// ׼������
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	var _echartData = [];
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '�ϼ�') {
			continue;
		}
		_echartData.push({
			name: rowData.uName,
			value: rowData[chartVal]
		});
	}
	// ˢ��
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

// ����������ʾ���˹���������ͼ��
function EchartPerTrendShow(rowIndex){
	var rowsData = $('#gridPyWorkload').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '���Ȳ�ѯ����������!',
			type: "info"
		});
		return;
	}
	var mCount = 0;
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.uName == '�ϼ�') {
			continue;
		}
		mCount = mCount + 1;
	}
	if (mCount == 0) {
		PHA.Popover({
			msg: 'û������,���߽����Ͻ��кϼ���!',
			type: "info"
		});
		return;
	}
	PHA_COM.VAR.CilckName = rowsData[rowIndex].uName;
	
	var winId = "echarts_win_per";
	var winContentId = winId + "_" + "content";
	var winTitle = "��ҩ����ҩ��������ͳ��";
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
		
		// ��ʼ��
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
				msg: '����columns��ָ��asEchartBar����!',
				type: "info"
			});
			return;
		}
		
		$('#chartType_per').keywords({
			singleSelect: true,
			items: [
				{text:'7��', id:'7', selected: true},
				{text:'30��', id:'30'}
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
	var cTitle = "��ҩ��ҩ������ͳ��";
	// ��ȡ����
	var phLocId = $('#phLocId').combobox('getValue');
	var days = $("#chartType_per").keywords("getSelected")[0].id || "";
	var countKey = $("#chartVal_per").keywords("getSelected")[0].id || "";
	var uName = PHA_COM.VAR.CilckName || "";
	// ׼������
	var chartDataStr = tkMakeServerCall('PHA.MOB.Workload.Query', 'GetPerHistoryData', phLocId, 'PY', uName, countKey, days);
	var chartData = eval('(' + chartDataStr + ')');
	// ˢ��
	Echart_Line('myChart_per', {
		title: '���˹�����ͳ��',
		data: [
			{
				name: uName,
				data: chartData
			}
		]
	});
}