/**
 * config 编目配置
 * 
 * Copyright (c) 2018-2019 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2019-09-29
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
		m_WorkFItemID:''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridCodeConfig = InitgridCodeConfig();
	Common_ComboToWorkFlow('cboWorkFlow');
	
	Common_ComboToICDVer('cboICDVer');
	Common_ComboToICDVer('cboOprVer');
	Common_ComboToICDVer('cboICDVer2');
	Common_ComboToICDVer('cboICDVer3');
	Common_ComboToDic('cboCodeMultiVer','CodeMultiVer',1,'')
	//工作流操作项目联动
	$HUI.combobox('#cboWorkFlow',{
	    onSelect:function(rows){
		   var WorkFlowID=rows["ID"];
		   Common_ComboToWorkFItem('cboWorkFItem',WorkFlowID);
	    }
    })
}

function InitEvent(){
	$('#add').click(function(){editCodeConfig('add');});
	$('#edit').click(function(){editCodeConfig('edit');});
	$('#delete').click(function(){deleteCodeConfig();});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 编目配置
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：InitgridCodeConfig,editCodeConfig,deleteCodeConfig,saveCodeConfig
 * TABLE: CT.IPMR.FP.CodeConfig
 */

 // 初始化编目配置表格
function InitgridCodeConfig(){
	var columns = [[
		{field:'WorkFlowDesc',title:'工作流',width:180,align:'left'},
		{field:'WorkFItemDesc',title:'操作项目',width:100,align:'left'},
		{field:'CodeMultiVerDesc',title:'编目数据版本',width:120,align:'left'},
		{field:'ICDVerDesc',title:'西医诊断库',width:200,align:'left'},
		{field:'OprVerDesc',title:'手术库',width:200,align:'left'},
		{field:'ICDVer2Desc',title:'中医诊断库',width:200,align:'left'},
		{field:'ICDVer3Desc',title:'肿瘤诊断库',width:200,align:'left'},
		{field:'IsDefault',title:'是否默认配置',width:120,align:'left',
			formatter:function(value,row,index){
				var IsDefault	= row.IsDefault;
				if (IsDefault == '1'){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{field:'Resume',title:'备注',width:200,align:'left'},
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];
	var gridCodeConfig =$HUI.datagrid("#gridCodeConfig",{
		fit: true,
		//title: "编目配置",
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
		    ClassName:"CT.IPMR.FPS.ConfigSrv",
			QueryName:"QueryCodeConfig"
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'delete',
				iconCls: 'icon-cancel'
			}
		],*/
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return gridCodeConfig;
}

// 编目配置新增、修改事件
function editCodeConfig(op){
	var selected = $("#gridCodeConfig").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$('#CodeConfigDialog').css('display','block');
	
	var cboFPType = $HUI.combobox("#cboFPType", {
		url:$URL,
		valueField:'ID',
		textField:'Desc',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onBeforeLoad: function (param) {
			param.ClassName = 'CT.IPMR.BTS.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.ResultSetType = 'array';
			param.aDicType = 'FrontPageType';
			param.aIsActive = 1;
			param.aHospID = '';
		}
	})
	var _title = "修改编目配置",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加编目配置",_icon="icon-w-add";
		$("#txtId").val('');
		$('#cboWorkFlow').combobox('setValue','');
		$('#cboCodeMultiVer').combobox('setValue','');
		Common_ComboToWorkFItem('cboWorkFItem','');
		$('#cboWorkFItem').combobox('setValue','');
		$('#cboICDVer').combobox('setValue','');
		$('#cboOprVer').combobox('setValue','');
		$('#cboICDVer2').combobox('setValue','');
		$('#cboICDVer3').combobox('setValue','');
		$("#txtResume").val('');
		$("#chkIsDefault").checkbox("setValue",false);
	} else {
		$("#txtId").val(selected.ID);
		$('#cboWorkFlow').combobox('select',selected.WorkFlowID);
		$('#cboCodeMultiVer').combobox('setValue',selected.CodeMultiVerID);
		$('#cboWorkFItem').combobox('setValue',selected.WorkFItemID);
		$('#cboICDVer').combobox('setValue',selected.ICDVerID);
		$('#cboOprVer').combobox('setValue',selected.OprVerID);
		$('#cboICDVer2').combobox('setValue',selected.ICDVer2ID);
		$('#cboICDVer3').combobox('setValue',selected.ICDVer3ID);
		$("#txtResume").val(selected.Resume);
		$("#chkIsDefault").checkbox("setValue",selected.IsDefault=='1'?true:false);
	}

	var CodeConfigDialog = $HUI.dialog('#CodeConfigDialog', {
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
					saveCodeConfig();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#CodeConfigDialog').window("close");
			}	
		}]
	});
}

// 编目配置删除事件
function deleteCodeConfig(){

	var selected = $("#gridCodeConfig").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.FP.Config",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridCodeConfig").datagrid("reload");
    	}
    });
}

// 编目配置保存操作
function saveCodeConfig(){
	var id = $("#txtId").val();
	var WorkFlow = $("#cboWorkFlow").combobox('getValue');
	var CodeMultiVer = $("#cboCodeMultiVer").combobox('getValue');
	var WorkFItem = $("#cboWorkFItem").combobox('getValue');
	var ICDVer = $("#cboICDVer").combobox('getValue');
	var OprVer = $("#cboOprVer").combobox('getValue');
	var ICDVer2 = $("#cboICDVer2").combobox('getValue');
	var ICDVer3 = $("#cboICDVer3").combobox('getValue');
	var resume = $("#txtResume").val();
	var IsDefault = $("#chkIsDefault").checkbox("getValue")?"1":"0";
	if (WorkFlow == '') {
		$.messager.popover({msg: '请选择工作流！',type: 'alert',timeout: 1000});
		return false;
	}
	if (WorkFItem == '') {
		$.messager.popover({msg: '请选择操作项目！',type: 'alert',timeout: 1000});
		return false;
	}
	if (OprVer == '') {
		$.messager.popover({msg: '请选择手术库！',type: 'alert',timeout: 1000});
		return false;
	}
	if ((ICDVer == '')&&(ICDVer2=='')) {
		$.messager.popover({msg: '西医诊断库和中医诊断库不能都为空！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + WorkFItem;
	inputStr += '^' + ICDVer;
	inputStr += '^' + OprVer;
	inputStr += '^' + ICDVer2;
	inputStr += '^' + ICDVer3;
	inputStr += '^' + resume;
	inputStr += '^' + CodeMultiVer;
	inputStr += '^' + IsDefault;

	var flg = $m({
		ClassName:"CT.IPMR.FP.Config",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "该工作流操作项目已经配置完成!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#CodeConfigDialog').window("close");
	$("#gridCodeConfig").datagrid("reload");
}