/*
 * @author: yaojining
 * @discription: �������������Ӳ���ά��
 * @date: 2020-9-14
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_EprMenu',
};

$(initUI);

/**
* @description: ��ʼ������
*/
function initUI() {
	initHosp(function(){
		initEprTree();
		initMethodGrid();
	});
	listenEvents();
}

/**
* @description: ��ʼ������ģ����
*/ 
function initEprTree() {
	$HUI.tree('#eprTree', {
		loader: function(param, success, error) {
			$cm({
				ClassName: "NurMp.Service.Refer.Epr",
				MethodName: "getEprInfo",
				HospitalID: GLOBAL.HospitalID
			}, function(data) {
				success(data);
			});
		},
		autoNodeHeight: true,
		onClick: eprTreeClick
	});
}
/**
* @description: ��ʼ������ģ����
*/ 
function initMethodGrid() {
	var node = $('#eprTree').tree('getSelected');
	$HUI.datagrid('#methodGrid',{
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Refer.Epr",
			QueryName: "getEprMenuDetail",
			HospitalID: GLOBAL.HospitalID,
			TypeID: ''
		},
		columns:[[
			{field:'name',title:'����',width:120},
			{field:'method',title:'����',width:400},
			{field:'param1',title:'����1',width:120},
			{field:'param2',title:'����2',width:120},
			{field:'type',title:'����',width:80},
			{
				field:'ifOn',
				title:'����',
				width:60,
				formatter: function (value, row) {
					return value === 'Y' ? '��' : '��';
				}
			},
			{field:'sortNo',title:'˳��',width:60},
			{field:'id',title:'ID',width:80}
		]],
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		rownumbers:true,
		singleSelect:true,
		width:500,
		toolbar: [{
			id: 'btnAdd',
			iconCls: 'icon-add',
			text:'����',
			handler: function(e) {
				propertyDialog('Add');
			}
		},{				
			id: 'btnEdit',
			iconCls: 'icon-write-order',
			text:'�޸�',
			handler: function(e) {
				propertyDialog('Modify');
			}
		},{	
			id: 'btnDelete',			
			iconCls: 'icon-cancel',
			text:'ɾ��',
			handler: deleteEpr
		},{	
			id: 'btnParentConfig1',			
			iconCls: 'icon-template',
			text:'�ڵ�ά��',
			handler: function(){
				var url = 'nur.hisui.nurseEprMenuConfig.csp?HospitalID=' + GLOBAL.HospitalID;
				$('#dialogMenu').dialog({  
					title: '�ڵ�ά��',
					iconCls: 'icon-w-list',
				    width: 1000,  
				    height: 600,  
				    cache: false,  
				    content:"<iframe scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
				    modal: true
				});
				$("#dialogMenu").dialog("open");
			}
		}],
		onDblClickRow: function(rowIndex, rowData) {
			propertyDialog('Modify');
		}
	});	
}
/**
* @description: epr������¼�
*/ 
function eprTreeClick(node) {
	$('#methodGrid').datagrid('reload',{
		ClassName: "NurMp.Service.Refer.Epr",
		QueryName: "getEprMenuDetail",
		HospitalID: GLOBAL.HospitalID,
		TypeID: node.id
	});
}
/**
* @description: ����
*/ 
function propertyDialog(methodCode) {
	var title = '����';
	var detailID = '';
	var node = $('#eprTree').tree('getSelected');
	if(!node) {
		$.messager.popover({
			msg: '��ѡ��һ�����ͣ�',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var enableValue = 'Y';
	if (methodCode == 'Add') {
		if(node.id.toString().indexOf('||') < 0) {
			$.messager.popover({
				msg: '��ѡ�����',
				type:'info',
				timeout: 1000
			});
			return;
		}
		$('#name').val('');
		$('#classMethod').val('');
		$('#parameter1').val('');
		$('#parameter2').val('');
		$('#sortNo').val('');
	}else{
		var row = $('#methodGrid').datagrid('getSelected');
		if (!row) {
			$.messager.popover({
				msg: '��ѡ��һ����¼��',
				type:'info',
				timeout: 1000
			});
			return;
		}
		$('#name').val(row.name);
		$('#classMethod').val(row.method);
		$('#parameter1').val(row.param1);
		$('#parameter2').val(row.param2);
		$('#eprType').combobox('select', row.type);
		enableValue = row.ifOn;
		$('#sortNo').val(row.sortNo);
		title = '�޸�';
		detailID = row.id;
	}
	$HUI.dialog('#dialogAdd',{
		title: title,
		width:420,
		height:378,
		iconCls:'icon-w-save',
		resizable:false,
		modal:true,
		buttons:[{
			text:'����',
			iconCls: 'icon-w-save',
			handler:function(){
				save(node.id, detailID);
			}
			},{
				text:'ȡ��',
				iconCls: 'icon-w-cancel',
				handler:function(){
					$HUI.dialog('#dialogAdd').close();
				}
			}
		],
		onOpen: function() {
			$HUI.combobox('#eprType', {
				valueField: 'id',
				textField: 'desc',
				url: $URL + '?ClassName=NurMp.Service.Refer.Epr&MethodName=getEprType&HospitalID=' + GLOBAL.HospitalID,
				value: node.id,
				editable:false
			});
			$HUI.combobox('#ifEnable', {
				valueField: 'id',
				textField: 'text',
				value: enableValue,
				editable:false,
				data:[
					{id:'Y', text:"��"},
					{id:'N', text:"��"},
				]
			});
		}
	});
}
/**
/**
* @description:  ����
*/
function save(typeID, detailID) {
	var name = $('#name').val();
	if (!name) {
		$.messager.popover({msg: '���������ƣ�', type:'alert',timeout: 1000});
		return;
	}
	var classMethod = $('#classMethod').val();
	if (!classMethod) {
		$.messager.popover({msg: '�����뷽����', type:'alert',timeout: 1000});
		return;
	}
	var parameter1 = $('#parameter1').val();
	var parameter2 = $('#parameter2').val();
	var eprType = $('#eprType').combobox('getValue');
	var ifEnable = $('#ifEnable').combobox('getValue');
	var sortNo = $('#sortNo').val();
	if (!sortNo) {
		$.messager.popover({msg: '��������ţ�', type:'alert',timeout: 1000});
		return;
	}
	var params = name + '^' + classMethod + '^' + parameter1 + '^' + parameter2 + '^' + eprType + '^' + ifEnable + '^' + sortNo;
	$m({
		ClassName: "NurMp.Service.Refer.Epr",
		MethodName: "saveDetail",
		HospitalID: GLOBAL.HospitalID,
		TypeID: typeID,
		DetailID: detailID,
		Params: params,
		UserID: session['LOGON.USERID']
	},function(txtData){
		if (txtData == '0') {
			$.messager.popover({
				msg: '����ɹ���',
				type:'success',
				timeout: 1000
			});
			$HUI.dialog('#dialogAdd').close();
			$('#methodGrid').datagrid('reload');
		}else{
			$.messager.popover({
				msg: txtData,
				type:'error',
				timeout: 1000
			});
		}
	});
}
/**
/**
* @description:  ɾ��
*/
function deleteEpr() {
	var row = $('#methodGrid').datagrid('getSelected');
	if (!row) {
		$.messager.popover({
			msg: '��ѡ��һ����¼��',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
		if (r) {	
			$m({
				ClassName: "NurMp.Service.Refer.Epr",
				MethodName: "deleteDetail",
				ID: row.id
			}, function (txtData) {
				if (txtData == '0') {
					$.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 1000 });
					$('#methodGrid').datagrid('reload');
					$('#methodGrid').datagrid('clearSelections');
				}
				else {
					$.messager.popover({ msg: txtData, type: 'alert', timeout: 1000 });
				}
			});
		}
	});
}
/**
/**
* @description:  �����¼�
*/
function listenEvents() {
	
}