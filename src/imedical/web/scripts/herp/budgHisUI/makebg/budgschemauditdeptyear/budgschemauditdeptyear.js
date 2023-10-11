/*
Creator: Liu XiaoMing
CreatDate: 2018-08-14
Description: 全面预算管理-预算编制管理-科室年度预算审核
CSPName: herp.budg.hisui.budgschemauditdeptyear.csp
ClassName: herp.budg.hisui.udata.uBudgSchemAuditDeptYear
 */

var factYearRowIndex = undefined;

//年度选择事件
function YearSelect() {
	$('#deptschemscb').combobox('clear');
	$('#deptschemscb').combobox('reload', $URL + '?ClassName=herp.budg.hisui.udata.uBudgSchemAuditDeptYear&MethodName=DeptSchems&ResultSetType=array');
	Search();
}

//科室下拉框选择事件
function deptcbSelectFn() {
	Search();
}

function checkBefSearch() {
	if (!$('#yearcb').combobox('getValue')) {
		$.messager.popover({
			msg: '请选择年度!',
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
	if (!$('#deptschemscb').combobox('getValue')) {
		$.messager.popover({
			msg: '请选择方案!',
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

}
//上半界面查询
function Search() {

	checkBefSearch();

	$('#schemGrid').datagrid('load', {
		ClassName: 'herp.budg.hisui.udata.uBudgSchemAuditDeptYear',
		MethodName: 'List',
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		bsmid: $('#deptschemscb').combobox('getValue')
	});
}

//单击方案表格方法
function SchemGridClickRow(rowIndex, rowData) {
	//SearchItems(rowData.rowid);
	//重新加载预算项目下拉框
	$('#itemcb').combobox('clear');
	$('#itemcb').combobox('reload',
		$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
		 + '&year=' + rowData.Year);

	//非两上两下模式
	if (rowData.IsTwoUpDown == 0) {
		//隐藏表格两上两下相关列;
		$('#schemDetailGrid').datagrid('hideColumn', 'OneUpVal');
		$('#schemDetailGrid').datagrid('hideColumn', 'OneDowVal');
		$('#schemDetailGrid').datagrid('hideColumn', 'TwoUpVal');
		$('#schemDetailGrid').datagrid('hideColumn', 'TwoDowVal');
		$('#schemDetailGrid').datagrid('hideColumn', 'CurStep');
		$('#schemDetailGrid').datagrid('hideColumn', 'DChkResult');
		$('#schemDetailGrid').datagrid('hideColumn', 'OneState');
		$('#schemDetailGrid').datagrid('hideColumn', 'TwoState');
	} else {
		//显示表格两上两下相关列;
		$('#schemDetailGrid').datagrid('showColumn', 'OneUpVal');
		$('#schemDetailGrid').datagrid('showColumn', 'OneDowVal');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoUpVal');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoDowVal');
		$('#schemDetailGrid').datagrid('showColumn', 'CurStep');
		$('#schemDetailGrid').datagrid('hideColumn', 'DChkResult');
		$('#schemDetailGrid').datagrid('showColumn', 'OneState');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoState');
	}

	isLast = $('#isLastckb').checkbox('getValue') ? 1 : '';
	//下半界面查询
	SearchItems(rowData);
}

//项目类别下拉框选择事件
function typecbSelectFn() {
	$('#itemcb').combobox('clear');
	$('#itemcb').combobox('reload');
	SearchItems('');
}

//预算项目下拉框加载前事件触发方法
function itemBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = '1^3';
	param.type = $('#typecb').combobox('getValue');
	param.level = '';
	param.supercode = '';
	param.str = param.q;
}

//预算项目下拉框选择事件
function itemcbSelectFn() {
	SearchItems('');
}

//项目状态下拉框选择事件
function itemStatecbFn() {
	SearchItems('');
}

//末级复选框变化事件
function checkChangeFn(e, value) {
	isLast = value ? 1 : '';
	SearchItems('');
}

//科室预算方案明细查询
function SearchItems(rowData) {
	if (!$('#schemGrid').datagrid('getSelected')) {
		$.messager.popover({
			msg: '请选择方案!',
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
	} else {
		rowData = $('#schemGrid').datagrid('getSelected');
	}

	$('#schemDetailGrid').datagrid('load', {
		ClassName: 'herp.budg.hisui.udata.uBudgSchemAuditDeptYear',
		MethodName: 'ListDetail',
		userid: userid,
		schemAuditId: rowData.Rowid,
		itemTyCo: $('#typecb').combobox('getValue'),
		itemCo: $('#itemcb').combobox('getValue'),
		itemState: $('#itemStatecb').combobox('getValue'),
		isLast: isLast
	});
}

//归口科室一下拉框渲染函数
function AuditDeptFormatter(value, row) {
	return row.AuditDeptNa;
}

//归口科室二下拉框渲染函数
function AuditDeptTwoFormatter(value, row) {
	return row.AuditDeptTwoNa;
}

//绩效目标渲染函数//onclick=endEditing('+rowid+'\;
function ProjGolFormatter(value, row, index) {
	var rowid = row.rowid;
	return '<a href="#" class="grid-td-text" )>' + value + '</a>';
}

//表格嵌套-归口科室下拉框加载前事件触发方法
function auditDeptBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = '8';
	param.str = param.q;
}

//保存前校验
function FYDChkBefSave(grid, schemRow, factYearRow) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = factYearRow[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false) && FactYearIsEdit(schemRow, factYearRow, index, field)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined) || (parseInt(reValue) == 0)) {
						var info = title + "列为必填项，不能为空或零！";
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
$("#saveItemBtn").click(
function FactYearSave() {
	var schemRow = $('#schemGrid').datagrid('getSelected');
	var mainData = schemRow.Rowid;

	var grid = $('#schemDetailGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			
			var ed = $('#schemDetailGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'AuditDept'
				});
			if (ed) {
				var AuditDeptNa = $(ed.target).combobox('getText');
				$('#schemDetailGrid').datagrid('getRows')[indexs[i]]['AuditDeptNa'] = AuditDeptNa;

			}
			
			var ed = $('#schemDetailGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'AuditDeptTwo'
				});
			if (ed) {
				var AuditDeptTwoNa = $(ed.target).combobox('getText');
				$('#schemDetailGrid').datagrid('getRows')[indexs[i]]['AuditDeptTwoNa'] = AuditDeptTwoNa;

			}
			
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	factYearRow = "",
	detailData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
			if (t) {
				for (var i = 0; i < rows.length; i++) {
					factYearRow = rows[i];
					rowIndex = grid.datagrid('getRowIndex', factYearRow);
					grid.datagrid('endEdit', rowIndex);
					if ((factYearRow.IsLast == 1)&& FYDChkBefSave(grid, schemRow, factYearRow)) {
						var tempdata = factYearRow.rowid
							 + "^" + factYearRow.Code
							 + "^" + factYearRow.AuditDept
							 + "^" + factYearRow.IsGovBuy
							 + "^" + factYearRow.OneUpVal
							 + "^" + factYearRow.OneDowVal
							 + "^" + factYearRow.TwoUpVal
							 + "^" + factYearRow.TwoDowVal
							 + "^" + factYearRow.PlanValue
							 + "^" + factYearRow.AuditDeptTwo;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					}
				}
				//alert(mainData);
				//alert(detailData);
				FYSaveOrder(mainData, detailData);
				grid.datagrid("reload");
			}
		})
	}
})

//保存请求后台方法
var FYSaveOrder = function (mainData, detailData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
		MethodName: 'FactYearSave',
		userid: userid,
		mainData: mainData,
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

//审核函数
$("#checkItemBtn").click(
function CheckItems() {
	var schemRow = $('#schemGrid').datagrid('getSelected');
	if (!schemRow) {
		$.messager.popover({
			msg: '请先选择对应方案!',
			type: 'info',
			timeout: 2000,
			showType: 'show'
		});
		return;
	}
	var factYearRows = $('#schemDetailGrid').datagrid('getSelections');
	if (!factYearRows) {
		$.messager.popover({
			msg: '请先选择要审核的单据!',
			type: 'info',
			timeout: 2000,
			showType: 'show'
		});
		return;
	} else {
		FYCheckWinShow(schemRow, factYearRows, "审核");
	}
})

//下放函数
$("#downItemBtn").click(
function CheckDownItems() {
	var schemRow = $('#schemGrid').datagrid('getSelected');
	if (!schemRow) {
		$.messager.popover({
			msg: '请先选择对应方案!',
			type: 'info',
			timeout: 2000,
			showType: 'show'
		});
		return;
	}
	var factYearRows = $('#schemDetailGrid').datagrid('getSelections');

	if (factYearRows.length == 0) {
		$.messager.popover({
			msg: '请先选择要下放的单据!',
			type: 'info',
			timeout: 2000,
			showType: 'show'
		});
		return;
	} else {
		FYCheckWinShow(schemRow, factYearRows, "下放");

	}
})

function endEditing() {
	if (factYearRowIndex == undefined) {
		return true
	}
	if ($('#schemDetailGrid').datagrid('validateRow', factYearRowIndex)) {
		if ($('#schemDetailGrid').datagrid('validateRow', factYearRowIndex)) {
			$('#schemDetailGrid').datagrid('endEdit', factYearRowIndex);
			factYearRowIndex = undefined;
			return true;

		}
	} else {
		return false;
	}
}

//判断是否可编辑
function FactYearIsEdit(schemRow, factYearRow, index, field) {

	//归口科室列/是否政府采购列
	if ((factYearRow.IsLast == 1)
		 && ((field == "AuditDept") || (field == "AuditDeptTwo") || (field == "IsGovBuy"))) {
		return true;
	}
	
	//两上两下模式
	if ((schemRow.IsTwoUpDown == 1) 
		&& (factYearRow.IsLast == 1) 
		&& (factYearRow.IsCurStep == 1)) {
		
		//一下预算列,当前过程为一下时可编辑
		if ((field == "OneDowVal")
			&&((factYearRow.CurStep == 2))) {
			return true;
		}
	}
    if ((schemRow.IsTwoUpDown == 0)
    	&&(schemRow.IsEconItem == 0)
    	&&(field == 'PlanValue')
    	&& (factYearRow.IsCurStep == 1)){
	    return true;
	    }
    
	return false;
}

//点击下半界面单元格事件
function onClickCell(index, field) {

	var schemRow = $('#schemGrid').datagrid('getSelected');
	if (!schemRow) {
		$.messager.alert('提示', '请先选择对应方案!', '提示');
		return;
	}
	var rows = $('#schemDetailGrid').datagrid('getRows');
	var factYearRow = rows[index];
	//点击年度预算弹出预算明细表界面
	if ((factYearRow.IsLast == 1) &&(field == 'PlanValue')&&(schemRow.isEconItem == 1)) {
		FYDetailGridShow(schemRow, factYearRow);
	}

	//状态链接
	if ((factYearRow.IsLast == 1) && (field == 'EstState')) {
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, "",factYearRow.Code);
	}
	if ((factYearRow.IsLast == 1) && (field == 'OneState')) {
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, 1, factYearRow.Code);
	}
	if ((factYearRow.IsLast == 1) && (field == 'TwoState')) {
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, 2, factYearRow.Code);
	}

	//按钮权限管控
	FYBtnsEnableManage(schemRow, factYearRow);

	//启用可编辑单元格
	if (endEditing() && FactYearIsEdit(schemRow, factYearRow, index, field)) {
		$('#schemDetailGrid').datagrid('editCell', {
			index: index,
			field: field
		});
		return factYearRowIndex = index;
	}

}

//按钮权限管控
function FYBtnsEnableManage(schemRow, factYearRow) {
	$('#saveItemBtn').linkbutton('disable');
	$('#checkItemBtn').linkbutton('disable');
	$('#downItemBtn').linkbutton('disable');
	//两上两下模式
	if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
		//是否当前审批字段=1
		if (factYearRow.IsCurStep == 1) {
            //console.log(factYearRow.IsCurStep+","+factYearRow.IsLast+","+schemRow.IsTwoUpDown+","+factYearRow.EstState
			//alert(factYearRow.EstState == 2 || factYearRow.EstState == 3);
			//是否当前审批字段=1时，保存按钮始终可用
			$('#saveItemBtn').linkbutton('enable');
			//提交、通过状态下-审核按钮可用、下放不可用
			if (factYearRow.EstState == 2 || factYearRow.EstState == 3) {
				$('#checkItemBtn').linkbutton('enable');
				$('#downItemBtn').linkbutton('disable');
			}
			//完成状态下-审核按钮不可用、下放可用
			if ((factYearRow.EstState == 4)||(factYearRow.EstState == 5)) {
				$('#checkItemBtn').linkbutton('disable');
				$('#downItemBtn').linkbutton('enable');
			}

		} else {
			$('#saveItemBtn').linkbutton('disable');
			$('#checkItemBtn').linkbutton('disable');
			$('#downItemBtn').linkbutton('disable');
		}
	}
   if((schemRow.IsTwoUpDown == 0)&&(factYearRow.IsCurStep == 1)&&(factYearRow.IsLast == 1))	{
	   $('#checkItemBtn').linkbutton('enable');
	   
	   }
}
