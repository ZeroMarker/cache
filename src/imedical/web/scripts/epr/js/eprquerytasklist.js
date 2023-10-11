﻿$(function(){
	var girdParam = {
		"OutputType":"String",
		"Class":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
		"Method":"SelectTaskList",
		"p1":userId
	};
	$('#taskListRecord').datagrid({
		title:"任务列表",
		headerCls:'panel-header-gray',
		pagination:false,
		rownumbers:true,
		fit:true,
		url: '../EMRservice.Ajax.common.cls',
		queryParams:girdParam,
	    columns:[[
	    		//{field:'GUID',title:'GUID',hidden:true},
	    		{field:'TaskName',title:'任务名称',width:200},
	    		{field:'Conditions',title:'条件',width:200,formatter: function (value) {
		                return "<span title='" + value + "'>" + value + "</span>";
	            	}
	    		},
				{field:'StartTime',title:'任务开始时间',width:200},
				{field:'EndTime',title:'任务结束时间',width:200},
				{field:'TaskStatus',title:'任务状态',width:120},
				{field:'TaskResult',title:'任务结果',width:100},
				{field:'UserName',title:'执行人',width:100},
				{field:'GUID',title:'操作',formatter: function (value) {
						var guidStatus = value.split("^");
						if (guidStatus[1] == "1")
						{
							return "<img class='x-btn-text-icon' src='../scripts/epr/Pics/btnClose.gif' onclick='deleteRecord("+value+")'></img>";
						}
	            	}
	    		}
		]],
	});
})

//查看查询结果明细
function viewResult(GUID)
{
	var returnValue = window.showModalDialog("dhc.epr.query.tasklistditails.csp?GUID="+GUID+"&UserName="+userName+"&UserID="+userId,"","dialogHeight:800px;dialogWidth:1500px;resizable:no;status:no");
	exportCallBack(returnValue,GUID);
}

//关闭查看结果界面前，如果没有进行导出结果，询问是否导出
function exportCallBack(returnValue,GUID)
{
	if (returnValue.dataLength == "0")	//没有数据，关闭后直接删除记录
	{
		deleteRecord(GUID);
		return;
	}
	if (returnValue.status == "-1")
	{
		var text = '关闭页面后将删除本条查询记录，是否导出结果';
		if (window.confirm(text))
		{
			jQuery.ajax({
				type: "post",
				dataType: "text",
				url: "../EMRservice.Ajax.common.cls",
				async: true,
				data: {
					"OutputType":"String",
					"Class":"EMRservice.Tools.ExportToExcel",
					"Method":"toExcelByEMR",
					"p1":userName+"-"+returnValue.conditionsDesc,
					"p2":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
					"p3":"ExportTaskResultDetails",
					"p4":GUID
				},
				success: function(d) {
						var flag = d.substring(0,1);
						if(flag=="w"){
							location.href=d;
							deleteRecord(GUID);
						}else
						{
							alert("导出失败！");
						}
				},
				error : function(d) { 
					alert("导出EXCEL错误");
				}
			})
		}
		else
		{
			deleteRecord(GUID);
		}
	}
	else if (returnValue.status == "0")
	{
		alert("导出失败！");
	}
	else	//导出成功
	{
		deleteRecord(GUID);
	}
}

//关闭页面后删除记录
function deleteRecord(GUID)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
			"Method":"DeleteByGUID",
			"p1":GUID
		},
		success: function(d) {
			$('#taskListRecord').datagrid("reload");
		}
	})
}