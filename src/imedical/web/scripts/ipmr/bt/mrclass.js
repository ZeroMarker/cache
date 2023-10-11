/**
 * mrclass 病案分类维护
 * 
 * 
 * CREATED BY zhouyang 2019-10-17
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.MrClass
 */
 
 
 var globalObj = {
	m_gridMrClass : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridMrClass = InitGridMrClass();
}

function InitEvent(){
	$('#mc-add').click(function(){editMrClass('add');});
	$('#mc-edit').click(function(){editMrClass('edit');});
	$('#mc-delete').click(function(){deleteMrClass();});
}

 // 初始化病案分类表格
function InitGridMrClass(){
	var columns = [[
		{field:'Code',title:'代码',width:500,align:'left'},
		{field:'Desc',title:'名称',width:500,align:'left'},
		{field:'Resume',title:'备注',width:500,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var MrClassItem =$HUI.datagrid("#gridMrClass",{
		fit: true,
		//title:"病案分类",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		fitColumns:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.BTS.MrClassSrv",
			QueryName:"QueryMrClass"
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'mc-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'mc-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'mc-delete',
				iconCls: 'icon-cancel'
			}
		],*/
		onClickRow:function(rowIndex,rowData){	
		}
	});
	return gridMrClass;
}

// 病案分类新增、修改事件
function editMrClass(op){
	var selected = $("#gridMrClass").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#MrClassDialog').css('display','block');
	var _title = "修改病案类型",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加病案类型",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#txtResume").val('');
	} else {
		$("#txtId").val(selected.ID);
		$("#txtCode").val(selected.Code);
		$("#txtDesc").val(selected.Desc);
		$("#txtResume").val(selected.Resume);
	}

	var MrClassDialog = $HUI.dialog('#MrClassDialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveMrClass();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#MrClassDialog').window("close");
			}	
		}]
	});
}

// 病案分类删除事件
function deleteMrClass(){

	var selected = $("#gridMrClass").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.MrClass",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridMrClass").datagrid("reload");
    	}
    });
}

// 病案分类保存操作
function saveMrClass(){
	var id = $("#txtId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var resume = $("#txtResume").val();
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + resume;

	var flg = $m({
		ClassName:"CT.IPMR.BT.MrClass",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "代码重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#MrClassDialog').window("close");
	$("#gridMrClass").datagrid("reload");

}