/*
* @author: yaojining
* @discription: 护理病历科室显示模板配置
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
* @description: 初始化界面
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
* @description: 初始化查询条件
*/
function initSearchCondition() {
	$m({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "getIfNeedImport"
	},function(msg) {
		if (msg != '0') {
			$.messager.confirm("警告", msg, function (r) {
				if (r) {
					$cm({
						ClassName: "NurMp.Service.Template.Directory",
						MethodName: "importTemplates",
						HospitalID: GLOBAL.HospitalID,
						UserID: session['LOGON.USERID']
					},function(ret){
						if (parseInt(ret) == 0) {
							$('#btnSync').hide();
							$.messager.popover({ msg: '导入成功!请将旧版科室显示模板菜单禁用！', type: 'success' , timeout: 2000});
							$HUI.tree('#leftTemplateTree','reload');
							$('#allTemplatesGrid').datagrid('reload');
						} else {
							$.messager.popover({ msg: '导入失败!', type: 'error' });
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
	        	$('#hospitalDiv').panel('setTitle', "当前院区所有科室可见");
	        }else if ((e.target.id == 'IP')&&(value)) {
	            $('#comboDepartment').combogrid('clear');
	        	$('#comboDepartment').combogrid('disable');
	        	$('#hospitalDiv').panel('setTitle', "当前院区住院科室可见（全院+住院）");
	        }else if ((e.target.id == 'OP')&&(value)) {
	            $('#comboDepartment').combogrid('clear');
	        	$('#comboDepartment').combogrid('disable');
	        	$('#hospitalDiv').panel('setTitle', "当前院区其它科室可见（全院+其它）");
	        }else{
	        	$('#comboDepartment').combogrid('enable');
	        	reloadLocs();
	        	$('#comboDepartment').combogrid('grid').datagrid('selectRow', 0);
				$('#hospitalDiv').panel('setTitle', "当前科室可见（全院+住院/其它+科室）");
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
			{field:'LocDesc',title:'名称',width:100},
			{field:'HospDesc',title:'院区',width:100},
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
			{id:1, text:"全部"},
			{id:2, text:"已筛选"},
			{id:3, text:"未筛选"}
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
* @description: 重新加载科室
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
* @description: 初始化所有模板表格
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
		nowrap:false,  /*此处为false*/
		frozenColumns:[[
			{field:'checkbox',checkbox:true,align:'center',width:80},
			{field:'name',title:'名称',width:250},
			{field:'authorityLocs',title:'权限',wordBreak:"break-all",width:350}
		]],
		columns:[[
			{field:'isFilter',title:'筛选',width:45},
			{field:'code',title:'代码',width:200},
			{field:'guid',title:'GUID',width:280},
			{field:'ifShare',title:'是否共享',width:50,hidden:true}
		]],
		// rowStyler: function (rowIndex, rowData) {
		// 	if (rowData.ifShare == '是') {
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
			text:'添加到目录',
			handler: addToDirectory
		},'-',{				
			id: 'btnAddFilter',
			iconCls: 'icon-arrow-right-top',
			text:'添加到筛选',
			handler: addToFilter
		},'-',{	
			id: 'btnDeleteFilter',			
			iconCls: 'icon-undo',
			text:'撤销筛选',
			handler: deleteFromFilter
		},'-',{	
			id: 'btnDirectory',			
			iconCls: 'icon-template',
			text:'根目录维护',
			handler: setDirectory
		},'-',{	
			id: 'btnEidtTabs',			
			iconCls: 'icon-gen',
			text:'页签配置',
			handler: setTemplateTabs
		},'-',{	
			id: 'btnShareToHosp',			
			iconCls: 'icon-big-switch',
			text:'医院授权',
			handler: shareToHosp
		}]
	});
	if ((!GLOBAL.HospEnvironment) || (GLOBAL.DataMode != "C")) {
		$("#btnShareToHosp").hide();
	}
}
/**
* @description:  初始化全院或科室模板
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
						if (node.authType == "全院") {
							color = "blue";
						}else if (node.authType == "住院") {
							color = "green";
						}else if (node.authType == "其它") {
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
		// 为所有节点绑定右击响应事件
	    onContextMenu : function(e,node){
            // 阻止浏览器默认的右键菜单事件
            e.preventDefault();
			$('#leftTemplateTree').tree('select', node.target);
            // 显示右键菜单
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
* @description:  添加筛选
*/
function addToFilter() {
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '请选择模板！',
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
				msg: '添加失败！' + txtData,
				type:'error',
				timeout: 500,
				style:{
					top: 300,
					left: 600
				}
			});
		} else {
			$.messager.popover({
				msg: '添加成功！',
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
* @description:  撤销筛选
*/
function deleteFromFilter() {
	var cannotMsg = '';
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	for (i=0;i<templates.length;i++) {
		var authorityLocs=templates[i].authorityLocs;
		var guid = templates[i].guid;
		var filterFlag = templates[i].isFilter;
		if (filterFlag.indexOf("是") < 0) {
			cannotMsg = '未添加筛选的模板无需撤销筛选！';
		}
		if (authorityLocs.indexOf("未挂出") < 0) {
			cannotMsg = '已经挂到全院或者科室的模板，请移除后再撤销筛选！'
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
			msg: '请选择模板！',
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
				msg: '撤销成功！',
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
* @description:  添加到目录结构
*/
function addToDirectory() {
	var flag = 0
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var node = $('#leftTemplateTree').tree('getSelected');
	if(!node) {
		$.messager.popover({
			msg: '请选择要添加的目录！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '1') {
		$.messager.popover({
			msg: '请选择根目录！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	for (i=0;i<templates.length;i++) {
		var guid = templates[i].guid;
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("否") > -1) {
			flag = 1;
			break;
		}
		guids = guids == '' ? guid : guids + '^' + guid;
	}
	if (flag === 1) {
		$.messager.popover({
			msg: '所选择的模板没有筛选！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$('#divAdd').dialog({
		title: '添加到目录',
		buttons: [{
			text:'确定',
			handler: function() {
				saveItem(node, guids);
			}
		 },{
			text:'取消',
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
* @description:  保存子节点
*/
function saveItem(node,guids){
	var depID = $('#comboDepartment').combobox('getValue');
	var groupID = $('#comboGroup').combobox('getValue');
	if ((!depID)&&(groupID == 'L')) {
		$.messager.popover({msg: '请先选择科室! ', type:'info', timeout: 1000});
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
				msg: '保存失败! ' + txtData,
				type:'info',
				timeout: 3000
			});
		}else {
			$.messager.popover({
				msg: '保存成功! ',
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
* @description:  目录维护
*/
function setDirectory() {
	var url = 'nur.hisui.nurseTemplateDirectoryConfig.csp?HospitalID=' + GLOBAL.HospitalID;
	$('#directoryDiv').dialog({  
		title: '目录维护',
	    width: 500,  
	    height: 600,  
	    cache: false,  
	    content:"<iframe scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
	    modal: true
	});
	$("#directoryDiv").dialog("open");
}
/**
* @description:  页签维护
*/
function setTemplateTabs() {
	var url = 'nur.hisui.nurseTemplateTabsConfig.csp?HospitalID=' + GLOBAL.HospitalID;
	$('#directoryDiv').dialog({  
		title: '页签维护 （显示优先级：科室>住院/其它>全院）',
	    width: 500,  
	    height: 600,  
	    cache: false,  
	    content:"<iframe scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
	    modal: true
	});
	$("#directoryDiv").dialog("open");
}
/**
* @description:  授权医院
*/
function shareToHosp() {
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'error',
			timeout: 1000
		});
		return;
	}
	var breakFlag = 0;
	var repeatFlag = 0;
	for (i=0;i<templates.length;i++) {
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("否") > -1) {
			breakFlag = 1;
			break;
		}
		var isShare = templates[i].ifShare;
		if (isShare.indexOf("是") > -1) {
			repeatFlag = 1;
			break;
		}
	}
	if (breakFlag == 1) {
 		$.messager.alert("简单提示", "请先添加筛选!", 'error');
 		return;
 	}
 	if (repeatFlag == 1) {
 		$.messager.alert("简单提示", "已经授权的模板不能再次授权！", 'error');
 		return;
 	}
	$('#dialogShare').dialog({  
		title: '授权到医院',
	    width: 400,  
	    height: 400,
	    buttons: [{
			id: 'btnShare',
			text: '确定',
			handler: saveShare
		},{
			id: 'btnCancle',
			text: '取消',
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
					{field:'HOSPDesc',title:'医院名称',width:280},
					{field:'HOSPRowId',title:'医院ID',width:80}
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
* @description:  保存共享
*/
function saveShare() {
	var guids = '';
	var templates = $('#allTemplatesGrid').datagrid('getSelections');
	if(templates.length == 0) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'error',
			timeout: 1000
		});
		return;
	}
	var breakFlag = 0;
	for (i=0;i<templates.length;i++) {
		var isFilter = templates[i].isFilter;
		if (isFilter.indexOf("否") > -1) {
			breakFlag = 1;
			break;
		}
		var guid = templates[i].guid;
		guids = guids == '' ? guid : guids + '^' + guid;
	}
	if (breakFlag == 1) {
 		$.messager.alert("简单提示", "请先添加筛选!", 'error');
 		return;
 	}
 	var hospRows = $("#hospGrid").datagrid("getSelections");
 	if (hospRows.length == 0) {
		$.messager.alert("提示", "请选择要共享的院区！", "error");
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
				msg: '共享成功！',
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
* @description: 初始化menu
*/
function initMenu() {
	$('#menu').empty();
    $('#menu').menu('appendItem', {
        id: 'menuRemove',
        text: '移除',
        iconCls: 'icon-remove',
        onclick: removeTemplate
    });
    $('#menu').menu('appendItem',{
        id: 'menuModify',
        text: '修改',
        iconCls: 'icon-edit',
        onclick: modify
    });
    $('#menu').menu('appendItem',{
        id: 'menuProperty',
        text: '属性',
        iconCls: 'icon-tip',
        onclick: showProperty
    });
}
/**
* @description: 删除
*/
function removeTemplate(item) {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '请选择模板！',
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
					msg: '移除成功! ',
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
	}, $g('确定要移除该模板吗？'));
}
/**
* @description: 修改
*/
function modify(item) {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}

    $('#divAdd').dialog({
		title: '修改',
		buttons: [{
			text:'确定',
			handler: function() {
				saveItem(node,node.guid);
			}
		 },{
			text:'取消',
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
* @description: 属性
*/
function showProperty() {
    var node = $('#leftTemplateTree').tree('getSelected');
    if(!node) {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	if(node.isLeaf == '0') {
		$.messager.popover({
			msg: '请选择模板！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$('#divProperty').dialog({
		title: '属性',
		buttons: [{
			text:'关闭',
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
		var alert = "确定要把旧版配置导入新版吗导入吗？"
		if (msg == '0') {
			alert = "此配置界面已经维护了数据，确定要再次导入吗？"
		}
    	$.messager.confirm("警告", alert, function (r) {
			if (r) {
				$cm({
					ClassName: "NurMp.Service.Template.Directory",
					MethodName: "importTemplates",
					HospitalID: GLOBAL.HospitalID,
					UserID: session['LOGON.USERID']
				},function(ret){
					if (parseInt(ret) == 0) {
						$.messager.popover({ msg: '导入成功!请将旧版科室显示模板菜单禁用！', type: 'success' , timeout: 2000});
						$HUI.tree('#leftTemplateTree','reload');
						$('#allTemplatesGrid').datagrid('reload');
					} else {
						$.messager.popover({ msg: '导入失败!', type: 'error' });
					}
				});
			} else {
				return;
			}
		});
    });
}
/**
* @description:  监听事件
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
