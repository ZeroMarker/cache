///Author:    qiaoqingao

var editArcIndex;
$(function(){
	
	initCombobox();
	
	initTable();
	
	initMethod();
});


/// 初始化combobox
function initCombobox(){
	
	$HUI.combobox('#nutType',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionFormula&MethodName=listNutType" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       $('#nutTypeUom').text(option.uom);
	    }	
	})
	
	
	$HUI.combobox('#typeParDr',{
		url:LINK_CSP+"?ClassName=web.DHCCKBNutritionArcType&MethodName=listArcType" ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
}

function initTable(){
	
	var flagEdit={
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			data:[
				{'value':'Y','text':'是'},
				{'value':'N','text':'否'}
			],
			required:true,
			editable:false
		}
	}
	
	var columns=[[
		{field:'id',title:'id',width:120,editor:{type:'validatebox',options:{}},hidden:true},
		{field:'code',title:'代码',width:80,editor:{type:'validatebox',options:{required:true}}},
		{field:'desc',title:'描述',width:220,editor:{type:'validatebox',options:{required:true}}},
		{field:'flag',title:'是否可用',align:'center',width:70,formatter:flagFormat,editor:flagEdit},
		{field:'no',title:'序号',width:60,editor:{type:'validatebox',options:{required:false}}}
	]]
	
	
	$HUI.treegrid('#datagridType',{
		title:'分类',
		headerCls:'panel-header-gray',
		columns:columns,
		border:true,
		toolbar:'#toolbarType',
		idField: 'id',
		treeField: 'desc',
	    rownumbers:false,
	    method:'get',
	    fitColumns:false,
	    singleSelect:true,
	    pagination:false,
	    nowrap: true,
	    onClickRow:onClickRowType,
	    onDblClickRow:onClickRow, 
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionArcType&MethodName=list'
	})
	
	var arcEdit={
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			mode:'remote',
			url:LINK_CSP+'?ClassName=web.DHCCKBNutritionContent&MethodName=listArc',
			required:true,
			blurValidValue:true
		}
	}
	
	var columns=[[
		{field:'id',title:'id',width:120,editor:{type:'validatebox',options:{}},hidden:true},
		{field:'arc',title:'医嘱项',width:420,editor:arcEdit,formatter:arcFormat},
		{field:'arcDesc',title:'医嘱项',width:120,editor:{type:'validatebox',options:{}},hidden:true}
	]]
	
	$HUI.datagrid('#datagridArc',{
		title:'医嘱项目',
		headerCls:'panel-header-gray',
		columns:columns,
		border:true,
		toolbar:'#toolbarArc',
	    rownumbers:true,
	    method:'get',
	    fitColumns:false,
	    singleSelect:true,
	    pagination:true,
	    nowrap: false,
	    onDblClickRow:onDbClickRowArc,
	    onClickRow:onClickRowArc,
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionArcType&MethodName=listTableArc'
	})
	
	var columns=[[
		{field:'id',title:'id',width:60,hidden:true},
		{field:'arc',title:'医嘱项',width:420},
		{field:'nutType',title:'营养成分',width:120},
		{field:'doseContent',title:'含量描述',width:420,formatter:function(index,row){
			return '每<span style="color:red">'+row.arcDose+'ml</span>含有<span style="color:blue">'+row.nutDose+row.nutTypeUom+'</span>';
		}},
		{field:'flag',title:'是否可用',align:'center',width:70,formatter:flagFormat}
	]]
	
	
	$HUI.datagrid('#datagridArcNut',{
		title:'营养维护',
		headerCls:'panel-header-gray',
		columns:columns,
		border:true,
		toolbar:'#toolbarArcNut',
	    rownumbers:true,
	    method:'get',
	    fitColumns:false,
	    singleSelect:true,
	    pagination:true,
	    nowrap: false,
	    onDblClickRow:onClickRow, 
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionContent&MethodName=listOneArc'
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

function arcFormat(value,row,index){
	return row.arcDesc;
}

///是否下拉
function flagFormat(value,row,index){
	if (value=='Y') return '是';
	return '否';
}


function addRow(){
	//commonAddRow({'datagrid':'#datagridType',value:{'id':'','code':'','desc':'','flag':'Y'}})
	$('#winTypeTitle').html('新增');
	var rowData = $HUI.treegrid('#datagridType').getSelected()||{};
	$HUI.combobox('#typeParDr').setValue(rowData.id);
	$HUI.window('#addTypeWin').open();
}

function onClickRowType(){
	loadArcTable();
	loadTableArcNut('');
}

//双击编辑
function onClickRow(index,row){
	//CommonRowClick(index,row,'#datagridType');
	$('#winTypeTitle').html('修改');
	var rowData = $HUI.treegrid('#datagridType').getSelected();
	$('#typeId').val(rowData.id);
	$('#typeCode').val(rowData.code);
	$('#typeDesc').val(rowData.desc);
	$('#typeNo').val(rowData.no);
	$HUI.combobox('#typeParDr').setValue(rowData.parDr);
	$HUI.checkbox('#flag').setValue(rowData.flag==="Y");
	$HUI.window('#addTypeWin').open();
}

function addArcRow(){
	
	var mainRow=$HUI.treegrid('#datagridType').getSelected();
	if(!mainRow) {
		$.messager.alert('提示','选择一个分类!','info'); 
		return;
	}
	
	var _options={'datagrid':'#datagridArc',value:{'id':'','arc':'','arcDesc':''}};
	if(endArcEditing(_options.datagrid)){
		value=$.extend({},_options.value);
		$(_options.datagrid).datagrid('insertRow',{index:0, row: value}).datagrid('beginEdit', 0);
		$(_options.datagrid).datagrid('selectRow', 0);//hxy
		editArcIndex=0;
	}
}

//双击编辑
function onDbClickRowArc(index,row){
	editArcIndex == undefined?'':editComboFun(editArcIndex,row,'#datagridArc');
	
	if (endArcEditing('#datagridArc')){
		$('#datagridArc').datagrid('selectRow', index).datagrid('beginEdit', index)
		editArcIndex = index;
	} else {
		$('#datagridArc').datagrid('selectRow', editArcIndex);
	}
}

function endArcEditing(){
	if (editArcIndex == undefined){return true}
	if ($('#datagridArc').datagrid('validateRow', editArcIndex)){
		$('#datagridArc').datagrid('endEdit', editArcIndex);
		editArcIndex = undefined;
		return true;
	} else {
		$('#datagridArc').datagrid('selectRow', editArcIndex).datagrid('beginEdit', editArcIndex);
		return false;
	}
}


function editComboFun(index,row,idPress){
	//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
	var ed = $(idPress).datagrid('getEditor', {index:index,field:'arc'});
	var arcDesc = $(ed.target).combobox('getText');
	$(idPress).datagrid('getRows')[index]['arcDesc'] = arcDesc;
	return;	
}

function save(){
	saveByDataGrid('web.DHCCKBNutritionArcType','save','#datagridType',function(data){
		if(data==0){
			loadTable();
		}else if(data==1){
			$.messager.alert('提示','代码已存在,不能重复保存!'); 
			loadTable();
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	
}

function saveArc(){
	if(!endArcEditing('#datagridArc')){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var changesData = $('#datagridArc').datagrid('getChanges');
	if(changesData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var mainRow=$HUI.treegrid('#datagridType').getSelected();
	var dataList = [];
	for(var i=0;i<changesData.length;i++){
		var nowRowData=changesData[i];
		dataList.push(nowRowData.id+'^'+mainRow.id+'^'+nowRowData.arc);
	} 
	var params=dataList.join("$$");
	runClassMethod('web.DHCCKBNutritionArcType','saveArc',{'params':params},function(data){
		if(data==0){
			loadArcTable();
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	})
}

function delet(){
	if ($('#datagridType').treegrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagridType').treegrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionArcType','delete',{'id':row.id},function(data){ 
				loadTable();
			})
	    }    
	}); 
}

function deletArc(){
	if ($('#datagridArc').datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagridArc').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionArcType','deleteArc',{'id':row.id},function(data){ 
				loadArcTable();
				loadTableArcNut('');
			})
	    }    
	}); 
}


///刷新table
function loadTable(){
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+'^'+desc;
	$HUI.treegrid('#datagridType').load({
		params:params
	})	
}

function loadArcTable(){
	var mainRow=$HUI.treegrid('#datagridType').getSelected();
	var arcTypeId=mainRow.id;
	var params=arcTypeId;
	$HUI.datagrid('#datagridArc').load({
		params:params
	})
}




function saveArcNut(){
	var id=$('#id').val();
	var arcRow=$HUI.datagrid('#datagridArc').getSelected() ;//$HUI.combobox('#arc').getValue();
	var nutTypeDr=$HUI.combobox('#nutType').getValue();
	var arcDose=$('#arcDose').val();
	var nutDose=$('#nutDose').val();
	
	if(!arcRow){
		$.messager.alert('提示','医嘱项必填!','info');
		return;	
	}
	
	var arcDr=arcRow.arc;
	
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
			onClickRowArc();
		}else{
			$.messager.alert('提示','失败!'+ret,'error');
		}
	});
}

function deletArcNut(){
	if ($('#datagridArcNut').datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除','info');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagridArcNut').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionContent','delete',{'id':row.id},function(data){ 
				onClickRowArc();
			})
	    }    
	}); 
}


function opArcNut(model){
	
	if(model=='add'){
		clearArcNutWin();	
	}
	
	if(model=='update'){
		var rowData=$HUI.datagrid('#datagridArcNut').getSelected();
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

function clearArcNutWin(){
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

function cancelArcNut(){
	$HUI.window('#addWin').close();
	return;
}

function onClickRowArc(){
	var row=$HUI.datagrid('#datagridArc').getSelected() 
	var params = row?row.arc:'';
	loadTableArcNut(params);
}

function loadTableArcNut(params){
	$HUI.datagrid('#datagridArcNut').load({
		params:params
	})
	return;
}

function saveTypeNut(){
	var id=$('#typeId').val();
	var code=$('#typeCode').val();
	var desc=$('#typeDesc').val();
	var parDr=$HUI.combobox('#typeParDr').getValue();
	var no=$('#typeNo').val();
	var flag = $HUI.checkbox('#flag').getValue()?'Y':'N';
	var params=id+'^'+code+'^'+desc+'^'+parDr+'^'+flag+'^'+no;
	
	$cm({
		ClassName:"web.DHCCKBNutritionArcType",
		MethodName:"save",
		params:params,
		dataType:'text'
	},function(ret){
		if(ret==0){
			loadTable();
			cancelTypeNut();
		}else if(ret==1){
			$.messager.alert('提示','代码已存在,不能重复保存!'); 
			loadTable();
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});
	
}

function cancelTypeNut(){
	clearTypeWin();
	$HUI.window('#addTypeWin').close();	
}

function clearTypeWin(){
	$('#typeId').val('');
	$('#typeCode').val('');
	$('#typeDesc').val('');
	$('#typeNo').val('');
	$HUI.combobox('#typeParDr').setValue('');
	$HUI.checkbox('#flag').setValue(true);
}