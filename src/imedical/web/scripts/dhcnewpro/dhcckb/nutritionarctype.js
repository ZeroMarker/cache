///Author:    qiaoqingao

var editArcIndex;
$(function(){
	
	initCombobox();
	
	initTable();
	
	initMethod();
});


/// ��ʼ��combobox
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
				{'value':'Y','text':'��'},
				{'value':'N','text':'��'}
			],
			required:true,
			editable:false
		}
	}
	
	var columns=[[
		{field:'id',title:'id',width:120,editor:{type:'validatebox',options:{}},hidden:true},
		{field:'code',title:'����',width:80,editor:{type:'validatebox',options:{required:true}}},
		{field:'desc',title:'����',width:220,editor:{type:'validatebox',options:{required:true}}},
		{field:'flag',title:'�Ƿ����',align:'center',width:70,formatter:flagFormat,editor:flagEdit},
		{field:'no',title:'���',width:60,editor:{type:'validatebox',options:{required:false}}}
	]]
	
	
	$HUI.treegrid('#datagridType',{
		title:'����',
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
		{field:'arc',title:'ҽ����',width:420,editor:arcEdit,formatter:arcFormat},
		{field:'arcDesc',title:'ҽ����',width:120,editor:{type:'validatebox',options:{}},hidden:true}
	]]
	
	$HUI.datagrid('#datagridArc',{
		title:'ҽ����Ŀ',
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
		{field:'arc',title:'ҽ����',width:420},
		{field:'nutType',title:'Ӫ���ɷ�',width:120},
		{field:'doseContent',title:'��������',width:420,formatter:function(index,row){
			return 'ÿ<span style="color:red">'+row.arcDose+'ml</span>����<span style="color:blue">'+row.nutDose+row.nutTypeUom+'</span>';
		}},
		{field:'flag',title:'�Ƿ����',align:'center',width:70,formatter:flagFormat}
	]]
	
	
	$HUI.datagrid('#datagridArcNut',{
		title:'Ӫ��ά��',
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

///�󶨷���
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

///�Ƿ�����
function flagFormat(value,row,index){
	if (value=='Y') return '��';
	return '��';
}


function addRow(){
	//commonAddRow({'datagrid':'#datagridType',value:{'id':'','code':'','desc':'','flag':'Y'}})
	$('#winTypeTitle').html('����');
	var rowData = $HUI.treegrid('#datagridType').getSelected()||{};
	$HUI.combobox('#typeParDr').setValue(rowData.id);
	$HUI.window('#addTypeWin').open();
}

function onClickRowType(){
	loadArcTable();
	loadTableArcNut('');
}

//˫���༭
function onClickRow(index,row){
	//CommonRowClick(index,row,'#datagridType');
	$('#winTypeTitle').html('�޸�');
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
		$.messager.alert('��ʾ','ѡ��һ������!','info'); 
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

//˫���༭
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
	//�б���������ʵ�֣��޸ĺ�ѻ�дfeetypename����Ϊformatter��ʾ����feetypename�ֶ�
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
			$.messager.alert('��ʾ','�����Ѵ���,�����ظ�����!'); 
			loadTable();
		}else{	
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
		}
	});	
}

function saveArc(){
	if(!endArcEditing('#datagridArc')){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var changesData = $('#datagridArc').datagrid('getChanges');
	if(changesData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
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
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
		}
	})
}

function delet(){
	if ($('#datagridType').treegrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
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
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$('#datagridArc').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionArcType','deleteArc',{'id':row.id},function(data){ 
				loadArcTable();
				loadTableArcNut('');
			})
	    }    
	}); 
}


///ˢ��table
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
		$.messager.alert('��ʾ','ҽ�������!','info');
		return;	
	}
	
	var arcDr=arcRow.arc;
	
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
			onClickRowArc();
		}else{
			$.messager.alert('��ʾ','ʧ��!'+ret,'error');
		}
	});
}

function deletArcNut(){
	if ($('#datagridArcNut').datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��','info');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
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
			$.messager.alert('��ʾ','�����Ѵ���,�����ظ�����!'); 
			loadTable();
		}else{	
			$.messager.alert('��ʾ','����ʧ��:'+data)
			
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