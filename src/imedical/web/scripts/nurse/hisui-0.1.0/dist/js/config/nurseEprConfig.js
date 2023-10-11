/*
 * @author: yaojining
 * @discription: 护理病历关联电子病历维护
 * @date: 2020-9-14
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_EprMenu',
};

$(initUI);

/**
* @description: 初始化界面
*/
function initUI() {
	initHosp(function(){
		initEprTree();
		initMethodGrid();
	});
	listenEvents();
}

/**
* @description: 初始化所有模板表格
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
* @description: 初始化所有模板表格
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
			{field:'name',title:'名称',width:120},
			{field:'method',title:'方法',width:400},
			{field:'param1',title:'参数1',width:120},
			{field:'param2',title:'参数2',width:120},
			{field:'type',title:'分类',width:80},
			{
				field:'ifOn',
				title:'启用',
				width:60,
				formatter: function (value, row) {
					return value === 'Y' ? '是' : '否';
				}
			},
			{field:'sortNo',title:'顺序',width:60},
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
			text:'新增',
			handler: function(e) {
				propertyDialog('Add');
			}
		},{				
			id: 'btnEdit',
			iconCls: 'icon-write-order',
			text:'修改',
			handler: function(e) {
				propertyDialog('Modify');
			}
		},{	
			id: 'btnDelete',			
			iconCls: 'icon-cancel',
			text:'删除',
			handler: deleteEpr
		},{	
			id: 'btnParentConfig1',			
			iconCls: 'icon-template',
			text:'节点维护',
			handler: function(){
				var url = 'nur.hisui.nurseEprMenuConfig.csp?HospitalID=' + GLOBAL.HospitalID;
				$('#dialogMenu').dialog({  
					title: '节点维护',
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
* @description: epr树点击事件
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
* @description: 属性
*/ 
function propertyDialog(methodCode) {
	var title = '新增';
	var detailID = '';
	var node = $('#eprTree').tree('getSelected');
	if(!node) {
		$.messager.popover({
			msg: '请选择一种类型！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var enableValue = 'Y';
	if (methodCode == 'Add') {
		if(node.id.toString().indexOf('||') < 0) {
			$.messager.popover({
				msg: '请选择子项！',
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
				msg: '请选择一条记录！',
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
		title = '修改';
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
			text:'保存',
			iconCls: 'icon-w-save',
			handler:function(){
				save(node.id, detailID);
			}
			},{
				text:'取消',
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
					{id:'Y', text:"是"},
					{id:'N', text:"否"},
				]
			});
		}
	});
}
/**
/**
* @description:  保存
*/
function save(typeID, detailID) {
	var name = $('#name').val();
	if (!name) {
		$.messager.popover({msg: '请输入名称！', type:'alert',timeout: 1000});
		return;
	}
	var classMethod = $('#classMethod').val();
	if (!classMethod) {
		$.messager.popover({msg: '请输入方法！', type:'alert',timeout: 1000});
		return;
	}
	var parameter1 = $('#parameter1').val();
	var parameter2 = $('#parameter2').val();
	var eprType = $('#eprType').combobox('getValue');
	var ifEnable = $('#ifEnable').combobox('getValue');
	var sortNo = $('#sortNo').val();
	if (!sortNo) {
		$.messager.popover({msg: '请输入序号！', type:'alert',timeout: 1000});
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
				msg: '保存成功！',
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
* @description:  删除
*/
function deleteEpr() {
	var row = $('#methodGrid').datagrid('getSelected');
	if (!row) {
		$.messager.popover({
			msg: '请选择一条记录！',
			type:'info',
			timeout: 1000
		});
		return;
	}
	$.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
		if (r) {	
			$m({
				ClassName: "NurMp.Service.Refer.Epr",
				MethodName: "deleteDetail",
				ID: row.id
			}, function (txtData) {
				if (txtData == '0') {
					$.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
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
* @description:  监听事件
*/
function listenEvents() {
	
}