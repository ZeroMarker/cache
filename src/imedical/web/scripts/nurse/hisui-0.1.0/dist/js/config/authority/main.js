/*
 * @Descripttion: ��������дȨ������
 * @Author: yaojining
 * @Date: 2021-10-14 09:21:10
 */

var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClassName: "NurMp.Service.Template.Authority",
	ConfigTableName: "Nur_IP_AuthControl"
};
var init = function () {
	initHosp(function(){
		initRoleGrid();
		initAuthority();
	});
	initCondition();
	listenEvents();
}
$(init);

/**
* @description: ����
*/ 
function initCondition() {
	$HUI.combogrid("#RoleDirect", {
		url: $URL,
		queryParams:{
			ClassName: "NurMp.Service.Patient.List",
			QueryName: "FindUserGroup",
			rows: 1000,
			HospitalID: GLOBAL.HospitalID, 
			TableName: "Nur_IP_AuthControl"
		},
		columns: [[
			{field:'Checkbox',title:'sel',checkbox:true},
			{field:'GroupDesc',title:'����',width:250},
			{field:'Id',title:'ID',width:100},
		]],
		mode:'remote',
		idField: 'Id',
		textField: 'GroupDesc',
		multiple:true,
		singleSelect:false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay:500,
		//pagination : true,
		enterNullValueClear:true,
		//editable:false,
		onBeforeLoad:function(param){
			var desc = "";
			if (param['q']) {
				desc=param['q'];
			}
			param = $.extend(param,{SearchDesc: desc});
			return true;
		},
	});	
}
/**
* @description: ��ɫ
*/ 
function initRoleGrid() {
	$HUI.datagrid('#roleGrid',{
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: "FindRole",
			HospitalID: GLOBAL.HospitalID,
			ConfigTableName: GLOBAL.ConfigTableName
		},
		columns: [[
			{field:'RoleName',title:'����',width:150},
			{field:'RoleDirect',title:'ָ���ɫ',width:230},
			{field:'LimitLoc',title:'ָ�����',width:80, align:'center',formatter: function(value, row, index){
				if (row.LocIds){
					return "<a style='display:block;width:65px;height:30px;' title='�����ƿ��ң�����ɲ鿴��ϸ' onclick='limitLoc(" + index + ")' class='icon-accept' href='#'></a>";
				} else {
					return "<a style='display:block;width:65px;height:30px;' title='δ���ƿ��ң�����ɽ���ά��' onclick='limitLoc(" + index + ")' class='icon-forbid' href='#'></a>";
				}
			}},
			{field:'LimitModel',title:'ָ��ģ��',width:80, align:'center',formatter: function(value,row,index){
				if (row.ModelIds){
					return "<a style='display:block;width:65px;height:30px;' title='������ģ�壬����ɲ鿴��ϸ' onclick='limitModel(" + index + ")' class='icon-accept' href='#'>&nbsp;&nbsp;&nbsp;&nbsp;</a>";
				} else {
					return "<a style='display:block;width:65px;height:30px;' title='δ����ģ�壬����ɽ���ά��' onclick='limitModel(" + index + ")' class='icon-forbid' href='#'></a>";
				}
			}}
		]],
		nowrap:false,
		singleSelect: true,
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		onClickRow: function(rowIndex, rowData){
			$("#RoleName").val(rowData.RoleName);
			if (!!rowData.Custom) {
				$("#IsCustom").radio("check");
				$("#RoleCustom").val(rowData.Custom);
			} else {
				$("#IsCustom").radio("uncheck");
				$('#RoleDirect').combogrid('clear');
				initCondition();
				$("#RoleDirect").combogrid('setValues', rowData.DirectId.split("^"));
			}
			setAuthValues(rowData.Id);
   		},
	});
}
/**
 * @description: ���ƿ���
 * @param {String} index
 */
function limitLoc(index) {
	$("#roleGrid").datagrid("selectRow", index);
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		return;
	}
	var locIds = roleRows[0].LocIds;
	var url = 'nur.emr.config.authority.loc.csp?HospitalID=' + GLOBAL.HospitalID + '&ConfigTableName=' + GLOBAL.ConfigTableName + '&Loc=' + locIds;
    $('#dialog-loc').dialog({  
        title: 'ָ�����',
        buttons:[{
			text:'����',
			handler:function(){
				var arrNewLoc = $("#iframeAuthLoc")[0].contentWindow.GLOBAL.ArrSelLoc;
				var param = {RowID: roleRows[0].Id, ACLoc: arrNewLoc.join("^")};
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: 'save',
					Param: JSON.stringify(param)
				},function(result){
					if(result == '0'){
						$.messager.popover({msg: "����ɹ���", type: "success"});
						$("#roleGrid").datagrid("reload");
						$("#dialog-loc").dialog("close");	
					}else{
						$.messager.popover({msg: result, type: "error"});		
					}
				});
			}
		},{
			text:'�ر�',
			handler:function(){
				$("#dialog-loc").dialog("close");
			}
		}],
        width: 600,  
        height: 568,  
        content: "<iframe id='iframeAuthLoc' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
    });
    $("#dialog-loc").dialog("open");
}
/**
 * @description: ����ģ��
 * @param {String} index
 */
function limitModel(index) {
	$("#roleGrid").datagrid("selectRow", index);
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		return;
	}
	var modelIds = roleRows[0].ModelIds;
	var locIds = roleRows[0].LocIds;
	var url = 'nur.emr.config.authority.model.csp?HospitalID=' + GLOBAL.HospitalID + '&ConfigTableName=' + GLOBAL.ConfigTableName + '&Model=' + modelIds + '&Loc=' + locIds;
    $('#dialog-model').dialog({  
        title: 'ָ��ģ��',
        buttons:[{
			text:'����',
			handler:function(){
				var arrNewModel = $("#iframeAuthModel")[0].contentWindow.GLOBAL.ArrSelModel;
				var param = {RowID: roleRows[0].Id, ACTemplate: arrNewModel.join("^")};
				$m({
					ClassName: GLOBAL.ClassName,
					MethodName: 'save',
					Param: JSON.stringify(param)
				},function(result){
					if(result == '0'){
						$.messager.popover({msg: "����ɹ���", type: "success"});
						$("#roleGrid").datagrid("reload");
						$("#dialog-model").dialog("close");	
					}else{
						$.messager.popover({msg: result, type: "error"});		
					}
				});
			}
		},{
			text:'�ر�',
			handler:function(){
				$("#dialog-model").dialog("close");
			}
		}],
        width: 600,  
        height: 568,  
        content: "<iframe id='iframeAuthModel' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
    });
    $("#dialog-model").dialog("open");
}
/**
* @description: Ȩ��
*/ 
function initAuthority() {
	$("#kwAuth").keywords({
		labelCls: 'blue',
		items:[
		// {
		//     text:'�鿴',type:"section",items:[
		//         {text:'�鿴����',id:"ACView"}
		//     ]
		// },
		{
		    text:"�༭",type:'section',items:[
		        {text:'�½�',id:"ACNew"},
		        {text:'�޸�',id:"ACModify"},
		        {text:'����',id:'ACCancel'},
		        // {text:'��������',id:'ACUnCancel'}
		    ]
		},
		// {
		//     text:"ͳ��",type:'section',items:[
		//         {text:'24Сʱͳ��',id:"ACStat24"},
		//         {text:'�ռ�С��',id:"ACStatDay"},
		//         {text:'��ʱ���ͳ��',id:'ACStatTime'},
		//         {text:'���ֵ��Сֵͳ��',id:'ACStatLimit'}
		//     ]
		// },
		{
		    text:"��ӡ",type:'section',items:[
		        // {text:'ȫ����ӡ',id:"ACPrintAll"},
		        {text:'��ӡ',id:"ACPrint"},
		        // {text:'����ͼƬ',id:"ACPicture"}
		    ]
		}
		]
    });
}
/**
* @description: ����
*/ 
function clear() {
	$("#RoleName").val("");
	$HUI.radio("#IsCustom").setValue(false);
	$HUI.combogrid("#RoleDirect").setValues([]);
}
/**
* @description: ����
*/ 
function add() {
	saveRole("");
}
/**
* @description: �����ɫ
*/ 
function saveRole(id) {
	var roleName = $("#RoleName").val();
	if (!roleName) {
		$.messager.alert("����ʾ", "�붨���ɫ���ƣ�", "info");
		return;
	}
	var isCustom = $("#IsCustom").radio("getValue");
	if (isCustom) {
		var roleCustom = $('#RoleCustom').val();
		if (!roleCustom) {
			$.messager.alert("��ʾ", "����д��ɫ�Զ���ָ����෽����", "info");
			return;
		}
	} else {
		var roleDirect = $("#RoleDirect").combobox("getValues");
		if (roleDirect.length < 1) {
			$.messager.alert("��ʾ", "��ѡ���ɫָ��", "info");
			return;
		}
	}
	var param = {RowID: id, ACHospDr: GLOBAL.HospitalID, ACRoleName: $("#RoleName").val(), ACGroup: $("#RoleDirect").combobox("getValues").join("^"), ACCustomRole: ""};
	if (isCustom) {
		param = {RowID: id, ACHospDr: GLOBAL.HospitalID, ACRoleName: $("#RoleName").val(), ACGroup: "", ACCustomRole: $("#RoleCustom").val()};
	}
	$m({
		ClassName: GLOBAL.ClassName,
		MethodName: 'save',
		Param: JSON.stringify(param)
	},function(result){
		if(result == '0'){
			$.messager.popover({msg: "����ɹ���", type: "success"});
			$("#btnClear").click();
			$("#roleGrid").datagrid("reload");			
		}else{
			$.messager.popover({msg: result, type: "error"});		
		}
	});
}
/**
* @description: �޸�
*/ 
function modify() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("����ʾ", "��ѡ��һ����ɫ��", "info");
		return;
	}
	var id = roleRows[0].Id;
	saveRole(id);
}
/**
* @description: ɾ��
*/ 
function remove() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("����ʾ", "��ѡ��һ����ɫ��", "info");
		return;
	}
	$.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
		if (r) {
			$m({
				ClassName: GLOBAL.ClassName,
				MethodName: 'delete',
				Id:  roleRows[0].Id
			},function(result){
				if(result == '0'){
					$.messager.popover({msg: "ɾ���ɹ���", type: "success"});
					$("#btnClear").click();
					$("#roleGrid").datagrid("reload");
					setAuthValues("");		
				}else{
					$.messager.popover({msg: result, type: "error"});		
				}
			});
		} else {
			return;
		}
	});
}
/**
* @description: ����Ȩ��
*/ 
function saveAuth() {
	var roleRows = $("#roleGrid").datagrid("getSelections");
	if (roleRows.length == 0) {
		$.messager.alert("����ʾ", "��ѡ��һ����ɫ��", "info");
		return;
	}
	var param = {
		RowID: roleRows[0].Id,
		ACView: "N",
		ACNew: "N",
		ACModify: "N",
		ACCancel: "N",
		ACUnCancel: "N",
		ACStat24: "N",
		ACStatDay: "N",
		ACStatTime: "N",
		ACStatLimit: "N",
		ACPrintAll: "N",
		ACPrint: "N",
		ACPicture: "N"
	};
	var kwAuths = $("#kwAuth").keywords('getSelected');
	$.each(kwAuths, function(index, kwAuth) {
		param[kwAuth.id] = "Y";
	});
	$m({
		ClassName: GLOBAL.ClassName,
		MethodName: 'save',
		Param: JSON.stringify(param)
	},function(result){
		if(result == '0'){
			$.messager.popover({msg: "����ɹ���", type: "success"});
			// $("#roleGrid").datagrid("reload");			
		}else{
			$.messager.popover({msg: result, type: "error"});		
		}
	});
}
/**
 * @description: Ĭ��Ȩ������
 * @param {String} roleId
 */
function setAuthValues(roleId) {
	$("#kwAuth").keywords("clearAllSelected");
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: "getAuth",
		RoleId: roleId
	}, function(words) {
		$.each(words, function(index, word) {
			if (word.value == "Y") {
				$("#kwAuth").keywords("select", word.id);
			}
		});
	});
	
}
/**
* @description: �����¼�
*/ 
function listenEvents() {
	$HUI.radio("[name='IsCustom']",{
        onCheckChange:function(e,value){
        	if (value) {
				$("#LabelDirect").hide();
				$("#divRoleDirect").hide();
	        	$("#LabelCustom").show();
				$("#RoleCustom").show();
        	}else{
				$("#LabelCustom").hide();
				$("#RoleCustom").hide();
	        	$("#LabelDirect").show();
				$("#divRoleDirect").show();
				$("#RoleCustom").val("");
        	}
        }
    });
    $("#btnClear").bind("click", clear);
    $("#btnAdd").bind("click", add);
    $("#btnModify").bind("click", modify);
    $("#btnDelete").bind("click", remove);
    $("#btnSave").bind("click", saveAuth);	    
}