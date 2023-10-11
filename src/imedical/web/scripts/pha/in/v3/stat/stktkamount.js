/**
 * 名称:   	 药房药库-盘点损益统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-04-14
 */
 PHA_COM.VAR = {
	TabsId: 'tabs-region',
	EmptyReport: '../csp/dhcst.blank.backgroud.csp?&MWToken=' + websys_getMWToken(),
	locId: session['LOGON.CTLOCID']
};
$(function() {	
	// 之后有新的报表,直接在此添加,其余勿动
	var rqPanels = [{
		reportName: 'PHAIN_StkTkAmount_StkTkDetail_Itm.rpx', 
		reportText: '损益明细'
	}, {
		reportName: 'PHAIN_StkTkAmount_StkTkDetail_Inc.rpx', 
		reportText: '品种汇总'
	}];
	InitDict();
	InitGridStktk();
	InitEvents();
	InitLayout(rqPanels);
});


// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
    $("#LossFlag").on("click", showReport);       
}
function InitDict(){
	PHA.ComboBox("phaLoc", {
		placeholder: '科室...',
		url: PHA_STORE.GetGroupDept().url
	});
	InitConditionVal();
}
function InitConditionVal(){
	PHA.SetComboVal('phaLoc', PHA_COM.VAR.locId)
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));

}
// 初始化 - 表格
function InitGridStktk() {
	var columns = [[{
				field: 'instid',
				title: 'instid',
				width: 100,
				hidden: true
			}, {
				field: 'instNo',
				title: '盘点单号',
				hidden: true
			}, {
				field: 'instNoInfo',
				title: '单据信息',
				align: 'left',
				hidden: false,
				width: 252,
				formatter: function(value, rowData, rowIndex){
					var htmlValue = '<div>'
					htmlValue += '<div style="margin-top:2px;">'
					htmlValue += '<div style="display:inline-block;overflow:initial;word-break:break-all;width:176px;">' + rowData.instNo + '</div>'
					htmlValue += '<div style="display:inline-block;float:right;color:#777777;">' + rowData.instStatus + '</div>'
					htmlValue += '</div>'
					htmlValue += '<div style="margin-top:2px;">'
					htmlValue += '<div style="display:inline-block;color:#777777;">' + rowData.instDateTime + '</div>'
					htmlValue += '<div style="display:inline-block;float:right;color:#777777;">' + rowData.userName + '</div>'
					htmlValue += '</div>'
					return htmlValue;
				}
			}, {
				field: 'instDateTime',
				title: '盘点时间',
				hidden: true
			},  {
				field: 'userName',
				title: '盘点人',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.STAT.StkTkAmount',
			QueryName: 'StkTkAmount'
		},
		toolbar: '#conToolbar',
		singleSelect: true,
		pagination: false,
		columns: columns,
		exportXls: true,
		nowrap: false,
		onSelect:function(){
			showReport();
		}
	};
	PHA.Grid('gridStkTk', dataGridOption);
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
			var selRow = $('#gridStkTk').datagrid('getSelected');
			if (isLoaded && selRow != null) {
				showReport();
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
			content: '<iframe id="' + queryId + '" style="border-width:0;display:block;width:99.8%;height:99.6%" src="' + PHA_COM.VAR.EmptyReport + '"/>'
		});
		$('#' + reportName + '-' + 'iframe').parent().css('overflow-x','hidden');
	}
	var tabsOpts = $LayoutTabs.tabs('options');
	tabsOpts.isLoaded = true;
	$('#' + PHA_COM.VAR.TabsId).tabs('select',0);
}

function Query(){
	
	// 参数
	var formDataArr = PHA.DomData("#div-conditions", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	//账盘完成标志
	formData.instComp = "Y";	
	//实盘完成标志
	formData.stkTkComp = "Y";
	//调整完成标志	
	formData.adjComp = "Y";

	$('#gridStkTk').datagrid('options').url = $URL;
	$('#gridStkTk').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}
	
function Clear(){
	ClearCondition()
	$('#gridStkTk').datagrid('loadData', []);
	// 报表页面
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var queryId = oneTabOpts.queryId;
	$('#' + queryId).attr('src', PHA_COM.VAR.EmptyReport);
}

// 获取表单
function ClearCondition(){
	PHA.DomData("#div-conditions", {
		doType: 'clear'
	});
	InitConditionVal();
}

function showReport(){
	var selRow = $('#gridStkTk').datagrid('getSelected');
	if (selRow == null || selRow.length == 0) {
		PHA.Popover({
			msg: '请选择盘点单',
			type: "alert"
		});
		return;
	}
	// 获取报表
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var reportName = oneTabOpts.reportName;
	var queryId = oneTabOpts.queryId;
	
	// 获取参数
	var formDataArr = PHA.DomData("#div-conditions", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	
	formData.instid = selRow.instid;
	var checkedRadioJObj = $("input[name='StatFlag']:checked");
    formData.statFlag = checkedRadioJObj.val();
	var InputStr = JSON.stringify(formData);
	var LocDesc = $('#phaLoc').combobox('getText');

	// 打开链接
	var _reportUrl = 'dhccpmrunqianreport.csp';
	_reportUrl += '?reportName=' + reportName;
	_reportUrl += '&InputStr=' + InputStr;
	_reportUrl += '&StartDate=' + formData.startDate;
	_reportUrl += '&EndDate=' + formData.endDate;
	_reportUrl += '&HospDesc=' + session['LOGON.HOSPDESC'];
	_reportUrl += '&UserName=' + session['LOGON.USERNAME'];
	_reportUrl += '&LocDesc=' + LocDesc;
	_reportUrl += '&MWToken=' + websys_getMWToken();

	$('#' + queryId).attr('src', _reportUrl);
}