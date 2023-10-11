//全局
var FSReportAuthStat = FSReportAuthStat || {
	ADateStart: '',
	ADateEnd: ''
};

(function($) {
	$(function() {
		var currDate = new Date();
		$('#authorizationDateStart').datebox('setValue',myformatter(currDate));
		$('#authorizationDateEnd').datebox('setValue',myformatter(currDate));
		FSReportAuthStat.ADateStart = $('#authorizationDateStart').datebox('getValue');
		FSReportAuthStat.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
		
		//授权记录汇总列表
		$('#authorizationSummaryListTable').datagrid({
			url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
			queryParams: {
				Action: 'authorizationlist',
				AStartDate: FSReportAuthStat.ADateStart,
				AEndDate: FSReportAuthStat.ADateEnd
			},
			method: 'post',
			title: '授权记录汇总列表',
			loadMsg: '数据装载中......',
			singleSelect: true,
			rownumbers: true,
			toolbar: '#authorizationSummaryListTableTBar',
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'AuthorizationID', title: 'AuthorizationID', width: 80, hidden: true },
				{ field: 'RequestUserID', title: 'RequestUserID', width: 80, hidden: true },
				{ field: 'RequestUserName', title: '申请人', width: 80 },
				{ field: 'RequestDeptID', title: 'RequestDeptID', width: 80, hidden: true },
				{ field: 'RequestDept', title: '申请人科室', width: 80, hidden: true },
				{ field: 'RequestSSGroupID', title: 'RequestSSGroupID', width: 80, hidden: true },
				{ field: 'RequestSSGroup', title: '申请人安全组', width: 80, hidden: true },
				{ field: 'RequestDate', title: '申请日期', width: 80 },
				{ field: 'RequestTime', title: '申请时间', width: 80 },
				{ field: 'RequestReason', title: '申请原因', width: 150 },
				{ field: 'RequestTimeSpan', title: '申请时长(小时)', width: 90 },
				{ field: 'AppointUserID', title: 'AppointUserID', width: 80, hidden: true },
				{ field: 'AppointUserName', title: '批准人', width: 80 },
				{ field: 'AppointDate', title: '批准日期', width: 80 },
				{ field: 'AppointTime', title: '批准时间', width: 80 },
				{ field: 'AppointEndDate', title: '批准到期日期', width: 80 },
				{ field: 'AppointEndTime', title: '批准到期时间', width: 80 },
				{ field: 'RoleID', title: 'RoleID', width: 80, hidden: true },
				{ field: 'RoleCode', title: '分配角色代码', width: 80 },
				{ field: 'RoleDesc', title: '分配角色', width: 80 },
				{ field: 'OperationID', title: 'OperationID', width: 80, hidden: true },
				{ field: 'OperationCode', title: '操作类型代码', width: 80, hidden: true },
				{ field: 'OperationDesc', title: '操作类型描述', width: 80 },
				{ field: 'EPRAction', title: '分配权限类型代码', width: 80, hidden: true },
				{ field: 'EPRActionDesc', title: '分配权限类型', width: 80 },
				{ field: 'AppointType', title: 'AppointType', width: 80, hidden: true },
				{ field: 'AppointStatus', title: '授权状态代码', width: 80, hidden: true },
				{ field: 'AppointStatusDesc', title: '授权状态', width: 80, formatter: formatStatusDesc },
				{ field: 'AppointComment', title: '被拒绝或取消原因', width: 200 },
				{ field: 'HasAdvancedSecurity', title: 'HasAdvancedSecurity', width: 80, hidden: true }
			]],
			rowStyler: function(index,row) {
				if (row.HasAdvancedSecurity == 'Y') {
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			}
		});
		
		//授权记录汇总查询 - 起始日期
		$('#authorizationDateStart').datebox({
			onSelect: function() {
				FSReportAuthStat.ADateStart = $('#authorizationDateStart').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSReportAuthStat.ADateStart = $('#authorizationDateStart').datebox('getValue');
			}
		});
		
		//授权记录汇总查询 - 截止日期
		$('#authorizationDateEnd').datebox({
			onSelect: function() {
				FSReportAuthStat.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSReportAuthStat.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
			}
		});
		
		$('#authorizationRefreshBtn').on('click', function() {
			refleshAuthorizationDG();
		});
		
		//刷新授权记录汇总列表
		function refleshAuthorizationDG(){
			var url = '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls';
			$('#authorizationSummaryListTable').datagrid('options').url = url;
			var queryParams = $('#authorizationSummaryListTable').datagrid('options').queryParams;
			queryParams.Action = 'authorizationlist';
			queryParams.AStartDate = FSReportAuthStat.ADateStart;
			queryParams.AEndDate = FSReportAuthStat.ADateEnd;
			$('#authorizationSummaryListTable').datagrid('options').queryParams = queryParams;
			$('#authorizationSummaryListTable').datagrid('reload');
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
