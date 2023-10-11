/**
 * description: ҩ��ҩ����־ - ҵ��������־��ѯ
 * creator:     Huxt 2022-05-06
 * csp:         pha.sys.v1.datalog.csp
 * js:          pha/sys/v1/datalog.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('ҩ��');
PHA_COM.App.Csp = 'pha.sys.v1.datalog.csp';
PHA_COM.App.Name = $g('ҵ��������־��ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	$('#panelMain').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('ҵ��������־��ѯ') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	InitDict();
	InitGridDataLog();
	InitEvents();
	
	QueryDataLog();
});

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QueryDataLog);
	$('#btnClean').on('click', Clean);
	
	$('#dataDesc').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryDataLog();
		}
	});
	$('#QText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryDataLog();
		}
	});
}

// ��ʼ�� - ��
function InitDict() {
	PHA.ComboBox('userID', {
		placeholder: '������...',
		url: PHA_STORE.SSUser().url,
		onSelect: function(rowData){
			QueryDataLog();
		}
	});
	PHA.ComboBox('logType', {
		panelHeight: 'auto',
		placeholder: '��������...',
		data: [{
			RowId: 'U',
			Description: '�޸�'
		}, {
			RowId: 'A',
			Description: '����'
		}, {
			RowId: 'D',
			Description: 'ɾ��'
		}],
		onSelect: function(rowData){
			QueryDataLog();
		}
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetVals([{
		startDate: 't',
		endDate: 't'
	}]);
}

// ��ʼ�� - ���
function InitGridDataLog() {
	var columns = [[{
				field: 'pidl',
				title: 'pidl',
				width: 100,
				hidden: true
			}, {
				field: 'logTypeDesc',
				title: '��������',
				width: 100,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					if (rowData.logType == 'A') {
				        return '<font color="#21ba45">'+$g("�½�")+'</font>';
				    } else if (rowData.logType == 'U'){
				        return '<font color="#f1c516">'+$g("�޸�")+'</font>';
				    } else if (rowData.logType == 'D'){
				        return '<font color="#f16e57">'+$g("ɾ��")+'</font>';
				    } else {
					    return value;
				    }
				    /*
				    // ������UIҪ��
					var vHtml = '<div style="font-size:12px;padding-left:4px;padding-right:4px;border-radius:2px';
					if (rowData.logType == 'A') {
						vHtml += ';background-color:rgb(228,247,210);color:rgb(19,82,0);">' + value + '</div>';
					} else if(rowData.logType == 'U') {
						vHtml += ';background-color:rgb(255,248,189);color:rgb(97,71,0);">' + value + '</div>';
					} else if (rowData.logType == 'D') {
						vHtml += ';background-color:rgb(255,232,230);color:rgb(130,0,20);">' + value + '</div>';
					} else {
						vHtml += '>' + value + '</div>';
					}
					return vHtml;
					*/
				}
			}, {
				field: 'classDesc',
				title: '����������',
				width: 140
			}, {
				field: 'dataRowId',
				title: '����ID',
				width: 100
			}, {
				field: 'dataDesc',
				title: '��������',
				width: 160
			}, {
				field: 'userID',
				title: '������ID',
				width: 100,
				hidden: true
			}, {
				field: 'userName',
				title: '������',
				width: 100
			}, {
				field: 'logDT',
				title: '����ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'logGroup',
				title: '���',
				width: 80
			}, {
				field: 'clientIP',
				title: '�ͻ���IP',
				width: 170
			}, {
				field: 'serverIP',
				title: '������IP',
				width: 170
			}, {
				field: 'logDataDetail',
				title: '������ϸ',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenDataDetailWin', rowIndex, '����鿴���ݲ�����ϸ');
				}
			}, {
				field: 'sessionInfoBtn',
				title: '��¼��Ϣ',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('search.png', 'OpenSessionWin', rowIndex, '����鿴����ʱ��ϸ��Session��Ϣ');
				}
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'DataLog',
			pPlug: 'datagrid'
		},
		fitColumns: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridDataLogBar',
		gridSave: false,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {},
		onDblClickRow: function(rowIndex, rowData){
			OpenDataDetailWin(rowIndex);
		}
	};
	PHA.Grid('gridDataLog', dgOptions);
}

// ��ѯ
function QueryDataLog() {
	var pJson = PHA.DomData('#gridDataLogBar', {
		doType: 'query',
		retType: 'Json'
	});
	var pJsonStr = JSON.stringify(pJson[0]);
	
	$('#gridDataLog').datagrid('options').url = PHA.$URL;
	$('#gridDataLog').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'DataLog',
		pPlug: 'datagrid',
		pJsonStr: pJsonStr
	});
}

// ����
function Clean(){
	PHA.DomData('#gridDataLogBar', {
		doType: 'clear'
	});
	$('#gridDataLog').datagrid('loadData', []);
	InitDictVal();
}

// ������ϸ
function OpenDataDetailWin(rowIndex){
	var rowsData = $("#gridDataLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var detailData = PHA.CM({
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'DataLogDetail',
		pJsonStr: JSON.stringify({
			pidl: rowData.pidl
		})
	}, false);
	if (detailData.success == 0) {
		PHA.Msg('error', detailData.msg);
		return;
	}
	var main = detailData.main;
	var detail = detailData.detail;
	var mainHtml = '<div style="padding:10px;"><label style="font-weight:bold;">' + main.userName + ' / ' + main.logDT + ' / ' + main.clientIP + ' / ' + main.logTypeDesc + ' / ' + main.tableName + '</label></div>';
	var detailRows = detail;
	
	LOG_COM.DataDetailWin({
		main: main,
		detail: detail,
		mainHtml: mainHtml
	});
}

// ��¼session��Ϣ
function OpenSessionWin(rowIndex){
	var rowsData = $("#gridDataLog").datagrid("getRows");
	var rowData = rowsData[rowIndex];
	var sessionJson = JSON.parse(rowData.sessionInfo == '' ? '{}' : rowData.sessionInfo);
	
	LOG_COM.SessionWin({
		sessionJson: sessionJson
	});
}
