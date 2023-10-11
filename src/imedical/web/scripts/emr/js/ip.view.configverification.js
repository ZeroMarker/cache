$(function(){
	loadConfigData()
})

$HUI.datagrid('#dgConfig',{
	idField:'id',
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	rownumbers:true,
	singleSelect:false,
	width:'100%',
	title:'项目配置验证列表',
	autoSizeColumn:false,
	fitColumns:true,
	toolbar:[{iconCls: 'icon-arrow-right',
		text:'导出',
		handler: function(){
			var rows = $('#dgConfig').datagrid('getSelections');
			if (rows.length ==0)
			{
				$.messager.popover({msg: "添加前请完成勾选",type:'alert'});
			}
			
		}
	}],
	columns:[[
		{field:'ck',title:'ckbox',checkbox:true},
		{field:'id',title:'ID',width:60,hidden:true},
		{field:'configitem',title:'配置项目',width:200,tipWidth:300},
		{field:'prjconfig',title:'当前值',width:180,showTip:true,tipWidth:300},
		{field:'recommendedconfig',title:'推荐值',width:180,showTip:true,tipWidth:300},
		{field:'reason',title:'推荐原因',width:550},
		{field:'sourcetype',title:'来源',width:400,tipWidth:300}
	]],
	rowStyler:function(index,row)
	{
		if (row.prjconfig != row.recommendedconfig)
		{
			return 'background-color:#6293BB;color:#fff;font-weight:bold;';
		}
	}
})


function loadConfigData()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLConfigVerification",
			"Method":"GetConfigVerification"
		},
		success : function(d) {
	    	loadDgData("dgConfig",d.data);
	    	console.log(d.message)
		},
		error : function(d) { 
			$.messager.popover({msg: "dgConfig:"+d ,type:'alert'});
		}
	});
	return result;
}
function loadDgData(id,data)
{
	$("#"+id).datagrid("loadData",data)

}