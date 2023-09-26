// 2015-01-27,11/23/64
$(function(){
	$('#tDetailsConditions').datagrid({
		title:"����������ϸ",
		rownumbers: true,
		//pagination: true,
		striped:true,
		singleSelect:true,
		columns:[[{field:'key',title:'��',width:100},{field:'value',title:'ֵ',width:100}]]
	});
	$('#tDetailsContent').datagrid({
		title:"���������ϸ",
		rownumbers: true,
		//pagination: true,
		striped:true,
		singleSelect:true,
		columns:[[{field:'key',title:'��',width:100},{field:'value',title:'ֵ',width:100}]]

	});
	$('#tDHCEventLogDetails').datagrid({
		rownumbers: true,
		pagination: true,
		striped:true,
		singleSelect:true,
		queryParams: { ClassName: 'web.DHCEventLogDetails',QueryName: 'Find',DetLogParref:$('#DetLogParref').val()},
		url:'jquery.easyui.querydatatrans.csp',
		columns:[[{field:'DetRowId',title:'DetRowId',width:100,align:'right',hidden:true},
		{field:'DetDate',title:'����',width:100,align:'right',hidden:false},
		{field:'DetTime',title:'ʱ��',width:60,align:'right',hidden:false},
		{field:'DetGroupDr',title:'DetGroupDr',width:100,align:'right',hidden:true},
		{field:'DetGroupDesc',title:'��ȫ��',width:100,align:'right',hidden:false},
		{field:'DetLocDr',title:'DetLocDr',width:100,align:'right',hidden:true},
		{field:'DetLocDesc',title:'����',width:100,align:'right',hidden:false},
		{field:'DetLoginDr',title:'DetLoginDr',width:100,align:'right',hidden:true},
		{field:'DetSecretLevelDr',title:'DetSecretLevelDr',width:100,align:'right',hidden:true},
		{field:'DetSecretLevelDesc',title:'�ܼ�',width:60,align:'right',hidden:false},
		{field:'DetUserDr',title:'DetUserDr',width:100,align:'right',hidden:true},
		{field:'DetUserName',title:'������',width:100,align:'right',hidden:false},
		{field:'DetComputerIP',title:'IP',width:100,align:'right',hidden:false},
		{field:'DetComputerMac',title:'Mac��ַ',width:100,align:'right',hidden:false},
		{field:'DetComputerName',title:'�������',width:100,align:'right',hidden:false},
		{field:'DetConditions',title:'����',width:100,align:'right' },
		{field:'DetContent',title:'��������',width:100,align:'right'}]]
	});
	$("#tDHCEventLogDetails").datagrid("options").onClickRow = function(index,rowData){
		var condJson,contJson,condData={rows:[],total:0},contData={rows:[],total:0};
		if (!!rowData["DetConditions"]){
			try{
				eval("var condJson="+rowData["DetConditions"]);
			}catch(e){}
		}
		if (!!rowData["DetContent"]){
			try{
				eval("var contJson="+rowData["DetContent"]);
			}catch(e){}
		}
		for (var p in condJson){
			condData.rows.push({"key":p,"value":condJson[p]});
			condData.total++;
		}
		for (var p1 in contJson){
			contData.rows.push({"key":p1,"value":contJson[p1]});
			contData.total++;
		}
		$('#tDetailsConditions').datagrid("loadData",condData);
		$('#tDetailsContent').datagrid("loadData",contData);
	}
})
