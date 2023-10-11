/*
Creator: Liu XiaoMing
CreatDate: 2018-09-04
Description: 全面预算管理-基本信息维护-预算年月维护
CSPName: herp.budg.hisui.zeroadjust.csp
ClassName: herp.budg.hisui.udata.uBudgAdjust,
herp.budg.udata.uBudgAdjust
 */

var yearColumn = [[{
			field: 'ck',
			checkbox: true
		}, {
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'compNa',
			title: '医疗单位',
			halign: 'center',
			width: 300,
			hidden: true
		}, {
			field: 'year',
			title: '年度',
			halign: 'left',
			width: 150,
			allowBlank: false,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min:2016,
					max:3000
				}
			}
		}
	]]

//自动生成按钮
var AutoAddBtn = {
	id: 'AutoAdd',
	iconCls: 'icon-add',
	text: '自动生成',
	handler: function () {
		AutoAdd();
	}
}

//增加按钮
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '新增',
	handler: function () {

		if (endEditing()) {
			$('#BudgYearGrid').datagrid('appendRow', {
				rowid: '',
				compNa: '',
				year: ''
			});

			startIndex = $('#BudgYearGrid').datagrid('getRows').length - 1;
			$('#BudgYearGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

		}
	}
}

//保存按钮
var SaveBtn = {
	id: 'Save',
	iconCls: 'icon-save',
	text: '保存',
	handler: function () {
		Save();
	}
}

//删除按钮
var DelBtn = {
	id: 'Del',
	iconCls: 'icon-cancel',
	text: '删除',
	handler: function () {
		Del();
	}
}

var yearGridObj = $HUI.datagrid('#BudgYearGrid', {
		title: '预算年度',
		headerCls: 'panel-header-gray',
		iconCls:'icon-paper',
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgAdjust',
			MethodName: 'ListBgYears',
			hospid: hospid,
			userid: userid
		},
		columns: yearColumn,
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn],  //AutoAddBtn, 
		onClickRow: ClickRow
	});

var yearMonthColumn = [[{
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'yearMonth',
			title: '年月',
			halign: 'left',
			width: 150
		}, {
			field: 'startDate',
			title: '月初',
			halign: 'left',
			width: 150
		}, {
			field: 'endDate',
			title: '月末',
			halign: 'left',
			width: 150
		}
	]]

var YearMonthGridObj = $HUI.datagrid('#YearMonthGrid', {
		title: '预算年月',
		headerCls: 'panel-header-gray',
		iconCls:'icon-paper',
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgAdjust',
			MethodName: 'ListYearMonth',
			hospid: hospid,
			userid: userid
		},
		toolbar:"#tb",
		columns: yearMonthColumn,
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 12,
		pageList: [12, 24, 36, 48, 60]
	});
	
//点击单元格事件
function ClickRow(rowIndex, rowData) {
	if(rowData.rowid!=''){
		$('#YearMonthGrid').datagrid('load', {
			ClassName: 'herp.budg.hisui.udata.uBudgAdjust',
			MethodName: 'ListYearMonth',
			hospid: hospid,
			userid: userid,
			year: rowData.year
		});
	}
}	
	
//自动生成
function AutoAdd() {

	var rowid = "";
	var adjNo = 0;
	var adjDate = "";
	var adjFile = "";
	var desc = encodeURIComponent("期初预算");
	var isApprove = 0;
	var isElast = 0;
	var elastMon = "";
	var mainData = rowid
		 + '^' + hospid
		 + '^' + (new Date().getFullYear() + 1)
		 + '^' + adjNo
		 + '^' + adjDate
		 + '^' + adjFile
		 + '^' + desc
		 + '^' + isApprove
		 + '^' + isElast
		 + '^' + elastMon;
	//alert(mainData);
	DoSave(mainData);
	$('#BudgYearGrid').datagrid("reload");
	$('#YearMonthGrid').datagrid("reload");
}	
	

//保存前校验
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined)) {
						var info = title + "列为必填项，不能为空！";
						$.messager.popover({
							msg: info,
							type: 'info',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 10
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}

//保存方法
function Save() {
	var grid = $('#BudgYearGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
			if (t) {
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var rowid = "";
						var adjNo = 0;
						var adjDate = "";
						var adjFile = "";
						var desc = encodeURIComponent("期初预算");
						var isApprove = 0;
						var isElast = 0;
						var elastMon = "";
						var tempdata = rowid
							 + '^' + hospid
							 + '^' + row.year
							 + '^' + adjNo
							 + '^' + adjDate
							 + '^' + adjFile
							 + '^' + desc
							 + '^' + isApprove
							 + '^' + isElast
							 + '^' + elastMon;
						if (mainData == "") {
							mainData = tempdata;
						} else {
							mainData = mainData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				if (flag == 1) {
					DoSave(mainData);
				}
				grid.datagrid("reload");
				$('#YearMonthGrid').datagrid("reload");
			}
		})
	}
}

//保存请求后台方法
var DoSave = function (mainData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgAdjust',
		MethodName: 'Save',
		mainData: mainData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '添加成功！',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
		} else {
			$.messager.popover({
				msg: '添加失败！' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
		}
	});
}

function Del() {
	var rows = $('#BudgYearGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '请选中要删除的记录！',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 10
			}
		});
		return;
	}

	$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//新增的行删除
					editIndex = $('#BudgYearGrid').datagrid('getRowIndex', row);
					$('#BudgYearGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgAdjust',
				MethodName: 'Del',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: '删除成功！',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
				} else {
					$.messager.popover({
						msg: '删除失败！' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
				}
			});
			$('#BudgYearGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			$('#BudgYearGrid').datagrid("reload");
			$('#YearMonthGrid').datagrid("reload");
			startIndex = undefined;
			return startIndex;
		}
	})
}