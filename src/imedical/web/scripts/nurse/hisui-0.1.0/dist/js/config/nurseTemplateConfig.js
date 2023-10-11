/*
* @author: yaojining
* @discription: ������������ʾģ������
* @date: 2019-12-29
*/
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_TemplateFilter',
	DataMode: $m({
		ClassName: "NurMp.Common.Base.Hosp",
		MethodName: "getDataType",
		ConfigTableName: "Nur_IP_TemplateFilter"
	}, false)
};

$(initUI);

/**
* @description: ��ʼ������
*/
function initUI() {
	initHosp(function(){
		initSearchCondition();
		initAllTemplatesGrid();
		initLeftTemplatesTree();
		initMenu();

	});
	listenEvents();
}
/**
* @description: ��ʼ����ѯ����
*/
function initSearchCondition() {
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "getIfNeedImport"
	},function(msg) {
		if (msg != '0') {
			$.messager.confirm("����", msg, function (r) {
				if (r) {
					$cm({
						ClassName: "NurMp.Service.Template.Directory",
						MethodName: "importTemplates",
						HospitalID: GLOBAL.HospitalID,
						UserID: session['LOGON.USERID']
					},function(ret){
						if (parseInt(ret) == 0) {
							$('#btnSync').hide();
							$.messager.popover({ msg: '����ɹ�!�뽫�ɰ������ʾģ��˵����ã�', type: 'success' , timeout: 2000});
							$HUI.tree('#leftTemplateTree','reload');
							$('#allTemplatesGrid').datagrid('reload');
						} else {
							$.messager.popover({ msg: '����ʧ��!', type: 'error' });
						}
					});
				} else {
					return;
				}
			});
		}else {
			$('#btnSync').hide();
		}
	});
	$HUI.radio("[name='radioType']",{
        onChecked:function(e,value){
            if ((e.target.id == 'ALL')&&(value)) {
	            $('#comboDepartment').combogrid('clear');
	        	$('#comboDepartment').combogrid('disable');
	        	$('#hospitalDiv').panel('setTitle', "��ǰԺ�����п��ҿɼ�");
	        }else if ((e.target.id == 'IP')&&(value)) {
	            $('#comboDepartment').combogrid('clear');
	        	$('#comboDepartment').combogrid('disable');
	        	$('#hospitalDiv').panel('setTitle', "��ǰԺ��סԺ���ҿɼ���ȫԺ+סԺ��");
	        }else if ((e.target.id == 'OP')&&(value)) {
	            $('#comboDepartment').combogrid('clear');
	        	$('#comboDepartment').combogrid('disable');
	        	$('#hospitalDiv').panel('setTitle', "��ǰԺ���������ҿɼ���ȫԺ+������");
	        }else{
	        	$('#comboDepartment').combogrid('enable');
	        	reloadLocs();
	        	$('#comboDepartment').combogrid('grid').datagrid('selectRow', 0);
				$('#hospitalDiv').panel('setTitle', "��ǰ���ҿɼ���ȫԺ+סԺ/����+���ң�");
		    }
	        initLeftTemplatesTree();
			// $('#allTemplatesGrid').datagrid('reload');
        }
    });
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
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'LocDesc',title:'����',width:100},
			{field:'HospDesc',title:'Ժ��',width:100},
			{field:'LocId',title:'ID',width:40}
		]],
		multiple:true,
		singleSelect:false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		pagination : true,
		enterNullValueClear:true,
		disabled: true,
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
			
		},
	});	
	$HUI.combobox('#comboFilter', {
		valueField: 'id',
		textField: 'text',
		value: 2,
		data:[
			{id:1, text:"ȫ��"},
			{id:2, text:"��ɸѡ"},
			{id:3, text:"δɸѡ"}
		], 
		onChange:function(newval, oldval){
			$('#btnSearch').click();
			if (newval === 2) {
				$('#btnAddFilter').linkbutton('disable');
				$('#btnDeleteFilter').linkbutton('enable');
			}else if (newval === 3) {
				$('#btnDeleteFilter').linkbutton('disable');
				$('#btnAddFilter').linkbutton('enable');
			}else {
				$('#btnAddFilter').linkbutton('enable');
				$('#btnDeleteFilter').linkbutton('enable');
			}
		},
		defaultFilter:4
	});
	$('#textTemplateName').searchbox("textbox").keydown(function(e) {
		if (e.keyCode == 13) {
			$("#btnSearch").click();
		}
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
		ConfigTableName: "Nur_IP_TemplateFilter",
		SearchDesc: ""
	});
}
/**
* @description: ��ʼ������ģ����
*/ 
function initAllTemplatesGrid() {
	$HUI.datagrid('#allTemplatesGrid',{
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Template.Directory",
			QueryName: "FindFilter",
			HospitalID: GLOBAL.HospitalID,
			FilterFlag: $('#comboFilter').combobox('getValue'),
			TemplateName: $('#textTemplateName').val()
		},
		nowrap:false,  /*�˴�Ϊfalse*/
		frozenColumns:[[
			{field:'checkbox',checkbox:true,align:'center',width:80},
			{field:'name',title:'����',width:250},
			{field:'authorityLocs',title:'Ȩ��',wordBreak:"break-all",width:350}
		]],
		columns:[[
			{field:'isFilter',title:'ɸѡ',width:45},
			{field:'code',title:'����',width:200},
			{field:'guid',title:'GUID',width:280},
			{field:'ifShare',title:'�Ƿ���',width:50,hidden:true}
		]],
		// rowStyler: function (rowIndex, rowData) {
		// 	if (rowData.ifShare == '��') {
		// 		return 'background-color:lightblue;';
		// 	}
		// },
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		rownumbers:true,
		width:500,
		toolbar: [{
			id: 'btnAddHosp',
			iconCls: 'icon-arrow-left',
			text:'��ӵ�Ŀ¼',
			handler: addToDirectory
		},'-',{				
			id: 'btnAddFilter',
			iconCls: 'icon-arrow-right-top',
			text:'��ӵ�ɸѡ',
			handler: addToFilter
		},'-',{	
			id: 'btnDeleteFilter',			
			iconCls: 'icon-undo',
			text:'����ɸѡ',
			handler: deleteFromFilter
		},'-',{	
			id: 'btnDirectory',			
			iconCls: 'icon-template',
			text:'��Ŀ¼ά��',
			handler: setDirectory
		},'-',{	
			id: 'btnEidtTabs',			
			iconCls: 'icon-gen',
			text:'ҳǩ����',
			handler: setTemplateTabs
		},'-',{	
			id: 'btnShareToHosp',			
			iconCls: 'icon-big-switch',
			text:'ҽԺ��Ȩ',
			handler: shareToHosp
		}]
	});
	if ((!GLOBAL.HospEnvironment) || (GLOBAL.DataMode != "C")) {
		$("#btnShareToHosp").hide();
	}
}
/**
* @description:  ��ʼ��ȫԺ�����ģ��
*/
function initLeftTemplatesTree() {
	$HUI.tree('#leftTemplateTree', {
		loader: function(param, success, error) {
			$cm({
				ClassName: "NurMp.Service.Template.Directory",
				MethodName: "getTemplates",
				HospitalID: GLOBAL.HospitalID,
				TypeCode: $("input[name='radioType']:checked").val(),
				LocID: $('#comboDepartment').combobox('getValues').join("^"),
				FilterFlag: $('#comboFilter').combobox('getValue'),
				TemplateName: $('#textTemplateName').val()
			}, function(data) {
				var addIDAndText = function(node) {
					if (!!node.authType) {
						var color = "brown";
						if (node.authType == "ȫԺ") {
							color = "blue";
						}else if (node.authType == "סԺ") {
							color = "green";
						}else if (node.authType == "����") {
							color = "red";
						}
						node.text = node.text + "&nbsp;&nbsp;<label style='font-size:12px;font-style:italic;color:" + color + ";'>" + node.authType + "</label>" ;
					}
				}
				data.forEach(addIDAndText);
				success(data);
			});
		},
		autoNodeHeight: true,
		onClick: function (node) {
			// $('#leftTemplateTree').tree('toggle', node.target);
		},
		// Ϊ���нڵ���һ���Ӧ�¼�
	    onContextMenu : function(e,node){
            // ��ֹ�����Ĭ�ϵ��Ҽ��˵��¼�
            e.preventDefault();
			$('#leftTemplateTree').tree('select', node.target);
            // ��ʾ�Ҽ��˵�
            if (node.isLeaf == '1') {
            	$('#menu').menu('show', {
	                left: e.pageX,
	                top: e.pageY
	            });
            }
	    }
	});
}

/**
* @description:  ���ɸѡ
*/
function addToFilter() {
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'error',
			timeout: 1000
		});
		return;
	}
	for (i=0;i<templates.length;i++) {
		var guid = templates[i].guid;
		guids = guids == '' ? guid : guids + '^' + guid;
	}
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "saveFilter",
		HospitalID: GLOBAL.HospitalID,
		Guids: guids,
		UserID: session['LOGON.USERID'] || ''
	},function(txtData){
		if (txtData != '0') {
			$.messager.popover({
				msg: '���ʧ�ܣ�' + txtData,
				type:'error',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
		} else {
			$.messager.popover({
				msg: '��ӳɹ���',
				type:'success',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
			$('#allTemplatesGrid').datagrid('reload');
		}
	});
}
/**
* @description:  ����ɸѡ
*/
function deleteFromFilter() {
	var cannotMsg = '';
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	for (i=0;i<templates.length;i++) {
		var authorityLocs=templates[i].authorityLocs;
		var guid = templates[i].guid;
		var filterFlag = templates[i].isFilter;
		if (filterFlag.indexOf("��") < 0) {
			cannotMsg = 'δ���ɸѡ��ģ�����賷��ɸѡ��';
		}
		if (authorityLocs.indexOf("δ�ҳ�") < 0) {
			cannotMsg = '�Ѿ��ҵ�ȫԺ���߿��ҵ�ģ�壬���Ƴ����ٳ���ɸѡ��'
		}else{
			guids = guids == '' ? guid : guids + '^' + guid;
		}
	}
	if (!!cannotMsg) {
 		$.messager.popover({
			msg: cannotMsg,
			type:'info',
			timeout: 1000
		});
 	}
	if ((!guids)&&(!cannotMsg)) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'error',
			timeout: 500,
			style:{
				top: 300,
				left: 600
			}
		});
		return;
	}
	if (!guids) {
		return;
	}
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "deleteFilter",
		HospitalID: GLOBAL.HospitalID,
		Guids: guids,
		UserID: session['LOGON.USERID'] || ''
	},function(txtData){
		if (txtData != '0') {
			$.messager.popover({
				msg: txtData,
				type:'error',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
		} else {
			$.messager.popover({
				msg: '�����ɹ���',
				type:'success',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
			$('#allTemplatesGrid').datagrid('reload');
		}
	});
}
/**
* @description:  ��ӵ�Ŀ¼�ṹ
*/
function addToDirectory() {
	var flag = 0
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var node = $('#leftTemplateTree').tree('getSelected');
	if(!node) {
		$.messager.popover({
			msg: '��ѡ��Ҫ��ӵ�Ŀ¼��',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '1') {
		$.messager.popover({
			msg: '��ѡ���Ŀ¼��',
			type:'info',
			timeout: 1000
		});
		return;
	}
	for (i=0;i<templates.length;i++) {
		var guid = templates[i].guid;
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("��") > -1) {
			flag = 1;
			break;
		}
		guids = guids == '' ? guid : guids + '^' + guid;
	}
	if (flag === 1) {
		$.messager.popover({
			msg: '��ѡ���ģ��û��ɸѡ��',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$('#divAdd').dialog({
		title: '��ӵ�Ŀ¼',
		buttons: [{
			text:'ȷ��',
			handler: function() {
				saveItem(node, guids);
			}
		 },{
			text:'ȡ��',
			handler:function(){
				$HUI.dialog('#divAdd').close();
			}
		}],
		closed:false,
		onOpen: function() {
			var typeCode = $("input[name='radioType']:checked").attr('id');
			$('#comboGroup').combobox('setValue',typeCode);
			$('#comboGroup').combobox('disable');
			$('#inputDesc').val('');
	 		$('#numberNo').numberbox('setValue','');
	 		$('#OperationLog').switchbox('setValue', false);
	 		$('#MarkLog').switchbox('setValue', false);
	 		$('#isOut').checkbox('setValue',false);
			$('#EjectFlag').switchbox('setValue', false);
			$('#EditFlag').switchbox('setValue', false);
	 		if (templates.length > 1) {
	 			$('#inputDesc').attr('disabled',true);
	 			$('#numberNo').attr('disabled',true);
	 		}else{
	 			$('#inputDesc').attr('disabled',false);
	 			$('#numberNo').attr('disabled',false);
	 		}	
		}
	});
}
/**
* @description:  �����ӽڵ�
*/
function saveItem(node,guids){
	var depID = $('#comboDepartment').combobox('getValue');
	var groupID = $('#comboGroup').combobox('getValue');
	if ((!depID)&&(groupID == 'L')) {
		$.messager.popover({msg: '����ѡ�����! ', type:'info', timeout: 1000});
		return;
	}
	var locID = $('#comboGroup').combobox('getValue') == 'ALL' ? '' : $('#comboDepartment').combobox('getValues').join('^');
	var rename = $('#inputDesc').val();
	var sortNo = $('#numberNo').numberbox('getValue');
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "saveBatch",
		NodeID: node.id,
		Guids: guids,
		LocID: locID,
		ReName: rename,
		SortNo: sortNo,
		UserID: session['LOGON.USERID'] || '',
		HospitalID: GLOBAL.HospitalID,
		TypeCode: $("input[name='radioType']:checked").val(),
		OperationLog: $('#OperationLog').switchbox('getValue'),
		MarkLog: $('#MarkLog').switchbox('getValue'),
		IsOut:$('#isOut').checkbox('getValue'),
		EjectFlag: $('#EjectFlag').switchbox('getValue'),
		EditFlag: $('#EditFlag').switchbox('getValue')
	},function(txtData){
		if (txtData != '0') {
			$.messager.popover({
				msg: '����ʧ��! ' + txtData,
				type:'info',
				timeout: 3000
			});
		}else {
			$.messager.popover({
				msg: '����ɹ�! ',
				type:'info',
				timeout: 1000
			});
		}
		$HUI.dialog('#divAdd').close();
		$HUI.tree('#leftTemplateTree','reload');
		$('#allTemplatesGrid').datagrid('reload');
		$('#allTemplatesGrid').datagrid('unselectAll');
	});
}
/**
* @description:  Ŀ¼ά��
*/
function setDirectory() {
	var url = 'nur.hisui.nurseTemplateDirectoryConfig.csp?HospitalID=' + GLOBAL.HospitalID;
	$('#directoryDiv').dialog({  
		title: 'Ŀ¼ά��',
	    width: 500,  
	    height: 600,  
	    cache: false,  
	    content:"<iframe scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
	    modal: true
	});
	$("#directoryDiv").dialog("open");
}
/**
* @description:  ҳǩά��
*/
function setTemplateTabs() {
	var url = 'nur.hisui.nurseTemplateTabsConfig.csp?HospitalID=' + GLOBAL.HospitalID;
	$('#directoryDiv').dialog({  
		title: 'ҳǩά�� ����ʾ���ȼ�������>סԺ/����>ȫԺ��',
	    width: 500,  
	    height: 600,  
	    cache: false,  
	    content:"<iframe scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
	    modal: true
	});
	$("#directoryDiv").dialog("open");
}
/**
* @description:  ��ȨҽԺ
*/
function shareToHosp() {
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'error',
			timeout: 1000
		});
		return;
	}
	var breakFlag = 0;
	var repeatFlag = 0;
	for (i=0;i<templates.length;i++) {
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("��") > -1) {
			breakFlag = 1;
			break;
		}
		var isShare = templates[i].ifShare;
		if (isShare.indexOf("��") > -1) {
			repeatFlag = 1;
			break;
		}
	}
	if (breakFlag == 1) {
 		$.messager.alert("����ʾ", "�������ɸѡ!", 'error');
 		return;
 	}
 	if (repeatFlag == 1) {
 		$.messager.alert("����ʾ", "�Ѿ���Ȩ��ģ�岻���ٴ���Ȩ��", 'error');
 		return;
 	}
	$('#dialogShare').dialog({  
		title: '��Ȩ��ҽԺ',
	    width: 400,  
	    height: 400,
	    buttons: [{
			id: 'btnShare',
			text: 'ȷ��',
			handler: saveShare
		},{
			id: 'btnCancle',
			text: 'ȡ��',
			handler: function(){$HUI.dialog('#dialogShare').close()}
		}],
	    onOpen: function(){
		    $HUI.datagrid('#hospGrid',{
				url: $URL,
				queryParams: {
					ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
					QueryName: "GetHospDataForCombo",
					tablename: "Nur_IP_TemplateFilter", 
					SessionStr: session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + GLOBAL.HospitalID
				},
				singleSelect: false,
				nowrap: false,
				columns:[[
					{field:'checkbox',checkbox:true,align:'center',width:80},
					{field:'HOSPDesc',title:'ҽԺ����',width:280},
					{field:'HOSPRowId',title:'ҽԺID',width:80}
				]],
				loadFilter: function(data){
					for(var i in data.rows){
						if(data.rows[i].HOSPRowId == GLOBAL.HospitalID){
							data.rows.splice(i,1);
						}
					}
					return data;
				}
			});
		}
	});
	$("#dialogShare").dialog("open");
}
/**
* @description:  ���湲��
*/
function saveShare() {
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'error',
			timeout: 1000
		});
		return;
	}
	var breakFlag = 0;
	for (i=0;i<templates.length;i++) {
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("��") > -1) {
			breakFlag = 1;
			break;
		}
		var guid = templates[i].guid;
		guids = guids == '' ? guid : guids + '^' + guid;
	}
	if (breakFlag == 1) {
 		$.messager.alert("����ʾ", "�������ɸѡ!", 'error');
 		return;
 	}
 	var hospRows = $("#hospGrid").datagrid("getSelections");
 	if (hospRows.length == 0) {
		$.messager.alert("��ʾ", "��ѡ��Ҫ�����Ժ����", "error");
		return;
	}
	var hospDrs = "";
	$.each(hospRows, function(index, hosp) {
		hospDrs = !!hospDrs ? hospDrs + "^" + hosp.HOSPRowId : hosp.HOSPRowId;
	});
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "saveShare",
		HospitalID: GLOBAL.HospitalID,
		Guids: guids,
		ShareHospDr: hospDrs
	},function(txtData){
		if (txtData != '0') {
			$.messager.popover({
				msg: txtData,
				type:'error',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
		} else {
			$.messager.popover({
				msg: '����ɹ���',
				type:'success',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
			$("#dialogShare").dialog("close");
			$('#allTemplatesGrid').datagrid('reload');
			
		}
	});
}
/**
* @description: ��ʼ��menu
*/
function initMenu() {
	$('#menu').empty();
    $('#menu').menu('appendItem', {
        id: 'menuRemove',
        text: '�Ƴ�',
        iconCls: 'icon-remove',
        onclick: removeTemplate
    });
    $('#menu').menu('appendItem',{
        id: 'menuModify',
        text: '�޸�',
        iconCls: 'icon-edit',
        onclick: modify
    });
    $('#menu').menu('appendItem',{
        id: 'menuProperty',
        text: '����',
        iconCls: 'icon-tip',
        onclick: showProperty
    });
}
/**
* @description: ɾ��
*/
function removeTemplate(item) {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	confirm(function(){
		$cm({
			ClassName: "NurMp.Service.Template.Directory",
			MethodName: "deleteDirectSub",
			LocID: node.locFlag,
			RootID: node.id.split('|')[0],
			Guid: node.guid,
			HospitalID: GLOBAL.HospitalID
		},function(txtData){
			if (txtData == '0') {
				$.messager.popover({
					msg: '�Ƴ��ɹ�! ',
					type:'info',
					timeout: 1000
				});
				$HUI.tree('#leftTemplateTree','reload');
				$('#allTemplatesGrid').datagrid('reload');
			}else {
				$.messager.popover({
					msg: txtData,
					type:'info',
					timeout: 1000
				});
				return;
			}
		});
	}, $g('ȷ��Ҫ�Ƴ���ģ����'));
}
/**
* @description: �޸�
*/
function modify(item) {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}

    $('#divAdd').dialog({
		title: '�޸�',
		buttons: [{
			text:'ȷ��',
			handler: function() {
				saveItem(node,node.guid);
			}
		 },{
			text:'ȡ��',
			handler:function(){
				$HUI.dialog('#divAdd').close();
			}
		}],
		closed:false,
		onOpen: function() {
			var typeCode = $("input[name='radioType']:checked").attr('id');
			$('#comboGroup').combobox('setValue',typeCode);
			$('#comboGroup').combobox('disable');
	 		$('#inputDesc').val(node.rename);
	 		$('#numberNo').numberbox('setValue',node.sortNo);
	 		$('#OperationLog').switchbox('setValue', node.operationLog);
	 		$('#MarkLog').switchbox('setValue', node.markLog);
			$('#inputDesc').attr('disabled',false);
			$('#numberNo').attr('disabled',false);
			$('#isOut').checkbox('setValue',node.isOut);
			$('#EjectFlag').switchbox('setValue', node.ejectFlag);
			$('#EditFlag').switchbox('setValue', node.editFlag);
		}
	});
}
 /**
* @description: ����
*/
function showProperty() {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$('#divProperty').dialog({
		title: '����',
		buttons: [{
			text:'�ر�',
			handler:function(){
				$HUI.dialog('#divProperty').close();
			}
		}],
		closed:false,
		onOpen: function() {
			debugger;
			$('#modelName').text(node.text.split('&')[0]);
			$('#modelKey').text(node.emrCode);
			$('#modelGuid').text(node.guid);
		}
	});
}
function importData() {
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "getIfNeedImport"
	},function(msg) {
		var alert = "ȷ��Ҫ�Ѿɰ����õ����°�������"
		if (msg == '0') {
			alert = "�����ý����Ѿ�ά�������ݣ�ȷ��Ҫ�ٴε�����"
		}
    	$.messager.confirm("����", alert, function (r) {
			if (r) {
				$cm({
					ClassName: "NurMp.Service.Template.Directory",
					MethodName: "importTemplates",
					HospitalID: GLOBAL.HospitalID,
					UserID: session['LOGON.USERID']
				},function(ret){
					if (parseInt(ret) == 0) {
						$.messager.popover({ msg: '����ɹ�!�뽫�ɰ������ʾģ��˵����ã�', type: 'success' , timeout: 2000});
						$HUI.tree('#leftTemplateTree','reload');
						$('#allTemplatesGrid').datagrid('reload');
					} else {
						$.messager.popover({ msg: '����ʧ��!', type: 'error' });
					}
				});
			} else {
				return;
			}
		});
    });
}
/**
* @description:  �����¼�
*/
function listenEvents() {
	$('#btnSearch').click(function(e) {
		$HUI.tree('#leftTemplateTree','reload');
		$('#allTemplatesGrid').datagrid('reload',{
			ClassName: "NurMp.Service.Template.Directory",
			QueryName: "FindFilter",
			HospitalID: GLOBAL.HospitalID,
			FilterFlag: $('#comboFilter').combobox('getValue'),
			TemplateName: $('#textTemplateName').searchbox('getValue')
		});	
	});
	$('.searchbox-button').bind('click', function() {
		$('#btnSearch').click();
	});
	$('#btnSync').bind('click', importData);
	$("#btnShare").bind("click", saveShare);
}

window.refreshLeftTree = function() {
	initLeftTemplatesTree();
}	
