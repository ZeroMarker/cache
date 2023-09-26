/**
 * FileName: dhcbill.conf.kpi.main.js
 * Anchor: ZhYW
 * Date: 2017-08-02
 * Description: 
 */

$(function () {
	initBtn();
	initMainCombo();
	initBillKPIGrid();
});

function initBtn() {
	$HUI.linkbutton("#btnAdd", {
		onClick: function () {
			addBillKPI();
		}
	});
	
	$HUI.linkbutton("#btnEdit", {
		onClick: function () {
			editBillKPI();
		}
	});
	
	$HUI.linkbutton("#btnDelete", {
		onClick: function () {
			deleteBillKPI();
		}
	});
	
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadBillKPIGrid();
		}
	});
	
	$HUI.linkbutton("#btnAuth", {
		onClick: function () {
			hospAuthClick();
		}
	});
}

function initMainCombo() {
	$('#taskType').combobox({
		panelHeight: 'auto',
		url: $URL + "?ClassName=BILL.CFG.COM.HospAuth&QueryName=FindKPITaskType&ResultSetType=array",
		valueField: 'id',
		textField: 'text',
		onChange: function (newValue, oldValue) {
			loadBillKPIGrid();
		}
	});
}

function initBillKPIGrid() {
	$('#tBillKPI').datagrid({
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
			editBillKPI();
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

function loadBillKPIGrid() {
	var queryParams = {
		ClassName: "BILL.CFG.COM.HospAuth",
		QueryName: "FindKPIDetails",
		taskTypeId: getValueById("taskType"),
		kpiCode: "",
		kpiName: ""
	};
	loadDataGridStore('tBillKPI', queryParams);
}

function addBillKPI() {
	websys_showModal({
		url: 'dhcbill.conf.kpi.details.csp?',
		title: '新增',
		iconCls: 'icon-w-add',
		height: 380,
		width: 540,
		callbackFunc: loadBillKPIGrid
	});
}

/**
* 修改
*/
function editBillKPI() {
	var row = $('#tBillKPI').datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的行", type: "success"});
		return;
	}
	websys_showModal({
		url: 'dhcbill.conf.kpi.details.csp?&KPIID=' + row.ID,
		title: '修改',
		iconCls: 'icon-w-edit',
		height: 380,
		width: 540,
		callbackFunc: loadBillKPIGrid
	});
}

/**
* 删除
*/
function deleteBillKPI() {
	var selectedRow = $('#tBillKPI').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.popover({msg: "请选择需要删除的行", type: "success"});
		return;
	}
	var ID = selectedRow.ID;
	$.messager.confirm('提示', '您确定要删除该条记录吗？', function (r) {
		if (r) {
			$.m({
				ClassName: "BILL.CFG.COM.HospAuth",
				MethodName: "DeleteKPI",
				kpiId: ID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', '删除成功', 'success');
					loadBillKPIGrid();
				} else {
					$.messager.alert('提示', '保存失败，错误代码：' + rtn);
				}
			});
		}
	});
	//以下代码控制焦点在取消按钮
	var okSpans = $('.l-btn-text');
	var len = okSpans.length;
	for (var i = 0; i < len; i++) {
		var $okSpan = $(okSpans[i]);
		var okSpanHtml = $okSpan.html();
		if (okSpanHtml == 'Cancel' || okSpanHtml == '取消') {
			$okSpan.parent().parent().trigger('focus');
		}
	}
}

/**
* 授权
*/
function hospAuthClick() {
	websys_showModal({
		url: 'dhcbill.conf.hosp.kpi.csp?',
		title: '授权',
		iconCls: 'icon-w-edit',
		height: 450,
		width: 400
	});
}
