/*
* @author: yaojining
* @discription: 护理病历知识库护理记录引用
* @date: 2020-04-27
*/
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_ReferRecord'
};

$(initUI);

/**
* @description: 初始化界面
*/
function initUI() {
	initHosp(function(){
		initSearchCondition();
		initEffictTemplateTree();
		initTemplateElementGrid();
		initReferElementGrid();
	});
	listenEvents();
}
/**
* @description: 初始化查询条件
*/
function initSearchCondition() {
	$HUI.combogrid("#comboDepartment", {
		url: $URL,
		queryParams:{
			ClassName: "NurMp.Common.Base.Hosp",
			QueryName: "FindHospLocs"
		},
		mode:'remote',
		idField: 'LocId',
		textField: 'LocDesc',
		columns: [[
			//{field:'Checkbox',title:'sel',checkbox:true},
			{field:'LocDesc',title:'名称',width:100},
			{field:'HospDesc',title:'院区',width:100},
			{field:'LocId',title:'ID',width:40}
		]],
		multiple:false,
		singleSelect:true,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		pagination : true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			var desc = "";
			if (param['q']) {
				desc=param['q'];
			}
			param = $.extend(param,{HospitalID:GLOBAL.HospitalID, ConfigTableName:"Nur_IP_TemplateFilter", SearchDesc: desc});
			return true;
		},
		onLoadSuccess:function(){
		},
		onSelect: function(record) {
			$('#btnSearch').click();
		},
	});	
	$('#searchTemplate').searchbox({
		searcher: function(value) {
			$HUI.tree('#effictTemplateTree','reload');
		},
		prompt: '模板名称、关键字'
	});
}
/**
* @description: 重新加载科室
*/ 
 function reloadLocs() {
	$('#comboDepartment').combogrid('grid').datagrid('reload', {
		ClassName: "NurMp.Common.Base.Hosp",
		QueryName: "FindHospLocs",
		HospitalID: GLOBAL.HospitalID,
		ConfigTableName: "Nur_IP_ReferRecord",
		SearchDesc: ""
	});
}
/**
* @description: 初始化所有模板表格
*/ 
function initEffictTemplateTree() {
	$HUI.tree('#effictTemplateTree', {
		loader: function(param, success, error) {
			$cm({
				ClassName: "NurMp.Service.Template.Directory",
				MethodName: "getTemplates",
				HospitalID: GLOBAL.HospitalID,
				TypeCode: 'L',
				LocID: $('#comboDepartment').combobox('getValue'),
				FilterFlag: '',
				TemplateName: $HUI.searchbox('#searchTemplate').getValue(),
			}, function(data) {
				var addIDAndText = function(node) {
					if (!node.locFlag) {
						node.text = node.text + '  【全院】' ;
					}else {
						node.text = node.text + '  【科室】' ;
					}
				}
				data.forEach(addIDAndText);
				success(data);
			});
		},
		//lines: true,
		autoNodeHeight: true,
		onClick: function (node) {
			if (!!node.guid) {
				initTemplateElementGrid(node.guid);
				initReferElementGrid(node.guid);
			}
		}
	});
}
/**
* @description: 初始化元素表格
*/ 
function initTemplateElementGrid(guid) {
	$HUI.datagrid('#templateElementGrid',{
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Refer.Record",
			QueryName: "GetEmrElement",
			Guid: guid,
			HospitalID: GLOBAL.HospitalID,
			LocID: $('#comboDepartment').combobox('getValue'),
			LRFlag: 1
		},
		columns:[[
			{field:'ElementLabel',title:'元素描述',width:150},
			{field:'ItemKey',title:'关键字',width:100},
			{field:'ElementCode',title:'元素代码',width:200},
			{field:'Guid',title:'GUID',width:250}
		]],
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		rownumbers:true,
		singleSelect:true,
		width:500,
		toolbar: [{
			id: 'btnAddElement',
			iconCls: 'icon-arrow-right',
			text:'添加到自定义引用模板',
			handler: addElementToConfig
		}]
	});	
}
/**
* @description: 初始化引用元素表格
*/ 
function initReferElementGrid(guid) {
	$HUI.datagrid('#referElementGrid',{
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Refer.Record",
			QueryName: "FindReferElements",
			Code: guid,
			HospitalID: GLOBAL.HospitalID,
			LocID: $('#comboDepartment').combobox('getValue')
		},
		columns:[[
			{field:'FrontNote',title:'前缀',width:150},
			{field:'ElementLabel',title:'元素描述',width:150},
			{field:'BackNote',title:'后缀',width:200},
			{field:'ValueType',title:'引用类型',width:100},
			{field:'ItemKey',title:'关键字',width:100},
			{field:'ElementCode',title:'元素描述',width:150},
			{field:'Guid',title:'模板Guid',width:200},
			{field:'Id',title:'ID',width:20}
		]],
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		rownumbers:true,
		singleSelect:true,
		width:500,
		toolbar: [{
			id: 'btnSave',
			iconCls: 'icon-save',
			text:'修改',
			handler: modify
		},{
			id: 'btndelete',
			iconCls: 'icon-remove',
			text:'删除',
			handler: remove
		}],
		onDblClickRow: modify
	});	
}
/**
* @description: 添加元素
*/ 
function addElementToConfig() {
	var row = $('#templateElementGrid').datagrid('getSelections');
	if (row.length == 0) {
		$.messager.popover({ msg: '请选择数据行！', type: 'alert' , timeout: 1000});
		return ;
	}
	$HUI.combobox('#valueType', {
		valueField: 'id',
		textField: 'text',
		value: 2,
		data:[
			{id:1, text:"NumberValue"},
			{id:2, text:"Text"},
			{id:3, text:"Value"}
		],
		defaultFilter:4
	});
	$HUI.dialog('#referDialog',{
		title: '添加引用元素',
		width:400,
		height:340,
		iconCls:'icon-save',
		resizable:false,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				save();
			}
			},{
				text:'取消',
				handler:function(){
					$HUI.dialog('#referDialog').close();
				}
			}
		]
	});
	$.each(row[0],function(key,value){    //objTmp对象数据
		var domID = key.replace(key[0],key[0].toLowerCase());
		if ($('#' + domID).length) {
			$('#'+domID).val(value);
		}
	});
	$('#elementLabel').attr('disabled',true);
	$('#itemKey').attr('disabled',true);
	$('#guid').attr('disabled',true);
	$('#elementCode').attr('disabled',true);
	$('#frontNote').val('');
	$('#backNote').val('');
}
/**
* @description: 修改
*/ 
function modify() {
	var row = $('#referElementGrid').datagrid('getSelections')[0];
	if (row.length == 0) {
		$.messager.popover({ msg: '请选择数据行！', type: 'alert' , timeout: 1000});
		return ;
	}
	$HUI.combobox('#valueType', {
		valueField: 'id',
		textField: 'text',
		value: 2,
		data:[
			{id:1, text:"NumberValue"},
			{id:2, text:"Text"},
			{id:3, text:"Value"}
		],
		defaultFilter:4
	});
	$HUI.dialog('#referDialog',{
		title: '引用元素修改',
		width:400,
		height:340,
		iconCls:'icon-save',
		resizable:false,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				save(row.Id);
			}
			},{
				text:'取消',
				handler:function(){
					$HUI.dialog('#referDialog').close();
				}
			}
		]
	});
	$.each(row,function(key,value){  
		var domID = key.replace(key[0],key[0].toLowerCase());
		if ($('#' + domID).length) {
			var domType = $('#' + domID).attr('class');
	        if (!!domType) {
	        	if (domType.indexOf('combobox') > -1) {
		        	$('#' + domID).combobox('setText', value);
		        } else if (domType.indexOf('textbox') > -1){
		        	$('#' + domID).val(value);
		        } else {}
			}
		}
	});
	$('#elementLabel').attr('disabled',true);
	$('#itemKey').attr('disabled',true);
	$('#guid').attr('disabled',true);
	$('#elementCode').attr('disabled',true);
}
/**
* @description: 保存
*/ 
function save(id) {
	$cm({
		ClassName: "NurMp.Service.Refer.Record",
		MethodName: "save",
		ID:id,
		HospitalID: GLOBAL.HospitalID,
		LocID: $('#comboDepartment').combobox('getValue'),
		Guid: $('#guid').val(),
		ElementLabel: $('#elementLabel').val(),
		ElementCode: $('#elementCode').val(),
		ItemKey: $('#itemKey').val(),
		FrontNote: $('#frontNote').val(),
		BackNote: $('#backNote').val(),
		ValueType: $('#valueType').combobox('getText'),
		UserID: session['LOGON.USERID']
	}, function(ret) {
		if (ret == '0') {
			
			if(typeof id =="undefined"){
				$.messager.popover({ msg: '添加成功！', type: 'success' , timeout: 1000});
			}else{
				$.messager.popover({ msg: '修改成功！', type: 'success' , timeout: 1000});
			}
			
			$HUI.dialog('#referDialog','close');
			$('#referElementGrid').datagrid('reload');
		}else {
			$.messager.popover({ msg: '添加失败！' + ret, type: 'error' , timeout: 1000});
			return;
		}
	});
}
/**
* @description: 删除
*/ 
function remove() {
	var row = $('#referElementGrid').datagrid('getSelections')[0];
	if (row.length == 0) {
		$.messager.popover({ msg: '请选择数据行！', type: 'alert' , timeout: 1000});
		return ;
	}
	$cm({
		ClassName: "NurMp.Service.Refer.Record",
		MethodName: "delete",
		ID: row.Id
	}, function(ret) {
		if (ret == '0') {
			$.messager.popover({ msg: '删除成功！', type: 'success' , timeout: 1000});
			$('#referElementGrid').datagrid('reload');
		}else {
			$.messager.popover({ msg: ret, type: 'error' , timeout: 1000});
			return;
		}
	});
}
/**
* @description: 事件监听
*/ 
function listenEvents() {
	$('#btnSearch').bind('click', function(e) {
		initEffictTemplateTree();
		initTemplateElementGrid();
		initReferElementGrid();
	});
}
