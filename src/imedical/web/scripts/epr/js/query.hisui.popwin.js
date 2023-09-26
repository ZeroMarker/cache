
$(function(){
	$('#cbtreeCategory').combotree({  
	    url: '../web.eprajax.query.basicsetting.cls?Action=getCategoryTree&node=RT0&frameType=HISUI',  
	    width: '600',
	    autoNodeHeight:true,
	    lines:true,
	    onSelect:function(record){
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
	$.each(checkedItems, function(index, item) {
		arrItems.push({"title":item.Title,"code":item.Code,"cateType":type,"cateName":node.text});
	});
	if (action == "result")
	{
		parent.setResultColums(arrItems);
	}
	else if (action == "condition")
	{
		parent.addAdvacedCondition(arrItems);
	}
	closeWindow();
}

function closeWindow()
{
	parent.closeDialog(dialogId);
}