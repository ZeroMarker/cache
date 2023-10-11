/**
 * dhcant.kss.config.function.app.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: ""
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})

function Init(){
	if ($.fn.datagrid){
		$.fn.datagrid.defaults.pageSize = 20;
		$.fn.datagrid.defaults.pageList = [20,30,50];
	}
	
	PageLogicObj.m_Grid = InitGrid();
	InitCache();
}
function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitEvent(){
	$("#i-add").click(addOSPara);
	$("#i-edit").click(editOSPara)
	//搜索
	$(".searchbox-button").on("click", function () {
		reloadGrid();
	});
	$(".searchbox-text").keydown(function (event) {
		if (event.which == 13 || event.which == 9) {
			reloadGrid();
		}
	});
	$("#i-export").on("click", function(){
		var rtn = $cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:'ANT-Config',
			ClassName:'DHCAnt.KSS.Config.Function',
			QueryName:'QryOSPara',
			parentCode: "PARAMATER"
		}, false);
		window.location.href = rtn;
	})
}

function PageHandle(){
	//
}

function InitGrid(){
	var columns = [[
			{field:'type',title:'配置类型',width:100,hidden:true},
			{field:'parCode',title:'父级代码',width:80,hidden:true},
			{field:'code',title:'配置代码',width:100},
			{field:'mcgDesc',title:'配置名称',width:150},
			{field:'controlValue',title:'配置数值',width:60,
				 formatter:function(value , record , index){
					if(value == "0"){
					   return '<span style=color:red; >' + value + '</span>' ;
					} else{
					   return '<span style=color:green; >' + value + '</span>' ; 
					}
				 }
			},
			{field:'mcgNoteB',title:'配置描述',width:250},
			{field:'active',title:'是否激活',width:60,hidden:true,
				formatter:function(value , record , index){
					if(value == "1"){
					   return '<span style=color:green; >' + value + '</span>' ;
					} else{
					   return '<span style=color:red; >' + value + '</span>' ; 
					}
				 }
			},
			{field:'id',title:'id',width:100,hidden:true}
		]];
			
	var DataGrid = $HUI.datagrid("#i-grid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.Function",
			QueryName : "QryOSPara",
			parentCode: ServerObj.type,
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:"#tb",
		onBeforeSelect:function(index, row){
			var selrow = DataGrid.getSelected();
			if (selrow){
				var oldIndex = DataGrid.getRowIndex(selrow);
				if (oldIndex==index){
					DataGrid.unselectRow(index);
					return false;
				}
			}
		}
	});
	
	return DataGrid;
}

function editOSPara() {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected){
		//layer.alert("请选择一条记录", {title:'提示',icon: 0}); 
		$.messager.alert("提示","请选择一条记录！","warning")
		return false;
	};
	if($('#i-config').hasClass("c-hidden")) {
		$('#i-config').removeClass("c-hidden");
	};
	$("#i-tab-para-center-active").localcombobox({
		disabled:true,
		data:[{id: '1', text: '是'}, {id: '0',text: '否'}]
	})
	$("#i-config input[name='id']").val(selected.id);
	$("#i-config input[name='action']").val("update");
	$("#i-config input[name='type']").val(selected.type).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');
	$("#i-config input[name='parCode']").val(selected.parCode).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');
	$("#i-config input[name='code']").val(selected.code).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');
	$("#i-config input[name='desc']").val(selected.mcgDesc).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');;
	$("#i-config input[name='value']").val($.trim(selected.controlValue));
	$("#i-config input[name='mcgNoteB']").val($.trim(selected.mcgNoteB));
	$("#i-tab-para-center-active").localcombobox("setValue", selected.active);
	
	$('#i-config').window({
		title: '修改配置',
		modal: true,
		iconCls:'icon-w-edit',
		minimizable:false,
		collapsible:false,
		maximizable:false,
		onClose: function () {
			$('#i-config').addClass("c-hidden");
		},
		onMaximize:function(){
			$.each($(".c-config > input"), function(){
				//$(this).css("width","500px");
			
			})
		}
	});
}
function addOSPara() {
	var SettingOBJ={};
		SettingOBJ.defaultType="";
		SettingOBJ.defaultParCode="";
		DHCANTConfig.setDefaultType(SettingOBJ,ServerObj.type);
	if($('#i-config').hasClass("c-hidden")) {
		$('#i-config').removeClass("c-hidden");
	};
	$("#i-tab-para-center-active").localcombobox({
		data:[{id: '1', text: '是'}, {id: '0',text: '否'}]
	});
	$("#i-config input[name='action']").val("add");
	if (SettingOBJ.defaultType != "") {
		$("#i-config input[name='type']").val(SettingOBJ.defaultType).attr("readonly",true).attr("disabled","disabled").css('background','#FFFAF0');	//#FFFAF0
		$("#i-config input[name='parCode']").val(SettingOBJ.defaultParCode).attr("readonly",true).attr("disabled","disabled").css('background','#FFFAF0');
	} else {
		$("#i-config input[name='type']").val(SettingOBJ.defaultType);
		$("#i-config input[name='parCode']").val(SettingOBJ.defaultParCode);
	}
	$("#i-config input[name='id']").val("");
	$("#i-config input[name='code']").val("");
	$("#i-config input[name='desc']").val("");
	$("#i-config input[name='mcgNoteB']").val("");
	$("#i-config input[name='value']").val("");
	$('#i-config').window({
		title: '添加配置',
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
function save(){
	var id = $("#i-config input[name='id']").val();
	var type = $("#i-config input[name='type']").val();
	var parCode = $("#i-config input[name='parCode']").val();
	var code = $("#i-config input[name='code']").val();
	var desc = $("#i-config input[name='desc']").val();
	var value = $.trim($("#i-config input[name='value']").val());
	var mcgNoteB = $("#i-config input[name='mcgNoteB']").val();
	var active = $("#i-tab-para-center-active").localcombobox('getValue')||"";
	var action = $("#i-config input[name='action']").val();
	if( $.trim(code) =="") {
		//layer.alert("配置代码不能为空！", {title:'提示',icon: 0}); 
		$.messager.alert("提示","配置代码不能为空！","warning")
		return false;
	}
	if (active == "") {
		//layer.alert("激活标志不能为空！", {title:'提示',icon: 0}); 
		$.messager.alert("提示","激活标志不能为空！","warning")
		return false;
	}
	
	var rtn = $.m({
			ClassName:"DHCAnt.KSS.Config.Function",
			MethodName:"DBUpdataMainConfig",
			MCGRowId: id,
			MCGType: $.trim(type),
			MCGParentCode: $.trim(parCode),
			MCGCode: $.trim(code),
			MCGDesc: desc,
			MCGActive: active,
			MCGDateFrom: "",
			MCGDateTo: "",
			MCGControlType: "1",
			MCGControlValue: value,
			MCGProcessNext: "",
			MCGStrB: mcgNoteB,
			MCGStrC: "",
			MCGStrD: ""
		},false);
	//var rtn=$.InvokeMethod("DHCAnt.KSS.Config.Function","DBUpdataMainConfig", id, $.trim(type), $.trim(parCode), $.trim(code), desc, active, "", "", "", value, "", mcgNoteB, "", "");
	if (rtn == "-1") {	
		//layer.alert("配置代码已经存在！", {title:'提示',icon: 0}); 
		$.messager.alert("提示","配置代码已经存在！","warning")
		return false;
	};
	if (rtn == "-2") {
		//layer.alert("配置代码不能为空！", {title:'提示',icon: 0}); 
		$.messager.alert("提示","配置代码不能为空！","warning")
		return false;
	};
	if (action=="add"){
		//layer.alert("添加成功...", {title:'提示',icon: 1}); 
		$.messager.alert("提示","新增成功！","success")
	} else {
		$.messager.alert("提示","修改成功！","success")
	}
	reloadGrid();
	PageLogicObj.m_Grid.clearSelections();
	$('#i-config').window('close');
	return false;
}
 
function reloadGrid() {
	var inValue = $(".searchbox-text").val();
	PageLogicObj.m_Grid.reload({
		ClassName:"DHCAnt.KSS.Config.Function",
		QueryName:"QryOSPara",
		parentCode:ServerObj.type,
		inValue:inValue
	});
};

 