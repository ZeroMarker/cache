/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: 全面预算管理-预算编制管理-归口科室年度预算审核-年度预算明细界面
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */

var startIndex = undefined;
var FYDEditIndex = undefined;

function FYDetailGridShow(schemRow, factYearRow) {

	var mainId = factYearRow.rowid;
	if (!mainId) {
		$.messager.popover({
			msg: '主表ID为空!',
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

	//factYearRow.schemAuditIdObjDept-归口表ID;factYearRow.rowid-年度主表ID;factYearRow.Code-年度主表项目编码
	var mainData = factYearRow.schemAuditIdObjDept + "^" + factYearRow.rowid + "^" + factYearRow.Code;
	
	var IsGov=(factYearRow.IsGovBuy==1) ? '(政府采购)' : '(非政府采购)';

	var FYDetailWinObj = $HUI.window("#FYDetailWin", {
			title: factYearRow.Name.replace(/&nbsp;/g,"")+ IsGov + '-' + '年预算明细编制',
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

				var OldRowIndex = $('#schemDetailGrid').datagrid('getRowIndex', factYearRow);
				$('#schemDetailGrid').datagrid("reload");
				//回调选中记录
				$('#schemDetailGrid').datagrid({
					onLoadSuccess: function () {
						$('#schemDetailGrid').datagrid("selectRow", OldRowIndex);
					}
				});
			}

		});
		
	$("#FYDetailWin").css("display", "block");
	

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
				field: 'ecoItemCo',
				title: '经济科目',
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
							param.flag = 1;
							param.year=$('#yearcb').combobox('getValue');
						},
						required: true
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
				title: '一上预算',
				width: 100,
				allowBlank: false,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'oneDowVal',
				title: '一下预算',
				width: 100,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoUpVal',
				title: '二上预算',
				width: 100,
				allowBlank: false,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoDowVal',
				title: '二下预算',
				width: 100,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'planVal',
				title: '最终预算',
				width: 100,
				formatter: function (value, row, index) {
					var rowid = row.rowid;
					if (rowid > 0) {
						return '<a href="#" class="grid-td-text" >' + value + '</a>';
					}
				},
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'desc',
				title: '备注',
				width: 300,
				editor: {
					type: 'text'
				}
			}

		]]

	//增加按钮
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '新增',
		handler: function () {

			if (FYDEndEditing()) {
				$('#FYDetailGrid').datagrid('appendRow', {
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
				//根据当前过程，置对应列可编辑
				var fields = $('#FYDetailGrid').datagrid('getColumnFields', true).concat($('#FYDetailGrid').datagrid('getColumnFields'));
				for (var i = 5; i < fields.length - 1; i++) {
					//alert(fields[i]);
					var col = $('#FYDetailGrid').datagrid('getColumnOption', fields[i]);
					var curStep = factYearRow.CurStep;
					if (curStep == '')
						curStep = 1;
					var fieldIndex = parseInt(curStep) + 4;
					//alert(fieldIndex);
					if (fieldIndex == i) {
						col.editor = col.editor;
					} else {
						col.editor = null;
					}
				}

				startIndex = $('#FYDetailGrid').datagrid('getRows').length - 1;
				$('#FYDetailGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

			}
		}
	}
	//保存按钮
	var SaveBtn = {
		id: 'FYDSave',
		iconCls: 'icon-save',
		text: '保存',
		handler: function () {
			FYDetailSave(schemRow, factYearRow);
		}
	}
	//删除按钮
	var DelBt = {
		id: 'FYDDel',
		iconCls: 'icon-cancel',
		text: '删除',
		handler: function () {
			FYDetailDel();
		}
	}
	//清空按钮
	var ClearBT = {
		id: 'FYDReset',
		iconCls: 'icon-reset',
		text: '重置',
		handler: function () {
			$('#FYDetailGrid').datagrid('rejectChanges');
		}
	}

	var FYDetailGridObj = $HUI.datagrid('#FYDetailGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDetail',
				rowid: mainId
			},
			columns: FYDGridColumn,
			striped: true,
			rownumbers: true, //行号
			pagination: true, //分页
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, SaveBtn, DelBt,ClearBT],
			onClickCell: FYDetailClickCell
		});
	$("#FYDetailGrid").addClass(' border-top-width'); 
	//点击单元格事件
	function FYDetailClickCell(index, field) {

		var factYearDetailRow = $('#FYDetailGrid').datagrid('getRows')[index];
		//alert(startIndex+"^"+index);
		startIndex = index;
		if (FYDEndEditing() && FYDIsEdit(schemRow, factYearRow, index, field)) {
			$('#FYDetailGrid').datagrid('editCell', {
				index: index,
				field: field
			});
			//startIndex = index;
		}

		//点击年度预算弹出附件表界面
		if ((factYearDetailRow.rowid != '') && (factYearRow.IsGovBuy == 1) && (field == 'planVal')) {

			FYDAppendixGridShow(schemRow, factYearRow, factYearDetailRow);
		}

	}

	//判断是否结束编辑
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#FYDetailGrid').datagrid('validateRow', startIndex)) {
			var ed = $('#FYDetailGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'ecoItemCo'
				});
			if (ed) {
				var ecoItemNa = $(ed.target).combobox('getText');
				$('#FYDetailGrid').datagrid('getRows')[startIndex]['ecoItemNa'] = ecoItemNa;

			}
			var ed = $('#FYDetailGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'fundTypeId'
				});
			if (ed) {
				var fundTypeNa = $(ed.target).combobox('getText');
				$('#FYDetailGrid').datagrid('getRows')[startIndex]['fundTypeNa'] = fundTypeNa;
			}

			$('#FYDetailGrid').datagrid('endEdit', startIndex);
			startIndex = undefined;
			return true;
		} else {
			return false;
		}
	}

	//判断是否可编辑
	function FYDIsEdit(schemRow, factYearRow, index, field) {

		//alert(factYearRow.IsLast);
		//经济科目/资金类型
		if ((factYearRow.IsLast == 1) && ((field == "ecoItemCo") || (field == "fundTypeId"))) {
			//是否当前审批=null/1 && 审批结果=null/1 && 审批过程=null/1
			if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
				 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
				 && ((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1))) {
				return true;
			}
		}

		//两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//一上预算列
			if (field == "oneUpVal") {
				//是否当前审批=null/1 && 审批结果=null/1(待审)/3(不同意) && 审批过程=null/1
				if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1) || (factYearRow.DChkResult == 3))
					 && ((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1))) {
					return true;
				}
				//编制状态=1（新建） && 审批结果=3(不同意) && 审批过程=''/null/1
				if (((factYearRow.EstState == 1))
					 && (factYearRow.DChkResult == 3)
					 && ((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1))) {
					return true;
				}
			}

			//一下预算列
			if (field == "oneDowVal") {
				//是否当前审批=1 && 审批过程=2(一下)
				if ((factYearRow.IsCurStep == 1)
					 && (factYearRow.CurStep == 2)) {
					return true;
				}
			}

			//二上预算列
			if (field == "twoUpVal") {
				//是否当前审批=null/1 && 审批结果=null/1 && 审批过程=null/2
				if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (factYearRow.CurStep == 3)) {
					return true;
				}

			}
			//二下预算列
			if (field == "twoDowVal") {
				//是否当前审批=1 && 审批过程=2(一下)
				if ((factYearRow.IsCurStep == 1)
					 && (factYearRow.CurStep == 4)) {
					return true;
				}
			}

		}

		if ((factYearRow.IsLast == 1) && (field == "desc")) {
			//是否当前审批=null/1 && 审批结果=null/1 && 审批过程=null/2
			if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
				 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
				 && ((factYearRow.CurStep == 1) || (factYearRow.CurStep == 2))) {
				return true;
			}
		}

		return false;
	}

	//保存方法
	function FYDetailSave(schemRow, factYearRow) {

		var grid = $('#FYDetailGrid');
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {

				var ed = $('#FYDetailGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'ecoItemCo'
					});
				if (ed) {
					var ecoItemNa = $(ed.target).combobox('getText');
					$('#FYDetailGrid').datagrid('getRows')[indexs[i]]['ecoItemNa'] = ecoItemNa;

				}
				var ed = $('#FYDetailGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'fundTypeId'
					});
				if (ed) {
					var fundTypeNa = $(ed.target).combobox('getText');
					$('#FYDetailGrid').datagrid('getRows')[indexs[i]]['fundTypeNa'] = fundTypeNa;
				}
				grid.datagrid("endEdit", indexs[i]);
			}
		}
		var rows = grid.datagrid("getChanges");
		var rowIndex = "",
		row = "",
		detailData = "";
		if (rows.length > 0) {
			$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						rowIndex = grid.datagrid('getRowIndex', row);
						grid.datagrid('endEdit', rowIndex);
						if (FYDChkBefSave(schemRow, factYearRow, rowIndex, grid, row)) {
							var tempdata = row.rowid
								 + "^" + row.ecoItemCo
								 + "^" + row.fundTypeId
								 + "^" + row.oneUpVal
								 + "^" + row.oneDowVal
								 + "^" + row.twoUpVal
								 + "^" + row.twoDowVal
								 + "^" + row.planVal
								 + "^" + row.desc
								if (detailData == "") {
									detailData = tempdata;
								} else {
									detailData = detailData + "|" + tempdata;
								}
						}
					}
					//alert(mainData);
					//alert(detailData);
					FYDSaveOrder(mainData, detailData);
				}
			})
		}
	}

	//保存前校验
	function FYDChkBefSave(schemRow, factYearRow, rowIndex, grid, row) {
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
					if ((tmobj.allowBlank == false) && FYDIsEdit(schemRow, factYearRow, rowIndex, field)) {
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

	//保存请求后台方法
	var FYDSaveOrder = function (mainData, detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
			MethodName: 'FYDetailSave',
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
				$('#FYDetailGrid').datagrid("reload");
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

	function FYDetailDel() {
		var rows = $('#FYDetailGrid').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '请选中要删除的记录！',
				type: 'info',
				timeout: 2000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}

		$.messager.confirm('确定', '级联删除对应附加表记录，确定要删除选定的数据吗？', function (t) {
			if (t) {
				var detailData = "";
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					var rowid = row.rowid;
					if (row.rowid > 0) {
						if (detailData == "") {
							detailData = row.rowid;
						} else {
							detailData = detailData + "|" + row.rowid;
						}
					} else {
						//新增的行删除
						editIndex = $('#FYDetailGrid').datagrid('getRowIndex', row);
						$('#FYDetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					}
				}
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
					MethodName: 'FYDetailDel',
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
						$('#FYDetailGrid').datagrid("reload");
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

				$('#FYDetailGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
				startIndex = undefined;
				return startIndex;
			}
		})
	}

	//按钮权限管控
	function FYDBtnsEnableManage(schemRow, factYearRow) {
		//两上两下模式
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//经济科目
			if (schemRow.IsEconItem == 1) {
				//alert(factYearRow.Name+"->"+factYearRow.EstState );
				//新建/下放完,待重提状态
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1) || (factYearRow.EstState == 7))) {
					$('#FYDAdd').linkbutton('enable');
					$('#FYDSave').linkbutton('enable');
					$('#FYDDel').linkbutton('enable');
					$('#FYDReset').linkbutton('enable');

				}
				//非新建状态
				if ((2 <= factYearRow.EstState) && (factYearRow.EstState <= 6)) {
					if (factYearRow.IsCurStep == 1) {
						$('#FYDAdd').linkbutton('enable');
						$('#FYDSave').linkbutton('enable');
						$('#FYDDel').linkbutton('enable');
						$('#FYDReset').linkbutton('enable');
					} else {
						$('#FYDAdd').linkbutton('disable');
						$('#FYDSave').linkbutton('disable');
						$('#FYDDel').linkbutton('disable');
						$('#FYDReset').linkbutton('disable');
					}
				}

			}
			//非经济科目
			if (schemRow.IsEconItem == 0) {
				//新建/下放完,待重提状态
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1) || (factYearRow.EstState == 7))) {
					$('#FYDAdd').linkbutton('enable');
					$('#FYDSave').linkbutton('enable');
					$('#FYDDel').linkbutton('enable');
					$('#FYDReset').linkbutton('enable');
				}
				//非新建状态
				if ((2 <= factYearRow.EstState) && (factYearRow.EstState <= 6)) {
					if (factYearRow.IsCurStep == 1) {
						$('#FYDAdd').linkbutton('enable');
						$('#FYDSave').linkbutton('enable');
						$('#FYDDel').linkbutton('enable');
						$('#FYDReset').linkbutton('enable');
					} else {
						$('#FYDAdd').linkbutton('disable');
						$('#FYDSave').linkbutton('disable');
						$('#FYDDel').linkbutton('disable');
						$('#FYDReset').linkbutton('disable');
					}
				}

			}
		}
	}

	//按钮权限管控
	FYDBtnsEnableManage(schemRow, factYearRow);

	FYDetailWinObj.open();
};
