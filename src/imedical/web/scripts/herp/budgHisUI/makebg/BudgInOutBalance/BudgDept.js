/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制平衡-收支预算编制平衡
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function BudgDeptBgWinShow(hospFYRow, auditFYRow) {

	var BudgDeptBgWinObj = $HUI.window("#BudgDeptBgWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + '业务科室年预算',
			//title: $.trim(auditFYRow.itemNa.replace(/&nbsp;/ig,'')) + '业务科室年预算',
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
				title: '科室名称',
				//hidden: true,
				width: 120
			}, {
				field: 'oneUpVal',
				title: '一上预算',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'oneDownVal',
				title: '一下预算',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoUpVal',
				title: '二上预算',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'twoDownVal',
				title: '二下预算',
				halign: 'right',
				align: 'right',
				//hidden: true,
				width: 120,
				formatter: dataFormat
			}, {
				field: 'planVal',
				title: '年预算',
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

	//主表格
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
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell: BudgDeptBgClickCell
		});

	//点击单元格事件
	function BudgDeptBgClickCell(index, field) {

		var budgFYRow = $('#BudgDeptBgGrid').datagrid('getRows')[index];
		//点击年预算链接弹出业务科室年预算明细界面
		if ((hospFYRow.isLast == 1)&&(field == "planVal")) {
			BudgDeptBgDetailWinShow(hospFYRow, auditFYRow, budgFYRow);
		}

	}

	BudgDeptBgWinObj.open();

	//关闭
	$("#BDBBtnCancel").unbind('click').click(function () {
		BudgDeptBgWinObj.close();
	});

}
