/*
Creator: Liu XiaoMing
CreatDate: 2018-07-30
Description: 全面预算管理-预算编制管理-科室年度预算编制（自编）-年度预算明细界面-明细附件界面
CSPName: herp.budg.hisui.budgschemMAself.csp
ClassName: herp.budg.hisui.udata.uBudgSchemMAself,
herp.budg.udata.uBudgSchemMAself
 */

var FYDAEditIndex = undefined;

function FYDAppendixGridShow(schemRow, factYearRow, factYearDetailRow) {
	var IsGov='';
	if(factYearRow.IsGovBuy==1){
		IsGov='(政府采购)';
	}else{
		IsGov='(非政府采购)';
	}
	

	var FYDAppendixWinObj = $HUI.window("#FYDAppendixWin", {
			iconCls: 'icon-w-new',
			title: factYearRow.Name + IsGov +'-' +'年预算明细-采购预算编制',
			width: 700,
			height: 500,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			draggable: true,
			modal: true,
			onClose: function () { //关闭关闭窗口后触发
				$('#FYDetailGrid').datagrid("reload");
			}

		});

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
						required: true,
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
						}
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
						required: true,
						valueField: 'fundTypeId',
						textField: 'fundTypeNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
						}
					}
				}
			}, {
				field: 'budgVal',
				title: '预算总额',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat,
				/*editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 2
					}
				}*/
			}, {
				field: 'bgPrice',
				title: '单价',
				width: 80,
				halign:'right',
				align:'right',
				formatter:dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 2
					}
				}
			}, {
				field: 'bgNum',
				title: '数量',
				width: 80,
				halign:'right',
				align:'right',
				editor: {
					type: 'text',
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
				width: 80,
				halign:'center',
				align:'center',
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
	//增加按钮
	var AddBtn = {
		id: 'FYDAppendixAdd',
		iconCls: 'icon-add',
		text: '增加',
		handler: function () {

			if (FYDAEndEditing()) {
				$('#FYDAppendixGrid').datagrid('appendRow', {
					rowid: '',
					mainId: FYDRowid,
					purchItemCo: '',
					fundTypeId: '',
					budgVal: '',
					bgPrice: '',
					bgNum: '',
					desc: '',
					process: factYearRow.CurStep
				});
				FYDAEditIndex = $('#FYDAppendixGrid').datagrid('getRows').length - 1;
				$('#FYDAppendixGrid').datagrid('selectRow', FYDAEditIndex).datagrid('beginEdit', FYDAEditIndex);
				//必须放置在beginEdit之后，不然et取不到值会为null
				//将编制过程列置为只读模式
				var et = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: FYDAEditIndex,
						field: 'process'
					});
				$(et.target).combobox('disable'); //只读模式，适用下拉框
				//$(et.target).attr('disabled', 'disabled'); //只读只读模式，适用文本框

			}
		}
	}

	//保存按钮
	var SaveBtn = {
		id: 'FYDAppendixSave',
		iconCls: 'icon-save',
		text: '保存',
		handler: function () {
			FYDAppendixSave(schemRow, factYearRow, factYearDetailRow);
		}
	}

	//删除按钮
	var DelBt = {
		id: 'FYDAppendixDel',
		iconCls: 'icon-remove',
		text: '删除',
		handler: function () {
			FYDAppendixDel();
		}
	}

	//清空按钮
	var ClearBT = {
		id: 'FYDAppendixReset',
		iconCls: 'icon-reset',
		text: '重置',
		handler: function () {
			$('#FYDAppendixGrid').datagrid('rejectChanges');
		}
	}
    var FYDRowid = factYearDetailRow.rowid;
	var FYDAppendixGridObj = $HUI.datagrid('#FYDAppendixGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDAppendix',
				rowid: FYDRowid
			},
			columns: FYDGridColumn,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, SaveBtn, DelBt, ClearBT],
			onClickCell: FYDAppendixClickCell
		});
  if (schemRow.IsTwoUpDown == 0) {
		//隐藏表格两上两下相关列;
		$('#FYDAppendixGrid').datagrid('hideColumn', 'process');
	} else {
		//显示表格两上两下相关列;
		$('#FYDAppendixGrid').datagrid('showColumn', 'process');
	}

	//判断是否结束编辑
	function FYDAEndEditing() {

		if (FYDAEditIndex == undefined) {
			return true
		}
		if ($('#FYDAppendixGrid').datagrid('validateRow', FYDAEditIndex)) {
			var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
					index: FYDAEditIndex,
					field: 'purchItemCo'
				});
			if (ed) {
				var purchItemNa = $(ed.target).combobox('getText');
				$('#FYDAppendixGrid').datagrid('getRows')[FYDAEditIndex]['purchItemNa'] = purchItemNa;
			}

			var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
					index: FYDAEditIndex,
					field: 'fundTypeId'
				});
			if (ed) {
				var fundTypeNa = $(ed.target).combobox('getText');
				$('#FYDAppendixGrid').datagrid('getRows')[FYDAEditIndex]['fundTypeNa'] = fundTypeNa;
			}

			$('#FYDAppendixGrid').datagrid('endEdit', FYDAEditIndex);
			FYDAEditIndex = undefined;
			return true;
		} else {
			return false;
		}
	}

	//判断是否可编辑
	function FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, index, field) {

		//alert(factYearRow.IsLast);

		//两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//是否可编辑判断
			if ((field == "purchItemCo") || (field == "fundTypeId") || (field == "budgVal") || (field == "bgPrice") || (field == "bgNum") || (field == "desc")) {
				//alert(factYearRow.CurStep);
				//alert(factYearDetailRow.process);

				//一上情况
				if (((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 1))
					 && ((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))) {
					if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1))
						 && ((factYearRow.OneState == '') || (factYearRow.OneState == null) || (factYearRow.OneState == 1))) {
						return true;
					}
				}
				
				//一下情况
				if ((factYearRow.IsCurStep == 1)&&((factYearDetailRow.process == 2))) {
					if (((factYearRow.OneState == 4) || (factYearRow.OneState == 5) || (factYearRow.OneState == 6))) {
						return true;
					}
				}
				
				//二上预算列
				if ((factYearDetailRow.process == 3) && ((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))) {
					if ((factYearRow.TwoState == 2)
						 ||(factYearRow.TwoState == 7)) {
						return true;
					}
				}
				//二下情况
				if ((factYearRow.IsCurStep == 1)
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 4)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 4)))) {
					return true;
				}

			}
		}

		//非两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 0)) {
			//是否可编辑判断
			if ((field == "purchItemCo") || (field == "fundTypeId") || (field == "budgVal") || (field == "bgPrice") || (field == "bgNum") || (field == "desc")) {
				//alert(factYearRow.CurStep);
				//alert(factYearDetailRow.process);
				//是否当前审批=null/1 && 审批结果=null/1 && 审批过程=null/1
				//一上情况
				if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 1)))) {
					return true;
				}
			}
		}
		return false;
	}

	//点击单元格事件
	function FYDAppendixClickCell(index, field) {

		var factYearDetailRow = $('#FYDAppendixGrid').datagrid('getRows')[index];
		//alert(FYDAEndEditing());
		//alert(FYDAppendixIsEdit(schemRow, factYearRow,factYearDetailRow, index, field));

		if (FYDAEndEditing() && FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, index, field)) {
			$('#FYDAppendixGrid').datagrid('editCell', {
				index: index,
				field: field
			});
			FYDAEditIndex = index;
		}
	}

	//保存前校验
	function FYDAppendixChkBefSave(schemRow, factYearRow, factYearDetailRow, rowIndex, grid, row) {
		var fields = grid.datagrid('getColumnFields')
			for (var j = 0; j < fields.length; j++) {
				var field = fields[j];
				var tmobj = grid.datagrid('getColumnOption', field);
				if (tmobj != null) {
					var reValue = "";
					reValue = row[field];
					if (reValue == undefined) {
						reValue = "";
					}
					if ((tmobj.allowBlank == false) && FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, rowIndex, field)) {
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
	function FYDAppendixSave(schemRow, factYearRow, factYearDetailRow) {

		var grid = $('#FYDAppendixGrid');
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {

				var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'purchItemCo'
					});
				if (ed) {
					var purchItemNa = $(ed.target).combobox('getText');
					$('#FYDAppendixGrid').datagrid('getRows')[indexs[i]]['purchItemNa'] = purchItemNa;

				}
				var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'fundTypeId'
					});
				if (ed) {
					var fundTypeNa = $(ed.target).combobox('getText');
					$('#FYDAppendixGrid').datagrid('getRows')[indexs[i]]['fundTypeNa'] = fundTypeNa;
				}
				$('#FYDAppendixGrid').datagrid("endEdit", indexs[i]);
			}
		}
		var rows = $('#FYDAppendixGrid').datagrid("getSelections");
		//alert(rows.length);
		var rowIndex = "",
		row = "",
		detailData = "";
		if (rows.length > 0) {
			$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						//alert(row.rowid)
						rowIndex = grid.datagrid('getRowIndex', row);
						grid.datagrid('endEdit', rowIndex);
						if (FYDAppendixChkBefSave(schemRow, factYearRow, factYearDetailRow, rowIndex, grid, row)) {
							var tempdata = row.rowid
								 + "^" + row.purchItemCo
								 + "^" + row.fundTypeId
								 + "^" + row.bgPrice*row.bgNum
								 + "^" + row.bgPrice
								 + "^" + row.bgNum
								 + "^" + row.desc
								 + "^" + row.process;
							if (detailData == "") {
								detailData = tempdata;
							} else {
								detailData = detailData + "|" + tempdata;
							}
						}
					}
					var FYDRowid = factYearDetailRow.rowid;
					var mainData = schemRow.Rowid + "^" + factYearRow.rowid + "^" + factYearRow.Code + "^" + factYearDetailRow.rowid;
					//alert(mainData);
					FYDAppendixSaveOrder(mainData, detailData);
					grid.datagrid("reload");
				}
			})
		}
	}

	//保存请求后台方法
	var FYDAppendixSaveOrder = function (mainData, detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
			MethodName: 'FYDAppendixSave',
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

	//删除
	function FYDAppendixDel() {
		var rows = $('#FYDAppendixGrid').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '请选中要删除的记录！',
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

		$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
			if (t) {
				var detailData = "";
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					var rowid = row.rowid;
					if (row.rowid > 0) {
						//只允许删除当前过程下的记录，不允许删除过往记录
						//alert(factYearRow.CurStep );
						//alert(row.process);
						if ((factYearRow.CurStep == '') || (factYearRow.CurStep == row.process)) {
							if (detailData == "") {
								detailData = row.rowid;
							} else {
								detailData = detailData + "|" + row.rowid;
							}
						}
					} else {
						//新增的行删除
						editIndex = $('#FYDAppendixGrid').datagrid('getRowIndex', row);
						$('#FYDAppendixGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					}
				}

				//alert(detailData);
				if (detailData != '') {
					$.m({
						ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
						MethodName: 'FYDAppendixDel',
						userid: userid,
						mainData: mainData,
						detailData: detailData
					},
						function (Data) {
						if (Data == 0) {
							$.messager.popover({
								msg: '删除成功！',
								type: 'success',
								timeout: 5000,
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
									top: 10
								}
							});
							$('#FYDAppendixGrid').datagrid("reload");
						} else {
							$.messager.popover({
								msg: '删除失败！' + Data,
								type: 'error',
								timeout: 5000,
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
									top: 10
								}
							});
						}
					});

					$('#FYDAppendixGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
					startIndex = undefined;
					return startIndex;
				} else {
					$.messager.popover({
						msg: '只允许删除当前过程下的记录!',
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
		})
	}

	//按钮权限管控
	function FYDABtnsEnableManage(schemRow, factYearRow) {
		//两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//业务科室编制界面
			//一上新建状态
			if (((factYearRow.OneState == '')
					 || (factYearRow.OneState == null)
					 || (factYearRow.OneState == 1))) {
				$('#FYDAppendixAdd').linkbutton('enable');
				$('#FYDAppendixSave').linkbutton('enable');
				$('#FYDAppendixDel').linkbutton('enable');
				$('#FYDAppendixReset').linkbutton('enable');

			}else if (factYearRow.TwoState == 7) {
				//二上新建状态 7-下放完，待重提
				$('#FYDAppendixAdd').linkbutton('enable');
				$('#FYDAppendixSave').linkbutton('enable');
				$('#FYDAppendixDel').linkbutton('enable');
				$('#FYDAppendixReset').linkbutton('enable');

			} 


			//业务科室审核界面
			else if (factYearRow.IsCurStep == 1) {
				$('#FYDAppendixAdd').linkbutton('enable');
				$('#FYDAppendixSave').linkbutton('enable');
				$('#FYDAppendixDel').linkbutton('enable');
				$('#FYDAppendixReset').linkbutton('enable');
			}else{
				$('#FYDAppendixAdd').linkbutton('disable');
				$('#FYDAppendixSave').linkbutton('disable');
				$('#FYDAppendixDel').linkbutton('disable');
				$('#FYDAppendixReset').linkbutton('disable');
				
				}

			//归口科室审核界面


		}
	}

	//按钮权限管控
	FYDABtnsEnableManage(schemRow, factYearRow);

	FYDAppendixWinObj.open();
};
