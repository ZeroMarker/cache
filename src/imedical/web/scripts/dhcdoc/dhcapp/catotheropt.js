var cat =getParam("cat");  ///医嘱项ID
window.onload=function(){
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
		if(cat==""||cat==null){		//lvpeng 2016-07-15
			//alert("所有");
			$('#datagrid').datagrid({
				url:''
			});
		}else{
			//alert("部分");
			$('#datagrid').datagrid({
				url:'dhcapp.broker.csp?ClassName=web.DHCAPPCatLinkOpt&MethodName=list',
				queryParams:{ALOOptParRef:cat}
			});
		}   //lvpeng 2016-07-15
}


//插入新行
function addRow(){
	if(cat==""){
		$.messager.alert('提示','请选择检查分类')
		return;	
	}
	commonAddRow({'datagrid':'#datagrid',value:{'ALOOptParRef':cat}})
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

//保存新行
function save(){
	saveByDataGrid("web.DHCAPPCatLinkOpt","save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==1){	
			    $.messager.alert('提示','该录入无效，请下拉选择!')
			    $("#datagrid").datagrid('reload')
			}else if(data==2){    ///sufan  2017-02-24
				$.messager.alert('提示','数据重复:'+data);
				$("#datagrid").datagrid('reload');
				}else{
				$.messager.alert('提示','保存失败:'+data)
			}
		});	
}
function cancel(){
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPCatLinkOpt","remove",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
	});	
}
function fillValue(rowIndex, rowData){
	$('#datagrid').datagrid('getRows')[editIndex]['ALOOptDr']=rowData.ID
}