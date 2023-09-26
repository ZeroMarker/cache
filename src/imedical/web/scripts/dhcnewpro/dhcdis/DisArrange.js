
$(function(){ 

	$('#taskid').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=TaskId",    
    	valueField:'id',    
    	textField:'text'   
	});
	$('#recLoc').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text'   
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
});




function save(){
	if(!$('#detail').form('validate')){
		return;	
	}
	$("#datagrid").datagrid('acceptChanges');
	arr=new Array();
	tableData=$("#datagrid").datagrid('getRows');
	for(var i=0;i<tableData.length;i++){
		subObj=new Object()
		subObj.REQItem=tableData[i].itmid;
		subObj.REQExeLocDr=tableData[i].locid;
		subObj.REQQty=tableData[i].qty;
		subObj.DPUserDr=tableData[i].userid;
		arr.push( jQuery.toJSON(subObj))
	}
	subStr=arr.join("^");
	mainObj=new Object();
	mainObj.REQCreateUser=LgUserID   
	mainObj.REQLocDr=LgCtLocID;		
	mainObj.REQRecLocDr=$("#recLoc").combobox('getValue'); 
	mainObj.REQRemarks=$("#remark").val();  
	mainObj.REQExeDate=$('#exeDate').datetimebox('getValue').split(" ")[0] 
	mainObj.REQExeTime=$('#exeDate').datetimebox('getValue').split(" ")[1]      
	mainObj.REQCreateDate=(new Date()).Format("yyyy-MM-dd")            
	mainObj.REQCreateTime=(new Date()).Format("hh:mm:ss")              
	mainStr=JSON.stringify(mainObj);
	runClassMethod("web.DHCDISArrange",
					"save",
					{'mainStr':mainStr,'subStr':subStr},
					function(data){
						if(data==0){$.messager.alert('提示','保存成功');}
						else{$.messager.alert('提示','保存失败'+data)} 
					},"json")	 	
}

function deleteRow(){
	select=$('#datagrid').datagrid('getSelected');
	if(null==select){
		$.messager.alert('提示','请选择');
		return;
	}
	$.messager.confirm('确认', '确认要删除吗?', function(r){
	if (r){
		index=$('#datagrid').datagrid('getRowIndex',select)
		$('#datagrid').datagrid('deleteRow',index)
		}
	});
	
}

function addRow(){
	if($('#recLoc').combobox('getValue')==""){
		$.messager.alert("提示","请先选择接受科室")
		return;	
	}
	commonAddRow({datagrid:'#datagrid',value:{qty:1}})	
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function fillValue(rowIndex, rowData){

	ed=$('#datagrid').datagrid('getEditor', {index:editIndex,field:'loc'})
	$(ed.target).combogrid('setValue',rowData.locdesc);
	$('#datagrid').datagrid('getRows')[editIndex]['itmid']=rowData.id
	$('#datagrid').datagrid('getRows')[editIndex]['locid']=rowData.loc
}

function fillLocValue(rowIndex, rowData){
	$('#datagrid').datagrid('getRows')[editIndex]['locid']=rowData.id
}

function fillUserValue(rowIndex, rowData){
	$('#datagrid').datagrid('getRows')[editIndex]['userid']=rowData.id
}

function clearForm(){
	$('#detail').form('clear');
	$('#datagrid').datagrid('loadData', { total: 0, rows: [] });
}