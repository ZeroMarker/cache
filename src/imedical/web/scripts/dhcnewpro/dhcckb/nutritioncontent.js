///Author:    qiaoqingao
$(function(){ 

	initCombobox();

	initTable();
	
	initMethod();
	
});

/// 初始化combobox
function initCombobox(){
	$HUI.combobox('#arc',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionContent&MethodName=listArc" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	
	$HUI.combobox('#nutType',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionFormula&MethodName=listNutType" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       $('#nutTypeUom').text(option.uom);
	    }	
	})
	
	$HUI.combobox('#inArc',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionContent&MethodName=listArc" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       loadTable();
	    }	
	})
	
	$HUI.combobox('#inNutType',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionFormula&MethodName=listNutType" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			loadTable();
	    }	
	})	
}

function initTable(){
	
	
	var columns=[[
		{field:'id',title:'id',width:60,hidden:true},
		{field:'arc',title:'医嘱项',width:420},
		{field:'nutType',title:'营养成分',width:120},
		{field:'doseContent',title:'含量描述',width:420,formatter:function(index,row){
			return '每<span style="color:red">'+row.arcDose+'ml</span>含有<span style="color:blue">'+row.nutDose+row.nutTypeUom+'</span>';
		}},
		{field:'flag',title:'是否可用',align:'center',width:70,formatter:flagFormat}
	]]
	
	
	$HUI.datagrid('#datagrid',{
		title:'药品营养维护',
		headerCls:'panel-header-gray',
		columns:columns,
		border:true,
		toolbar:'#toolbar',
	    rownumbers:true,
	    method:'get',
	    fitColumns:false,
	    singleSelect:true,
	    pagination:true,
	    nowrap: false,
	    onDblClickRow:onClickRow, 
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionContent&MethodName=list'
	})
}

///绑定方法
function initMethod(){
	$('#code').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });
    $('#desc').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });		
}

///是否下拉
function flagFormat(value,row,index){
	if (value=='Y') return '是';
	return '否';
}


function addRow(){
	//commonAddRow({'datagrid':'#datagrid',value:{'id':'','code':'','desc':'','flag':'Y'}})
}
//双击编辑
function onClickRow(index,row){
	//editIndex == undefined?'':editComboFun(editIndex,row,'#datagrid');
	//CommonRowClick(index,row,'#datagrid');
}

function editComboFun(index,row,idPress){
	//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
	var ed = $(idPress).datagrid('getEditor', {index:index,field:'unit'});
	var unitDesc = $(ed.target).combobox('getText');
	$(idPress).datagrid('getRows')[index]['unitDesc'] = unitDesc;
	return;	
}

function save(){
	var id=$('#id').val();
	var arcDr=$HUI.combobox('#arc').getValue();
	var nutTypeDr=$HUI.combobox('#nutType').getValue();
	var arcDose=$('#arcDose').val();
	var nutDose=$('#nutDose').val();
	
	if(!arcDr){
		$.messager.alert('提示','医嘱项必填!','info');
		return;	
	}
	if(!nutTypeDr){
		$.messager.alert('提示','医嘱项必填!','info');
		return;	
	}
	if(!arcDose){
		$.messager.alert('提示','剂量必填!','info');
		return;	
	}
	if(!nutDose){
		$.messager.alert('提示','含量必填!','info');
		return;	
	}
	var flag = $HUI.checkbox('#flag').getValue()?'Y':'N';
	var params=id+'^'+arcDr+'^'+nutTypeDr+'^'+arcDose+'^'+nutDose+'^'+flag;
	
	$cm({
		ClassName:"web.DHCCKBNutritionContent",
		MethodName:"save",
		params:params,
		dataType:'text'
	},function(ret){
		if(ret==='0'){
			$.messager.alert('提示','成功!','info');
			$HUI.window('#addWin').close();
			loadTable();
		}else{
			$.messager.alert('提示','失败!'+ret,'error');
		}
	});
}

function delet(){
	if ($('#datagrid').datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除','info');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagrid').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionContent','delete',{'id':row.id},function(data){ 
				loadTable();
			})
	    }    
	}); 
}

///刷新table
function loadTable(){
	var inArc=$HUI.combobox('#inArc').getValue();
	var inNutType=$HUI.combobox('#inNutType').getValue();
	var params=inArc+'^'+inNutType;
	$HUI.datagrid('#datagrid').load({
		params:params
	})	
}

function op(model){
	
	if(model=='add'){
		clearWin();	
	}
	
	if(model=='update'){
		var rowData=$HUI.datagrid('#datagrid').getSelected();
		if(!rowData){
			$.messager.alert('提示','请选择一条数据!','info'); 
			return;	
		}
		$('#id').val(rowData.id);
		$HUI.combobox('#arc').setValue(rowData.arcDr);
		$HUI.combobox('#nutType').setValue(rowData.nutTypeDr);
		$('#arcDose').val(rowData.arcDose);
		$('#nutDose').val(rowData.nutDose);
		//$('#arcUom').text(rowData.arcUom);
		$('#nutTypeUom').text(rowData.nutTypeUom);
		var isCheck=(rowData.flag==='Y'?true:false);
		$HUI.checkbox('#flag').setValue(isCheck);
	}
	
	$HUI.window('#addWin').open();
	return;
}

function clearWin(){
	$('#id').val('');
	$HUI.combobox('#arc').setValue('');
	$HUI.combobox('#nutType').setValue('');
	$('#arcDose').val('');
	$('#nutDose').val('');
	//$('#arcUom').text(rowData.arcUom);
	$('#nutTypeUom').text('');
	$HUI.checkbox('#flag').setValue(true);
	return;
}

function cancel(){
	$HUI.window('#addWin').close();
	return;
}