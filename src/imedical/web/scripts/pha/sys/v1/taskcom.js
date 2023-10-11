/**
 * 药房药库通用任务管理 - 公共js
 * Huxt 2022-08-12
 * pha/sys/v1/taskcom.js
 */

var PHA_TASK_COM = {
	// 任务详情弹窗界面
	DetailWin: function(_options){
		var winId = 'win_detail';
		var gridId = winId + '_grid';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			$('#' + winId).dialog($.extend({
				title: '任务详细信息',
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
						title: '属性',
						width: 45,
						//align: 'right',
						//formatter: function(value, rowData, rowIndex){
						//	return '<b>' + value + '</b>';
						//}
					}, {
						field: 'tValue',
						title: '值',
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
	// 任务执行日志弹窗
	HistoryWin: function(_options){
		var winId = "history_win";
		var winContentId = winId + "_" + "content";
		if ($('#' + winId).length == 0) {
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog($.extend({
				width: $(document.body).width() - 40,
				height: $(document.body).height() - 40,
				modal: true,
				title: '任务历史查询',
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
	// 字段对照
	SysTaskFields: {
		Name: $g('任务名称'),
		Description: $g('任务描述'),
		NameSpace: $g('任务命名空间'),
		StartDate: $g('任务开始日期'),
		DisplayInterval: $g('任务间隔描述'),
		DisplayRun: $g('任务运行描述'),
		TaskClass: $g('任务类型'),
		Priority: $g('任务优先级'),
		SuspendOnError: $g('任务出错时是否挂起'),
		OpenOutputFile: $g('任务运行完是否输出文件'),
		OutputFilename: $g('任务输出文件路径'),
		RunAsUser: $g('任务运行用户'),
		RescheduleOnStart: $g('系统重启后重新计划任务'),
		LastSchedule: $g('上次计划时间'),
		LastStarted: $g('上次开始时间'),
		LastFinished: $g('上次结束时间'),
		Status: $g('上次状态'),
		DayNextScheduled: $g('下次计划日期'),
		TimeNextScheduled: $g('下次计划时间'),
		ExecuteCode: $g('执行代码')
	},
	TaskFields: {
		code: $g('代码'),
		name: $g('名称'),
		exeCode: $g('执行代码'),
		remarks: $g('备注'),
		sysTaskDR: $g('关联系统任务ID'),
		sysTaskName: $g('关联系统任务名称'),
		sysTaskDesc: $g('关联系统任务描述'),
		addUserName: $g('添加人'),
		addDate: $g('添加日期'),
		addTime: $g('添加时间'),
		updUserName: $g('更新人'),
		updDate: $g('更新日期'),
		updTime: $g('更新时间'),
		activeFlag: $g('是否可用'),
		sortNum: $g('执行序号')
	}
};
