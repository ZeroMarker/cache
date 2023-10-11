$(function(){
	initData();
	initButton();
})

function initButton()
{
	//关联
	$("#operBatchContact").click(function () {
		returnValue = "1";
		setContact();
	});
	//移除
	$("#operRemove").click(function () {
		returnValue = "1";
		deleteContact();
	});
}

//初始化数据
function initData()
{
	initNoLinkGrid();
	initOperations();
	initRecordGrid();
	getNoLinkGrid();
}

//初始化手术信息
function initOperations()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.Event.BLEvents",
            "Method":"GetData",
            "p1":"Operation",
            "p2":gl.episodeId
        },
		success: function(d){
			if(d !== "")
			{
				data = eval("["+d+"]");
				for (var i=0;i<data.length;i++)
				{
					data[i].text = data[i].OperDate+" "+data[i].OperTime+" | "+data[i].OperDesc+" | "+data[i].OperDocName+" | "+data[i].OperAssistFirstDesc+" | "+data[i].OperAssistSecondDesc+data[i].OperPAStatus
				}
				$("#operations").combobox({
					valueField:"ID",
					textField:"text",
					data:data,
					filter: function (q, row) {
			            var opts = $(this).combobox('options');
			            return (row["text"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
			        },
			        onSelect:function(record){
				        getRecordGrid(record.ID)
					}
				});
			}
		},
		error: function(d) {alert("getAllTitles error");}
	})
}

//手术下实例
function initRecordGrid()
{
	$('#recordGrid').datagrid({
		iconCls:'icon-paper',
	    headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    fitColumns:true,
	    title:'病历表格',
	    fit:true,
	    toolbar:[],
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
	    	{field:'ck',checkbox:"true"},
			{field:'status',title:'医生签名状态',width:140,hidden:true},
	        {field:'text',title:'名称',width:200},
	        {field:'createdate',title:'创建日期',width:110},
			{field:'createtime',title:'创建时间',width:90},
			{field:'creator',title:'创建人',width:100},
			{field:'operator',title:'最后修改人',width:100,hidden:true},
		]]
	});
}

//获取手术下的实例
function getRecordGrid(eventID)
{
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceByCategoryEvent",
            "p1":gl.categoryId,
            "p2":gl.episodeId,
            "p3":"Operation",
            "p4":eventID,
            "p5":gl.sequence
        },
        success: function(d) {
            var data = eval("["+d+"]");
            $('#recordGrid').datagrid('loadData',data);
        },
        error : function(d) { 
            alert("getRecordGrid error");
        }
    });
}

//无关联病历
function initNoLinkGrid()
{
	$('#noLinkGrid').datagrid({
		iconCls:'icon-paper',
	    headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    fitColumns:true,
	    fit:true,
	    toolbar:[],
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
	    	{field:'ck',checkbox:"true"},
			{field:'status',title:'医生签名状态',width:140,hidden:true},
	        {field:'text',title:'名称',width:200},
	        {field:'createdate',title:'创建日期',width:110},
			{field:'createtime',title:'创建时间',width:90},
			{field:'creator',title:'创建人',width:100},
			{field:'operator',title:'最后修改人',width:100,hidden:true},
		]]
	});
}

//获取无关联实例
function getNoLinkGrid()
{
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceNoLinkEvent",
            "p1":gl.categoryId,
            "p2":gl.episodeId,
            "p3":"Operation"
        },
        success: function(d) {
            var data = eval("["+d+"]");
            $('#noLinkGrid').datagrid('loadData',data);
        },
        error : function(d) { 
            alert("getNoLinkGrid error");
        }
    });
}

//手术关联病历
function setContact()
{
	var eventId = $("#operations").combobox("getValue");
	if (eventId == "")
	{
		$.messager.alert('提示','请先选择手术信息', 'info');
		return;
	}
	var rows = $("#noLinkGrid").datagrid('getSelections');
	var instanceId = "";
	for(var i=0;i<rows.length;i++)
	{
		if (i == 0) instanceId = rows[i].id;
		else instanceId = instanceId + "^" +rows[i].id;
	}
	if (instanceId == "")
	{
		$.messager.alert('提示','请先勾选右侧病历信息', 'info');
		return;
	}
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.Event.BLOperation",
            "Method":"SetContactDocument",
            "p1":eventId,
            "p2":instanceId
        },
        success: function(d) {
	        if (d == "1")
	        {
		        getRecordGrid(eventId);
	            getNoLinkGrid();
	        }
	        else
	        {
		        $.messager.alert('提示','关联失败，请联系管理员', 'info');
		    }
        },
        error : function(d) { 
            alert("setContact error");
        }
    });
}

//手术移除病历
function deleteContact()
{
	var eventId = $("#operations").combobox("getValue");
	if (eventId == "")
	{
		$.messager.alert('提示','请先选择手术信息', 'info');
		return;
	}
	var rows = $("#recordGrid").datagrid('getSelections');
	var instanceId = "";
	for(var i=0;i<rows.length;i++)
	{
		if (i == 0) instanceId = rows[i].id;
		else instanceId = instanceId + "^" +rows[i].id;
	}
	if (instanceId == "")
	{
		$.messager.alert('提示','请先勾选左侧病历信息', 'info');
		return;
	}
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.Event.BLOperation",
            "Method":"DeleteContactDocument",
            "p1":instanceId,
            "p2":gl.userId
        },
        success: function(d) {
	        if (d == "1")
	        {
		        getRecordGrid(eventId);
	            getNoLinkGrid();
	        }
	        else
	        {
		        $.messager.alert('提示','移除失败，请联系管理员', 'info');
		    }
        },
        error : function(d) { 
            alert("deleteContact error");
        }
    });
}