/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: ȫ��Ԥ�����-Ԥ�����ƽ��-��֧Ԥ�����ƽ��
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function DetailAppendixWinShow(hospFYRow, auditFYRow, budgFYRow, budgFYDRow) {

	var DetailAppendixWinObj = $HUI.window("#DetailAppendixWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + budgFYRow.deptNa + '-' + budgFYDRow.ecoItemNa + '-' + budgFYDRow.fundTypeNa + '-' + '�ɹ���Ϣ',
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
			onClose: function () { //�رչرմ��ں󴥷�
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
				title: '����ID',
				hidden: true
			}, {
				field: 'purchItemCo',
				title: '�ɹ�ƷĿ����',
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
				title: '�ʽ�����',
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
				title: 'Ԥ���ܶ�',
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
				title: '����',
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
				title: '����',
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
				title: '��ע',
				width: 300,
				editor: {
					type: 'text'
				}
			}, {
				field: 'process',
				title: '���ƹ���',
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
								name: 'һ��'
							}, {
								rowid: '2',
								name: 'һ��'
							}, {
								rowid: '3',
								name: '����'
							}, {
								rowid: '4',
								name: '����'
							}
						]
					}
				}
			}

		]];
		
	//������ť
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '����',
		handler: function () {


		}
	}
	//���水ť
	var SaveBtn = {
		id: 'FYDSave',
		iconCls: 'icon-save',
		text: '����',
		handler: function () {
		}
	}
	//ɾ����ť
	var DelBt = {
		id: 'FYDDel',
		iconCls: 'icon-cancel',
		text: 'ɾ��',
		handler: function () {
		}
	}
	//��հ�ť
	var ClearBT = {
		id: 'FYDReset',
		iconCls: 'icon-reset',
		text: '����',
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
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, '-', SaveBtn, '-', DelBt, '-', ClearBT],

		});

	DetailAppendixWinObj.open();

	//�ر�
	$("#DAppendixBtnCancel").unbind('click').click(function () {
		DetailAppendixWinObj.close();
	});
};
