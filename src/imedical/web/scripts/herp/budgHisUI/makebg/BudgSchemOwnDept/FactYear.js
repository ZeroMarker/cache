/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: 全面预算管理-预算编制管理-归口科室年度预算审核
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */
/**
 *按钮权限说明
 *新建状态：增加、保存、删除均可用
 *其他：均不可用
 *
 **/

var factYearRowIndex = undefined;
var RowDelim = String.fromCharCode(1); //行数据间的分隔符, IsCheck, curSchemeName, syear
DetailFun = function (schemRow, LowerPartrow) {
	//console.log(JSON.stringify(row));
	//schemRow.ObjDeptId
	//初始化窗口
	//var aa=LowerPartrow.ItemName;
	//console.log(aa.replace(/&nbsp;/g,""))
	var $Detailwin;
	$Detailwin = $('#DetailWin').window({
			title: schemRow.ObjDeptNa + '的' + LowerPartrow.ItemName.replace(/&nbsp;/g,"") + '预算情况',
			width: 1100,
			height: 580,
			top: ($(window).height() - 580) * 0.5,
			left: ($(window).width() - 1100) * 0.5,
			shadow: true,
			modal: true,
			closed: true,
			minimizable: false,
			maximizable: false,
			collapsible: false,
			resizable: true,
			onClose: function () { //关闭关闭窗口后触发
				$("#LowerPartGrid").datagrid("reload"); //关闭窗口，重新加载主表格
			}
		});
	$("#DetailWin").css("display", "block");
	
	$Detailwin.window('open');
	// 表单的垂直居中
	//xycenter($("Detailnorth"),$("Detailform"));
	
	//业务科室
	var DeptBoxObj = $HUI.combobox("#DeptBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 6;
				param.year = LowerPartrow.Year;
				param.audept = schemRow.ObjDeptId;
			},
			onSelect: function (data) {

				schemDetailGrid.load({
					ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
					MethodName: "ListDetailDept",
					userid: userid,
					schemAuditId: schemRow.Rowid,
					audept: schemRow.ObjDeptId,
					itemcode: LowerPartrow.ItemCode,
					deptdr: data.rowid,
					itemState: $('#itemStatecb').combobox('getValue')
				})
			}
		});

	//项目状态下拉框选择事件
	function itemStatecbFn() {
		SearchItems();
	}

	// 查询函数
	function SearchItems() {

		schemDetailGrid.load({
			ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
			MethodName: "ListDetailDept",
			userid: userid,
			schemAuditId: schemRow.Rowid,
			audept: schemRow.ObjDeptId,
			itemcode: LowerPartrow.ItemCode,
			deptdr: $('#DeptBox').combobox('getValue'),
			itemState: $('#itemStatecb').combobox('getValue')
		})
	}

	// 点击查询按钮
	$("#DFindBn").click(SearchItems);

	//表格嵌套-归口科室下拉框加载前事件触发方法
	function auditDeptBefLoad(param) {
		param.hospid = hospid;
		param.userdr = userid;
		param.flag = '8';
		param.str = param.q;
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

	//列配置对象
	frozenColumns = [[{
				field: 'ck',
				checkbox: true
			}, {
				field: 'schemAuditIdObjDept',
				title: '方案归口业务科室ID',
				halign: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'rowid',
				title: 'ID',
				halign: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'Year',
				title: '年度',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'Deptdr',
				title: '业务科室ID',
				halign: 'center',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'DeptNa',
				title: '业务科室',
				halign: 'center',
				align: 'left',
				width: 200
			}, {
				field: 'Code',
				title: '项目编码',
				halign: 'center',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'Name',
				title: '项目名称',
				halign: 'center',
				align: 'left',
				width: 200,
				hidden: true
			}, {
				field: 'AdjustNo',
				title: '调整序号',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'Level',
				title: '层级',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'IsLast',
				title: '末级',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '是'
							}, {
								rowid: '0',
								name: '否'
							}
						]
					}
				}
			}, {
				field: 'EditMod',
				title: '编制模式',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '自上而下'
							}, {
								rowid: '2',
								name: '自下而上'
							}, {
								rowid: '3',
								name: '上下结合'
							}
						]
					}
				}

			}
		]]

	//列配置对象
	EditColumns = [[{
				field: 'AuditDept',
				title: '归口科室一',
				halign: 'center',
				width: 120,
				formatter: AuditDeptFormatter,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array',
						mode: 'remote',
						valueField: 'rowid',
						textField: 'name',
						onBeforeLoad: auditDeptBefLoad
					}
				}
			}, {
				field: 'AuditDeptTwo',
				title: '归口科室二',
				halign: 'center',
				width: 120,
				formatter: AuditDeptTwoFormatter,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array',
						mode: 'remote',
						valueField: 'rowid',
						textField: 'name',
						onBeforeLoad: auditDeptBefLoad
					}

				}
			}, {
				field: 'IsGovBuy',
				title: '政府采购',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '是'
							}, {
								rowid: '0',
								name: '否'
							}
						]
					}
				}
			}, {
				field: 'PlanValue',
				title: '本年预算',
				halign: 'center',
				align: 'right',
				width: 100,
				formatter: ValueFormatter,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'OneUpVal',
				title: '一上预算',
				halign: 'center',
				align: 'right',
				width: 100,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'OneDowVal',
				title: '一下预算',
				halign: 'center',
				align: 'right',
				width: 100,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'TwoUpVal',
				title: '二上预算',
				halign: 'center',
				align: 'right',
				width: 100,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'TwoDowVal',
				title: '二下预算',
				halign: 'center',
				align: 'right',
				width: 100,
				formatter: dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'PerfTargets',
				title: '绩效目标',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: ProjGolFormatter
			}, {
				field: 'EstState',
				title: '编制状态',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: comboboxFormatter,
				styler: gridTextStyler,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '新建'
							}, {
								rowid: '2',
								name: '提交'
							}, {
								rowid: '3',
								name: '通过'
							}, {
								rowid: '4',
								name: '完成'
							}, {
								rowid: '5',
								name: '下放'
							}, {
								rowid: '6',
								name: '下放完成'
							}, {
								rowid: '7',
								name: '下放完,待重提'
							}
						]
					}
				}

			}, {
				field: 'OneState',
				title: '一编状态',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: comboboxFormatter,
				styler: gridTextStyler,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '新建'
							}, {
								rowid: '2',
								name: '提交'
							}, {
								rowid: '3',
								name: '通过'
							}, {
								rowid: '4',
								name: '完成'
							}, {
								rowid: '5',
								name: '下放'
							}, {
								rowid: '6',
								name: '下放完成'
							}, {
								rowid: '7',
								name: '下放完,待重提'
							}
						]
					}
				}
			}, {
				field: 'TwoState',
				title: '二编状态',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: comboboxFormatter,
				styler: gridTextStyler,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '新建'
							}, {
								rowid: '2',
								name: '提交'
							}, {
								rowid: '3',
								name: '通过'
							}, {
								rowid: '4',
								name: '完成'
							}, {
								rowid: '5',
								name: '下放'
							}, {
								rowid: '6',
								name: '下放完成'
							}, {
								rowid: '7',
								name: '下放完,待重提'
							}
						]
					}
				}
			}, {
				field: 'IsCurStep',
				title: '当前审批',
				halign: 'center',
				align: 'center',
				width: 100,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '是'
							}, {
								rowid: '0',
								name: '否'
							}
						]
					}
				}
			}, {
				field: 'CurStep',
				title: '当前过程',
				halign: 'center',
				align: 'center',
				width: 100,
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
			}, {
				field: 'DChkResult',
				title: '审批明细结果',
				halign: 'center',
				align: 'center',
				width: 120,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: '待审'
							}, {
								rowid: '2',
								name: '同意'
							}, {
								rowid: '3',
								name: '不同意'
							}, {
								rowid: '4',
								name: '待下放'
							}, {
								rowid: '5',
								name: '同意下放'
							}, {
								rowid: '6',
								name: '不同意下放'
							}
						]
					}
				}
			}, {
				title: '前年预算',
				field: 'PreLastPlanValue',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '前年执行',
				field: 'PreLast9ExeValue',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '差额',
				field: 'dis1',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '差异率（%）',
				field: 'disrate1',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '去年预算',
				field: 'LastPlanValue',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '去年执行',
				field: 'Last9ExeValue',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '差额',
				field: 'dis2',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}, {
				title: '差异率（%）',
				field: 'disrate2',
				width: '100',
				halign: 'right',
				align: 'right',
				formatter: dataFormat
			}

		]];

	//保存按钮
	$("#saveItemBtn").click(function(row){
    	FactYearSave();
    });
    //审核按钮
    $("#checkItemBtn").click(function(row){
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
    });
    //下放按钮
    $("#downItemBtn").click(function(row){
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
    });	
	$('#saveItemBtn').linkbutton('disable');
	$('#checkItemBtn').linkbutton('disable');
	$('#downItemBtn').linkbutton('disable');
	
	//定义表格
	var schemDetailGrid = $HUI.datagrid("#schemDetailGrid", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
				MethodName: "ListDetailDept",
				userid: userid,
				schemAuditId: schemRow.Rowid,
				audept: schemRow.ObjDeptId,
				itemcode: LowerPartrow.ItemCode,
				deptdr: ""
			},
			autoRowHeight: true,
			autoSizeColumn: true, //调整列的宽度以适应内容
			singleSelect: false,
			checkOnSelect: true, //如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
			selectOnCheck: true, //如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
			loadMsg: "正在加载，请稍等…",
			rownumbers: true, //行号
			nowap: true, //禁止单元格中的文字自动换行
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //页面大小选择列表
			pagination: true, //分页
			fit: true,
			frozenColumns: frozenColumns,
			columns: EditColumns,
			toolbar: '#dtb',
			onClickCell: onClickCell
		});

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
				 && ((factYearRow.CurStep == 2))) {
				return true;
			}

		}

		return false;
	}

	//点击下半界面单元格事件
	function onClickCell(index, field) {

		var rows = $('#schemDetailGrid').datagrid('getRows');
		var factYearRow = rows[index];

		//点击年度预算弹出预算明细表界面
		if ((factYearRow.IsLast == 1) && (field == 'PlanValue')) {
			FYDetailGridShow(schemRow, factYearRow);
		}

		//状态链接
		if ((factYearRow.IsLast == 1) && (field == 'EstState')) {
			schemastatefun(factYearRow.schemAuditIdObjDept, userid, schemRow.SchemId, "", "");
		}
		if ((factYearRow.IsLast == 1) && (field == 'OneState')) {
			schemastatefun(factYearRow.schemAuditIdObjDept, userid, schemRow.SchemId, 1, factYearRow.Code);
		}
		if ((factYearRow.IsLast == 1) && (field == 'TwoState')) {
			schemastatefun(factYearRow.schemAuditIdObjDept, userid, schemRow.SchemId, 2, factYearRow.Code);
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
	function FactYearSave() {

		var schemRow = $('#schemGrid').datagrid('getSelected');
		var mainData = "";

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
						if ((factYearRow.IsLast == 1) && FYDChkBefSave(grid, schemRow, factYearRow)) {
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
								 + "^" + factYearRow.schemAuditIdObjDept;
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
	}

	//保存请求后台方法
	var FYSaveOrder = function (mainData, detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgSchemOwnDept',
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

	//按钮权限管控
	function FYBtnsEnableManage(schemRow, factYearRow) {
		//两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//alert(factYearRow.Name+"->"+factYearRow.EstState );
			//是否当前审批字段=1
			if (factYearRow.IsCurStep == 1) {

				//是否当前审批字段=1时，保存按钮始终可用
				$('#saveItemBtn').linkbutton('enable');

				//提交、通过状态下-审核按钮可用、下放不可用
				if ((factYearRow.EstState == 2) || (factYearRow.EstState == 3)) {
					$('#checkItemBtn').linkbutton('enable');
					$('#downItemBtn').linkbutton('disable');
				}
				//完成状态下-审核按钮不可用、下放可用
				if ((factYearRow.EstState == 4) || (factYearRow.EstState == 5)) {
					$('#checkItemBtn').linkbutton('disable');
					$('#downItemBtn').linkbutton('enable');
				}

			} else {
				$('#saveItemBtn').linkbutton('disable');
				$('#checkItemBtn').linkbutton('disable');
				$('#downItemBtn').linkbutton('disable');
			}
		}
	}


	
	//关闭按钮
	$("#DetailClose").click(function () {
		$Detailwin.window('close');
	});
}
