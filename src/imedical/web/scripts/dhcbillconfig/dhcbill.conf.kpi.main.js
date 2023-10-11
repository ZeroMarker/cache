/**
 * FileName: dhcbill.conf.kpi.main.js
 * Anchor: ZhYW
 * Date: 2017-08-02
 * Description: 指标维护
 */

//全局变量
var GV = {};

$(function () {
	initQueryMenu();
	initKPIList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.linkbutton("#btn-edit", {
		onClick: function () {
			editClick();
		}
	});
	
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadKPIList();
		}
	});
	
	$HUI.linkbutton("#btn-auth", {
		onClick: function () {
			authClick();
		}
	});
	
	$("#taskType").combobox({
		panelHeight: 'auto',
		url: $URL + '?ClassName=BILL.CFG.COM.HospAuth&QueryName=FindKPITaskType&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		onChange: function (newValue, oldValue) {
			loadKPIList();
		}
	});
}

function initKPIList() {
	GV.KPIList = $HUI.datagrid("#KPIList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: 'ID', field: 'ID', hidden: true},
				   {title: '指标代码', field: 'Code', width: 160},
				   {title: '指标名称', field: 'Name', width: 190},
				   {title: '指标类型', field: 'TypeName', width: 100},
				   {title: '任务类型', field: 'TaskTypeName', width: 100},
				   {title: '类名', field: 'ClassName', width: 150},
				   {title: '方法名', field: 'MethodName', width: 180},
				   {title: '数据存储类型', field: 'StorageType', width: 100},
				   {title: '表名', field: 'TableName', width: 150},
				   {title: '数据节点', field: 'DataNode', width: 100},
				   {title: '维度', field: 'DataDimen', width: 100},
				   {title: '是否启用', field: 'Active', width: 75,
					formatter: function (value, row, index) {
						return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {title: '创建者', field: 'Creator', width: 100},
				   {title: '创建时间', field: 'CreatDate', width: 150,
				    formatter: function(value, row, index) {
					    return value + " " + row.CreatTime;
					}
				   },
				   {title: '备注', field: 'ReMark', width: 150}
			]],
		toolbar: '#tToolBar',
		onDblClickRow: function (rowIndex, rowData) {
			editClick();
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.HospAuth",
			QueryName: "FindKPIDetails",
			taskTypeId: getValueById("taskType"),
			kpiCode: "",
			kpiName: ""
		}
	});
}

function loadKPIList() {
	var queryParams = {
		ClassName: "BILL.CFG.COM.HospAuth",
		QueryName: "FindKPIDetails",
		taskTypeId: getValueById("taskType"),
		kpiCode: "",
		kpiName: ""
	};
	loadDataGridStore("KPIList", queryParams);
}

function addClick() {
	var opt = {
		url: 'dhcbill.conf.kpi.details.csp?',
		title: '新增',
		iconCls: 'icon-w-add'
	};
	showEditModal(opt);
}

/**
* 修改
*/
function editClick() {
	var row = GV.KPIList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	var opt = {
		url: 'dhcbill.conf.kpi.details.csp?&KPIID=' + row.ID,
		title: '修改',
		iconCls: 'icon-w-edit'
	};
	showEditModal(opt);
}

function showEditModal(opt) {
	websys_showModal({
		url: opt.url,
		title: opt.title,
		iconCls: opt.iconCls,
		height: 380,
		width: 540,
		callbackFunc: loadKPIList
	});
}

/**
* 删除
*/
function deleteClick() {
	var row = GV.KPIList.getSelected();
	if (!row || !row.ID) {
		$.messager.popover({msg: "请选择需要删除的行", type: "info"});
		return;
	}
	$.messager.confirm("确定", "您确定要删除该条记录吗？", function (r) {
		if (r) {
			$.m({
				ClassName: "BILL.CFG.COM.HospAuth",
				MethodName: "DeleteKPI",
				kpiId: row.ID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "删除成功", type: "success"});
					loadKPIList();
				} else {
					$.messager.popover({msg: "保存失败，错误代码：" + rtn, type: "error"});
				}
			});
		}
	});
	
	//以下代码控制焦点在取消按钮
	$(".messager-button>a .l-btn-text").each(function(index, item) {
		var $okSpan = $(item);
		if ($.inArray($okSpan.text(), ["Cancel", "取消"])) {
			$okSpan.parent().parent().trigger("focus");   //取消按钮聚焦
		}
	});
}

/**
* 授权
*/
function authClick() {
	var row = GV.KPIList.getSelected();
	if (!row || !row.ID) {
		$.messager.popover({msg: "请选择需要授权的行", type: "info"});
		return;
	}
	GenHospWin("Bill_Com_KPI", row.ID);
}
