/*
Creator: Liu XiaoMing
CreatDate: 2018-07-22
Description: 全面预算管理-预算编制管理-科室年度预算编制（自编）
CSPName: herp.budg.hisui.budgschemMAself.csp
ClassName: herp.budg.hisui.udata.uBudgSchemMAself,
herp.budg.udata.uBudgSchemMAself
 */

//全局变量用于checkbox状态变化
var isLast = '';
var isValue ='';
var factYearRowIndex = '';

function selectRows(grid, rowIndexArr) {
	//刷新后将之前选中的数据重新选中
	grid.datagrid("reload");
	grid.datagrid({
		onLoadSuccess: function () {
			for (var i = 0; i < rowIndexArr.length; i++) {
				grid.datagrid("selectRow", rowIndexArr[i]);
			}
			//清空数组
			rowIndexArr = [];
		}
	});

}

//年度下拉框选择事件
function yearcbSelectFn() {
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
	if (!$('#deptcb').combobox('getValue')) {
		$.messager.popover({
			msg: '请选择科室!',
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
		ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
		MethodName: 'List',
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		detpId: $('#deptcb').combobox('getValue')
	});
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
//是否有值复选框变化事件
function isValuecheckFn(e, value) {
	isValue = value ? 1 : 0;
	SearchItems('');
}
//表格单元格链接渲染函数
function gridTextStyler(value, row, index) {
	return 'color:#017bce;cursor:hand;cursor:pointer;text-decoration:underline;';

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
		$('#schemDetailGrid').datagrid('hideColumn', 'OneState');
		$('#schemDetailGrid').datagrid('hideColumn', 'TwoState');
	} else {
		//显示表格两上两下相关列;
		$('#schemDetailGrid').datagrid('showColumn', 'OneUpVal');
		$('#schemDetailGrid').datagrid('showColumn', 'OneDowVal');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoUpVal');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoDowVal');
		$('#schemDetailGrid').datagrid('showColumn', 'OneState');
		$('#schemDetailGrid').datagrid('showColumn', 'TwoState');
	}

	isLast = $('#isLastckb').checkbox('getValue') ? 1 : '';
	isValue = $('#isValue').checkbox('getValue') ? 1 : 0;
	

	
//下半界面查询
	SearchItems(rowData);
}
//科室预算方案明细查询
function SearchItems(rowData) {
	if (!$('#schemGrid').datagrid('getSelected')) {
		$.messager.popover({
			msg: '请选择对应方案!',
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
		ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
		MethodName: 'ListDetail',
		userid: userid,
		schemAuditId: rowData.Rowid,
		itemTyCo: $('#typecb').combobox('getValue'),
		itemCo: $('#itemcb').combobox('getValue'),
		itemState: $('#itemStatecb').combobox('getValue'),
		isLast: isLast,
		isValue:isValue
	});
}

//是否启用编辑
var editIndex = undefined;
function endEditing() {
	if (editIndex == undefined) {
		return true
	}
	if ($('#schemDetailGrid').datagrid('validateRow', editIndex)) {
		if ($('#schemDetailGrid').datagrid('validateRow', editIndex)) {
			var ed = $('#schemDetailGrid').datagrid('getEditor', {
					index: editIndex,
					field: 'AuditDept'
				});
			if (ed) {
				var AuditDeptNa = $(ed.target).combobox('getText');
				$('#schemDetailGrid').datagrid('getRows')[editIndex]['AuditDeptNa'] = AuditDeptNa;

			}
			$('#schemDetailGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
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
		 && ((field=="Desc")||(field == "AuditDept") || (field == "AuditDeptTwo") || (field == "IsGovBuy"))) {
		return true;
	}
	//末级
	if (factYearRow.IsLast == 1){
		//无经济科目
		if(schemRow.IsEconItem==0){
			//有两上两下
			if(schemRow.IsTwoUpDown == 1){
				/*if ((field == "PlanValue")|| (field == "TwoUpVal") || (field == "TwoDowVal")){
					//是否当前审批=null/1 && 审批结果=null/1
					if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))) {
						return true;
					}}*/
				 if(field == "OneUpVal"&&((factYearRow.EstState == 1)||(factYearRow.EstState == ""))){
					 return true;
					 }
			     if(field == "TwoUpVal"&&(factYearRow.EstState == 7)){
				     return true
				     }
			}else if(schemRow.IsTwoUpDown == 0){//无两上两下
				if (field == "PlanValue"&&((factYearRow.EstState == 1)||(factYearRow.EstState == ""))){
						return true;
				}
			}
			
		}
	}
	
	return false;
}

//点击下半界面单元格事件
function onClickCell(index, field) {
	var schemRow = $('#schemGrid').datagrid('getSelected');
	if (!schemRow) {
		$.messager.popover({
			msg: '请先选择对应方案!',
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
	var rows = $('#schemDetailGrid').datagrid('getRows');
	var factYearRow = rows[index];
	
	//点击年度预算弹出预算明细表界面
	if ((factYearRow.IsLast == 1) && (field == 'PlanValue')&&(schemRow.IsEconItem!=0)) {
		FYDetailGridShow(schemRow, factYearRow);
	}
	if ((factYearRow.IsLast == 1) && (field == 'EstState')) {
		//console.log("schemRow.Rowid:"+schemRow.Rowid+";userid:"+userid+";schemRow.SchemId:"+schemRow.SchemId+";factYearRow.Code:"+factYearRow.Code);
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, "", factYearRow.Code);
	}
	if ((factYearRow.IsLast == 1) && (field == 'OneState')) {
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, 1, factYearRow.Code);
	}
	if ((factYearRow.IsLast == 1) && (field == 'TwoState')) {
		schemastatefun(schemRow.Rowid, userid, schemRow.SchemId, 2, factYearRow.Code);
	}

	if (endEditing()) {
		//按钮权限管控
		FYBtnsEnableManage(schemRow, factYearRow);
		
		//启用编辑
		if (FactYearIsEdit(schemRow, factYearRow, index, field)) {
			$('#schemDetailGrid').datagrid('editCell', {
				index: index,
				field: field
			});
			editIndex = index;
		}

		return factYearRowIndex = index;
	}
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
	var fields = grid.datagrid('getColumnFields');
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

				//初始化一个数组
				var rowIndexArr = [];
				for (var i = 0; i < rows.length; i++) {
					factYearRow = rows[i];
					rowIndex = grid.datagrid('getRowIndex', factYearRow);
					//将rowIndex存入数组rowIndexArr中
					rowIndexArr[i] = rowIndex;
					grid.datagrid('endEdit', rowIndex);
					if ((factYearRow.IsLast == 1) && (FYDChkBefSave(grid, schemRow, factYearRow))) {
						var tempdata = factYearRow.rowid
							 	+ "^" + factYearRow.Code
							 	+ "^" + factYearRow.AuditDept
							 	+ "^" + factYearRow.IsGovBuy
							 	+ "^" + factYearRow.OneUpVal
							 	+ "^" + factYearRow.OneDowVal
							 	+ "^" + factYearRow.TwoUpVal
							 	+ "^" + factYearRow.TwoDowVal
							 	+ "^" + factYearRow.PlanValue
							 	+ "^" + factYearRow.AuditDeptTwo
								+ "^" + factYearRow.Desc;
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

				//刷新后将之前选中的数据重新选中
				grid.datagrid("reload");
				grid.datagrid({
					onLoadSuccess: function () {
						for (var i = 0; i < rowIndexArr.length; i++) {
							$('#schemDetailGrid').datagrid("selectRow", rowIndexArr[i]);
						}
						//清空数组
						rowIndexArr = [];
					}
				});
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
				msg: '保存失败！' + Data,
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

//提交方法
$("#subitItemBtn").click(
function FactYearSubmit() {

	var schemRow = $('#schemGrid').datagrid('getSelected');
	var mainData = schemRow.Rowid + "^" + schemRow.SchemId;

	var grid = $('#schemDetailGrid');
	var rows = grid.datagrid('getSelections');
	var rowIndex = "",
	factYearRow = "",
	detailData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要提交数据吗？', function (t) {
			if (t) {
				//初始化一个数组
				var rowIndexArr = [];
				for (var i = 0; i < rows.length; i++) {
					factYearRow = rows[i];
					rowIndex = grid.datagrid('getRowIndex', factYearRow);
					//将rowIndex存入数组rowIndexArr中
					rowIndexArr[i] = rowIndex;
					//alert(factYearRow.EstState);
					if ((factYearRow.IsLast == 1)
						 && ((factYearRow.EstState == '')
							 || (factYearRow.OneState == null)
							 || (factYearRow.EstState == 1)
							 || (factYearRow.EstState == 7))) {
						var tempdata = factYearRow.rowid;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					} else {
						detailData = '';
						$.messager.popover({
							msg: '请确保所有选中记录编制状态都为新建或者空状态!',
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
						break;

					}
				}
				//alert(mainData);
				//alert(detailData);
				if (detailData != '') {

					FYSubmitOrder(mainData, detailData);

					//主表选中操作记录
					var schemRowIndexArr = [];
					schemRowIndexArr[0] = $('#schemGrid').datagrid('getRowIndex', schemRow);
					selectRows($('#schemGrid'), schemRowIndexArr)
					//明细表选中操作记录
					selectRows(grid, rowIndexArr)
				}

			}
		})
	}
})

//提交请求后台方法
var FYSubmitOrder = function (mainData, detailData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
		MethodName: 'FactYearSubmit',
		userid: userid,
		mainData: mainData,
		detailData: detailData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '提交成功！',
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
				msg: '提交失败！' + Data,
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

//撤销方法
$("#backItemBtn").click(
function FactYearBack() {

	var schemRow = $('#schemGrid').datagrid('getSelected');
	var mainData = schemRow.Rowid + "^" + schemRow.SchemId;

	var grid = $('#schemDetailGrid');
	var rows = grid.datagrid('getSelections');
	var rowIndex = "",
	factYearRow = "",
	detailData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要撤销数据吗？', function (t) {
			if (t) {
				//初始化一个数组
				var rowIndexArr = [];
				for (var i = 0; i < rows.length; i++) {
					factYearRow = rows[i];
					rowIndex = grid.datagrid('getRowIndex', factYearRow);
					//将rowIndex存入数组rowIndexArr中
					rowIndexArr[i] = rowIndex;
					//撤销只针对末级项目及提交状态的记录而言
					//alert(factYearRow.EstState);
					if ((factYearRow.IsLast == 1) && (factYearRow.EstState == 2)) {
						var tempdata = factYearRow.rowid;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					} else {
						detailData = '';
						$.messager.popover({
							msg: '请确保所有选中记录编制状态都为提交状态!',
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
						break;
					}
				}
				//alert(mainData);
				//alert(detailData);
				if (detailData != '') {
					FYBackOrder(mainData, detailData);
					//主表选中操作记录
					var schemRowIndexArr = [];
					schemRowIndexArr[0] = $('#schemGrid').datagrid('getRowIndex', schemRow);
					selectRows($('#schemGrid'), schemRowIndexArr)
					//明细表选中操作记录
					selectRows(grid, rowIndexArr)
				}
			}
		})
	}
})

//撤销请求后台方法
var FYBackOrder = function (mainData, detailData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
		MethodName: 'FactYearBack',
		userid: userid,
		mainData: mainData,
		detailData: detailData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '撤销成功！',
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
				msg: '撤销失败！' + Data,
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


//按钮权限管控
function FYBtnsEnableManage(schemRow, factYearRow) {
	$('#saveItemBtn').linkbutton('disable');
	$('#subitItemBtn').linkbutton('disable');
	$('#backItemBtn').linkbutton('disable');
	//末级
	if (factYearRow.IsLast == 1){   
		  //无经济科目
			if(schemRow.IsTwoUpDown == 1){//有两上两下
				//新建或待下放
				if (((factYearRow.EstState == '')|| (factYearRow.EstState == null)|| (factYearRow.EstState == 1)|| (factYearRow.EstState == 7))) {
					if(schemRow.IsEconItem==0){
						$('#saveItemBtn').linkbutton('enable');
					}
					else {
						$('#saveItemBtn').linkbutton('disable');
					}
					$('#subitItemBtn').linkbutton('enable');
					$('#backItemBtn').linkbutton('disable');
				}else if ((factYearRow.EstState == 2)){ //提交
					$('#saveItemBtn').linkbutton('disable');
					$('#subitItemBtn').linkbutton('disable');
					$('#backItemBtn').linkbutton('enable');
				}
			}else if(schemRow.IsTwoUpDown == 0){//无两上两下
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1) || (factYearRow.EstState == 7))) {
					if(schemRow.IsEconItem==0){
						$('#saveItemBtn').linkbutton('enable');
					}
					else {
						$('#saveItemBtn').linkbutton('disable');
					}
					$('#subitItemBtn').linkbutton('enable');
					$('#backItemBtn').linkbutton('disable');
				} else if ((factYearRow.EstState == 2)) {
					$('#saveItemBtn').linkbutton('disable');
					$('#subitItemBtn').linkbutton('disable');
					$('#backItemBtn').linkbutton('enable');
				}
			}
			
		
	}
	

}
