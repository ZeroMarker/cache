/**
 * basedata.center.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2019-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-05-30
 * 
 */
$(function(){
	var parCodeDisplay = aimItemDisplay = true;
	if (type=="AIMITEM") {
		parCodeDisplay = false
	}
	if (type=="IND") {
		parCodeDisplay = false
	}
	if (type=="AIM") {
		parCodeDisplay = false
		aimItemDisplay = false
	}
	$('#i-tab-para-center').simpledatagrid({
				queryParams: {
					ClassName:"DHCAnt.KSS.Config.BaseData",
					QueryName:"QryAllbasedata",
					ModuleName:"datagrid",
					Arg1:type,
					ArgCnt:1
				},
				border:false,
				singleSelect:true,
				toolbar:[{
						text:'修改',
						iconCls: 'icon-edit',
						handler: function(){
							var selected = $('#i-tab-para-center').simpledatagrid('getSelected');
							if (!selected){
								layer.alert("请选择一条记录", {title:'提示',icon: 0}); 
								return false;
							};
							if($('#i-config').hasClass("c-hidden")) {
								$('#i-config').removeClass("c-hidden");
							};
							$("#i-tab-para-center-active").localcombobox({
								data:[{id: '1', text: '是'}, {id: '0',text: '否'}]
							})
							$("#i-config input[name='id']").val(selected.id);
							$("#i-config input[name='tableType']").val(selected.tableType);
							$("#i-config input[name='tableName']").val(selected.tableName);
							$("#i-config input[name='action']").val("update");
							
							if ((type == "AIMITEM")||(type == "AIM")||(type == "IND")) {
								$HUI.combobox("#i-parCode", {
									url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=OBJ&ResultSetType=array",
									valueField:'id',
									textField:'desc',
									blurValidValue:true,
									onSelect: function (record) {
										var cid = $(this).combobox("getValue")||"";
										if (type == "AIM") {
											var url = $URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&parDr="+ cid +"&ResultSetType=array";
											$("#i-aimItem").combobox("reload",url);
										}								
									},
									onHidePanel: function () {
										if (type == "AIM") {
											var curValue = $(this).combobox("getValue")||"";
											if (curValue == "") {
												var url = $URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&parDr="+ "return" +"&ResultSetType=array";
												$("#i-aimItem").combobox("reload",url);
											}
										}		
									}							
								});	
								if (type == "AIM") {
									$HUI.combobox("#i-aimItem", {
										//url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&ResultSetType=array",
										valueField:'id',
										textField:'desc',
										blurValidValue:true
									});
								} else {
									$("#i-config input[name='aimItem']").val("");
								}
								$("#i-parCode").combobox("select",selected.parCode);
								if (type == "AIM") {
									$("#i-aimItem").combobox("select",selected.aimItem);
								}
									
							} else {
								$("#i-config input[name='parCode']").val(selected.parCode);
								$("#i-config input[name='aimItem']").val(selected.aimItem);
							}

							$("#i-config input[name='code']").val(selected.code);
							$("#i-config input[name='desc']").val(selected.desc);
							$("#i-config input[name='specialFlag']").val(selected.specialFlag);
							$("#i-tab-para-center-active").localcombobox("setValue", selected.active);
							$('#i-config').window({
								title: '修改数据',
								modal: true,
								maximizable:false,
								iconCls:'icon-w-edit',
								minimizable:false,
								collapsible:false,
								onClose: function () {
									$('#i-config').addClass("c-hidden");
								}
							});
							
						}
					},{
						text:'增加',
						iconCls: 'icon-add',
						handler: function(){
							if($('#i-config').hasClass("c-hidden")) {
								$('#i-config').removeClass("c-hidden");
							};
							$("#i-tab-para-center-active").localcombobox({
								data:[{id: '1', text: '是'}, {id: '0',text: '否'}]
							})
							$("#i-config input[name='action']").val("add");
							
							$("#i-config input[name='id']").val("");
							$("#i-config input[name='tableType']").val("");
							$("#i-config input[name='tableName']").val("");
							
							if ((type == "AIMITEM")||(type == "AIM")||(type == "IND")) {
								$HUI.combobox("#i-parCode", {
									url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=OBJ&ResultSetType=array",
									valueField:'id',
									textField:'desc',
									blurValidValue:true,
									onSelect: function (record) {
										if (type == "AIM") {
											var url = $URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&parDr="+ record.id +"&ResultSetType=array";
											$("#i-aimItem").combobox("reload",url);
										}								
									},
									onHidePanel: function () {
										if (type == "AIM") {
											var curValue = $(this).combobox("getValue")||"";
											if (curValue == "") {
												var url = $URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&parDr="+ "return" +"&ResultSetType=array";
												$("#i-aimItem").combobox("reload",url);
											}
										}		
									}
														
								});	
								if (type == "AIM") {
									$HUI.combobox("#i-aimItem", {
										//url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=AIMITEM&ResultSetType=array",
										valueField:'id',
										textField:'desc',
										blurValidValue:true
									});
									$("#i-aimItem").combobox("setValue","")
								} else {
									$("#i-config input[name='aimItem']").val("");
								}
								
								$("#i-parCode").combobox("setValue","");
								if (type == "AIM") {
									$("#i-aimItem").combobox("setValue","");
								}
								
							} else {
								$("#i-config input[name='parCode']").val("");
								$("#i-config input[name='aimItem']").val("");
							}
							
							$("#i-config input[name='code']").val("");
							$("#i-config input[name='desc']").val("");
							$("#i-config input[name='specialFlag']").val("");
							
							$('#i-config').window({
								title: '添加数据',
								modal: true,
								iconCls:'icon-w-add',
								minimizable:false,
								maximizable:false,
								collapsible:false,
								onClose: function () {
									$('#i-config').addClass("c-hidden");
								}
							});
							
						}
					
					}],
			frozenColumns:[
				{field:'ck',checkbox:false}
			],
			onBeforeSelect:function(index, row){
				var selrow=$("#i-tab-para-center").datagrid('getSelected');
				if (selrow){
					var oldIndex=$("#i-tab-para-center").datagrid('getRowIndex',selrow);
					if (oldIndex==index){
						$("#i-tab-para-center").datagrid('unselectRow',index);
						return false;
					}
				}
			},
			columns:[[
					{field:'code',title:'代码',width:100},
					{field:'desc',title:'描述',width:200},
					{field:'parDesc',title:'父级值',width:200,hidden:parCodeDisplay},
					{field:'aimItemDesc',title:'使用目的子类',width:100,hidden:aimItemDisplay},
					{field:'specialFlag',title:'特殊标志',width:100},
					{field:'active',title:'激活',width:100,
						formatter:function(value,row,index){
							if (value == "1") {
								return "<span class='c-ok'>是</span>";
							} else if (value == "0") {
								return "<span class='c-no'>否</span>";
							} else {
								return value;
							}
						}
					},
					{field:'tableType',title:'表类型',width:100,hidden:true},
					{field:'tableName',title:'表描述',width:100,hidden:true},
					{field:'id',title:'id',width:100,hidden:true}
					]]
			});	
	  
	    
	
})
function save(){
	var id = $("#i-config input[name='id']").val();
	var tableType=$("#i-config input[name='tableType']").val();
	var tableName=$("#i-config input[name='tableName']").val();
	var desc = $("#i-config input[name='desc']").val();
	var code = $("#i-config input[name='code']").val();
	var active = $("#i-tab-para-center-active").localcombobox('getValue')||"";
	if (type == "AIM") {
		var parCode = $("#i-parCode").combobox("getValue")||"";
		var aimItem = $("#i-aimItem").combobox("getValue")||"";
	} else if (type == "AIMITEM") {
		var parCode = $("#i-parCode").combobox("getValue")||"";
		var aimItem = $("#i-config input[name='aimItem']").val();
	} else {
		var parCode = $("#i-config input[name='parCode']").val();
		var aimItem = $("#i-config input[name='aimItem']").val();
	}
	var specialFlag = $("#i-config input[name='specialFlag']").val();	
	var action = $("#i-config input[name='action']").val();
	if (tableType == "") tableType = type;
	if (tableName == "") tableName = $.InvokeMethod("DHCAnt.Base.MainConfigExcute","GetOSDesc", type);
	var paraStr = id + "^" + tableType + "^" + tableName + "^" + desc + "^" + code + "^" + active;
	var paraStr = paraStr + "^" + parCode + "^" + aimItem + "^" + specialFlag + "^" + "";
	if( $.trim(code) =="") {
		layer.alert("数据代码不能为空！", {title:'提示',icon: 0}); 
		return false;
	}
	if (active == "") {
		layer.alert("激活标志不能为空！", {title:'提示',icon: 0}); 
		return false;
	}
	var rtn=$.InvokeMethod("DHCAnt.KSS.Config.BaseData","DBSaveBasedata", paraStr);
	if (rtn <= 0) {	
		layer.alert("保存失败!", {title:'提示',icon: 5}); 
		return false;
	};
	if (action=="add"){
		layer.alert("添加成功...", {title:'提示',icon: 1}); 
	} else {
		layer.alert("修改成功...", {title:'提示',icon: 1}); 
	}
	reloadGrid();
	$('#i-config').window('close');
 }
function reloadGrid() {
	$('#i-tab-para-center').simpledatagrid("reload",{
		ClassName:"DHCAnt.KSS.Config.BaseData",
		QueryName:"QryAllbasedata",
		ModuleName:"datagrid",
		Arg1:type,
		ArgCnt:1
	});
}