/*
* @author: yaojining
* @discription: ������֪ʶ�⻤���¼����
* @date: 2020-04-27
*/
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_ReferRecord'
};

$(initUI);

/**
* @description: ��ʼ������
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
* @description: ��ʼ����ѯ����
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
			{field:'LocDesc',title:'����',width:100},
			{field:'HospDesc',title:'Ժ��',width:100},
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
		prompt: 'ģ�����ơ��ؼ���'
	});
}
/**
* @description: ���¼��ؿ���
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
* @description: ��ʼ������ģ����
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
						node.text = node.text + '  ��ȫԺ��' ;
					}else {
						node.text = node.text + '  �����ҡ�' ;
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
* @description: ��ʼ��Ԫ�ر��
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
			{field:'ElementLabel',title:'Ԫ������',width:150},
			{field:'ItemKey',title:'�ؼ���',width:100},
			{field:'ElementCode',title:'Ԫ�ش���',width:200},
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
			text:'��ӵ��Զ�������ģ��',
			handler: addElementToConfig
		}]
	});	
}
/**
* @description: ��ʼ������Ԫ�ر��
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
			{field:'FrontNote',title:'ǰ׺',width:150},
			{field:'ElementLabel',title:'Ԫ������',width:150},
			{field:'BackNote',title:'��׺',width:200},
			{field:'ValueType',title:'��������',width:100},
			{field:'ItemKey',title:'�ؼ���',width:100},
			{field:'ElementCode',title:'Ԫ������',width:150},
			{field:'Guid',title:'ģ��Guid',width:200},
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
			text:'�޸�',
			handler: modify
		},{
			id: 'btndelete',
			iconCls: 'icon-remove',
			text:'ɾ��',
			handler: remove
		}],
		onDblClickRow: modify
	});	
}
/**
* @description: ���Ԫ��
*/ 
function addElementToConfig() {
	var row = $('#templateElementGrid').datagrid('getSelections');
	if (row.length == 0) {
		$.messager.popover({ msg: '��ѡ�������У�', type: 'alert' , timeout: 1000});
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
		title: '�������Ԫ��',
		width:400,
		height:340,
		iconCls:'icon-save',
		resizable:false,
		modal:true,
		buttons:[{
			text:'����',
			handler:function(){
				save();
			}
			},{
				text:'ȡ��',
				handler:function(){
					$HUI.dialog('#referDialog').close();
				}
			}
		]
	});
	$.each(row[0],function(key,value){    //objTmp��������
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
* @description: �޸�
*/ 
function modify() {
	var row = $('#referElementGrid').datagrid('getSelections')[0];
	if (row.length == 0) {
		$.messager.popover({ msg: '��ѡ�������У�', type: 'alert' , timeout: 1000});
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
		title: '����Ԫ���޸�',
		width:400,
		height:340,
		iconCls:'icon-save',
		resizable:false,
		modal:true,
		buttons:[{
			text:'����',
			handler:function(){
				save(row.Id);
			}
			},{
				text:'ȡ��',
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
* @description: ����
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
				$.messager.popover({ msg: '��ӳɹ���', type: 'success' , timeout: 1000});
			}else{
				$.messager.popover({ msg: '�޸ĳɹ���', type: 'success' , timeout: 1000});
			}
			
			$HUI.dialog('#referDialog','close');
			$('#referElementGrid').datagrid('reload');
		}else {
			$.messager.popover({ msg: '���ʧ�ܣ�' + ret, type: 'error' , timeout: 1000});
			return;
		}
	});
}
/**
* @description: ɾ��
*/ 
function remove() {
	var row = $('#referElementGrid').datagrid('getSelections')[0];
	if (row.length == 0) {
		$.messager.popover({ msg: '��ѡ�������У�', type: 'alert' , timeout: 1000});
		return ;
	}
	$cm({
		ClassName: "NurMp.Service.Refer.Record",
		MethodName: "delete",
		ID: row.Id
	}, function(ret) {
		if (ret == '0') {
			$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success' , timeout: 1000});
			$('#referElementGrid').datagrid('reload');
		}else {
			$.messager.popover({ msg: ret, type: 'error' , timeout: 1000});
			return;
		}
	});
}
/**
* @description: �¼�����
*/ 
function listenEvents() {
	$('#btnSearch').bind('click', function(e) {
		initEffictTemplateTree();
		initTemplateElementGrid();
		initReferElementGrid();
	});
}
