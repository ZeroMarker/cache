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
			//$.messager.progress({title: "��ʾ",text: '��ѯ��....'});
			var StartDate = $('#StartDate').datebox('getValue');
			if (!StartDate) {
				$.messager.alert("��ʾ", "��ѡ��ʼ���ڣ�");
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
			{field:'StartDate', title:'��ʼ����',width:100},
			{field:'StartTime', title:'��ʼʱ��',width:100},
			{field:'timeConsume', title:'��ʱ(��)',width:60},			
			{field:'EndDate', title:'��������',width:100},
			{field:'EndTime', title:'����ʱ��',width:100},
			{field:'CaptionInterface', title:'�ӿ�����',width:100},
			{field:'TCodeInterface', title:'�ӿڴ���',width:100},
			{field:'TSessUserCode', title:'�û�����',width:80},			
			{field:'TSessLoc', title:'�Ự����',width:100},
			{field:'TSessGroup', title:'�Ự��ȫ��',width:100},
			{field:'ClassName', title:'����',width:160},
			{field:'MethodName', title:'������',width:100},
			//,{field:'Status', title:'״̬'}
			// ,{field:'ProcessId', title:'ProcessId'}
			// ,{field:'TimeOutDate', title:'TimeOutDate'}
			// ,{field:'TimeOutTime', title:'TimeOutTime'}
			{field:'ServerIP', title:'������IP',width:120},
			// ,{field:'ProcessInfo', title:'ProcessInfo'}
			// ,{field:'Note', title:'Note'}
			// ,{field:'SessionToken', title:'SessionToken'}
			{field:'BizDesc', title:'�ֶ�ҵ������',width:100},
			{field:'BizId', title:'�ֶ�ҵ������',width:100},
			{field:'Args', title:'��������',width:160},
			{field:'TimeOut', title:'��ʱʱ��',width:60},
			{field:'LogonLogDr', title:'��¼��־ID',width:100},
			{field:'TSessIPAddr', title:'�ͻ���IP',width:100},
			{field:'TSessMac', title:'�ͻ���Mac',width:140},
			{field:'TSessCompName', title:'�ͻ��˻�����',width:150}
					
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