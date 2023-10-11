/**
 * user 用户
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
	m_griduser : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_griduser = Initgriduser();
	Common_ComboToDicCode("cboInternalType","CPTInternalType",1,'');
}

function InitEvent(){
	$('#c-add').click(function(){edituser('add');});
	$('#c-edit').click(function(){edituser('edit');});
	$('#c-delete').click(function(){deleteuser();});
	$('#btnSearch').click(function(){
		QueryUser();
	});
	$('#textAlias').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			QueryUser();
			$('#textAlias').val('');
	　　}
	});
	$('#textAlias1').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
			QueryDpUser();
			$('#textAlias1').val('');
	　　}
	});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 系统定义
 * DATE: 2019-09-29
 * NOTE: 包括方法：QueryLoc,Initgriduser,edituser,deleteuser,saveuser
 * TABLE: CT_IPMR_BT.system
 */

function QueryUser(){
	var Alias = $("#textAlias").val();
	$('#griduser').datagrid('load',  {
		ClassName:"MA.IPMR.BTS.SSUserSrv",
		QueryName:"QueryUser",
		aAlias:Alias,
		aTypeCode:'',
		aUserID:'',
		aIsActive:'',
		rows:10000
	});
	$('#griduser').datagrid('unselectAll');
}

 // 初始化表格
function Initgriduser(){
	var columns = [[
		{field:'Code',title:'用户工号',width:100,align:'left'},
		{field:'Desc',title:'用户名称',width:100,align:'left'},
		{field:'IsActive',title:'是否有效',width:80,align:'left',
			formatter:function(value,row,index){
				var IsActive	= row.IsActive;
				if (IsActive == '1'){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{field:'CPTInternalTypeDesc',title:'医护类型',width:100,align:'left'},
		{field:'CPTDesc',title:'医护人员类型名称',width:100,align:'left'},
		{field:'Unit',title:'医生资格证书号',width:100,align:'left'},
		{field:'Spell',title:'姓名拼音',width:100,align:'left'},
		{field:'d',title:'用户对照',width:80,align:'left',
			formatter:function(value,row,index) {
            	var UserID = row.ID;
				var UserDesc = row.Desc;
               	//return '<a href="#" class="grid-td-text-gray" onclick = OpenMapWin("' + UserID + '","' + UserDesc + '")>' + '对照' + '</a>';
               	return '<a href="#" class="grid-td-text-gray" onclick="OpenMapWin(\'' + UserID+'\',\''+ UserDesc + '\')">'+'对照'+'</a>';
            }
		}
    ]];
	var griduser =$HUI.datagrid("#griduser",{
		fit: true,
		//title: "用户定义",
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
		    ClassName:"MA.IPMR.BTS.SSUserSrv",
			QueryName:"QueryUser",
			aAlias:'',
			aTypeCode:'',
			aUserID:'',
			aIsActive:''
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return griduser;
}

// 新增、修改事件
function edituser(op){
	var selected = $("#griduser").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var _title = "修改用户",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加用户",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtUserCode").val('');
		$("#txtUserDesc").val('');
		$("#txtSpell").val('');
		$("#cboInternalType").combobox('setValue', '');
		$("#txtCPTDesc").val('');
		$("#txtUnit").val('');
		$("#chkActive").checkbox("setValue",false);
	} else {
		$("#txtId").val(selected.ID);
		$("#txtUserCode").val(selected.Code);
		$("#txtUserDesc").val(selected.Desc);
		$("#txtSpell").val(selected.Spell);
		$("#cboInternalType").combobox('setValue', selected.CPTInternalType);
		$("#txtCPTDesc").val(selected.CPTDesc);
		$("#txtUnit").val(selected.Unit);
		$("#chkActive").checkbox("setValue",selected.IsActive=='1'?true:false);
	}

	var userDialog = $HUI.dialog('#userDialog', {
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
					saveuser();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#userDialog').window("close");
			}	
		}]
	});
}

// 删除事件
function deleteuser(){

	var selected = $("#griduser").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"MA.IPMR.BT.SSUser",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#griduser").datagrid("reload");
    	}
    });
}

// 保存操作
function saveuser(){
	var id = $("#txtId").val();
	var code = $("#txtUserCode").val();
	var desc = $("#txtUserDesc").val();
	var spell = $("#txtSpell").val();
	var InternalType = $("#cboInternalType").combobox('getValue');
	var CPTDesc = $("#txtCPTDesc").val();
	var unit = $("#txtUnit").val();
	var isactive = $("#chkActive").checkbox("getValue")?"1":"0";
	if (code == '') {
		$.messager.popover({msg: '请填写用户工号！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写用户名称！',type: 'alert',timeout: 1000});
		return false;
	}
	if (spell == '') {
		$.messager.popover({msg: '请填写名称拼音！',type: 'alert',timeout: 1000});
		return false;
	}
	if (InternalType == '') {
		$.messager.popover({msg: '请选择医护类型！',type: 'alert',timeout: 1000});
		return false;
	}
	if (CPTDesc == '') {
		$.messager.popover({msg: '请填写医护人员类型名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + isactive;
	inputStr += '^' + spell;
	inputStr += '^' + InternalType;
	inputStr += '^' + CPTDesc;
	inputStr += '^' + unit;
	var flg = $m({
		ClassName:"MA.IPMR.BT.SSUser",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "用户工号重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#userDialog').window("close");
	$("#griduser").datagrid("reload");

}
/**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 对照
 * DATE: 2019-09-29
 * NOTE: 包括方法
 * TABLE: 
 */

 function QueryDpUser(){
	var Alias		= $("#textAlias1").val();
	$('#gridDpUser').datagrid('load',  {
		ClassName : "CT.IPMR.DPS.SSUserSrv",
		QueryName : "QryUser",
		aKeyword:Alias,
		rows:10000
	});
	$('#gridDpUser').datagrid('unselectAll');
}

// 打开对照页面
function OpenMapWin(UserID,UserDesc) {
	var mapColumns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'Code', title: '外部用户工号', width: 80, align: 'left'},
		{field: 'Desc', title: '外部用户名称', width: 120, align: 'left'},
		{field:'IsActive',title:'是否有效',width:80,align:'left',		
			formatter: function(value,row,index){
				var Type  = row["IsActive"];
				if(Type == 1) {
					return $g("是")
				}else {
					return $g("否")
				}	
			}
		},
		{field:'opt',title:'取消对照',width:50,align:'left',
			formatter:function(value,row,index) {
				var MapID = row.MapID;
				/*var btn =  '<img title="取消对照" onclick=UnMap("'+MapID+'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">'   
				return btn;  */
				return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='UnMap(\"" + MapID + "\");'>" + "取消" + "</a>";
			}  
	  }
	]];
	var gridMap= $HUI.datagrid("#gridMap", {
		fit: true,
		title:'已对照用户',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.DPS.SSUserMapSrv",
			QueryName : "QryMapUser",
			aIpmrUserId :UserID
	    },
	    columns : mapColumns
	});
	var Columns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'Code', title: '用户工号', width: 80, align: 'left'},
		{field: 'Desc', title: '用户名称', width: 120, align: 'left'},
		{field:'IsActive',title:'是否有效',width:50,align:'left',
			formatter:function(value,row,index){
				var IsActive	= row.IsActive;
				if (IsActive == '1'){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{field:'opt',title:'对照',width:40,align:'left',
			formatter:function(value,row,index) { 
				var HisUserID = row.UserID;     
                /*var btn =  '<img title="对照" onclick=Map("'+HisUserID+ '","' + UserID +'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn; */
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='Map(\"" + HisUserID + "\",\"" + UserID + "\");'>" + "对照" + "</a>";  
			}  
      	}
	]];
	var gridDpUser= $HUI.datagrid("#gridDpUser", {
		fit: true,
		title:'外部用户',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "CT.IPMR.DPS.SSUserSrv",
			QueryName : "QryUser",
			aKeyword:''
	    },
	    columns : Columns
	});
	var MapDialog = $('#MapDialog').dialog({
	    title: '用户对照-'+UserDesc,
		iconCls: 'icon-w-new',
	    width: 1200,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	return;
}


function Map(HisUserID,UserID) {
	var inputStr = '';
	inputStr += '^' + UserID;
	inputStr += '^' + HisUserID;
	var flg = $m({
		ClassName:"CT.IPMR.DP.SSUserMap",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "重复对照!", 'info');
		}else{
			$.messager.alert("错误", "对照失败!", 'error');
		}
		return;
	}
	$("#gridMap").datagrid("reload");

}

function UnMap(MapID) {
	$.messager.confirm('确认', '确认取消对照该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"CT.IPMR.DP.SSUserMap",
				MethodName:"DeleteById",
				aId:MapID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "取消对照失败!", 'error');
				return;
			}
			$("#gridMap").datagrid("reload");
    	}
    });
}