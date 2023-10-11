var categoryId = "";
$(function(){
	$('#cbtreeCategory').combotree({  
	    url: '../web.eprajax.query.basicsetting.cls?Action=getCategoryTree&node=RT0&frameType=HISUI',  
	    width: '610',
	    autoNodeHeight:true,
	    lines:true,
	    onSelect:function(record){
		    categoryId = record.id;
		    setCategoryItems(record.id);
	    }
	});
	$('#dgItems').datagrid({
		url:'../web.eprajax.query.basicsetting.cls?frameType=HISUI',
		fitColumns:true,
		pagination:true,
		pageSize:10,
		fit:true,
		data:[], 
		toolbar:$("#ttb"),
	    columns:[[
	    	{field:'ck',checkbox:true},
	    	{field:'Code',hidden:true},
	    	{field:'Title',title:'检索项目',width:$(this).width() * 0.2}
	    ]] 
	});
	
	$("#btAdd").click(function(){
		getCategoryItems();
	});	
	$("#btCancel").click(function(){
		closeWindow();
		window.returnValue = "";
	});
	$("#btAddItem").click(function(){
		var content = "<iframe id='editCondition' name='editCondition' scrolling='auto' frameborder='0' src='epr.query.hisui.operationitem.csp' style='height:100%;width:100%;display:block;'></iframe>"
		parent.createModalDialog("dialogEditConditionDiv","编辑条件","1300","700","editCondition",content);
	});
	$('#ss').searchbox({
		width:'600',
		prompt:emrTrans('从下方列表中检索查询项目'),
		searcher : function (value) {
			if (categoryId=="")
			{
				$.messager.alert("提示信息", "请选择检索类别！")
			}
			else
			{
				$('#dgItems').datagrid('load', {
			        Action: 'getCategoryItems',
			        CategoryID: categoryId,
			        FilterValue:value
			    });
			}

		}
	}); 
},0);﻿

function setCategoryItems(categoryId)
{
	$('#dgItems').datagrid('load', {
        Action: 'getCategoryItems',
        CategoryID: categoryId
    });
}

function getCategoryItems()
{
	var arrItems = new Array()
	var tree = $('#cbtreeCategory').combotree('tree');	
	var node = tree.tree('getSelected');
	var type = node.rcode	
	var checkedItems = $('#dgItems').datagrid('getChecked');
	var containLoc = "0";
	$.each(checkedItems, function(index, item) {
		if (canViewAllLoc == "N")
		{
			if ((item.Title.indexOf("科室") == -1)&&(item.Title.indexOf("病区") == -1))
			{
				arrItems.push({"title":item.Title,"code":item.Code,"cateType":type,"cateName":node.text});
			}
			else
			{
				containLoc = "1";
			}
		}
		else
		{
			arrItems.push({"title":item.Title,"code":item.Code,"cateType":type,"cateName":node.text});
		}
	});
	if (action == "result")
	{
		parent.setResultColums(arrItems);
	}
	else if (action == "condition")
	{
		parent.addAdvacedCondition(arrItems);
	}
	if (containLoc == "1")
	{
		parent.$.messager.alert("提示信息", "当前权限只能查询本科室本病区，不能添加科室病区条件！","alert");
	}
	closeWindow();
}

function closeWindow()
{
	parent.closeDialog(dialogId);
}
