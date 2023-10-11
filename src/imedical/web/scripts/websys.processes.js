function init() {
	$('#ClearBtn').trigger('click');
    $("#Loading").fadeOut("fast");
    $('#ProcessLog').datagrid({
		queryParams: {
			ClassName: "websys.Processes",
			QueryName: "Find",
			rows:50
		},
		url:$URL,
		onBeforeLoad: function (p) {
			//$.messager.progress({title: "提示",text: '查询中....'});
			var StartDate = $('#StartDate').datebox('getValue');
			if (!StartDate) {
				$.messager.alert("提示", "请选择开始日期！");
				return false;
			}
			var StartTime = $('#StartTime').timespinner('getValue');
			var clsName = $('#clsName').val();
			var CodeInterface = $('#CodeInterface').val();
			var timeConsume = $('#timeConsume').val();
			var EndDate = $('#EndDate').datebox('getValue');
			var EndTime = $('#EndTime').timespinner('getValue');
			$.extend(p, {
				StartDate:StartDate,
				StartTime:StartTime,
				EndDate:EndDate,
				EndTime:EndTime,
				ClsName:clsName,
				CodeInterface:CodeInterface,
				TimeConsume:timeConsume,
				IPAddr:$("#IPAddr").val()
			});
		},
		onLoadSuccess: function () {
			$.messager.progress("close");
		},
		idField:'ContentId' ,
		//height:500,
		fit:true,
		singleSelect:true,
		rownumbers: true,
		pagination: true,
		pageSize:15,
		pageList: [15,30,50,100],  
		striped: true ,	
		columns:[[			
			{field:'StartDate', title:'开始日期',width:100},
			{field:'StartTime', title:'开始时间',width:100},
			{field:'timeConsume', title:'耗时(秒)',width:60},			
			{field:'EndDate', title:'结束日期',width:100},
			{field:'EndTime', title:'结束时间',width:100},
			{field:'CaptionInterface', title:'接口名称',width:100},
			{field:'TCodeInterface', title:'接口代码',width:100},
			{field:'TSessUserCode', title:'用户工号',width:80},			
			{field:'TSessLoc', title:'会话科室',width:100},
			{field:'TSessGroup', title:'会话安全组',width:100},
			{field:'ClassName', title:'类名',width:160},
			{field:'MethodName', title:'方法名',width:100},
			//,{field:'Status', title:'状态'}
			// ,{field:'ProcessId', title:'ProcessId'}
			// ,{field:'TimeOutDate', title:'TimeOutDate'}
			// ,{field:'TimeOutTime', title:'TimeOutTime'}
			{field:'ServerIP', title:'服务器IP',width:120},
			// ,{field:'ProcessInfo', title:'ProcessInfo'}
			// ,{field:'Note', title:'Note'}
			// ,{field:'SessionToken', title:'SessionToken'}
			{field:'BizDesc', title:'手动业务描述',width:100},
			{field:'BizId', title:'手动业务描述',width:100},
			{field:'Args', title:'方法参数',width:160},
			{field:'TimeOut', title:'超时时间',width:60},
			{field:'LogonLogDr', title:'登录日志ID',width:100},
			{field:'TSessIPAddr', title:'客户端IP',width:100},
			{field:'TSessMac', title:'客户端Mac',width:140},
			{field:'TSessCompName', title:'客户端机器名',width:150}
					
		]]		
	});
}
$('#ClearBtn').click(function(){
	var defDate = new Date();
	var defDateStr = $('#StartDate').datebox('options').formatter(defDate);
	var defTimeStr = defDate.getHours()+":"+defDate.getMinutes()+":"+defDate.getSeconds();
	$('#StartDate').datebox('setValue', defDateStr);
	$('#StartTime').timespinner('setValue', "00:00:00");
	$('#EndDate').datebox('setValue', defDateStr);
	$('#EndTime').timespinner('setValue', defTimeStr);
	$('#clsName').val("");
	$('#CodeInterface').val("");
	$('#timeConsume').val("");
	$('#IPAddr').val("");
})
$('#FindBtn').click(function(){
	$('#ProcessLog').datagrid('load');
});
$(init);