/*
Description: 全面预算管理-基本信息维护-配置项目经济科目
CSPName: herp.budg.hisui.budgitemeconomic.csp
ClassName: herp.budg.hisui.udata.uBudgItemEconomic
 */

var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
var groupid = session['LOGON.GROUPID'];
var WinCopyObj = '';
var budgItemTree = '';
var addItemsObj = '';
var isAll = false; //管控是否展开所选节点所有子节点

//医疗单位初始化
function HospBefLoad(param) {
	param.userdr = userid;
	param.rowid = hospid;
	param.str = param.q;
}

//复制弹出窗--历史年度选择事件
function PastYearSelect(param) {
	$('#BudgYear').combobox('clear');
	$('#BudgYear').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=EndYear&ResultSetType=array');
	$('#BudgYear').combobox('enable');
}

//复制弹出窗--预算年度初始化
function BudgYearBefLoad(param) {
	param.startYear = $('#PastYear').combobox('getValue');
	param.str = param.q;
}

//年度下拉框加载前事件
function YearBefLoad(param) {
	param.flag = '';
}
//年度下拉框选择事件：根据所选年度查询对应预算支出科目
function YearOnSelect(rec) {
	//combogrid重新加载方法
	$('#itemcb').combogrid('clear');
	//$('#itemcb').combogrid('grid').datagrid('options').url = $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem';
	$('#itemcb').combogrid('grid').datagrid('reload');

}
//科目下拉框加载前事件
function ItemBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.year = $('#yearcb').combobox('getValue');
	param.flag = '1';
	param.type = '';
	param.level = '';
	param.supercode = '';
	param.str = param.q;
}
//复制弹出窗--保存
function WinSave() {
	var data = '';
	var hospid = $('#CopyHosp').combobox('getValue');
	if (!hospid) {
		$.messager.popover({
			msg: '请选择医疗单位!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;

	}
	var pastyear = $('#PastYear').combobox('getValue');
	if (!pastyear) {
		$.messager.popover({
			msg: '请选择历史年度!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;
	}
	var budgyear = $('#BudgYear').combobox('getValue');
	if (!budgyear) {
		$.messager.popover({
			msg: '请选择预算年度!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;
	}

	data = hospid + '^' + pastyear + '^' + budgyear;

	if (data) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgItemEconpmic',
			MethodName: 'Copy',
			data: data
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: '复制成功!',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});

			} else {
				$.messager.popover({
					msg: '复制失败!' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});
			};
		});
	}
}
		
	//点击末级预算科室刷新右侧对应的预算项目表格
	function onClickRow(row) {
		if ($('#budgLocTree').treegrid('getSelected').isLast == 1) {
			SearchItems($('#budgLocTree').treegrid('getSelected').id);
		}
	}


//查询科室归口的科目
function SearchItems(deptId) {
	if (!deptId && (!$('#budgLocTree').treegrid('getSelected') || ($('#budgLocTree').treegrid('getSelected').isLast != 1))) {
		$.messager.popover({
			msg: '请先选择末级预算项目!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;

	}

	$('#itemsGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
		MethodName: "EcoList",
		Hospid: hospid,
		Year: $('#budgLocTree').treegrid('getSelected').year,
		itemcode: $('#budgLocTree').treegrid('getSelected').code,
		ecocode: $('#itemcb').combogrid('grid').datagrid('getSelected') !== null ? $('#itemcb').combogrid('grid').datagrid('getSelected').ecoItemCo : ''
	});
}

//查询经济科目
function AddItems() {
	$("#addItemNa").val('');
	var yearCmb = $HUI.combobox('#addYearCmb', {
			placeholder: '必选',
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			},
			onSelect: function (record) {
				$('#budgItemTree').treegrid('load', {
					ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
					MethodName: 'List',
					hospid: hospid,
					Year: $("#addYearCmb").combobox('getValue'),
				});

			}
		});

	//查询方法
	$("#addfindBtn").click(function () {
		//获取年度
		var year = $("#addYearCmb").combobox('getValue');
		if (!year) {
			$.messager.popover({
				msg: '请先选择年度!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		//过滤查询
		if (year != '') {
			$('#budgItemTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
				MethodName: 'List',
				hospid: hospid,
				Year: $("#addYearCmb").combobox('getValue'),
				Name: $("#addItemNa").val()
			});
		}
	});

	//获取选中的末级预算科室ID
	var CheckedNodes = $('#budgLocTree').treegrid('getCheckedNodes');
	//console.log(JSON.stringify(CheckedNodes))
	var deptIds = '',
	deptYear = '';
	for (i = 0; i < CheckedNodes.length; i++) {
		//alert(CheckedNodes[i].isLast);
		if (CheckedNodes[i].isLast == 1) {
			if (deptIds == '') {
				deptIds = CheckedNodes[i].id;
				deptYear = CheckedNodes[i].year;
			} else {
				deptIds = deptIds + "^" + CheckedNodes[i].id;
								//alert(deptIds)

			}
		}
	}
	//console.log(deptIds)
	if (deptIds == '') {
		$.messager.popover({
			msg: '请先选中末级预算项目的复选框!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;
	}

	//取消勾选的节点
	$('#budgItemTree').treegrid('clearChecked');

	if (!addItemsObj) {
		$("#addItemsWin").show();
		addItemsObj = $HUI.dialog("#addItemsWin", {
				onClose: function () {
					//取消勾选的节点
					$('#budgLocTree').treegrid('clearChecked');
				}
			});
	} else {
		addItemsObj.open();
	}
}

//查询科室归口的科目
function DelItems() {
	var itemIds = '';
	var Rows = $('#itemsGrid').datagrid('getSelections');
	if (Rows == "") {
		$.messager.alert('提示', '请选择删除项!');
		return;
	} else {
		for (i = 0; i < Rows.length; i++) {
			if (itemIds == '')
				itemIds = Rows[i].rowid;
			else
				itemIds = itemIds + "^" + Rows[i].rowid;
		}
	}

	if (itemIds) {
		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
			MethodName: "DelEco",
			rowids: itemIds
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: '删除成功！',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});
			} else {
				$.messager.popover({
					msg: '删除失败：' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});
			};
		});
	}
}

//保存
function SaveItemsFn() {
	//获取选中的末级预算项目code
	var CheckedItemNodes = $('#budgLocTree').treegrid('getCheckedNodes');
	var deptIds = '';
	for (i = 0; i < CheckedItemNodes.length; i++) {
		if (CheckedItemNodes[i].isLast == 1) {
			if (deptIds == '') {
				deptIds = CheckedItemNodes[i].code;
			} else {
				deptIds = deptIds + "^" + CheckedItemNodes[i].code;
			}
		}
	}

	//获取选中的末级经济科目code
	var CheckedEcoNodes = $('#budgItemTree').treegrid('getCheckedNodes');
	var itemIds = '';
	for (i = 0; i < CheckedEcoNodes.length; i++) {
		if (CheckedEcoNodes[i].IsLast == 1) {
			if (itemIds == '') {
				itemIds = CheckedEcoNodes[i].Code;
			} else {
				itemIds = itemIds + "^" + CheckedEcoNodes[i].Code;
			}
		}
	}

	if (deptIds && itemIds) {

		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
			MethodName: "Save",
			Hospid: hospid,
			Year: $("#YearBox").combobox('getValue'),
			ItemCodes: deptIds,
			EcoCodes: itemIds
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: '保存成功！',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});
			} else {
				$.messager.popover({
					msg: '保存失败：' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});
			};
		});
	}
}

//关闭窗口
function CloseWinFn() {
	addItemsObj.close();
}

//文档就绪事件
$(function () {
	$("#addItemNa").val('');
	Init();
});

function Init() {

	var yearCmb = $HUI.combobox('#YearBox', {
			placeholder: '必选',
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			},
			onSelect: function (record) {

				$('#budgLocTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
				});

			}
		});
		
	//数据加载完成之后触发
	function onLoadSuccessFN(row, data) {
		if (row && isAll) {
			var data = $('#budgLocTree').treegrid('getChildren', row.id);
			for (i = 0; i < data.length; i++) {
				if (data[i].state == 'closed') {
					$('#budgLocTree').treegrid('expandAll', data[i].id);
				}
			}
		} else {
			return;
		}
	}

	//定义树形表格
	var budgLocTreeObj = $HUI.treegrid('#budgLocTree', {
			checkbox: true,
			lines: true,
			fit: true,
			idField: 'id',
			treeField: 'name',
			rownumbers: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
			},
			onClickRow: onClickRow,
			onLoadSuccess: onLoadSuccessFN,
			toolbar: '#deptToolbar',
			columns: [[{
						title: '医疗单位ID',
						field: 'hospId',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '医疗单位名称',
						width: '140',
						field: 'hospNa',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '年度',
						width: '140',
						field: 'year',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '是否末级',
						width: '140',
						field: 'isLast',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '预算项目ID',
						field: 'id',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '预算项目编码',
						width: '150',
						field: 'code',
						halign: 'left',
						align: 'left'
					}, {
						title: '预算项目名称',
						width: '320',
						field: 'name',
						halign: 'left',
						align: 'left'
					}

				]]

		});

	//查询方法
	$("#findBtn").click(function () {
		var codeNa = $("#CodeName").val();
		$('#budgLocTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
		});
	});

	//全部展开
	$('#expandAllBtn').click(function () {
		isAll = true;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('expandAll', SelectedNode.id);
	});

	//全部折叠
	$('#collapAllBtn').click(function () {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('collapseAll', SelectedNode.id);
	});

	//复制科室的往年归口科目到目标年度
	$('#copyBtn').click(function () {
		$('#CopyHosp').combobox('setValue', '');
		$('#PastYear').combobox('setValue', '');
		$('#BudgYear').combobox('setValue', '');

		//复制弹出窗--取消
		function WinCancel() {
			WinCopyObj.close();
		}

		$('#copyDlg').show();
		WinCopyObj = $HUI.dialog('#copyDlg', {});
	});

	//类别下拉框加载前事件
	function deptTyBefLoad(param) {
		param.str = param.q;
		param.hospid = hospid;
		param.userdr = userid;
	}

	//类别下拉框选择事件：清空并重新加载科室下拉框
	function deptTyOnSelect(rec) {
		$("#deptcb").combobox('clear');
		$('#deptcb').combobox('reload');

	}

	//科室下拉框加载前事件触发方法
	function DeptBefLoad(param) {
		param.hospid = hospid;
		param.userdr = userid;
		param.flag = '1^' + $("#deptTycb").combobox('getValue');
		param.str = '';
	}

	//单击科室表格方法
	function DeptsGridClickRow(rowIndex, rowData) {
		//alert(rowData.rowid);
		SearchItems(rowData.rowid);
	}

}
