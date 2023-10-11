/**
 * Security 菜单授权
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
	m_gridGroup : ''
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	globalObj.m_gridGroup = InitgridGroup();
	InitMenusTree();
	InitOperTree();
}

function InitEvent(){
	$("#c-search").click(function(){
		var InputStr=$("#search").val();
		$("#gridGroup").datagrid('load',
		{
			ClassName:"MA.IPMR.BTS.SSGroupSrv",
			QueryName:"QuerySSGroup",
			aAlias:InputStr
		});
		$('#menusTree').treegrid('clearChecked');
	});

	$("#btnSave").click(function(){
		var o = $('#menusTree').treegrid('getCheckedNodes','checked');
		alert(o)
	});


}

 // 初始化安全组表格
function InitgridGroup(){
	var columns = [[
		{field:'GroupDesc',title:'描述',width:200,align:'left'}
    ]];
	var gridGroup =$HUI.datagrid("#gridGroup",{
		fit: true,
		title: "安全组",
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
		    ClassName:"MA.IPMR.BTS.SSGroupSrv",
			QueryName:"QuerySSGroup",
			aAlias:""
	    },
	    columns :columns,
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) { 
				// 处理菜单权限
				$m({
					ClassName:"MA.IPMR.BTS.SecritySrv",
					MethodName:"GetSecrity",
					aGroupId:rowData.ID
				},function(txtData){
					$('#menusTree').treegrid('clearChecked');
					var arrSecrity = txtData.split('^');
					for (var i = 0;i<arrSecrity.length ;i++ )
					{
						if (arrSecrity[i]=='') continue;
						$('#menusTree').treegrid('checkNode',arrSecrity[i]);
					}
				});
				// 处理安全组权限
				$m({
					ClassName:"MA.IPMR.BTS.SecritySrv",
					MethodName:"GetSecrityOper",
					aGroupId:rowData.ID
				},function(txtData){
					$('#operTree').treegrid('clearChecked');
					var arrSecrity = txtData.split('^');
					for (var i = 0;i<arrSecrity.length ;i++ )
					{
						if (arrSecrity[i]=='') continue;
						$('#operTree').treegrid('checkNode',arrSecrity[i]);
					}
				});
			}
		}
	});
	return gridGroup;
}

 // 初始化菜单树
function InitMenusTree() {
	var menusTree = $HUI.treegrid("#menusTree",{
        url:$URL,
		fitColumns:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		autoSizeColumn:false,
		checkbox:true,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.MenusSrv",
			QueryName:"QueryMenus"
	    },
        idField:'ID',
        treeField:'Desc',
        columns:[[
    		{title:'名称',field:'Desc',width:250},
    		{title:'目标地址',field:'LinkUrl',width:450}
        ]],
		onBeforeCheckNode:function(row,checked){
			var selectGroup = $('#gridGroup').datagrid('getSelected');
			if (!selectGroup) {
				$.messager.alert("提示","请选择安全组...","info")
				return false;
			}
		},
		onCheckNode:function(row,checked){
			var selectGroup = $('#gridGroup').datagrid('getSelected');
			var groupid = selectGroup.ID;
			var menuId	= row.ID;
			var authority = (checked?1:0);
			
			var flg = $m({
				ClassName:"MA.IPMR.BT.Security",
				MethodName:"UpdateSecurity",
				aGroupId:groupid,
				aMenuId:menuId,
				aAuthority:authority
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "操作失败!", 'error');
				return;
			}
		}
	});
}

 // 初始化操作树
function InitOperTree() {
	var operTree = $HUI.treegrid("#operTree",{
        url:$URL,
		fitColumns:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		autoSizeColumn:false,
		checkbox:true,
		queryParams:{
		    ClassName:"CT.IPMR.BTS.MenusSrv",
			QueryName:"QueryMenuOper"
	    },
        idField:'ID',
        treeField:'OperaName',
        columns:[[
    		{title:'名称',field:'OperaName',width:250}
        ]],
		onBeforeCheckNode:function(row,checked){
			var selectGroup = $('#gridGroup').datagrid('getSelected');
			if (!selectGroup) {
				$.messager.alert("提示","请选择安全组...","info")
				return false;
			}
		},
		onCheckNode:function(row,checked){
			var selectGroup = $('#gridGroup').datagrid('getSelected');
			var groupid = selectGroup.ID;
			var menuOperId	= row.ID;
			var authority = (checked?1:0);
			MenuOperId = menuOperId!=''?menuOperId.split('-')[0]+'||'+menuOperId.split('-')[1]:'';
			var flg = $m({
				ClassName:"MA.IPMR.BT.SecurityOper",
				MethodName:"UpdateSecurity",
				aGroupId:groupid,
				aMenuOperId:MenuOperId,
				aAuthority:authority
			},false);
			if (parseInt(flg) <= 0) {
				$.messager.alert("错误", "操作失败!", 'error');
				return;
			}
		}
	});
}