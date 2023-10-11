/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制平衡-收支预算编制平衡
CSPName: herp.budg.hisui.budginoutbalance.csp
ClassName: herp.budg.hisui.udata.uBudgInOutBalance,
herp.budg.udata.uBudgInOutBalance
 */

function AuditDeptBgWinShow(hospFYRow) {

	var AuditDeptBgWinObj = $HUI.window("#AuditDeptBgWin", {
			title: hospFYRow.itemNa.replace(/&nbsp;/ig, '') + '-' + '归口+业务科室年预算',
			//title: $.trim(hospFYRow.itemNa.replace(/&nbsp;/ig,'')) + '归口科室年预算',
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
			onClose: function () { //关闭关闭窗口后触发
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
				title: '科室名称',
				halign: 'left',
				align: 'left',
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
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			onClickCell: AuditDeptBgClickCell

		});

	//点击单元格事件
	function AuditDeptBgClickCell(index, field) {

		var auditFYRow = $('#AuditDeptBgGrid').datagrid('getRows')[index];
		//点击科室汇总链接弹出归口科室预算界面
		if ((hospFYRow.isLast == 1)&&(field == "planVal")) {
			BudgDeptBgWinShow(hospFYRow, auditFYRow);
		}

	}

	AuditDeptBgWinObj.open();

	//关闭
	$("#BtnCancel").unbind('click').click(function () {
		AuditDeptBgWinObj.close();
	});

}
