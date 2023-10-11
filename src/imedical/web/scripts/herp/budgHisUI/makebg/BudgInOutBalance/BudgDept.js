/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: ȫ��Ԥ�����-Ԥ�����ƽ��-��֧Ԥ�����ƽ��
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function BudgDeptBgWinShow(hospFYRow, auditFYRow) {

	var BudgDeptBgWinObj = $HUI.window("#BudgDeptBgWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + 'ҵ�������Ԥ��',
			//title: $.trim(auditFYRow.itemNa.replace(/&nbsp;/ig,'')) + 'ҵ�������Ԥ��',
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
				$('#AuditDeptBgGrid').datagrid("reload");
			}

		});
		
	$("#BudgDeptBgWin").css("display", "block");

	var BudgDeptBgColumn = [[{
				field: 'rowid',
				title: 'ID',
				hidden: true
			}, {
				field: 'deptNa',
				title: '��������',
				//hidden: true,
				width: 120
			}, {
				field: 'oneUpVal',
				title: 'һ��Ԥ��',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'oneDownVal',
				title: 'һ��Ԥ��',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoUpVal',
				title: '����Ԥ��',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoDownVal',
				title: '����Ԥ��',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'planVal',
				title: '��Ԥ��',
				halign: 'right',
				align: 'right',
				width: 120,
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

			}
		]]

	//�����
	var BudgDeptBgGridObj = $HUI.datagrid('#BudgDeptBgGrid', {
			title: '',
			region: 'center',
			fit: true,
			singleSelect: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgInOutBalance',
				MethodName: 'ListItemBudgDeptBg',
				auditDeptFYId: auditFYRow.rowid

			},
			columns: BudgDeptBgColumn,
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell: BudgDeptBgClickCell
		});

	//�����Ԫ���¼�
	function BudgDeptBgClickCell(index, field) {

		var budgFYRow = $('#BudgDeptBgGrid').datagrid('getRows')[index];
		//�����Ԥ�����ӵ���ҵ�������Ԥ����ϸ����
		if ((hospFYRow.isLast == 1)&&(field == "planVal")) {
			BudgDeptBgDetailWinShow(hospFYRow, auditFYRow, budgFYRow);
		}

	}

	BudgDeptBgWinObj.open();

	//�ر�
	$("#BDBBtnCancel").unbind('click').click(function () {
		BudgDeptBgWinObj.close();
	});

}
