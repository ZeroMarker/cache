/**
 * ҩ��ҩ��ͨ��������� - ����js
 * Huxt 2022-08-12
 * pha/sys/v1/taskcom.js
 */

var PHA_TASK_COM = {
	// �������鵯������
	DetailWin: function(_options){
		var winId = 'win_detail';
		var gridId = winId + '_grid';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			$('#' + winId).dialog($.extend({
				title: '������ϸ��Ϣ',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 640,
				height: 650,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '</div>';
					return cHtml;
				})()
			}, _options)).dialog('open');
			var columns = [
				[
					{
						field: 'tField',
						title: '����',
						width: 45,
						//align: 'right',
						//formatter: function(value, rowData, rowIndex){
						//	return '<b>' + value + '</b>';
						//}
					}, {
						field: 'tValue',
						title: 'ֵ',
						width: 100
					}
				]
			];
			var dgOptions = {
				url: '',
				queryParams: {},
				fitColumns: true,
				rownumbers: true,
				columns: columns,
				pagination: false,
				toolbar: '',
				gridSave: false,
				border: true,
				bodyCls: 'panel-body-gray',
				onRowContextMenu: function(){},
				onHeaderContextMenu: function(e, field){}
			};
			PHA.Grid(gridId, dgOptions);
		} else {
			$('#' + winId).dialog('open');
			$('#' + winId).dialog('setTitle', _options.title);
		}
		$('#' + gridId).datagrid('loadData', _options.data);
	},
	// ����ִ����־����
	HistoryWin: function(_options){
		var winId = "history_win";
		var winContentId = winId + "_" + "content";
		if ($('#' + winId).length == 0) {
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog($.extend({
				width: $(document.body).width() - 40,
				height: $(document.body).height() - 40,
				modal: true,
				title: '������ʷ��ѯ',
				iconCls: 'icon-w-find',
				content: "<iframe id='" + winContentId + "' src='' style='border-width:0px;'></iframe>",
				closable: true,
				onClose: function () {}
			}, _options));
			$('#' + winContentId).width($('#' + winContentId).parent().width());
			$('#' + winContentId).height($('#' + winContentId).parent().height());
		}
		$('#' + winContentId).attr('src', _options.url);
		$('#' + winContentId).parent().css('overflow', 'hidden');
		$('#' + winId).css('overflow', 'hidden');
		$('#' + winId).dialog('setTitle', _options.title);
		$('#' + winId).dialog('open');
	},
	FmtDetail: function (data, flag){
		var retArr = [];
		var tFields = {};
		if (PHA_TASK_COM[flag]) {
			tFields = PHA_TASK_COM[flag];
		} else {
			for (var f in data) {
				tFields[f] = f;
			}
		}
		for (var k in tFields) {
			if (typeof data[k] == 'undefined') {
				continue;
			}
			retArr.push({
				tField: tFields[k],
				tValue: data[k]
			});
		}
		return retArr;
	},
	// �ֶζ���
	SysTaskFields: {
		Name: $g('��������'),
		Description: $g('��������'),
		NameSpace: $g('���������ռ�'),
		StartDate: $g('����ʼ����'),
		DisplayInterval: $g('����������'),
		DisplayRun: $g('������������'),
		TaskClass: $g('��������'),
		Priority: $g('�������ȼ�'),
		SuspendOnError: $g('�������ʱ�Ƿ����'),
		OpenOutputFile: $g('�����������Ƿ�����ļ�'),
		OutputFilename: $g('��������ļ�·��'),
		RunAsUser: $g('���������û�'),
		RescheduleOnStart: $g('ϵͳ���������¼ƻ�����'),
		LastSchedule: $g('�ϴμƻ�ʱ��'),
		LastStarted: $g('�ϴο�ʼʱ��'),
		LastFinished: $g('�ϴν���ʱ��'),
		Status: $g('�ϴ�״̬'),
		DayNextScheduled: $g('�´μƻ�����'),
		TimeNextScheduled: $g('�´μƻ�ʱ��'),
		ExecuteCode: $g('ִ�д���')
	},
	TaskFields: {
		code: $g('����'),
		name: $g('����'),
		exeCode: $g('ִ�д���'),
		remarks: $g('��ע'),
		sysTaskDR: $g('����ϵͳ����ID'),
		sysTaskName: $g('����ϵͳ��������'),
		sysTaskDesc: $g('����ϵͳ��������'),
		addUserName: $g('�����'),
		addDate: $g('�������'),
		addTime: $g('���ʱ��'),
		updUserName: $g('������'),
		updDate: $g('��������'),
		updTime: $g('����ʱ��'),
		activeFlag: $g('�Ƿ����'),
		sortNum: $g('ִ�����')
	}
};
