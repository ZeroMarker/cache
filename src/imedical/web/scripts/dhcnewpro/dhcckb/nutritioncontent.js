///Author:    qiaoqingao
$(function(){ 

	initCombobox();

	initTable();
	
	initMethod();
	
});

/// ��ʼ��combobox
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
		{field:'arc',title:'ҽ����',width:420},
		{field:'nutType',title:'Ӫ���ɷ�',width:120},
		{field:'doseContent',title:'��������',width:420,formatter:function(index,row){
			return 'ÿ<span style="color:red">'+row.arcDose+'ml</span>����<span style="color:blue">'+row.nutDose+row.nutTypeUom+'</span>';
		}},
		{field:'flag',title:'�Ƿ����',align:'center',width:70,formatter:flagFormat}
	]]
	
	
	$HUI.datagrid('#datagrid',{
		title:'ҩƷӪ��ά��',
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

///�󶨷���
function initMethod(){
	$('#code').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });
    $('#desc').bind('keypress',function(event){
		event.keyCode == '13'?loadTable():'';
    });		
}

///�Ƿ�����
function flagFormat(value,row,index){
	if (value=='Y') return '��';
	return '��';
}


function addRow(){
	//commonAddRow({'datagrid':'#datagrid',value:{'id':'','code':'','desc':'','flag':'Y'}})
}
//˫���༭
function onClickRow(index,row){
	//editIndex == undefined?'':editComboFun(editIndex,row,'#datagrid');
	//CommonRowClick(index,row,'#datagrid');
}

function editComboFun(index,row,idPress){
	//�б���������ʵ�֣��޸ĺ�ѻ�дfeetypename����Ϊformatter��ʾ����feetypename�ֶ�
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
		$.messager.alert('��ʾ','ҽ�������!','info');
		return;	
	}
	if(!nutTypeDr){
		$.messager.alert('��ʾ','ҽ�������!','info');
		return;	
	}
	if(!arcDose){
		$.messager.alert('��ʾ','��������!','info');
		return;	
	}
	if(!nutDose){
		$.messager.alert('��ʾ','��������!','info');
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
			$.messager.alert('��ʾ','�ɹ�!','info');
			$HUI.window('#addWin').close();
			loadTable();
		}else{
			$.messager.alert('��ʾ','ʧ��!'+ret,'error');
		}
	});
}

function delet(){
	if ($('#datagrid').datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��','info');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$('#datagrid').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionContent','delete',{'id':row.id},function(data){ 
				loadTable();
			})
	    }    
	}); 
}

///ˢ��table
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
			$.messager.alert('��ʾ','��ѡ��һ������!','info'); 
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