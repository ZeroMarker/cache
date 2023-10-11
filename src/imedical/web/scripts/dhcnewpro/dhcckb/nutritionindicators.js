///Author:    qiaoqingao
$(function(){ 
	initTable();
	
	initMethod();	
});

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
	
	var unitEdit={
		type:'combobox',
		options:{
			valueField:'value',
			textField:'text',
			url:LINK_CSP+'?ClassName=web.DHCCKBNutritionIndicators&MethodName=listUnit',
			required:false,
			blurValidValue:true
		}
	}
	
	
	var columns=[[
		{field:'id',title:'id',width:120,editor:{type:'validatebox',options:{}},hidden:true},
		{field:'code',title:'����',width:120,editor:{type:'validatebox',options:{required:true}}},
		{field:'desc',title:'����',width:120,editor:{type:'validatebox',options:{required:true}}},
		{field:'unitDesc',title:'��λ',width:120,editor:{type:'validatebox',options:{required:false}}},
		{field:'valueMethod',title:'���ݷ���',width:450,editor:{type:'validatebox',options:{required:false}}},
		{field:'flag',title:'�Ƿ����',align:'center',width:70,formatter:flagFormat,editor:flagEdit}
	]]
	
	
	$HUI.datagrid('#datagrid',{
		title:'����ָ���ֵ�ά��',
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
		url:LINK_CSP+'?ClassName=web.DHCCKBNutritionIndicators&MethodName=list'
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
	commonAddRow({'datagrid':'#datagrid',value:{'id':'','code':'','desc':'','flag':'Y'}})
}
//˫���༭
function onClickRow(index,row){
	//editIndex == undefined?'':editComboFun(editIndex,row,'#datagrid');
	CommonRowClick(index,row,'#datagrid');
}

function editComboFun(index,row,idPress){
	//�б���������ʵ�֣��޸ĺ�ѻ�дfeetypename����Ϊformatter��ʾ����feetypename�ֶ�
	var ed = $(idPress).datagrid('getEditor', {index:index,field:'unit'});
	var unitDesc = $(ed.target).combobox('getText');
	$(idPress).datagrid('getRows')[index]['unitDesc'] = unitDesc;
	return;	
}

function save(){
	saveByDataGrid('web.DHCCKBNutritionIndicators','save','#datagrid',function(data){
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

function delet(){
	if ($('#datagrid').datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$('#datagrid').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionIndicators','delete',{'id':row.id},function(data){ 
				loadTable(); 
			})
	    }    
	}); 
}

///ˢ��table
function loadTable(){
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+'^'+desc;
	$HUI.datagrid('#datagrid').load({
		params:params
	})	
}
