$(function(){
	InitCaseList();
	loadCaseName();
	
	$HUI.radio("[name='readCaseByRole']",{
        onChecked:function(e,value){
            loadCaseName();
        }
    });
	
	$("#btSearch").click(function(){
		loadCaseName();
	});
	$("#btRead").click(function(){
		readQueryCase();
	});	
	$("#btDelete").click(function(){
		deleteQueryCase();
	});	
});﻿

function InitCaseList()
{
	$('#caseList').datagrid({
		pagination:false,
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:'../web.eprajax.query.getquerycase.cls',
		idField:'ID', 
		rownumbers:true,
		singleSelect:true,
		fit:true,
		columns:[[  
			{field:'ID',title:'ID',width:80,hidden: true},
			{field:'Desc',title:'方案名称',width:400},
			{field:'SaveUserID',title:'SaveUserID',width:80,hidden: true},
			{field:'SaveUserName',title:'保存者',width:160}
		]],
		onLoadSuccess:function(data){
			$('#caseList').datagrid('clearSelections');
		}
	});
}

function loadCaseName()
{
	var caseName = $('#caseName').val();
	var checkedRadioJObj = $("input[name='readCaseByRole']:checked");
	var queryType = checkedRadioJObj.val();
	if (queryType=='readCaseByUserID')
	{
		var QueryAreaStr = "userID" + "^" + parent.userID;
	}
	else if (queryType=='readCaseByCtLocID')
	{
		var QueryAreaStr = "ctLocID" + "^" + parent.ctLocID;
	}
	else if (queryType=='readCaseByGroupID')
	{
		var QueryAreaStr = "groupID" + "^" + parent.ssGroupID;
	}
	$('#caseList').datagrid('load', {    
	    action: 'getCaseName',
	    QueryAreaStr: QueryAreaStr,
	    desc: caseName
	});
}

function readQueryCase()
{
	var selection = $('#caseList').datagrid('getSelected');
	if (selection !== null)
	{
		var caseID = selection.ID;
		var caseDesc = selection.Desc;
		var SaveUserID = selection.SaveUserID;
		var SaveUserName = selection.SaveUserName;
		
		parent.tempStore = 
		{
			ID:caseID,
			Desc:caseDesc,
			SaveUserID:SaveUserID,
			SaveUserName:SaveUserName
		};// 记录当前添加的方案，为“修改方案”提供信息
		var readConditionFlag = "N";
		jQuery.ajax({
			type: "post",
			url: "../web.eprajax.query.getquerycase.cls",
			async: false,
			data: {
				action: 'getCaseConditionInfo',
				CaseID: caseID
			},
			success: function(d) {
				readConditionFlag = parent.readAdvacedCondition(d);
			},
			error : function(d) { $.messager.alert("简单提示", "error", 'info');}
		});
		if (readConditionFlag == "N")
		{
			return;
		}
		var readResultColsFlag = "N";
		jQuery.ajax({
			type: "post",
			url: "../web.eprajax.query.getquerycase.cls",
			async: false,
			data: {
				action: 'getCaseResultColsInfo',
				CaseID: caseID
			},
			success: function(d) {
				parent.readCaseResultCols(d);
				readResultColsFlag = "Y";
			},
			error : function(d) { $.messager.alert("简单提示", "error", 'info');}
		});
		if ((readConditionFlag == "Y")&&(readResultColsFlag == "Y"))
		{
			closeWindow();
		}
	}
	else if (selection == null)
	{
		$.messager.alert("提示信息", "请选择要读取的方案！","alert");
		return;
	}
}

function deleteQueryCase()
{
	var selection = $('#caseList').datagrid('getSelected');
	if (selection !== null)
	{
		var SaveUserID = selection.SaveUserID;
		if (parent.userID == SaveUserID)
		{
			$.messager.confirm("删除", "确定要删除这条方案?", function (r) {
				if (r) {
					try{
						var DeleteCaseID = selection.ID;
						jQuery.ajax({
							type: "post",
							url: "../web.eprajax.query.getquerycase.cls",
							async: false,
							data: {
								action: 'DeleteCase',
								DeleteCaseID: DeleteCaseID
							},
							success: function(d) {
								if (d == 0)
								{
									$.messager.alert("提示信息", "删除成功！","alert");
									// 删除成功后重新加载方案列表
									loadCaseName();
								}
							},
							error : function(d) { $.messager.alert("简单提示", "error", 'info');}
						});	
						
					}catch(err){
						Ext.MessageBox.alert('报错', '删除操作出现错误！', Ext.MessageBox.ERROR);
					}
				}
			});
		}
		else
		{
			$.messager.alert("提示信息", "您不是该方案的保存者，不能删除此方案！","alert");
			return;
		}
	}
	else if (selection == null)
	{
		$.messager.alert("提示信息", "请选择要删除的方案！","alert");
		return;
	}
}

function closeWindow()
{
	parent.closeDialog(dialogId);	
}