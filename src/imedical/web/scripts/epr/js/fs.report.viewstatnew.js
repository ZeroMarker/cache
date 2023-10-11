//全局
var FSReportViewStat = FSReportViewStat || {
	HDateStart: '',
	HDateEnd: '',
	ViewType: 'A'
};

(function($) {
	$(function() {
		$g = window.$g || function(a){return a;};
		
		//浏览记录汇总查询 - 起始日期
		$('#historyDateStart').datebox({
			onSelect: function() {
				FSReportViewStat.HDateStart = $('#historyDateStart').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSReportViewStat.HDateStart = $('#historyDateStart').datebox('getValue');
			}
		});
		
		//浏览记录汇总查询 - 截止日期
		$('#historyDateEnd').datebox({
			onSelect: function() {
				FSReportViewStat.HDateEnd = $('#historyDateEnd').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSReportViewStat.HDateEnd = $('#historyDateEnd').datebox('getValue');
			}
		});
		
		var currDate = new Date();
		$('#historyDateStart').datebox('setValue',myformatter(currDate));
		$('#historyDateEnd').datebox('setValue',myformatter(currDate));
		FSReportViewStat.HDateStart = $('#historyDateStart').datebox('getValue');
		FSReportViewStat.HDateEnd = $('#historyDateEnd').datebox('getValue');
		
		//浏览类型
		$('#historyViewType').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'A',
				text: $g('全部')
			}, {
				code: 'N',
				text: $g('授权浏览')
			}, {
				code: 'D',
				text: $g('默认角色浏览')
			}],
			panelHeight: 'auto',
			editable: false,
			onLoadSuccess: function() {
				var viewTypeData = $('#historyViewType').combobox('getData');
				$('#historyViewType').combobox('select', viewTypeData[0].code);
			},
			onSelect: function(rec) {
				FSReportViewStat.ViewType = rec.code;
			}
		});
		
		//浏览记录汇总查询
		$('#refreshBtn').on('click', function() {
			refleshHistoryDG();
		});
		
		//浏览记录汇总列表
		$HUI.datagrid('#historyListTable',{
			title: '浏览记录汇总',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#historyListTableTBar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLLog',
				QueryName: 'GetHistoryList',
				AUserID: '',
				ALogType: 'VIEW',
				AStartDate: FSReportViewStat.HDateStart,
				AEndDate: FSReportViewStat.HDateEnd,
				AViewType: FSReportViewStat.ViewType
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'UserID',title:'UserID',width:80,hidden:true},
				{field:'UserName',title:'操作者',width:80},
				{field:'AppointStatus',title:'授权状态代码',width:80,hidden:true},
				{field:'AppointStatusDesc',title:'授权状态',width:100,formatter:formatStatusDesc},
				{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
				{field:'AuthorizationGroupID',title:'AuthorizationGroupID',width:80,hidden:true},
				{field:'LogDate',title:'浏览日期',width:100},
				{field:'LogTime',title:'浏览时间',width:100},
				{field:'PAStatusType',title:'状态',width:80},
				{field:'PAAdmType',title:'就诊类型',width:80},
				{field:'MedRecordNo',title:'病案号',width:100},
				{field:'RegNo',title:'登记号',width:100},
				{field:'PAPMIName',title:'患者姓名',width:80},
				{field:'PADischgeDate',title:'出院日期',width:100},
				{field:'PADischgeTime',title:'出院时间',width:100},
				{field:'PAAdmLoc',title:'科室',width:160},
				{field:'PAAdmWard',title:'病区',width:160},
				{field:'PAAdmDoc',title:'医生',width:80},
				{field:'PAAdmDate',title:'入院日期',width:100},
				{field:'PAAdmTime',title:'入院时间',width:100},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PAPMIAge',title:'年龄',width:60},
				{field:'PAPMISex',title:'性别',width:60},
				{field:'PayMode',title:'付费类型',width:120},
				{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
				{field:'PatientID',title:'病人号',width:80,hidden:true}
			]]
		});
		
		//刷新浏览记录汇总列表
		function refleshHistoryDG() {
			var queryParams = $('#historyListTable').datagrid('options').queryParams;
			queryParams.AStartDate = FSReportViewStat.HDateStart;
			queryParams.AEndDate = FSReportViewStat.HDateEnd;
			queryParams.AViewType = FSReportViewStat.ViewType;
			$('#historyListTable').datagrid('options').queryParams = queryParams;
			$('#historyListTable').datagrid('reload');
		}
		
		function formatStatusDesc(value,row,index) {
			var status = row.AppointStatus;
			if (status == 'N') {
				return '<font color="#AAAAFF">' + value + '</font>';
			}
			else if (status == 'F') {
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (status == 'R') {
				return '<font color="#FF9797">' + value + '</font>';
			}
			else if (status == 'D') {
				return '<font color="#7B7B7B">' + value + '</font>';
			}
			else if (status == 'I') {
				return '<font color="#7B7B7B">' + value + '</font>';
			}
		}
		
		function myformatter(date) {
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
		
		function myformatter1(date, span) {
			var d = date.getDate() - span;
			var tmp = new Date();
			tmp.setDate(d);
			var y = tmp.getFullYear();
			var m = tmp.getMonth()+1;
			d = tmp.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
	});
})(jQuery);
