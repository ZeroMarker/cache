/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: ȫ��Ԥ�����-Ԥ�����ƽ��-��֧Ԥ�����ƽ��
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function BudgDeptBgDetailWinShow(hospFYRow, auditFYRow, budgFYRow) {
	var startIndex = undefined;
	
	var mainId = budgFYRow.rowid;
	if (!mainId) {
		$.messager.popover({
			msg: '����IDΪ��!',
			type: 'info',
			timeout: 2000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;
	}

	
	var BudgDeptBgDetailWinObj = $HUI.window("#BudgDeptBgDetailWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + budgFYRow.deptNa + '-' + 'ҵ�������Ԥ����ϸ',
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
				title: '����ID',
				hidden: true
			}, {
				field: 'ecoItemCo',
				title: '���ÿ�Ŀ',
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
				field: 'oneUpVal',
				title: 'һ��Ԥ��',
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
				title: 'һ��Ԥ��',
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
				title: '����Ԥ��',
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
				title: '����Ԥ��',
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
				title: '����Ԥ��',
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
				title: '��ע',
				width: 300,
				editor: {
					type: 'text'
				}
			}

		]]
		
	//������ť
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '����',
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
				//�ö�Ӧ�пɱ༭
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
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, '-', SaveBtn, '-', DelBt, '-', ClearBT],
			onClickCell: BudgDeptBgDetailClickCell
		});
		
	//�ж��Ƿ�����༭
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

	//�����Ԫ���¼�
	function BudgDeptBgDetailClickCell(index, field) {

		var budgFYDRow = $('#BudgDeptBgDetailGrid').datagrid('getRows')[index];
		//�����Ԥ�����ӵ����ɹ���ϸ
		if (field == "planVal") {
			DetailAppendixWinShow(hospFYRow, auditFYRow, budgFYRow, budgFYDRow);
		}

	}

	BudgDeptBgDetailWinObj.open();

	//�ر�
	$("#BDBDBtnCancel").unbind('click').click(function () {
		BudgDeptBgDetailWinObj.close();
	});
};
