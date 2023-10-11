/**
 * workitem 操作项目维护
 * 
 * 
 * CREATED BY zhouyang 2019-10-17
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.WorkItem
 */
 
 
 var globalObj = {
	m_gridWorkItem : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridWorkItem = InitGridWorkItem();
}

function InitEvent(){
	$('#wi-add').click(function(){editWorkItem('add');});
	$('#wi-edit').click(function(){editWorkItem('edit');});
	$('#wi-delete').click(function(){deleteWorkItem();});
}

 // 初始化操作项目表格
function InitGridWorkItem(){
	var columns = [[
		{field:'Code',title:'代码',width:500,align:'left'},
		{field:'Desc',title:'名称',width:500,align:'left'},
		{field:'Resume',title:'备注',width:500,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridWorkItem =$HUI.datagrid("#gridWorkItem",{
		fit: true,
		//title:"操作项目",
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
		    ClassName:"CT.IPMR.BTS.WorkItemSrv",
			QueryName:"QueryWorkItem"
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'wi-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'wi-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'wi-delete',
				iconCls: 'icon-cancel'
			}
		],*/
		onClickRow:function(rowIndex,rowData){	
		}
	});
	return gridWorkItem;
}

// 操作项目新增、修改事件
function editWorkItem(op){
	var selected = $("#gridWorkItem").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#WorkItemDialog').css('display','block');
	var _title = "修改操作项目",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加操作项目",_icon="icon-w-add";
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

	var WorkItemDialog = $HUI.dialog('#WorkItemDialog', {
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
					saveWorkItem();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#WorkItemDialog').window("close");
			}	
		}]
	});
}

// 操作项目删除事件
function deleteWorkItem(){

	var selected = $("#gridWorkItem").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.WorkItem",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridWorkItem").datagrid("reload");
    	}
    });
}

// 操作项目保存操作
function saveWorkItem(){
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
		ClassName:"CT.IPMR.BT.WorkItem",
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
	$('#WorkItemDialog').window("close");
	$("#gridWorkItem").datagrid("reload");

}