/**
 * datamaster 首页术语集维护
 * 
 * 
 * CREATED BY maxin 2019-10-23
 * 
 * 注解说明
 * TABLE: CT_IPMR_BT.Glossary
 */
//页面全局变量对象
var globalObj = {
	m_gridConfig : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridConfig = InitgridDatamaster();
}

function InitEvent(){
	$('#c-add').click(function(){editDatamaster('add');});
	$('#c-edit').click(function(){editDatamaster('edit');});
	$('#c-delete').click(function(){deleteDatamaster();});
}
 /**
 * 
 * CTOR: MaXin
 * DESC: 参数配置
 * DATE: 2019-10-23
 * NOTE: 包括四个方法：InitgridDatamaster,editDatamaster,deleteDatamaster,saveDatamaster
 * TABLE: CT_IPMR_BT.Glossary
 */


 // 初始化字典类型表格
function InitgridDatamaster(){
	
	var columns = [[
		{field:'FPTypeDesc',title:'首页类型',width:60,align:'left'},
		{field:'Code',title:'代码',width:80,align:'left'},
		{field:'Desc',title:'名称',width:160,align:'left'},
		{field:'DataTypeDesc',title:'数据类型',width:60,align:'left'},//全部剧中
		{field:'IsActiveDesc',title:'是否有效',width:60,align:'left'},
		{field:'Resume',title:'备注',align:'left',width:250},  
		{field:'ID',title:'ID',hidden:true,order:'asc'}
    ]];

	var gridConfig =$HUI.datagrid("#gridConfig",{
		fit: true,
		//title: "术语集维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize:20,
		fitColumns:true,
		fixRowNumber:true,
	    url:$URL,
	    queryParams:{
		    ClassName:"CT.IPMR.BTS.GlossarySrv",
			QueryName:"QueryGlossary"
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
		}
	});
	return gridConfig;
}

///查询
$("#c-search").click(function(){
   var InputStr=$("#search").val();
	$("#gridConfig").datagrid('load',
	{
	  ClassName:"CT.IPMR.BTS.GlossarySrv",
	  QueryName:"QueryGlossary",
	  aFPTypeID:"",
	  aAlias:InputStr,
	  aIsActive:""
	});
	  
});
       
 

// 字典类型新增、修改事件
function editDatamaster(op){
	var selected = $("#gridConfig").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	$('#ConfigDialog').css('display','block');
	//数据类型
	Common_ComboToDic("cboBGDataType","FPDataType",1,'');
	Common_ComboToDic("cboBGFPType","FrontPageType",1,'');
	
	//是否有效
	var BGIsActive = $HUI.combobox("#txtBGIsActive",{
		editable:false,
		allowNull:true,
		valueField:'IsActive',
		textField:'IsActiveDesc',
		//pabelheight:'auto',
		data:[
		{IsActive:'1',IsActiveDesc:'是'},
		{IsActive:'0',IsActiveDesc:"否"}
		],
		defaultFilter:4
	});
	
	var _title = "修改术语集",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加术语集",_icon="icon-w-add";
		$("#txtId").val('');
		$('#cboBGFPType').combobox('enable');
		$("#cboBGFPType").combobox('setValue', '');
		//$("#txtBGCode").validatebox("setDisabled",false);
		$("#txtBGCode").attr("disabled", false);
		$("#txtBGCode").val('');
		$("#txtBGDesc").val('');
		$("#cboBGDataType").combobox('setValue', '');
		$("#txtBGIsActive").combobox('setValue', '');
		$("#txtBGResume").val('');
	} else {
		$("#txtId").val(selected.ID);
		$('#cboBGFPType').combobox('setValue',selected.FPTypeID);
		$('#cboBGFPType').combobox('disable');
		//$("#txtBGCode").validatebox("setDisabled",true);
		$("#txtBGCode").attr("disabled", true);
		$("#txtBGCode").val(selected.Code);
		$("#txtBGDesc").val(selected.Desc);
		$('#cboBGDataType').combobox('setValue',selected.DataTypeID);
		$('#txtBGIsActive').combobox('setValue',selected.IsActive);
		$("#txtBGResume").val(selected.Resume);                    
	}

	var ConfigDialog = $HUI.dialog('#ConfigDialog', {
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
					saveDatamaster();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#ConfigDialog').window("close");
			}	
		}]
	});
}

// 字典类型删除事件
function deleteDatamaster(){

	var selected = $("#gridConfig").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.BT.Glossary",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridConfig").datagrid("reload");
    	}
    });
}

// 字典类型保存操作
function saveDatamaster(){
	var id = $("#txtId").val(); //ID
	var BGFPTypeDr = $("#cboBGFPType").combobox('getValue');//首页类型
	var BGCode	= $("#txtBGCode").val();//代码
	var	BGDesc	= $("#txtBGDesc").val();//描述
	var BGDataType=$("#cboBGDataType").combobox('getValue');//数据类型
	var BGIsActive = $("#txtBGIsActive").combobox('getValue');//是否有效
	var BGResume	= $("#txtBGResume").val();//备注
	if (BGFPTypeDr == '') {
		$.messager.popover({msg: '请选择首页类型！',type: 'alert',timeout: 1000});
		return false;
	}
	
	if (BGDataType == '') {
		$.messager.popover({msg: '请选择数据类型！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + BGFPTypeDr;
	inputStr += '^' + BGCode;
	inputStr += '^' + BGDesc;
	inputStr += '^' + BGDataType;
	inputStr += '^' + BGIsActive;  ///项目名称
	inputStr += '^' + BGResume;
   
	var flg = $m({
		ClassName:"CT.IPMR.BT.Glossary",
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
	$('#ConfigDialog').window("close");
	$("#gridConfig").datagrid("reload");

}