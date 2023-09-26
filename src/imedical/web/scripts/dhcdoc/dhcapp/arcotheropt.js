var editIndex = undefined;
var itmmastid =getParam("itmmastid");  ///医嘱项ID
 var Info={};
$(function(){
	
	$.extend($.fn.datagrid.methods, {
		 editCell: function(jq,param){
			 return jq.each(function(){
			 opts = $(this).datagrid('options');
			 var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			 for(var i=0; i<fields.length; i++){
				 var col = $(this).datagrid('getColumnOption', fields[i]);
				 col.editor1 = col.editor;
				 if (fields[i] != param.field){
					 col.editor = null;
				 }
			 }
			 $(this).datagrid('beginEdit', param.index);
			 	for(var i=0; i<fields.length; i++){
			 		var col = $(this).datagrid('getColumnOption', fields[i]);
			 		col.editor = col.editor1;
			 	}
			 });
		 }
	 });
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
	
	
	var HospID=window.parent.$HUI.combogrid('#_HospList').getValue()
	$('#datagrid').datagrid({
		url:LINK_CSP+'?ClassName=web.DHCAPPArcLinkOpt&MethodName=list&itmmastid='+itmmastid+'&HospID='+HospID
	});
})





function endEditing(){
	if (editIndex == undefined){return true;};
	if ($('#datagrid').datagrid('validateRow', editIndex)){
		$('#datagrid').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/// 插入新行
function add(){
	
	if(itmmastid==""){
		$.messager.alert('提示','请选择医嘱项分类')   //lvpeng 2016-7-14
		return;	
	}
	if(endEditing()){
		$("#datagrid").datagrid('insertRow', {
			index: 0, 
			row: {}
		});
		$("#datagrid").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
		editIndex=0;
	}
}

/// 删除选中行
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {  //lvpeng 2016-7-14
		$.messager.alert('提示','请选一个删除');
		return;
	}
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcLinkOpt","remove",{'Id':rowsData.ID},function(jsonString){
					$('#datagrid').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

function onDblClickRow(index, rowData){
	 if(endEditing()){
		 $("#datagrid").datagrid('beginEdit', index);
		 editIndex = index;
	 }
}



function fillValue(rowIndex, rowData){
	var selected = $('#datagrid').datagrid('getData').rows[editIndex];
	runClassMethod("web.DHCAPPArcLinkOpt","Save",{"ALOArcDr":itmmastid,"ALOOptDr":rowData.ID,"ID":selected.ID},function(jsonString){
		if(jsonString==0){
			$.messager.alert('提示','操作成功');
		}else if(jsonString==-10){
			$.messager.alert('提示','该项目已存在不能添加');
		}
		$('#datagrid').datagrid('endEdit', editIndex);
		editIndex = undefined;
		$('#datagrid').datagrid('reload'); //重新加载
	})  
}