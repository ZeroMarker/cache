/**
 * dhcant.kss.config.function.app.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
$(function(){
	var products = ANT.DHC.getProcessDep();
	var hospGrid = InitGrid();
	
	function InitGrid(){
		var columns = [[
			{field:'text',title:'院区',width:100},
			{field:'id',title:'id',width:100,hidden:true}
		]]
		var DataGrid = $HUI.datagrid("#i-hosp", {
			fit : true,
			border : true,
			striped : true,
			singleSelect : true,
			fitColumns : true,
			rownumbers:false,
			//autoRowHeight : false,
			//pagination : true,  
			headerCls:'panel-header-gray',
			//pageSize:14,
			//pageList : [14,20,50],
			url:$URL,
			queryParams:{
				ClassName : "DHCAnt.KSS.Config.Authority",
				QueryName : "QryHosp"
			},
			columns :columns
		});
		
		return DataGrid;
	}

	$('#i-tab-process').simpledatagrid({
		pagination:true,
		//title:'流程配置项',
		headerCls:'panel-header-gray',
		iconCls:'fa fa-gavel',
		singleSelect:true,
		queryParams: {
			ClassName:"DHCAnt.KSS.Config.Function",
			QueryName:"QryProcessConfig",
			ModuleName:"datagrid",
			Arg1:"",
			ArgCnt:1
		},
		idField:"id",
		columns:[[
			{field:'ParentCode',title:'流程类型代码',width:100,hidden:true},
			{field:'ParentDesc',title:'流程类型描述',width:150},
			{field:'MCGType',title:'配置类型代码',width:100,hidden:true},
			{field:'CodeF',title:'是否科室预审',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeH',title:'是否会诊',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeS',title:'是否科室审核',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeU',title:'是否最终审核',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'ULocID',title:'最终审核科室',width:100,
				formatter:function(value){
					for(var i=0; i<products.length; i++){
						if (products[i].id == value) return products[i].desc;
					}
					return value;
				},
				editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'desc',
						data:products,
						required:false
					}
				}
			},
			{field:'id',title:'id',width:100,hidden:true},
			{field:'action',title:'操作',width:50,align:'center',
				formatter:function(value,row,index){
					var listId = "#i-tab-process";
					if (row.editing){
						var s = '<span style="cursor:pointer;" onclick="ANT.saveGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/27-save.png" /></span>&nbsp;&nbsp;';
						var c = '<span style="cursor:pointer;" onclick="ANT.cancelGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/26-no.png" /></span>';
						return s + c;
					} else {
						var e = '<span style="cursor:pointer;" onclick="ANT.editGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/28-edit.png" /></span> ';
						return e;
					}
				}
			}
		]],
		onLoadSuccess:function(data){  
			//var eds = $('#i-tab-process').datagrid('getEditors',index);  
			//$(eds[0].target).bind('click',function(){  
			//});
			/*
			$(".datagrid-header-check").html("");
			 if (data.rows.length > 0) {
                 for (var i = 0; i < data.rows.length; i++) {
                    $("input[type='checkbox']").remove();
                 }
			 }*/
		},
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		onBeforeEdit:function(index,row){
			row.editing = true;
			ANT.updateGridActions(index, "#i-tab-process");
		},
		onAfterEdit:function(index,row){
			row.editing = false;
			ANT.updateGridActions(index, "#i-tab-process");
			var selected = $('#i-tab-process').simpledatagrid('getSelected');
			if (!selected){
				layer.alert("请选择一条记录", {title:'提示',icon: 0}); 
				return false;
			};
			if ($.trim(selected.CodeU) == "1") {
				if (($.trim(selected.ULocID) == "")||(!selected.ULocID)) {
					layer.alert("流程中包含最终审核，必须要维护最终审核科室！", {title:'提示',icon: 0}); 
					
					$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
					return false;
				}
			} 
			var type = selected.MCGType;
			var parCode = selected.ParentCode;
			var processStr=selected.CodeF + "^" + selected.CodeH + "^" + selected.CodeS + "^" + selected.CodeU;
			var loc = selected.ULocID||"";
			if ((selected.CodeF == 0) && (selected.CodeH == 0) && (selected.CodeS == 0) && (selected.CodeU == 0)) {
				layer.alert("至少配置一个流程步骤！", {title:'提示',icon: 2});
				//$.messager.alert("提示", "保存失败", "error");
				$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
				return false;
			};
			//var rtn=$.InvokeMethod("DHCAnt.KSS.Config.Function","DBInsertProcessConfig", type, parCode, processStr, loc);
			var result = $m({
				ClassName:"DHCAnt.KSS.Config.Function",
				MethodName:"DBInsertProcessConfig",
				type:type,
				ParentCode:parCode,
				valueStr:processStr,
				loc:loc
			},false);
			
			if (result == "0") {
				layer.alert("保存成功！", {title:'提示',icon: 1}); 
			} else {
				layer.alert("保存失败！", {title:'提示',icon: 2});
			};
			$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
			return false;
				
		},
		onCancelEdit:function(index,row){
			row.editing = false;
			ANT.updateGridActions(index, "#i-tab-process");
		}
	});
})