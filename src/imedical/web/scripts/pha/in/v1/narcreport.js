/**
 * ����:   	 ҩ��ҩ��-����ҩƷ����-ͳ�Ʊ���
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-23
 * csp:		 pha.in.v1.narcreport.csp
 * js:		 pha/in/v1/narcreport.js
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
};

$(function() {
	// ֮�����µı���,ֱ���ڴ����,������
	var rqPanels = [
		{reportName:'PHAIN_NarcReport_Reg.rpx', reportText:'�ǼǱ���'},
		{reportName:'PHAIN_NarcReport_Com.rpx', reportText:'�ۺϱ���'}
	];
	
	InitDict();
	InitEvents();
	InitLayout(rqPanels);
	InitConfig();
});

// ��ʼ�� - ���ֵ�
function InitDict(){
	InitCondition();
}

// ��ʼ�� - �¼���
function InitEvents(){
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
    $('#patNo').on('keydown', function(e){
		if (e.keyCode == 13) {
			var tPatNo = $('#patNo').val() || "";
			if (tPatNo == '') {
				return;
			}
			var nPatNo = PHA_COM.FullPatNo(tPatNo);
			$('#patNo').val(nPatNo);
			Query();
		}
	});
}

function InitLayout(rqPanels){
	var $LayoutTabs = $('#' + PHA_COM.VAR.TabsId);
	// ��ʼ��
	$LayoutTabs.tabs({
		onSelect: function(title, index){
			var oneTabOpts = $('#' + PHA_COM.VAR.TabsId).tabs('getTab', index).panel('options');
			var reportName = oneTabOpts.reportName;
			if (reportName == 'PHAIN_NarcReport_Reg.raq' || reportName == 'PHAIN_NarcReport_RegByInci.raq') {
				$('#recLocId').combobox('disable');
				PHA.SetComboVal('recLocId', '');
			} else {
				$('#recLocId').combobox('enable');
				PHA.SetComboVal('recLocId', session['LOGON.CTLOCID']);
			}
			
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
			content: '<iframe id="' + queryId + '" style="display:block;width:99.6%;height:99%" src="' + PHA_COM.VAR.EmptyReport + '"/>'
		});
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
	
	// ��ȡ���� & ��֤
	var formData = GetCondition();
	if (reportName == 'PHAIN_NarcReport_RegByInci.raq') {
		var inci = formData.inci || "";
		if (inci == "") {
			PHA.Popover({
				msg: '��ѡ��ҩƷ!',
				type: "alert"
			});
			return;
		}
	}
	formData.regState = 'Y'; // �ۺϱ��� - ����ѯ�ѵǼǵ�(�������Ĵ�ӡһ��)
	formData.recState = formData.recLocId > 0 ? 'Y' : 'A';
	var InputStr = JSON.stringify(formData);
	
	// ������
	var _reportUrl = 'dhccpmrunqianreport.csp';
	_reportUrl += '?reportName=' + reportName;
	_reportUrl += '&InputStr=' + InputStr;
	_reportUrl += '&startDate=' + formData.startDate;
	_reportUrl += '&endDate=' + formData.endDate;
	_reportUrl += '&hospId=' + session['LOGON.HOSPID'];
	if (typeof websys_writeMWToken !== 'undefined') {
		_reportUrl = websys_writeMWToken(_reportUrl);
	}
	$('#' + queryId).attr('src', _reportUrl);
}

function Clear(){
	ClearCondition();
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
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
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}