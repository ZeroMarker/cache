/**
 * func.center.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2019-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-05-30
 * 
 */
$(function(){
	$('#i-tab-para-center').simpledatagrid({
		queryParams: {
			ClassName:"DHCAnt.KSS.Config.Function",
			QueryName:"QryFuncConfigByParentCode",
			ModuleName:"datagrid",
			Arg1:type,
			ArgCnt:1
		},
		singleSelect:true,
		border:false,
	toolbar:"#tb",
	toolbars:[{
				text:'�޸�',
				iconCls: 'icon-edit',
				handler: function(){
					
				}
			},{
				text:'����',
				iconCls: 'icon-add',
				handler: function(){
					
					
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
			{field:'type',title:'��������',width:100,hidden:true},
			{field:'parCode',title:'��������',width:80,hidden:true},
			{field:'code',title:'���ô���',width:100},
			{field:'mcgDesc',title:'��������',width:150},
			{field:'controlValue',title:'������ֵ',width:60,
				 formatter:function(value , record , index){
					if(value == "0"){
					   return '<span style=color:red; >' + value + '</span>' ;
					} else{
					   return '<span style=color:green; >' + value + '</span>' ; 
					}
				 }
			},
			{field:'mcgNoteB',title:'��������',width:250},
			{field:'active',title:'�Ƿ񼤻�',width:60,hidden:true,
				formatter:function(value , record , index){
					if(value == "1"){
					   return '<span style=color:green; >' + value + '</span>' ;
					} else{
					   return '<span style=color:red; >' + value + '</span>' ; 
					}
				 }
			},
			{field:'id',title:'id',width:100,hidden:true}
			]]
	});
			
	//�޸�
	$("#i-edit").on("click", function () {
		var selected = $('#i-tab-para-center').simpledatagrid('getSelected');
		if (!selected){
			layer.alert("��ѡ��һ����¼", {title:'��ʾ',icon: 0}); 
			return false;
		};
		if($('#i-config').hasClass("c-hidden")) {
			$('#i-config').removeClass("c-hidden");
		};
		$("#i-tab-para-center-active").localcombobox({
			disabled:true,
			data:[{id: '1', text: '��'}, {id: '0',text: '��'}]
		})
		$("#i-config input[name='id']").val(selected.id);
		$("#i-config input[name='action']").val("update");
		$("#i-config input[name='type']").val(selected.type).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');
		$("#i-config input[name='parCode']").val(selected.parCode).attr("readonly",true).attr("disabled","disabled")	//.css('background','#FFFAF0');
		$("#i-config input[name='code']").val(selected.code).attr("disabled","disabled");
		$("#i-config input[name='desc']").val(selected.mcgDesc);
		$("#i-config input[name='value']").val($.trim(selected.controlValue)).attr("disabled","disabled");
		$("#i-config input[name='mcgNoteB']").val($.trim(selected.mcgNoteB));
		$("#i-tab-para-center-active").localcombobox("setValue", selected.active);
		
		$('#i-config').window({
			title: '�޸�����',
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
	});
	
	//����
	$("#i-add").on("click", function () {
		var SettingOBJ={};
			SettingOBJ.defaultType="";
			SettingOBJ.defaultParCode="";
			DHCANTConfig.setDefaultType(SettingOBJ,type);
		if($('#i-config').hasClass("c-hidden")) {
			$('#i-config').removeClass("c-hidden");
		};
		$("#i-tab-para-center-active").localcombobox({
			disabled:false,
			data:[{id: '1', text: '��'}, {id: '0',text: '��'}]
		});
		$("#i-config input[name='action']").val("add");
		if (SettingOBJ.defaultType != "") {
			$("#i-config input[name='type']").val(SettingOBJ.defaultType).attr("readonly",true).attr("disabled","disabled");	//#FFFAF0
			$("#i-config input[name='parCode']").val(SettingOBJ.defaultParCode).attr("readonly",true).attr("disabled","disabled");
		} else {
			$("#i-config input[name='type']").val(SettingOBJ.defaultType);
			$("#i-config input[name='parCode']").val(SettingOBJ.defaultParCode);
		}
		$("#i-config input[name='id']").val("");
		$("#i-config input[name='code']").val("").removeAttr("disabled");
		$("#i-config input[name='desc']").val("");
		$("#i-config input[name='mcgNoteB']").val("");
		$("#i-config input[name='value']").val("").removeAttr("disabled");
		$('#i-config').window({
			title: '�������',
			modal: true,
			iconCls:'icon-w-add',
			minimizable:false,
			maximizable:false,
			collapsible:false,
			onClose: function () {
				$('#i-config').addClass("c-hidden");
			}
		});
	});
	$("#i-export").on("click", function(){
		var rtn = $cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:'ANT-Config',
			ClassName:'DHCAnt.KSS.Config.Function',
			QueryName:'QryFuncConfigByParentCode',
			parentCode: "PARAMATER"
		}, false);
		window.location.href = rtn;
	})
	//����
	$(".searchbox-button").on("click", function () {
		reloadGrid();
	});
	$(".searchbox-text").keydown(function (event) {
		if (event.which == 13 || event.which == 9) {
			reloadGrid();
		}
	});
	    
	
})
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
		layer.alert("���ô��벻��Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	}
	if (active == "") {
		layer.alert("�����־����Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	}
	var rtn=$.InvokeMethod("DHCAnt.KSS.Config.Function","DBUpdataMainConfig", id, $.trim(type), $.trim(parCode), $.trim(code), desc, active, "", "", "", value, "", mcgNoteB, "", "");
	if (rtn == "-1") {	
		layer.alert("���ô����Ѿ����ڣ�", {title:'��ʾ',icon: 0}); 
		return false;
	};
	if (rtn == "-2") {
		layer.alert("���ô��벻��Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	};
	if (action=="add"){
		layer.alert("��ӳɹ�...", {title:'��ʾ',icon: 1}); 
	} else {
		layer.alert("�޸ĳɹ�...", {title:'��ʾ',icon: 1}); 
	}
	reloadGrid();
	$('#i-tab-para-center').simpledatagrid("clearSelections");
	$('#i-config').window('close');
	return false;
 }
 
 //$('.searchbox ').appendTo('.datagrid-toolbar');
//var $serach = $('<input id="i-search" href="#" class="hisui-searchbox"/>');
//$(".datagrid-toolbar").prepend($serach);
function reloadGrid() {
	var inValue = $(".searchbox-text").val();
	$('#i-tab-para-center').simpledatagrid("reload",{
		ClassName:"DHCAnt.KSS.Config.Function",
		QueryName:"QryFuncConfigByParentCode",
		ModuleName:"datagrid",
		Arg1:type,
		Arg2:inValue,
		ArgCnt:2
	});
};
//�޸�