/**
 * hospital 医院维护
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
	m_gridhosp : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridhosp = Initgridhosp();
}

function InitEvent(){
	$('#c-add').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		edithosp('add');
	});
	$('#c-edit').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		edithosp('edit');
	});
	$('#c-delete').click(function(){
		if ($(this).hasClass("l-btn-disabled")) return;
		deletehosp();
	});
}
 /**
 * NUMS: D001
 * CTOR: LIYI
 * DESC: 医院定义
 * DATE: 2019-09-29
 * NOTE: 包括四个方法：Initgridhosp,edithosp,deletehosp,savehosp
 * TABLE: MA.IPMR.BT.Hospital
 */

 // 初始化表格
function Initgridhosp(){
	var columns = [[
		{field:'HospCode',title:'医院代码',width:100,align:'left'},
		{field:'HospDesc',title:'医院名称',width:100,align:'left'},
		{field:'IsActive',title:'是否有效',width:100,align:'left',
			formatter:function(value,row,index){
				var IsActive	= row.IsActive;
				if (IsActive == '1'){
					return $g("是");
				} else {
					return $g("否");
				}
			}
		},{field:'d',title:'医院对照',width:80,align:'left',
			formatter:function(value,row,index) {
            	var HospID = row.HospID;
				var HospDesc = row.HospDesc;
               	//return '<a href="#" class="grid-td-text-gray" onclick = OpenMapWin("' + HospID + '","' + HospDesc + '")>' + $g('对照') + '</a>';   
               	return '<a href="#" class="grid-td-text-gray" onclick="OpenMapWin(\'' + HospID+'\',\''+ HospDesc + '\')">'+ $g('对照') +'</a>';         
            }
		}
    ]];
	var gridhosp =$HUI.datagrid("#gridhosp",{
		fit: true,
		//title: "医院维护",
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
		    ClassName:"MA.IPMR.BTS.HospitalSrv",
			QueryName:"QryHosp",
			aIsActive:"",
			aHospId:""
	    },
	    columns :columns,
		/*
		toolbar:[{
				text:'新增',
				id:'c-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'c-edit',
				iconCls: 'icon-edit'
			},{
				text:'删除',
				id:'c-delete',
				iconCls: 'icon-cancel'
			}
			
		],*/
		onClickRow:function(rowIndex,rowData){
			
		}
	});
	return gridhosp;
}

// 新增、修改事件
function edithosp(op){
	var selected = $("#gridhosp").datagrid('getSelected');
	if (( op == "edit")&&(!selected)) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	
	var _title = "修改医院定义",_icon="icon-w-edit"
	if (op == "add") {
		_title = "添加医院定义",_icon="icon-w-add";
		$("#txtId").val('');
		$("#txtCode").val('');
		$("#txtDesc").val('');
		$("#chkActive").checkbox("setValue",false);
	} else {
		$("#txtId").val(selected.HospID);
		$("#txtCode").val(selected.HospCode);
		$("#txtDesc").val(selected.HospDesc);
		$("#chkActive").checkbox("setValue",selected.IsActive=='1'?true:false);
	}

	var hospDialog = $HUI.dialog('#hospDialog', {
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
					savehosp();
				}
		},{
		text:'关闭',
		iconCls:'icon-w-close',
		handler:function(){
				$('#hospDialog').window("close");
			}	
		}]
	});
}

// 删除事件
function deletehosp(){

	var selected = $("#gridhosp").datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: '请选择一条记录！',type: 'alert',timeout: 1000});
		return false;
	}
	$.messager.confirm('确认', '确认删除该条数据?', function(r){
    	if (r){
    		var flg = $m({
				ClassName:"MA.IPMR.BT.Hospital",
				MethodName:"DeleteById",
				aId:selected.ID
			},false);
			
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "删除失败!", 'error');
				return;
			}
			$("#gridhosp").datagrid("reload");
    	}
    });
}

// 保存操作
function savehosp(){
	var id = $("#txtId").val();
	var code = $("#txtCode").val();
	var desc = $("#txtDesc").val();
	var IsActive = $("#chkActive").checkbox("getValue")?"1":"0";
	if (code == '') {
		$.messager.popover({msg: '请填写医院代码！',type: 'alert',timeout: 1000});
		return false;
	}
	if (desc == '') {
		$.messager.popover({msg: '请填写医院名称！',type: 'alert',timeout: 1000});
		return false;
	}
	var inputStr = id;
	inputStr += '^' + code;
	inputStr += '^' + desc;
	inputStr += '^' + IsActive;

	var flg = $m({
		ClassName:"MA.IPMR.BT.Hospital",
		MethodName:"Update",
		aInputStr:inputStr,
		aSeparate:"^"
	},false);
	
	if (parseInt(flg) <= 0) {
		if (parseInt(flg)==-100){
			$.messager.alert("提示", "医院代码重复!", 'info');
		}else{
			$.messager.alert("错误", "保存失败!", 'error');
		}
		return;
	}
	$('#hospDialog').window("close");
	$("#gridhosp").datagrid("reload");

}

 /**
 * NUMS: D002
 * CTOR: LIYI
 * DESC: 医院对照
 * DATE: 2019-09-29
 * NOTE: 包括方法
 * TABLE: 
 */
// 打开对照页面
function OpenMapWin(hospid,HospDesc) {
	var mapColumns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'HospCode', title: '医院代码', width: 80, align: 'left'},
		{field: 'HospDesc', title: '医院名称', width: 120, align: 'left'},
		{field:'opt',title:'取消对照',width:50,align:'left',
			formatter:function(value,row,index) {
				var MapID = row.MapID;
				/*var btn =  '<img title="取消对照" onclick=UnMap("'+MapID+'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">'   
				return btn; */ 
				return "<a href='#' style='white-space:normal;color:#FB7D00' onclick='UnMap(\"" + MapID + "\");'>" + "取消" + "</a>";
			}  
	  }
	]];
	var gridMap= $HUI.datagrid("#gridMap", {
		fit: true,
		title:'已对照医院',
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
		    ClassName : "CT.IPMR.DPS.HospitalMapSrv",
			QueryName : "QryMapHosp",
			aIpmrHospId :hospid
	    },
	    columns : mapColumns
	});
	var Columns = [[
		{field: 'SysDesc', title: '系统名称', width: 80, align: 'left'},
		{field: 'HospCode', title: '医院代码', width: 80, align: 'left'},
		{field: 'HospDesc', title: '医院名称', width: 120, align: 'left'},
		{field:'IsActive',title:'是否有效',width:40,align:'left',
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
				var HospID = row.HospID;     
                /*var btn =  '<img title="对照" onclick=Map("'+HospID+ '","' + hospid +'") src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">'   
				return btn;*/
				return "<a href='#' style='white-space:normal;color:#229A06' onclick='Map(\"" + HospID + "\",\"" + hospid + "\");'>" + "对照" + "</a>"; 
			}  
      	}
	]];
	var gridDpHosp= $HUI.datagrid("#gridDpHosp", {
		fit: true,
		title:'第三方医院',
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
		    ClassName : "CT.IPMR.DPS.HospitalSrv",
			QueryName : "QryHosp"
	    },
	    columns : Columns
	});
	var MapDialog = $('#MapDialog').dialog({
	    title: '医院对照-'+HospDesc,
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

function Map(HospID,hospid) {
	var inputStr = '';
	inputStr += '^' + hospid;
	inputStr += '^' + HospID;
	var flg = $m({
		ClassName:"CT.IPMR.DP.HospitalMap",
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
				ClassName:"CT.IPMR.DP.HospitalMap",
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