/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制平衡-收支预算编制平衡
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function BudgDeptBgDetailWinShow(hospFYRow, auditFYRow, budgFYRow) {
	var startIndex = undefined;
	
	var mainId = budgFYRow.rowid;
	if (!mainId) {
		$.messager.popover({
			msg: '主表ID为空!',
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
		return;
	}

	
	var BudgDeptBgDetailWinObj = $HUI.window("#BudgDeptBgDetailWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + budgFYRow.deptNa + '-' + '业务科室年预算明细',
			iconCls:'icon-w-edit',
			width: 1015,
			height: 500,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			draggable: true,
			modal: true,
			onClose: function () { //关闭关闭窗口后触发
				$('#BudgDeptBgGrid').datagrid("reload");
			}

		});
		
	$("#BudgDeptBgDetailWin").css("display", "block");

	var BDBDetaiGridColumn = [[{
				field: 'ck',
				checkbox: true
			}, {
				field: 'rowid',
				title: 'ID',
				hidden: true
			}, {
				field: 'mainId',
				title: '主表ID',
				hidden: true
			}, {
				field: 'ecoItemCo',
				title: '经济科目',
				width: 120,
				allowBlank: false,
				formatter: function (value, row) {
					return row.ecoItemNa;
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: 'ecoItemCo',
						textField: 'ecoItemNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemEco",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
							param.flag = '1^3';
							param.type = '';
							param.level = '';
							param.supercode = '';
						},
						required: true
					}
				}

			}, {
				field: 'fundTypeId',
				title: '资金性质',
				width: 100,
				allowBlank: false,
				formatter: function (value, row) {
					return row.fundTypeNa;
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: 'fundTypeId',
						textField: 'fundTypeNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
						},
						required: true
					}
				}
			}, {
				field: 'oneUpVal',
				title: '一上预算',
				width: 100,
				halign: 'right',
				align: 'right',
				allowBlank: false,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'oneDowVal',
				title: '一下预算',
				width: 100,
				halign: 'right',
				align: 'right',
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoUpVal',
				title: '二上预算',
				width: 100,
				halign: 'right',
				align: 'right',
				allowBlank: false,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoDowVal',
				title: '二下预算',
				width: 100,
				halign: 'right',
				align: 'right',
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}

				
			}, {
				field: 'planVal',
				title: '最终预算',
				width: 100,
				halign: 'right',
				align: 'right',
				formatter: ValueFormatter,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				},
				styler: function (value, row, index) {
					return 'background-color:#E7F7FE;color:red;cursor:hand;cursor:pointer;';
				}
			}, {
				field: 'desc',
				title: '备注',
				width: 300,
				editor: {
					type: 'text'
				}
			}

		]]
		
	//新增按钮
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '新增',
		handler: function () {
			if (FYDEndEditing()) {
				$('#BudgDeptBgDetailGrid').datagrid('appendRow', {
					rowid: '',
					mainId: mainId,
					ecoItemCo: '',
					fundTypeId: '',
					oneUpVal: '',
					oneDowVal: '',
					twoUpVal: '',
					twoDowVal: '',
					planVal: '',
					desc: ''
				});
				//置对应列可编辑
				var fields = $('#BudgDeptBgDetailGrid').datagrid('getColumnFields', true).concat($('#BudgDeptBgDetailGrid').datagrid('getColumnFields'));
				for (var i = 5; i < fields.length - 1; i++) {
					//alert(fields[i]);
					var col = $('#BudgDeptBgDetailGrid').datagrid('getColumnOption', fields[i]);

					if (i == 9) {
						col.editor = col.editor;
					} else {
						col.editor = null;
					}
				}
				
				startIndex = $('#BudgDeptBgDetailGrid').datagrid('getRows').length - 1;
				$('#BudgDeptBgDetailGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

			}
		}
	}
	//保存按钮
	var SaveBtn = {
		id: 'FYDSave',
		iconCls: 'icon-save',
		text: '保存',
		handler: function () {
		}
	}
	//删除按钮
	var DelBt = {
		id: 'FYDDel',
		iconCls: 'icon-cancel',
		text: '删除',
		handler: function () {
		}
	}
	//清空按钮
	var ClearBT = {
		id: 'FYDReset',
		iconCls: 'icon-reset',
		text: '重置',
		handler: function () {
		}
	}		

	var BudgDeptBgDetailGridObj = $HUI.datagrid('#BudgDeptBgDetailGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDetail',
				rowid: budgFYRow.rowid
			},
			columns: BDBDetaiGridColumn,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, '-', SaveBtn, '-', DelBt, '-', ClearBT],
			onClickCell: BudgDeptBgDetailClickCell
		});
		
	//判断是否结束编辑
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#BudgDeptBgDetailGrid').datagrid('validateRow', startIndex)) {
			$('#BudgDeptBgDetailGrid').datagrid('endEdit', startIndex);
			startIndex = undefined;
			return true;
		} else {
			return false;
		}
	}		

	//点击单元格事件
	function BudgDeptBgDetailClickCell(index, field) {

		var budgFYDRow = $('#BudgDeptBgDetailGrid').datagrid('getRows')[index];
		//点击年预算链接弹出采购明细
		if (field == "planVal") {
			DetailAppendixWinShow(hospFYRow, auditFYRow, budgFYRow, budgFYDRow);
		}

	}

	BudgDeptBgDetailWinObj.open();

	//关闭
	$("#BDBDBtnCancel").unbind('click').click(function () {
		BudgDeptBgDetailWinObj.close();
	});
};
