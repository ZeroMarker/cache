var TempData = "";
var GridData = "";
$(function(){
	init();
});

function init()
{
	initCombobox();
}

function initCombobox()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetEMRTemplateGroup",
			"p1":gl.userLocId
		},
		success: function(d) {
			if(d != "") setEMRTemplateGroup(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("GetTemplateSet error");
		}
	});
}

function setEMRTemplateGroup(data)
{
	$('#templateRecord').combobox({
		valueField:'TemplateGroupCode',                        
		textField:'TemplateGroupName',
		width:200,
		panelHeight:'auto',
		data:data,
		onLoadSuccess:function()
		{
			if ($('#templateRecord').combobox('getValue') === "")
			{
				$('#templateRecord').combobox('select',data[0]["TemplateGroupCode"]);
			}
		},
		onSelect:function(record)
		{
			loadTemplate(record.TemplateGroupCode);
		}
	});
}

function loadTemplate(groupCode)
{
	var templateData = getTemplateData(groupCode);
	var recordData = getRecordData(groupCode);

	temparam = [];
	if (templateData != "") setListTemplate(templateData);
	if (recordData == "")
	{
		recordData = {"total":0,"rows":[]};
	}
	setListRecord(recordData);
	TempData = $('#listtemplate').datagrid('getData').rows;
	GridData = $('#gridshow').datagrid('getData').rows;
}
//获得模板
function getTemplateData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetTempCateJsonByGroupCode",
			"p1":gl.episodeId,
			"p2":groupCode
		},
		success: function(d) {
			if(d != "") data = eval("["+d+"]");
		},
		error : function(d) { 
			alert("GetTempCateJsonByGroupCode error");
		}
	});
	return data;
}

//获得实例数据
function getRecordData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetInstanceJsonByGroupCode",
			"p1":gl.episodeId,
			"p2":groupCode,
			"p3":"Save"
		},
		success: function(d) {
			if(d != ""){
				data = eval("["+d+"]");
			}
		},
		error : function(d) { 
			alert("GetInstanceJsonByGroupCode error");
		}
	});
	return data;
}
//加载列表模板数据
function setListTemplate(data)
{
	$('#listtemplate').datagrid({
	    iconCls:'icon-paper',
	    fitColumns:true, 
	    title:"新建模板列表",
	    headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    data:data,
	    singleSelect:false,
	    idField:'id',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
            {field:'ck',checkbox:true},
            {field:'id',title:'id',hidden:true},
            {field:'text',title:'名称',width:200,sortable:true},
            {field:'quotation',hidden:true},
            {field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
            {field:'categoryId',hidden:true},{field:'templateId',hidden:true},
            {field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
            {field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true},
            {field:'groupCode',hidden:true}
        ]],
        onCheck:function(rowIndex,rowData){
            var length = temparam.length;
            var temp = {
                "id":"",
                "text":rowData.text,
                "pluginType":rowData.documentType,
                "chartItemType":rowData.chartItemType,
                "characteristic":rowData.characteristic,
                "emrDocId":rowData.id,
                "templateId":rowData.templateId,
                "isLeadframe":rowData.isLeadframe,
                "isMutex":rowData.isMutex,
                "categoryId":rowData.categoryId,
                "actionType":"CREATE",
                "status":"NORMAL",
                "closable":true,
                "flag":"List",
                "args":{
                    "spreading":{"action":"GroupCreation","groupCode":rowData.groupCode}
                }
            };
            if (rowData.userTemplateCode){ temp.userTemplateCode = rowData.userTemplateCode}
            if (rowData.titleCode){ temp.titleCode = rowData.titleCode}
            temparam.splice(length,0,temp);
        },
        onUncheck:function(rowIndex,rowData){
            $.each(temparam, function(index,item){
                if (item.emrDocId == rowData.id){
                    temparam.splice(index,1);
                    return  false;
                }
            });
        },
        onCheckAll:function(rows){
            temparam = [];
            $.each(rows,function(idx,val){
                temparam[idx] ={
                    "id":"",
                    "text":val.text,
                    "pluginType":val.documentType,
                    "chartItemType":val.chartItemType,
                    "characteristic":val.characteristic,
                    "emrDocId":val.id,
                    "templateId":val.templateId,
                    "isLeadframe":val.isLeadframe,
                    "isMutex":val.isMutex,
                    "categoryId":val.categoryId,
                    "actionType":"CREATE",
                    "status":"NORMAL",
                    "closable":true,
                    "flag":"List",
                    "args":{
                        "spreading":{"action":"GroupCreation","groupCode":val.groupCode}
                    }
                };
                if (val.userTemplateCode){ temparam[idx].userTemplateCode = val.userTemplateCode}
                if (val.titleCode){ temparam[idx].titleCode = val.titleCode}
            });
        },
        onUncheckAll:function(rows){
            temparam = [];
        },
        onLoadSuccess:function(data){
            $('#listtemplate').datagrid('checkAll');
        }
    });
}
//新建操作
function CreateOperate(val,row,index)
{
	var span = '<a id="createoperate" onclick="createDocument('+"'"+row+"'"+')">'+emrTrans("新建")+'</a>';  
	return span;
}
//加载列表实例数据
function setListRecord(data)
{
	$('#gridshow').datagrid({
	    iconCls:'icon-paper',
	    title:"表格病历列表",
	    headerCls:'panel-header-gray',
	    fitColumns:true, 
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    data:data,
	    singleSelect:true,
	    idField:'id',
	    sortName:'text',
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
			{field:'status',title:'医生签名状态',width:180,formatter:StatusOperate,styler:formatColor,sortable:true},
	        {field:'text',title:'名称',width:300,sortable:true},
			{field:'happendate',title:'发生日期',width:200,sortable:true},
			{field:'happentime',title:'发生时间',width:200,sortable:true},
			{field:'summary',title:'备注',width:300,resizable:true},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
			{field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
			{field:'isMutex',hidden:true},{field:'categoryId',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true},
			{field:'patientsign',title:'患者待签',width:130,formatter: PatientStatusOperate,sortable:true}
		]],
		//点击表格病历打开
		onClickRow:function(index,row)
		{
			var groupCode = $('#templateRecord').combobox('getValue'); 
			var tabParam ={
				"id":row.id,
				"text":row.text,
				"pluginType":row.documentType,
				"chartItemType":row.chartItemType,
				"characteristic":row.characteristic,
				"emrDocId":row.emrDocId,
				"templateId":row.templateId,
				"isLeadframe":row.isLeadframe,
				"isMutex":row.isMutex,
				"categoryId":row.categoryId,
				"actionType":"LOAD",
				"status":"NORMAL",
		    	"closable":true,
		    	"flag":"List",
		    	"args":{
				"spreading":{"action":"GroupCreation","groupCode":groupCode}
			}

			};
			parent.parent.openGroupRecord([tabParam]);
			//自动记录病例操作日志
			openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
		}
	});
}
//签名状态设置
function StatusOperate(val,row,index)
{
	if(row.doctorwait == "1")
	{
		var span = '<a>'+emrTrans("待签")+'</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}
//设置病历状态颜色
function formatColor(val,row)
{
	if (row.doctorwait == "1")
	{
		return 'color:#FFFFFF;background-color:#FB9A42;';
	}	
}

function PatientStatusOperate(val,row,index)
{
	if(row.patientwait == "1")
	{
		var span = '<a>'+emrTrans("待签")+'</a>';  
		return span;
	}
}

///过滤页面
function searchSelect(value)
{
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	
	$('#listtemplate').hide();
	$('#gridshow').hide();
	var newTemp = [];
	for(var i=0;i<TempData.length;i++){
	if(value != ""){
		if((TempData[i].text.indexOf(value)!=-1)||(TempData[i].JaneSpell.indexOf(value)!=-1)||(TempData[i].FullFight.indexOf(value)!=-1))
			{
				newTemp.push(TempData[i]);
			}
		}else if(value == ""){
			newTemp.push(TempData[i]);
		}
	}
	$('#listtemplate').datagrid("loadData",newTemp).show();
	var newGrid = [];
	for(var i=0;i<GridData.length;i++){
		if(value != ""){
			if((GridData[i].text.indexOf(value)!=-1)||(GridData[i].JaneSpell.indexOf(value)!=-1)||(GridData[i].FullFight.indexOf(value)!=-1))
			{
				newGrid.push(GridData[i]);
			}
		}else if(value == ""){
			newGrid.push(GridData[i]);
		}
	}
	$('#gridshow').datagrid("loadData",newGrid).show();
}


//从模板组新建
function createTemplateGroup()
{
	if (temparam.length == 0) alert("请配置模板组数据");
	//创建病历
	parent.parent.openGroupRecord(temparam);
	CreateGroupDocumentLog(temparam,"EMR.Nav.RecordNav.CreateGroup");

}

//从模板新建
function createDocument(obj)
{
	var obj = $(obj).closest("li");
    var tabParam = {
	    "id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"CREATE",
		"status":"NORMAL",
		"flag":"List",
		"closable":true,
		"characteristic":obj.attr("characteristic")
	};
	///创建病历
	parent.parent.operateRecord([tabParam]);
	
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
}

//刷新
function refresh()
{
    window.location.reload();
}
