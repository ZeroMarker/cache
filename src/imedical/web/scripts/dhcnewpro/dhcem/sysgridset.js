// 名称:Grid设置管理
// 编写日期:2016-11-14
///CreatDate:  2016-09-08
///Author:    zhanghailong 
var SAId=""//全局变量:左表id
var editRow=""//全局变量：子表双击编辑index 
$(function(){
	$("#date").datagrid({
		onSelect:function (rowIndex,rowDate){
			$("#datagrid1").datagrid("reload",{
				"SGSGridID":rowDate.SGSGridID,
				"SGSCspName":rowDate.SGSCspName,
				"SGSSaveFor":rowDate.SGSSaveFor,
				"SGSReference":rowDate.SGSReference	
				})
			}
		})
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
});	

///新增行 (左表) 
function addRowSys(){
	commonAddRow({'datagrid':'#date'})
}

///保存 (左表) 
function saveSys(){
	saveByDataGrid("web.DHCEmSysGridSet","SaveSys","#date",function(data){
			if(data==0){
				$.messager.alert("提示","保存成功!");
				$("#date").datagrid('load');
				$("#datagrid1").datagrid('load');
			}else if(data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#date").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});		
}

///删除 (左表) 
function cancelSys(){
	if ($("#date").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	     var rowDate =$("#date").datagrid('getSelected');   //获取选中行的数据
		 runClassMethod("web.DHCEmSysGridSet","Delete",{
			    "SGSGridID":rowDate.SGSGridID,
				"SGSCspName":rowDate.SGSCspName,
				"SGSSaveFor":rowDate.SGSSaveFor,
				"SGSReference":rowDate.SGSReference	},function(data){ 
				if(data==0){
				     $.messager.alert("提示","删除成功!");
			      }else {	
				     $.messager.alert('提示','删除失败:'+data)
			      }	
		 $('#date').datagrid('load');
		 $('#datagrid1').datagrid('load');
		  })
    }    
}); 
}

///双击编辑 (右表)
function onClickRowSysItm(index,row){
    editRow=index //add hxy 2016-08-06
	CommonRowClick(index,row,"#datagrid1");
}

///新增行 (右表) 
function addRowSysItm(){
	 if ($("#date").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择左表');
		return;
	 }
	var row =$("#date").datagrid('getSelected');
	commonAddRow({'datagrid':'#datagrid1'})
	var SGSGridID = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSGridID'});
	var SGSCspName = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSCspName'});
	var SGSSaveFor = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSSaveFor'});
	var SGSReference = $("#datagrid1").datagrid('getEditor', {index:"0",field:'SGSReference'});
	$(SGSGridID.target).val(row.SGSGridID); 
	$(SGSCspName.target).val(row.SGSCspName); 
	$(SGSSaveFor.target).val(row.SGSSaveFor); 
	$(SGSReference.target).val(row.SGSReference); 
}

///保存 (右表)
function save(){
	saveByDataGrid("web.DHCEmSysGridSet","SaveSys","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("提示","保存成功!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","不能重复保存!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
			}
		});			
}
