$(function(){
	loadSummary();
	loadLocInfo();
})


$HUI.datagrid('#dgTemplateSummary',{
	idField:'id',
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	rownumbers:true,
	singleSelect:false,
	width:'100%',
	title:'摘要',
	autoSizeColumn:false,
	fitColumns:true,
	columns:[[
		{field:'ck',title:'ckbox',checkbox:true},
		{field:'templatecount',title:'模板总计',width:150},
		{field:'basetemplate',title:'基础模板',width:150},
		{field:'usertemplate',title:'科室模板',width:150},
		{field:'diseasetypes',title:'病种',width:150}
		
	]]
})

$HUI.datagrid('#dgCTLoc',{
	idField:'id',
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	rownumbers:true,
	singleSelect:true,
	width:'100%',
	title:'科室',
	fit:true,
	autoSizeColumn:false,
	fitColumns:true,
	columns:[[
		{field:'ck',title:'ckbox',checkbox:true},
		{field:'locid',title:'ID',width:50},
		{field:'locdesc',title:'描述',width:300}
	]],
	onSelect:function(index,row)
	{
		loadTemplateData(row.locid)
	}
})

$HUI.treegrid('#tgTemplateSet',{
	iconCls:'icon-paper',
        fitColumns:true, 
        title:"模板列表",
        headerCls:'panel-header-gray',
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        nowrap:true,
        singleSelect:true,
        fit:true,
        idField:'id',
        treeField:'DocIDText',
        toolbar:'#tempSearch',
        columns:[[
            {field:'id',title:'typeID',hidden:true},
            //2020-6-19 by yejian 名称显示修改docidtext
            {field:'text',title:'名称',width:300,sortable:true,hidden:true},
            {field:'DocIDText',title:'名称',width:300,sortable:true,formatter:show},
            {field:"emrDocId",title:"emrDocId",hidden:true},
            {field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
            {field:'categoryId',hidden:true},{field:'templateId',hidden:true},
            {field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
            {field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
        ]],
})
	
function loadSummary()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTemplateDataSet",
			"Method":"GetTemplateSummary"
		},
		success : function(d) {
	    	loadDgData("dgTemplateSummary",d.data);
		},
		error : function(d) { 
			$.messager.popover({msg: "dgTemplateSummary:"+d ,type:'alert'});
		}
	});
	return result;
}
function loadLocInfo()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTemplateDataSet",
			"Method":"GetCTLocData"
		},
		success : function(d) {
	    	loadDgData("dgCTLoc",d.data);
		},
		error : function(d) { 
			$.messager.popover({msg: "dgCTLoc"+d ,type:'alert'});
		}
	});
	return result;
}
function loadTemplateData(locId)
{
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLTemplateDataSet",
			//"Method":"GetTemplateDataByLocID",
			"Method":"GetTemplateData",
			"p1":locId
		},
		success : function(d) {

			$("#tgTemplateSet").treegrid("loadData",d.data);
			$("#tgTemplateSet").treegrid("expandAll");
			
		},
		error : function(d) { 
			$.messager.popover({msg: "初始化模板目录："+d ,type:'alert'});
		}
	});	
	
}


function loadDgData(id,data)
{
	$("#"+id).datagrid("loadData",data)

}

//鼠标放在上面显示全名
function show(val,row){
    if (val){
        return '<span title="' + val + '">' + val + '</span>';
    } else {
        return val;
    }
}