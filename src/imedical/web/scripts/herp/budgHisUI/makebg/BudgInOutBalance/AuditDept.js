/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: ȫ��Ԥ�����-Ԥ�����ƽ��-��֧Ԥ�����ƽ��
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function AuditDeptBgWinShow(hospFYRow) {

	var AuditDeptBgWinObj = $HUI.window("#AuditDeptBgWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + '���+ҵ�������Ԥ��',
			//title: $.trim(hospFYRow.itemNa.replace(/&nbsp;/ig,'')) + '��ڿ�����Ԥ��',
			iconCls:'icon-w-paper',
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
				$('#mainGrid').datagrid("reload");
			}

		});
		
	$("#AuditDeptBgWin").css("display", "block");

	var AuditDeptBgColumn = [[{
				field: 'rowid',
				title: 'ID',
				hidden: true
			}, {
				field: 'deptNa',
				title: '��������',
				halign: 'left',
				align: 'left',
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
	var AuditDeptBgGridObj = $HUI.datagrid('#AuditDeptBgGrid', {
			title: '',
			region: 'center',
			fit: true,
			singleSelect: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgInOutBalance',
				MethodName: 'ListItemAduitDeptBg',
				hospFactYearId: hospFYRow.rowid

			},
			columns: AuditDeptBgColumn,
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell: AuditDeptBgClickCell

		});

	//�����Ԫ���¼�
	function AuditDeptBgClickCell(index, field) {

		var auditFYRow = $('#AuditDeptBgGrid').datagrid('getRows')[index];
		//������һ������ӵ�����ڿ���Ԥ�����
		if ((hospFYRow.isLast == 1)&&(field == "planVal")) {
			BudgDeptBgWinShow(hospFYRow, auditFYRow);
		}

	}

	AuditDeptBgWinObj.open();

	//�ر�
	$("#BtnCancel").unbind('click').click(function () {
		AuditDeptBgWinObj.close();
	});

}
