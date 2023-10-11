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
				{'value':'Y','text':'是'},
				{'value':'N','text':'否'}
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
		{field:'code',title:'代码',width:120,editor:{type:'validatebox',options:{required:true}}},
		{field:'desc',title:'描述',width:120,editor:{type:'validatebox',options:{required:true}}},
		{field:'unitDesc',title:'单位',width:120,editor:{type:'validatebox',options:{required:false}}},
		{field:'valueMethod',title:'数据方法',width:450,editor:{type:'validatebox',options:{required:false}}},
		{field:'flag',title:'是否可用',align:'center',width:70,formatter:flagFormat,editor:flagEdit}
	]]
	
	
	$HUI.datagrid('#datagrid',{
		title:'计算指标字典维护',
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
	commonAddRow({'datagrid':'#datagrid',value:{'id':'','code':'','desc':'','flag':'Y'}})
}
//双击编辑
function onClickRow(index,row){
	//editIndex == undefined?'':editComboFun(editIndex,row,'#datagrid');
	CommonRowClick(index,row,'#datagrid');
}

function editComboFun(index,row,idPress){
	//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
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
			$.messager.alert('提示','代码已存在,不能重复保存!'); 
			loadTable();
		}else{	
			$.messager.alert('提示','保存失败:'+data)
			
		}
	});	
}

function delet(){
	if ($('#datagrid').datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){
		    var row =$('#datagrid').datagrid('getSelected');     
			runClassMethod('web.DHCCKBNutritionIndicators','delete',{'id':row.id},function(data){ 
				loadTable(); 
			})
	    }    
	}); 
}

///刷新table
function loadTable(){
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+'^'+desc;
	$HUI.datagrid('#datagrid').load({
		params:params
	})	
}
