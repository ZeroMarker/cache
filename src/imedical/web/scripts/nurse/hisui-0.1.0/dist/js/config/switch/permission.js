/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置-授权
 */
var GLOBAL = {
	ConfigTableName: 'Nur_IP_RecordsConfig',
	ClassName: 'NurMp.Service.Switch.Permission'
};
/**
 * @description 初始化界面
 */
function initUI() {
	loadGrid();
	listenEvents();
}
$(initUI);
/**
 * @description 加载所有grid
 */
function loadGrid() {
	initConditions();
	loadLocs();
	loadModels();
}
/**
 * @description 初始化条件
 */
function initConditions() {
	$('#cbConfig').combobox({
		valueField: 'id',
		textField: 'text',
		value: 'nur.hisui.nurseSwitchConfig.edit.csp',
		data: [
			{ id: 'nur.hisui.nurseSwitchConfig.edit.csp', text: "功能开关配置->病历填写" }
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
			{ field: 'LocDesc', title: '名称', width: 100 },
			{ field: 'HospDesc', title: '院区', width: 100 },
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
 * @description 初始化下拉模板树
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
 * @description 加载科室
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
			{ field: 'LocDesc', title: '名称', width: 210 },
			{ field: 'HospDesc', title: '院区', width: 210 },
			{ field: 'LocId', title: '科室ID', width: 50, hidden: true },
			{ field: 'Id', title: '数据ID', width: 70, hidden: true },
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
 * @description 加载模板
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
			{ field: 'ModelDesc', title: '名称', width: 300 },
			{ field: 'ModelRoot', title: '父目录', width: 120},
			{ field: 'ModelId', title: '模板ID', width: 70},
			{ field: 'Id', title: '数据ID', width: 70, hidden: true  },
		]],
		idField: 'Id'
	});
}
/**
 * @description 科室加入
 */
function addLoc() {
	var locs = $("#cbLoc").combobox("getValues");
	if (locs.length < 1) {
		$.messager.alert("提示", "请选择需要授权的科室！", "info");
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
			$.messager.popover({ msg: "保存成功！", type: "success" });
			$('#cbLoc').combobox('clear');
			$("#gridLoc").datagrid("reload");
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
		}
	});
}
/**
 * @description 科室移出
 */
function removeLoc() {
	var rows = $("#gridLoc").datagrid("getSelections");
	if (rows.length < 1) {
		$.messager.alert("提示", "请选择需要取消授权的科室！", "info");
		return;
	}
	$.messager.confirm("提示", "确定要取消所选择科室的授权吗?", function (r) {
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
 * @description 模板加入
 */
function addModel() {
	var selIds = $('#cbModel').combobox('getValues');
    if(!selIds) {
		$.messager.popover({
			msg: '请选择模板！',
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
			msg: '请选择模板！',
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
			$.messager.popover({ msg: "保存成功！", type: "success" });
			$('#cbModel').combobox('clear');
			$("#gridModel").datagrid("reload");
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
		}
	});
}
/**
 * @description 模板移出
 */
function removeModel() {
	var rows = $("#gridModel").datagrid("getSelections");
	if (rows.length < 1) {
		$.messager.alert("提示", "请选择需要取消授权的模板！", "info");
		return;
	}
	$.messager.confirm("提示", "确定要取消所选择模板的授权吗?", function (r) {
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
 * @description 事件监听
 */
function listenEvents() {
	$('#btnLocAdd').bind('click', addLoc);
	$('#btnLocRemove').bind('click', removeLoc);
	$('#btnModelAdd').bind('click', addModel);
	$('#btnModelRemove').bind('click', removeModel);
}
