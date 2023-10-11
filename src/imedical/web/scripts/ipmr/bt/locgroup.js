/**
 * locgroup 科室组维护
 * 
 * 
 * CREATED BY zhouyang 2019-10-21
 * 
 * 注解说明
 * TABLE: CT.IPMR.BT.LocGroup
 */
 
 
 var globalObj = {
	m_gridLocGroup : '',//科室组
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridLocGroup = InitGridLocGroup();
}

function InitEvent(){
	$('#mc-add').click(function(){editLocGroup('add');});
	$('#mc-edit').click(function(){editLocGroup('edit');});
	$('#mc-delete').click(function(){deleteLocGroup();});
}
 // 初始化科室分组表格
function InitGridLocGroup(){
	var columns = [[
		{field:'Code',title:'代码',width:400,align:'left'},
		{field:'Desc',title:'科室组',width:400,align:'left'},
		{field:'Type',title:'类型',width:400,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["Type"];
				if(Type == "E") {
					return "科室"
				}else if(Type == "W"){
					return "病区"
				}else if(Type == "O")
				{
					return "其他"
				}	
			}
		},
		{field:'IsActive',title:'是否有效',width:400,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["IsActive"];
				if(Type == 1) {
					return "是"
				}else {
					return "否"
				}	
			}
		},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridLocGroup =$HUI.datagrid("#gridLocGroup",{
		fit: true,
		//title:"科室组",
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
		    ClassName:"MA.IPMR.BTS.LocGroupSrv",
			QueryName:"QueryLocGroup",
			aKeyword: "",
			aType :"",
			aAddItem:'',
			aIsActive:''
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
	return gridLocGroup;
}

// 科室组新增、修改事件
function editLocGroup(op){
	var selected = $("#gridLocGroup").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	$('#LocGroupDialog').css('display','block');
    $('#comboxType').combobox({
		textField : 'text',
		valueField : 'value',
		panelHeight : 'auto',
		data : [
			{'text' : '', 'value' : ''},
	        {'text' : '科室', 'value' : 'E'},
	        {'text' : '病区', 'value' : 'W'},
		],
	})
	
	var _title = "修改科室组",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加科室组",_icon="icon-w-add";
		$("#txtLocId").val('');
		$("#txtLocCode").val('');
		$("#txtLocDesc").val('');
		$("#comboxType").combobox('setValue','');
		$("#chkLocActive").checkbox("setValue",false);
	} else {
		$("#txtLocId").val(selected.ID);
		$("#txtLocCode").val(selected.Code);
		$("#txtLocDesc").val(selected.Desc);
		$("#comboxType").combobox("setValue",selected.Type);
		$("#chkLocActive").checkbox("setValue",selected.IsActive=='1'?true:false);
	}

	var LocGroupDialog = $HUI.dialog('#LocGroupDialog', {
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
					saveLocGroup();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#LocGroupDialog').window("close");
			}	
		}]
	});
}

// 科室组删除事件
function deleteLocGroup(){

	var selected = $("#gridLocGroup").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"MA.IPMR.BT.LocGroup",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridLocGroup").datagrid("reload");
    	}
    });
}

// 科室组保存操作
function saveLocGroup(){
	var id = $("#txtLocId").val();
	var code = $("#txtLocCode").val();
	var desc = $("#txtLocDesc").val();
	var type = $("#comboxType").combobox('getValue')
	var isActive = $("#chkLocActive").checkbox("getValue")?"1":"0"
	if (code == '') {
		$.messager.popover({msg: '请填写代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写科室组！',type: 'alert',timeout: 1000});
		return false;
	}
	if (type == '') {
		$.messager.popover({msg: '请选择类型！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + type;
	inputStr += '^' + isActive;

	var flg = $m({
		ClassName:"MA.IPMR.BT.LocGroup",
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
	$('#LocGroupDialog').window("close");
	$("#gridLocGroup").datagrid("reload");
}