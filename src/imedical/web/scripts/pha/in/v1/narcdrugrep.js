/**
 * 名称:   	 药房药库 - 毒麻药品管理- 药品统计报表
 * 编写人:   Huxiaotian
 * 编写日期: 2021-10-11
 * csp:		 pha.in.v1.narcdrugrep.csp
 * js:		 pha/in/v1/narcdrugrep.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcreport.csp';
PHA_COM.App.Name = '毒麻药品统计报表';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {
	TabsId: 'tabs-region',
	EmptyReport: '../csp/dhcst.blank.backgroud.csp',
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};
if (typeof websys_writeMWToken !== 'undefined') {
	PHA_COM.VAR.EmptyReport = websys_writeMWToken(PHA_COM.VAR.EmptyReport);
}
$(function() {
	// 之后有新的报表,直接在此添加,其余勿动
	var rqPanels = [
		{reportName:'PHAIN_NarcReport_RegByInci.rpx', reportText:'毒麻药品使用登记册'},
		{reportName:'PHAIN_NarcReport_LocUse.rpx', reportText:'科室使用记录表'},
		{reportName:'PHAIN_NarcReport_Hand.rpx', reportText:'交接班记录报表'}
	];
	
	InitDict();
	InitGridNarcDrug();
	InitEvents();
	InitLayout(rqPanels);
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		width: 225,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.TriggerBox("phccDescAll", {
		placeholder: '药学分类...',
		width: 225,
		handler: function(){
			PHA_UX.DHCPHCCat('', '', function(rowData){
				$("#phccDescAll").triggerbox('setValue', rowData.phcCatDescAll);
				$("#phccDescAll").triggerbox('setValueId', rowData.phcCatDescAll);
			})
		}
	});
	PHA.ComboBox('locId', {
		placeholder: '科室...',
		disabled: true,
		url: PHA_STORE.CTLoc().url
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('locId', session['LOGON.CTLOCID']);
}

// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFindNarcDrug').on("click", QueryNarcHand);
	$('#btnClearNarcDrug').on("click", ClearNarcDrug);
	$('#inciText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryNarcHand();
		}
	});
	
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
}

// 初始化 - 表格
function InitGridNarcDrug() {
	var columns = [[{
				field: 'inci',
				title: 'inci',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 140,
				hidden: true
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 200
			}, {
				field: 'inciSpec',
				title: '规格',
				width: 100,
				hidden: true
			}, {
				field: 'poisonDesc',
				title: '管制分类',
				width: 120,
				hidden: true
			}, {
				field: 'phccDescAll',
				title: '药学分类',
				width: 120,
				hidden: true
			}, {
				field: 'showDetail',
				title: '详情',
				width: 45,
				fixed: true,
				formatter: function(value, rowData, rowIndex){
					return "<a class='pha-detail-tips' rowIndex='" + rowIndex + "'>" + "详情" + "</a>";
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.Narc.Report',
			QueryName: 'NarcDrug',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: true,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcDrugBar',
		onSelect: function (rowIndex, rowData) {
			Query();
		},
		onLoadSuccess: function (data) {
			$(".pha-detail-tips").each(function(){
				var rowIndex = $(this).attr('rowIndex');
				var rowsData = $('#gridNarcDrug').datagrid('getRows');
				var rowData = rowsData[rowIndex];
				var contentHtml = '';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品代码') + '：</font><font style="color:#000000;">' + rowData.inciCode + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品名称') + '：</font><font style="color:#000000;">' + rowData.inciDesc + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品规格') + '：</font><font style="color:#000000;">' + rowData.inciSpec + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('管制分类') + '：</font><font style="color:#000000;">' + rowData.poisonDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药学分类') + '：</font><font style="color:#000000;">' + rowData.phccDescAll + '</p>';
				$(this).popover({
					placement: 'auto',
					trigger: 'hover',
					title: '药品详情',
					content: contentHtml
				});
			});
		}
	};
	PHA.Grid('gridNarcDrug', dataGridOption);
}
// 查询毒麻药品
function QueryNarcHand(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	
	$('#gridNarcDrug').datagrid('options').url = $URL;
	$('#gridNarcDrug').datagrid('query', {
		pJsonStr: JSON.stringify(formData),
		hospId: PHA_COM.VAR.hospId
	});
}
// 清除毒麻药品
function ClearNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'clear'
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcDrug').datagrid('loadData', []);
	Clear();
}

// 初始化TAB布局
function InitLayout(rqPanels){
	var $LayoutTabs = $('#' + PHA_COM.VAR.TabsId);
	// 初始化
	$LayoutTabs.tabs({
		onSelect: function(title, index){
			var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', index).panel('options');
			var reportName = oneTabOpts.reportName;
			var isLoaded = $('#' + PHA_COM.VAR.TabsId).tabs('options').isLoaded;
			if (isLoaded && PHA_COM.VAR.CONFIG) {
				Query();
			}
		}
	});
	// 添加Tab
	var rqPanelsLen = rqPanels.length;
	for (var i = 0; i < rqPanelsLen; i++) {
		var oneRQPanel = rqPanels[i];
		var reportName = oneRQPanel["reportName"];
		var reportText = oneRQPanel["reportText"];
		var queryId = reportName.replace('.', '_');
		$LayoutTabs.tabs('add', {
			queryId: queryId,
			reportName: reportName,
			title: reportText,
			content: '<iframe id="' + queryId + '" style="display:block;width:99.6%;height:99%;" frameborder="no"  border=0  marginwidth=0  marginheight=0 src="' + PHA_COM.VAR.EmptyReport + '"/>'
		});
		$('#' + reportName + '-' + 'iframe').parent().css('overflow-x','hidden');
	}
	var tabsOpts = $LayoutTabs.tabs('options');
	tabsOpts.isLoaded = true;
	$('#' + PHA_COM.VAR.TabsId).tabs('select',0);
}

function Query(){
	// 获取报表
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var reportName = oneTabOpts.reportName;
	var queryId = oneTabOpts.queryId;
	
	// 获取参数
	var formDataArr = PHA.DomData("#repParam", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var selRow = $('#gridNarcDrug').datagrid('getSelected');
	if (selRow == null || selRow.length == 0) {
		PHA.Popover({
			msg: '请选择药品!',
			type: "alert"
		});
	}
	formData.inci = selRow.inci;
	formData.hospId = PHA_COM.VAR.hospId;
	formData.dateType = 'RegDate';
	var InputStr = JSON.stringify(formData);
	
	// 打开链接
	var _reportUrl = 'dhccpmrunqianreport.csp';
	_reportUrl += '?reportName=' + reportName;
	_reportUrl += '&InputStr=' + InputStr;
	_reportUrl += '&pJsonStr=' + InputStr;
	_reportUrl += '&startDate=' + formData.startDate;
	_reportUrl += '&endDate=' + formData.endDate;
	_reportUrl += '&hospId=' + PHA_COM.VAR.hospId;
	if (typeof websys_writeMWToken !== 'undefined') {
		_reportUrl = websys_writeMWToken(_reportUrl);
	}
	$('#' + queryId).attr('src', _reportUrl);
}

function Clear(){
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	InitDictVal();
	// 报表页面
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var queryId = oneTabOpts.queryId;
	$('#' + queryId).attr('src', PHA_COM.VAR.EmptyReport);
}

// 配置初始化
function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}