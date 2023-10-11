/**
 * 日志查询界面通用
 * Huxt 2022-05-07
 * pha/sys/v1/logcom.js
 */
var LOG_COM = {
	/*
	 * 查询图标按钮
	 * LOG_COM.IconBtn()
	 */
	IconPath: '../scripts_lib/hisui-0.1.0/dist/css/icons/',
	IconBtn: function(img, fnStr, rowIndex, titleStr, addValue){
		titleStr = titleStr || '';
		if (typeof addValue == 'undefined') {
			return '<div><img src="' + LOG_COM.IconPath + img + '" style="border:0px;cursor:pointer;margin-top:5px;" onclick=' + fnStr + '("' + rowIndex + '") title="' + $g(titleStr) + '"/></div>';
		}
		return '<div><img src="' + LOG_COM.IconPath + img + '" style="float:left;border:0px;cursor:pointer;margin-top:5px;" onclick=' + fnStr + '("' + rowIndex + '") title="' + $g(titleStr) + '"/></div>&nbsp;&nbsp;' + addValue;
	},
	/*
	 * 类方法格式化
	 * LOG_COM.FmtMethodStr()
	 */
	FmtMethodStr: function(className, methodName, paramStr){
		var showHtml = '';
		showHtml += '<label style="color:#0034A9;">##calss</label>(';
		showHtml += '<label style="color:#0092A9;">' + className + '</label>' + ').';
		showHtml += '<label style="color:#0034E7;">' + methodName + '</label>' + '(';
		showHtml += '<label style="color:#008000;">' + paramStr + '</label>)';
		return showHtml;
		
		try {
			var runInfo = null;
			if (typeof value == 'string') {
				runInfo = JSON.parse(value);
			} else {
				runInfo = value;
			}
			
			
			var pVal = '';
			var isFirst = true;
			for (var k in runInfo) {
				if (['className', 'methodName'].indexOf(k) >= 0) {
					continue;
				}
				pVal = "\"" + runInfo[k] + "\"";
				showHtml += isFirst == true ? pVal : ',' + pVal;
				isFirst = false;
			}
			return showHtml;
		} catch(e){
			return value;
		}
	},
	/*
	 * 数据日志明细弹窗
	 * LOG_COM.DataDetailWin()
	 */
	DataDetailWin: function(_options){
		var main = _options.main;
		var mainHtml = '';
		if (_options.mainHtml) {
			mainHtml = _options.mainHtml;
		} else if (main) {
			mainHtml += '<div style="padding:10px;"><label style="font-weight:bold;">';
			var isFirst = true;
			for (var k in main) {
				if (isFirst) {
					mainHtml += main[k];
					isFirst = false;
				} else {
					mainHtml += ' / ' + main[k];
				}
			}
			mainHtml += '</label></div>';
		}
		var detailRows = _options.detail;
		
		// 显示弹窗
		var winId = 'win_data_detail';
		var gridId = winId + '_grid';
		var gridBarId = gridId + '_bar';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: '操作数据明细',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 1000,
				height: 650,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '</div>';
					cHtml += '<div id="' + gridBarId + '" style="height:40px;"></div>';
					return cHtml;
				})()
			};
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
		} else {
			$('#' + winId).dialog('open');
		}
		
		// 表格
		var tOldValHidden = false;
		var tNewValHidden = false;
		if (main.logType == 'A') {
			tOldValHidden = true;
		} else if (main.logType == 'D') {
			tNewValHidden = true;
		}
		var columns = [
			[
				{
					field: 'tField',
					title: '字段',
					width: 60,
					//align: 'right',
					formatter: function(value, rowData, rowIndex){
						return value;
						return '<b>' + value + '</b>';
					}
				}, {
					field: 'tFieldDesc',
					title: '字段描述',
					width: 60
				}, {
					field: 'tOldVal',
					title: '原数据',
					width: 100,
					hidden: tOldValHidden
				}, {
					field: 'tNewVal',
					title: '新数据',
					width: 100,
					styler: function(value, rowData, rowIndex){
						if (main.logType == 'U' && rowData.tOldVal != rowData.tNewVal) {
							return 'color:red';
						}
						return '';
					},
					hidden: tNewValHidden
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
			toolbar: '#' + gridBarId,
			gridSave: false,
			border: true,
			bodyCls: 'panel-body-gray',
			onRowContextMenu: function(){},
			onHeaderContextMenu: function(e, field){}
		};
		PHA.Grid(gridId, dgOptions);
		
		// 显示数据
		$('#' + gridBarId).html(mainHtml);
		$('#' + gridId).datagrid('loadData', detailRows);
	},
	/*
	 * session信息查看弹窗
	 * LOG_COM.SessionWin()
	 */
	SessionWin: function(_options){
		var sessionJson = _options.sessionJson;
		var gLoadData = [];
		for (var s in sessionJson) {
			gLoadData.push({
				tField: s,
				tValue: sessionJson[s]
			});
		}
		
		// 显示弹窗
		var winId = 'win_session';
		var gridId = winId + '_grid';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: '用户登录详细信息',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 600,
				height: 600,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '</div>';
					return cHtml;
				})()
			}
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
			
			var columns = [
				[
					{
						field: 'tField',
						title: '字段',
						width: 60,
						//align: 'right',
						formatter: function(value, rowData, rowIndex){
							return value;
							return '<b>' + value + '</b>';
						}
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
		}
		$('#' + gridId).datagrid('loadData', gLoadData);
	},
	/*
	 * 参数格式化界面
	 * LOG_COM.ParamsFmtWin()
	 */
	ParamsFmtWin: function(_options){
		var mParams = _options.paramStr;
		try {
			mParams = JSON.parse(mParams);
		} catch(e) {
			mParams = mParams;
		}
		
		var gLoadData = [];
		if (typeof mParams == 'string') {
			gLoadData.push({
				tParamName: 'params',
				tParamVal: mParams
			});
		} else {
			for (var k in mParams) {
				gLoadData.push({
					tParamName: k,
					tParamVal: mParams[k]
				});
			}
		}
		
		// 显示弹窗
		var winId = 'win_params_fmt';
		var gridId = winId + '_grid';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: '入参信息',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 700,
				height: 600,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '</div>';
					return cHtml;
				})()
			}
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
			
			var columns = [
				[
					{
						field: 'tParamName',
						title: '参数名',
						width: 180,
						//align: 'right',
						fixed: true,
						formatter: function(value, rowData, rowIndex){
							return value;
							return '<b>' + value + '</b>';
						}
					}, {
						field: 'tParamVal',
						title: '参数值',
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
		}
		$('#' + gridId).datagrid('loadData', gLoadData);
	},
	/*
	 * 参数格式化界面
	 * LOG_COM.DataFmtWin()
	 */
	DataFmtWin: function(_options){
		var dataStr = _options.dataStr || '';
		var title = _options.title || $g('数据查看');
		var winId = 'win_data_fmt';
		var dataDivId = winId + '_div';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: title,
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 700,
				height: 600,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body" style="overflow:hidden;">';
					cHtml += '		<textarea id="' + dataDivId + '" class="textbox" data-pha=\'class:"hisui-validatebox",requied:false\' size=12 rows="6" style="min-height:541px;min-width:674px;max-height:541px;max-width:674px;word-break:break-all;line-height:24px;margin-top:0px;" readonly="readonly" spellcheck="false" placeholder="接口方法运行结果..."></textarea>';
					cHtml += '	</div>';
					cHtml += '</div>';
					return cHtml;
				})()
			}
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
		} else {
			$('#' + winId).dialog('open');
		}
		$('#' + dataDivId).val(dataStr);
	},
	/*
	 * 堆栈详细信息界面
	 * LOG_COM.StackInfoWin()
	 */
	StackInfoWin: function(_options){
		var stackInfo = _options.stackInfo;
		var gLoadData = [];
		var stackInfoArr = stackInfo.split('];');
		for (var i = 0; i < stackInfoArr.length; i++) {
			var iStackInfo = stackInfoArr[i] || '';
			iStackInfo = iStackInfo.replace('place:', '<label style="color:#9e9e9e;">place:</label>');
			iStackInfo = iStackInfo.replace('source:', '<label style="color:#9e9e9e;">source:</label>');
			iStackInfo = (i == stackInfoArr.length - 1) ? iStackInfo : iStackInfo + ']';
			gLoadData.push({
				tStack: iStackInfo
			})
		}
		
		// 显示弹窗
		var winId = 'win_stack_info';
		var gridId = winId + '_grid';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: '程序运行堆栈详细信息',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 1000,
				height: 640,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '</div>';
					return cHtml;
				})()
			}
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
			
			var columns = [
				[
					{
						field: 'tStack',
						title: '堆栈信息',
						width: 60
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
		}
		$('#' + gridId).datagrid('loadData', gLoadData);
	},
	/*
	 * 测试接口调用的弹窗
	 * LOG_COM.RunFaceWin()
	 */
	RunFaceWin: function(_options){
		LOG_COM._InitOpts = _options;
		var ClassName = _options.ClassName;
		var MethodName = _options.MethodName;
		var MethodParams = _options.MethodParams;
		var runRet = _options.runRet || '';
		var runType = _options.runType || '';
		var relaLogId = _options.relaLogId || '';
		
		var clsMtdPar = PHA.CM({
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'GetParamsJson',
			pJsonStr: JSON.stringify({
				ClassName: ClassName,
				MethodName: MethodName
			})
		}, false);
		var gLoadData = [];
		gLoadData.push({
			tField: 'ClassName',
			tValue: ClassName,
		});
		gLoadData.push({
			tField: 'MethodName',
			tValue: MethodName,
		});
		for (var p in clsMtdPar) {
			var iParam = {
				tField: p,
				tValue: clsMtdPar[p],
			}
			if (MethodParams && MethodParams[p]) {
				iParam.tValue = MethodParams[p];
			}
			gLoadData.push(iParam);
		}
		
		// 显示弹窗
		var winId = 'win_run_face';
		var gridId = winId + '_grid';
		var gridBarId = gridId + '_bar';
		var runId = winId + '_btn';
		var runRetId = winId + '_ret';
		if ($('#' + winId).length == 0) {
			$('body').append('<div id="' + winId + '"></div>');
			var _defWinOpts = {
				title: '接口方法测试',
				collapsible: false,
				minimizable: false,
				iconCls: "icon-w-list",
				border: false,
				closed: true,
				modal: true,
				width: 800,
				height: 700,
				content: (function(){
					var cHtml = '';
					cHtml += '<div class="hisui-layout" fit="true" border="false">';
					cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
					cHtml += '		<table id="' + gridId + '"></table>';
					cHtml += '	</div>';
					cHtml += '	<div data-options="region:\'south\',height:280,border:false" class="pha-body">';
					cHtml += '		<div class="hisui-panel pha-body" title="接口方法运行结果" data-options="fit:true,headerCls:\'panel-header-gray\',bodyCls:\'panel-body-gray\'" style="overflow:hidden;">';
					cHtml += '			<textarea id="' + runRetId + '" class="textbox" data-pha=\'class:"hisui-validatebox",requied:false\' size=12 rows="6" style="min-height:201px;min-width:749px;max-height:201px;max-width:749px;word-break:break-all;line-height:24px;margin-top:0px;" readonly="readonly" spellcheck="false" placeholder="接口方法运行结果..."></textarea>';
					cHtml += '		</div>';
					cHtml += '	</div>';
					cHtml += '</div>';
					cHtml += '<div id="' + gridBarId + '">';
					cHtml += '	<a class="hisui-linkbutton" plain=\'true\' iconCls="icon-run" id="' + runId + '">运行接口方法</a>';
					cHtml += '</div>';
					return cHtml;
				})()
			}
			var _newWinOpts = $.extend({}, _defWinOpts, _options);
			$('#' + winId).dialog(_newWinOpts).dialog('open');
			
			var columns = [
				[
					{
						field: 'tField',
						title: '标识',
						width: 180,
						align: 'right',
						fixed: true
					}, {
						field: 'tValue',
						title: '值',
						width: 60,
						editor: {
							type: 'validatebox',
							options: {}
						}
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
				toolbar: '#' + gridBarId,
				gridSave: false,
				border: true,
				bodyCls: 'panel-body-gray',
				onRowContextMenu: function(){},
				onHeaderContextMenu: function(e, field){},
				onClickCell: function(index, field, value){
					if (LOG_COM._InitOpts.editParam == false) {
						return;
					}
					var edIndex = $(this).datagrid('options').edIndex;
					if (edIndex >= 0) {
						$(this).datagrid('endEdit', edIndex);
					}
					
					var rowsData = $(this).datagrid('getRows');
					var rowData = rowsData[index];
					if (['ClassName', 'MethodName', 'QueryName'].indexOf(rowData.tField) >= 0) {
						return;
					}
					
					$(this).datagrid('beginEdit', index);
					$(this).datagrid('options').edIndex = index;
					
					var ed = $(this).datagrid('getEditor', {
						index: index,
						field: field
					});
					if (ed) {
						$(ed.target).focus();
					}
				}
			};
			PHA.Grid(gridId, dgOptions);
			$('#' + gridId).parent().parent().css('border-top', '1px solid #E2E2E2')
			$('#' + gridId).parent().parent().css('border-radius', '4px');
			
			$('#' + runId).on('click', runFaceMtd);
		} else {
			$('#' + winId).dialog('open');
		}
		$('#' + gridId).datagrid('loadData', gLoadData);
		$('#' + runRetId).val(runRet);
		
		// 调用接口测试方法
		function runFaceMtd(){
			$('#' + runRetId).val('正在运行...');
			var edIndex = $('#' + gridId).datagrid('options').edIndex;
			if (edIndex >= 0) {
				$('#' + gridId).datagrid('endEdit', edIndex);
			}
			var runFaceParams = {
				_code: LOG_COM._InitOpts.faceCode,
				_loc: LOG_COM._InitOpts.faceLoc,
				_log: 'SYS',
				_run: runType,
				_rela: relaLogId
			}
			var rowsData = $('#' + gridId).datagrid('getRows');
			for (var r = 0; r < rowsData.length; r++) {
				var rData = rowsData[r];
				if (['ClassName', 'MethodName', 'QueryName'].indexOf(rData.tField) >= 0) {
					continue;
				}
				runFaceParams[rData.tField] = rData.tValue;
			}
			
			// 使用异步
			// var ret = PHA_LOG.Face(runFaceParams);
			return $.m({
				ClassName: 'PHA.COM.Log',
				MethodName: 'Face',
				pJsonStr: JSON.stringify(runFaceParams)
			}, function(data){
				$('#' + runRetId).val(data);
			});
		}
	}
}