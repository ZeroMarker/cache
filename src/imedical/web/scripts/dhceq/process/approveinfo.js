$(document).ready(function(){
$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQBuyRequestNew',
			MethodName:'GetStatusInfo',
			Arg1:getParam("RequestNo"),
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			$('#RequestSpeed').val(data);
		}
	});
$('#RequestSpeed').attr("disabled",true)
$("#tApproveInfo").datagrid({
	url:"dhceq.jquery.csp",
	panelWidth:1200,
	queryParams:{
		ClassName:"web.DHCEQBuyRequestNew",
		QueryName:"RequestEquip",
		Arg1:getParam("RequestNo"),
		ArgCnt:1
		},
	singleSelect:true,
	fit:true,
	columns:[[
		{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
		{field:'TRow',title:'序号',width:50,align:'center'},
		{field:'TDate',title:'日期',width:150,align:'center'},
		{field:'TEquipNo',title:'设备编号',width:150,align:'center'},
		{field:'TEquipName',title:'设备名称',width:200,align:'center'},
		{field:'TLoc',title:'科室',width:150,align:'center'},
	]],
	pagination:true,
	pageSize:15,
	pageNumber:1,
	pageList:[15,30,45,60,75]
});


})