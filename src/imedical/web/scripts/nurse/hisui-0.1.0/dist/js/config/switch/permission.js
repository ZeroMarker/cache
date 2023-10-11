/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-��Ȩ
 */
var GLOBAL = {
	ConfigTableName: 'Nur_IP_RecordsConfig',
	ClassName: 'NurMp.Service.Switch.Permission'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	loadGrid();
	listenEvents();
}
$(initUI);
/**
 * @description ��������grid
 */
function loadGrid() {
	initConditions();
	loadLocs();
	loadModels();
}
/**
 * @description ��ʼ������
 */
function initConditions() {
	$('#cbConfig').combobox({
		valueField: 'id',
		textField: 'text',
		value: 'nur.hisui.nurseSwitchConfig.edit.csp',
		data: [
			{ id: 'nur.hisui.nurseSwitchConfig.edit.csp', text: "���ܿ�������->������д" }
		],
		disabled: true
	});
	$HUI.combogrid("#cbLoc", {
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Common.Base.Hosp",
			QueryName: "FindHospLocs"
		},
		mode: 'remote',
		idField: 'LocId',
		textField: 'LocDesc',
		columns: [[
			{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'LocDesc', title: '����', width: 100 },
			{ field: 'HospDesc', title: 'Ժ��', width: 100 },
			{ field: 'LocId', title: 'ID', width: 40 }
		]],
		multiple: true,
		singleSelect: false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay: 500,
		pagination: true,
		enterNullValueClear: true,
		onBeforeLoad: function (param) {
			var desc = "";
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { HospitalID: HospitalID, ConfigTableName: GLOBAL.ConfigTableName, SearchDesc: desc });
			return true;
		}
	});
}
/**
 * @description ��ʼ������ģ����
 */
function initModelTree(ArrayLoc) {
	var cbtreeModel = $HUI.combotree('#cbModel', {
		multiple: true,
		lines: true,
		panelWidth: 400,
		panelHeight: 400,
		delay: 500,
	});
	$cm({
		ClassName: "NurMp.Service.Template.Directory",
		MethodName: "getTemplates",
		HospitalID: HospitalID,
		TypeCode: 'L',
		LocID: ArrayLoc.join('^')
	}, function (data) {
		cbtreeModel.loadData(data);
	});
}
/**
 * @description ���ؿ���
 */
function loadLocs() {
	$HUI.datagrid('#gridLoc', {
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Service.Switch.Permission',
			QueryName: 'FindAuthLocs',
			HospitalID: HospitalID,
			Page: Page
		},
		columns: [[
			{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'LocDesc', title: '����', width: 210 },
			{ field: 'HospDesc', title: 'Ժ��', width: 210 },
			{ field: 'LocId', title: '����ID', width: 50, hidden: true },
			{ field: 'Id', title: '����ID', width: 70, hidden: true },
		]],
		idField: 'Id',
		onLoadSuccess: function(data) {
			var arrRowIds = new Array();
			$.each(data.rows,function(index, row){
				arrRowIds.push(row.LocId);
			});
			initModelTree(arrRowIds);
		}
	});
}
/**
 * @description ����ģ��
 */
function loadModels() {
	$('#gridModel').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Service.Switch.Permission',
			QueryName: 'FindAuthModels',
			HospitalID: HospitalID,
			Page:Page
		},
		columns: [[
			{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'ModelDesc', title: '����', width: 300 },
			{ field: 'ModelRoot', title: '��Ŀ¼', width: 120},
			{ field: 'ModelId', title: 'ģ��ID', width: 70},
			{ field: 'Id', title: '����ID', width: 70, hidden: true  },
		]],
		idField: 'Id'
	});
}
/**
 * @description ���Ҽ���
 */
function addLoc() {
	var locs = $("#cbLoc").combobox("getValues");
	if (locs.length < 1) {
		$.messager.alert("��ʾ", "��ѡ����Ҫ��Ȩ�Ŀ��ң�", "info");
		return;
	}
	var page = $('#cbConfig').combobox('getValue');
	var param = { 
		CPHospDr: HospitalID, 
		CPPage: Page,
		LocIds: locs.join('^') 
	};
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'SaveAuth',
		Param: JSON.stringify(param)
	}, function (result) {
		if (result.status >=0 ) {
			$.messager.popover({ msg: "����ɹ���", type: "success" });
			$('#cbLoc').combobox('clear');
			$("#gridLoc").datagrid("reload");
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
		}
	});
}
/**
 * @description �����Ƴ�
 */
function removeLoc() {
	var rows = $("#gridLoc").datagrid("getSelections");
	if (rows.length < 1) {
		$.messager.alert("��ʾ", "��ѡ����Ҫȡ����Ȩ�Ŀ��ң�", "info");
		return;
	}
	$.messager.confirm("��ʾ", "ȷ��Ҫȡ����ѡ����ҵ���Ȩ��?", function (r) {
		if (r) {
			var arrRowIds = new Array();
			$.each(rows,function(index,row){
				arrRowIds.push(row.Id);
			});
			$cm({
				ClassName: 'NurMp.Common.Logic.Handler',
				MethodName: 'Delete',
				ClsName: 'CF.NUR.EMR.PermissionLoc',
				Ids: arrRowIds.join('^')
			}, function (result) {
				if (result.status >=0 ) {
					$.messager.popover({ msg: result.msg, type: "success" });
					$("#gridLoc").datagrid("reload");
				} else {
					$.messager.popover({ msg: result.msg, type: "error" });
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description ģ�����
 */
function addModel() {
	var selIds = $('#cbModel').combobox('getValues');
    if(!selIds) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var isRoot = false;
	var models = new Array();
	for (var i=0; i < selIds.length; i++) {
		if (selIds[i].indexOf('|') < 0) {
			isRoot = true;
		} else {
			models.push(selIds[i]);
		}
	}
	if ((isRoot) && (models.length == 0)) {
		$.messager.popover({
			msg: '��ѡ��ģ�壡',
			type:'info',
			timeout: 1000
		});
		return;
	}
	var page = $('#cbConfig').combobox('getValue');
	var param = { 
		CPHospDr: HospitalID, 
		CPPage: Page,
		ModelIds: models.join('^')
	};
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'SaveAuth',
		Param: JSON.stringify(param)
	}, function (result) {
		if (result.status >=0 ) {
			$.messager.popover({ msg: "����ɹ���", type: "success" });
			$('#cbModel').combobox('clear');
			$("#gridModel").datagrid("reload");
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
		}
	});
}
/**
 * @description ģ���Ƴ�
 */
function removeModel() {
	var rows = $("#gridModel").datagrid("getSelections");
	if (rows.length < 1) {
		$.messager.alert("��ʾ", "��ѡ����Ҫȡ����Ȩ��ģ�壡", "info");
		return;
	}
	$.messager.confirm("��ʾ", "ȷ��Ҫȡ����ѡ��ģ�����Ȩ��?", function (r) {
		if (r) {
			var arrRowIds = new Array();
			$.each(rows,function(index,row){
				arrRowIds.push(row.Id);
			});
			$cm({
				ClassName: 'NurMp.Common.Logic.Handler',
				MethodName: 'Delete',
				ClsName: 'CF.NUR.EMR.PermissionModel',
				Ids: arrRowIds.join('^')
			}, function (result) {
				if (result.status >=0 ) {
					$.messager.popover({ msg: result.msg, type: "success" });
					$("#gridModel").datagrid("reload");
				} else {
					$.messager.popover({ msg: result.msg, type: "error" });
				}
			});
		} else {
			return;
		}
	});
}

/**
 * @description �¼�����
 */
function listenEvents() {
	$('#btnLocAdd').bind('click', addLoc);
	$('#btnLocRemove').bind('click', removeLoc);
	$('#btnModelAdd').bind('click', addModel);
	$('#btnModelRemove').bind('click', removeModel);
}
