/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制平衡-收支预算编制平衡
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */
//全局变量
var isLast = 1;

//末级复选框变化事件
function checkChangeFn(e, value) {
	isLast = value ? 1 : '';
	SearchFn();
}

//文档就绪事件
$(function () {
	Init();
});

function Init() {

	//年度
	var yearcbObj = $HUI.combobox('#yearcb', {
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: YearBefLoad,
			onSelect: function (record) {
				$('#levelcb').combobox('clear');
				$('#levelcb').combobox('reload');

				//重新加载预算项目下拉框
				$('#itemcb').combobox('clear');
				$('#itemcb').combobox('reload',
					$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
					 + '&year=' + record.year);

				SearchFn();
			}

		});

	//项目类别
	var typecbObj = $HUI.combobox('#typecb', {
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType&flag=1&ResultSetType=array',
			mode: 'remote',
			valueField: 'code',
			textField: 'name',
			onSelect: function () {
				//重新加载预算项目下拉框
				$('#itemcb').combobox('clear');
				$('#itemcb').combobox('reload',
					$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
					 + '&year=' + $('#yearcb').combobox('getValue'));

				SearchFn();
			}
		});

	//项目级次
	var typecbObj = $HUI.combobox('#levelcb', {
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemLev&ResultSetType=array',
			mode: 'remote',
			valueField: 'level',
			textField: 'level',
			onBeforeLoad: function (param) {
				param.userid = userid;
				param.hospid = hospid;
				param.year = $('#yearcb').combobox('getValue');
				param.str = param.q;
			},
			onSelect: function () {
				//重新加载预算项目下拉框
				$('#itemcb').combobox('clear');
				$('#itemcb').combobox('reload',
					$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
					 + '&year=' + $('#yearcb').combobox('getValue'));
				SearchFn();

			}
		});

	//预算项目
	var itemcbObj = $HUI.combobox('#itemcb', {
			valueField: 'code',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = '1^3';
				param.type = $('#typecb').combobox('getValue');
				param.level = $('#levelcb').combobox('getValue');
				param.supercode = '';
				param.str = param.q;
			},
			onSelect: function () {
				SearchFn();
			}
		});

	//查询函数
	function SearchFn() {
		var year = $('#yearcb').combobox('getValue');
		if (!year) {
			$.messager.popover({
				msg: '请先选择年度!',
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
		}

		$('#mainGrid').datagrid('load', {
			ClassName: 'herp.budg.hisui.udata.uBudgInOutBalance',
			MethodName: 'ListMain',
			hospid: hospid,
			year: $('#yearcb').combobox('getValue'),
			typeCo: $('#typecb').combobox('getValue'),
			level: $('#levelcb').combobox('getValue'),
			isLast: isLast,
			itemCo: $('#itemcb').combobox('getValue')

		})
	}

	//点击查询按钮
	$("#findBtn").click(SearchFn);

	var mainGridColumn = [[{
				field: 'rowid',
				title: 'ID',
				hidden: true
			}, {
				field: 'compNa',
				halign: 'left',
				title: '医疗单位名称',
				width: 120,
				hidden: true
			}, {
				field: 'itemCo',
				title: '项目编码',
				halign: 'left',
				width: 120
			}, {
				field: 'itemNa',
				title: '项目名称',
				halign: 'left',
				width: 120
			}, {
				field: 'isLast',
				title: '是否末级',
				halign: 'left',
				width: 120,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '是'
							}, {
								rowid: '0',
								name: '否'
							}
						]
					}
				}
			}, {
				field: 'oneUpVal',
				title: '一上预算',
				halign: 'right',
				align: 'right',
				hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'oneDownVal',
				title: '一下预算',
				halign: 'right',
				align: 'right',
				hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoUpVal',
				title: '二上预算',
				halign: 'right',
				align: 'right',
				hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoDownVal',
				title: '二下预算',
				halign: 'right',
				align: 'right',
				hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'planVal',
				title: '全院年预算',
				halign: 'right',
				align: 'right',
				width: 120,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
				/*,
				styler: function (value, row, index) {
				return 'background-color:#E7F7FE;color:red;cursor:hand;cursor:pointer;';
				}*/

			}, {
				field: 'deptsPlanVal',
				title: '科室年预算汇总',
				halign: 'right',
				align: 'right',
				width: 120,
				formatter: ValueFormatter
			}, {
				field: 'disVal',
				title: '差额',
				halign: 'right',
				align: 'right',
				width: 120,
				formatter: dataFormat
			}, {
				field: 'disRate',
				title: '差异率(%)',
				halign: 'right',
				align: 'right',
				width: 120,
				formatter: dataFormat
			}
		]]

	//主表格
	var mainGridObj = $HUI.datagrid('#mainGrid', {
			title: '',
			region: 'center',
			border: false,
			fit: true,
			singleSelect: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgInOutBalance',
				MethodName: 'ListMain',
				hospid: hospid,
				year: $('#yearcb').combobox('getValue'),
				typeCo: $('#typecb').combobox('getValue'),
				level: $('#levelcb').combobox('getValue'),
				isLast: isLast,
				itemCo: $('#itemcb').combobox('getValue')

			},
			columns: mainGridColumn,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [{
					id: 'MainSaveBtn',
					iconCls: 'icon-save',
					text: '保存',
					handler: function () {
						Save();
					}
				}, {
					id: 'ApproBtn',
					iconCls: 'icon-mnypaper-down2',
					text: '预算下达',
					handler: function () {
						if (ChkBefFn()) {
							Approve();
						} else {
							return;
						}
					}
				}, {
					id: 'UnApproBtn',
					iconCls: 'icon-mnypaper-no',
					text: '取消下达',
					handler: function () {
						if (ChkBefFn()) {
							UnApprove();
						} else {
							return;
						}
					}
				}
			],
			onClickCell: MGridClickCell
		});

	//是否启用编辑
	var mainRowIndex = undefined;
	function endEditing() {
		if (mainRowIndex == undefined) {
			return true
		}
		if ($('#mainGrid').datagrid('validateRow', mainRowIndex)) {
			$('#mainGrid').datagrid('endEdit', mainRowIndex);
			mainRowIndex = undefined;
			return true;
		}

		return false;

	}

	//点击单元格事件
	function MGridClickCell(index, field) {

		var hospFYRow = $('#mainGrid').datagrid('getRows')[index];
		//点击科室汇总链接弹出归口科室预算界面
		if (field == "deptsPlanVal") {
			AuditDeptBgWinShow(hospFYRow);
		}

		if (endEditing()) {

			if ((hospFYRow.isLast == 1) && (field == "planVal")) {
				//启用编辑
				$('#mainGrid').datagrid('editCell', {
					index: index,
					field: field
				});
			}
			return mainRowIndex = index;
		}

	}

	//保存方法
	function Save() {

		var grid = $('#mainGrid');
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				grid.datagrid("endEdit", indexs[i]);
			}
		}
		var rows = grid.datagrid("getChanges");
		var rowIndex = "",
		row = "",
		detailData = "";
		if (rows.length > 0) {
			$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						rowIndex = grid.datagrid('getRowIndex', row);
						grid.datagrid('endEdit', rowIndex);
						var tempdata = row.rowid + "^" + row.planVal;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					}
					//alert(detailData);
					SaveOrder(detailData);
					grid.datagrid("reload");
				}
			})
		}
	}

	//保存请求后台方法
	var SaveOrder = function (detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgInOutBalance',
			MethodName: 'Save',
			userid: userid,
			mainData: '',
			detailData: detailData
		},
			function (Data) {
			if (Data == 0) {
				$.messager.popover({
					msg: '保存成功！',
					type: 'success',
					timeout: 5000
				});
			} else {
				$.messager.popover({
					msg: '保存失败！' + Data,
					type: 'error',
					timeout: 5000
				});
			}
		});
	}

	function ChkBefFn() {
		if (!$('#yearcb').combobox('getValue')) {
			$.messager.popover({
				msg: '请先选择年度!',
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
		return true;
	}

	//预算下达方法
	function Approve() {
		$.messager.confirm('确定', '确定要预算下达吗？', function (t) {
			if (t) {
				ApproveOrder();
				grid.datagrid("reload");
			}
		})
	}

	//预算下达请求后台方法
	var ApproveOrder = function () {
		$.m({
			ClassName: 'herp.budg.udata.uBudgInOutBalance',
			MethodName: 'Approve',
			hospid: hospid,
			data: $('#yearcb').combobox('getValue') + "^0"
		},
			function (Data) {
			if (Data == 0) {
				$.messager.popover({
					msg: '预算下达成功！',
					type: 'success',
					timeout: 5000,
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
					msg: '预算下达失败！' + Data,
					type: 'error',
					timeout: 5000,
					showType: 'show',
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

	//取消预算下达方法
	function UnApprove() {
		$.messager.confirm('确定', '确定要取消预算下达吗？', function (t) {
			if (t) {
				UnApproveOrder();
				grid.datagrid("reload");
			}
		})
	}

	//取消预算下达请求后台方法
	var UnApproveOrder = function () {
		$.m({
			ClassName: 'herp.budg.udata.uBudgInOutBalance',
			MethodName: 'UndoApprove',
			hospid: hospid,
			data: $('#yearcb').combobox('getValue') + "^0"
		},
			function (Data) {
			if (Data == 0) {
				$.messager.popover({
					msg: '取消预算下达成功！',
					type: 'success',
					timeout: 5000,
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
					msg: '取消预算下达失败！' + Data,
					type: 'error',
					timeout: 5000,
					showType: 'show',
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
}
