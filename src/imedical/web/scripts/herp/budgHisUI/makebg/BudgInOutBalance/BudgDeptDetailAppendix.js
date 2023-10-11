/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制平衡-收支预算编制平衡
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function DetailAppendixWinShow(hospFYRow, auditFYRow, budgFYRow, budgFYDRow) {

	var DetailAppendixWinObj = $HUI.window("#DetailAppendixWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + budgFYRow.deptNa + '-' + budgFYDRow.ecoItemNa + '-' + budgFYDRow.fundTypeNa + '-' + '采购信息',
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
				$('#BudgDeptBgDetailGrid').datagrid("reload");
			}

		});
		
	$("#DetailAppendixWin").css("display", "block");

	var FYDGridColumn = [[{
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
				field: 'purchItemCo',
				title: '采购品目编码',
				width: 120,
				allowBlank: false,
				formatter: function (value, row) {
					return row.purchItemNa;
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: 'code',
						textField: 'name',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemPurch",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
							param.flag = '1';
							param.year = factYearRow.Year;
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
				field: 'budgVal',
				title: '预算总额',
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
				field: 'bgPrice',
				title: '单价',
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
				field: 'bgNum',
				title: '数量',
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
				field: 'desc',
				title: '备注',
				width: 300,
				editor: {
					type: 'text'
				}
			}, {
				field: 'process',
				title: '编制过程',
				width: 100,
				halign: 'center',
				align: 'center',
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '一上'
							}, {
								rowid: '2',
								name: '一下'
							}, {
								rowid: '3',
								name: '二上'
							}, {
								rowid: '4',
								name: '二下'
							}
						]
					}
				}
			}

		]];
		
	//新增按钮
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '新增',
		handler: function () {


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
	
	var DetailAppendixGridObj = $HUI.datagrid('#DetailAppendixGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDAppendix',
				rowid: budgFYDRow.rowid
			},
			columns: FYDGridColumn,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, '-', SaveBtn, '-', DelBt, '-', ClearBT],

		});

	DetailAppendixWinObj.open();

	//关闭
	$("#DAppendixBtnCancel").unbind('click').click(function () {
		DetailAppendixWinObj.close();
	});
};
