/**
 * ����:   	 ҩ��ҩ�� - ����ҩƷ����- ҩƷͳ�Ʊ���
 * ��д��:   Huxiaotian
 * ��д����: 2021-10-11
 * csp:		 pha.in.v1.narcdrugrep.csp
 * js:		 pha/in/v1/narcdrugrep.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcreport.csp';
PHA_COM.App.Name = '����ҩƷͳ�Ʊ���';
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
	// ֮�����µı���,ֱ���ڴ����,������
	var rqPanels = [
		{reportName:'PHAIN_NarcReport_RegByInci.rpx', reportText:'����ҩƷʹ�õǼǲ�'},
		{reportName:'PHAIN_NarcReport_LocUse.rpx', reportText:'����ʹ�ü�¼��'},
		{reportName:'PHAIN_NarcReport_Hand.rpx', reportText:'���Ӱ��¼����'}
	];
	
	InitDict();
	InitGridNarcDrug();
	InitEvents();
	InitLayout(rqPanels);
	InitConfig();
});

// ��ʼ�� - ���ֵ�
function InitDict(){
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
		width: 225,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.TriggerBox("phccDescAll", {
		placeholder: 'ҩѧ����...',
		width: 225,
		handler: function(){
			PHA_UX.DHCPHCCat('', '', function(rowData){
				$("#phccDescAll").triggerbox('setValue', rowData.phcCatDescAll);
				$("#phccDescAll").triggerbox('setValueId', rowData.phcCatDescAll);
			})
		}
	});
	PHA.ComboBox('locId', {
		placeholder: '����...',
		disabled: true,
		url: PHA_STORE.CTLoc().url
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('locId', session['LOGON.CTLOCID']);
}

// ��ʼ�� - �¼���
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

// ��ʼ�� - ���
function InitGridNarcDrug() {
	var columns = [[{
				field: 'inci',
				title: 'inci',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 140,
				hidden: true
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 200
			}, {
				field: 'inciSpec',
				title: '���',
				width: 100,
				hidden: true
			}, {
				field: 'poisonDesc',
				title: '���Ʒ���',
				width: 120,
				hidden: true
			}, {
				field: 'phccDescAll',
				title: 'ҩѧ����',
				width: 120,
				hidden: true
			}, {
				field: 'showDetail',
				title: '����',
				width: 45,
				fixed: true,
				formatter: function(value, rowData, rowIndex){
					return "<a class='pha-detail-tips' rowIndex='" + rowIndex + "'>" + "����" + "</a>";
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
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ����') + '��</font><font style="color:#000000;">' + rowData.inciCode + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ����') + '��</font><font style="color:#000000;">' + rowData.inciDesc + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ���') + '��</font><font style="color:#000000;">' + rowData.inciSpec + '</font></p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('���Ʒ���') + '��</font><font style="color:#000000;">' + rowData.poisonDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩѧ����') + '��</font><font style="color:#000000;">' + rowData.phccDescAll + '</p>';
				$(this).popover({
					placement: 'auto',
					trigger: 'hover',
					title: 'ҩƷ����',
					content: contentHtml
				});
			});
		}
	};
	PHA.Grid('gridNarcDrug', dataGridOption);
}
// ��ѯ����ҩƷ
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
// �������ҩƷ
function ClearNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'clear'
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcDrug').datagrid('loadData', []);
	Clear();
}

// ��ʼ��TAB����
function InitLayout(rqPanels){
	var $LayoutTabs = $('#' + PHA_COM.VAR.TabsId);
	// ��ʼ��
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
	// ���Tab
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
	// ��ȡ����
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var reportName = oneTabOpts.reportName;
	var queryId = oneTabOpts.queryId;
	
	// ��ȡ����
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
			msg: '��ѡ��ҩƷ!',
			type: "alert"
		});
	}
	formData.inci = selRow.inci;
	formData.hospId = PHA_COM.VAR.hospId;
	formData.dateType = 'RegDate';
	var InputStr = JSON.stringify(formData);
	
	// ������
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
	// ����ҳ��
	var selTab = $('#' + PHA_COM.VAR.TabsId).tabs('getSelected');
	var selIndex = $('#' + PHA_COM.VAR.TabsId).tabs('getTabIndex', selTab);
	var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', selIndex).panel('options');
	var queryId = oneTabOpts.queryId;
	$('#' + queryId).attr('src', PHA_COM.VAR.EmptyReport);
}

// ���ó�ʼ��
function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Com.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}